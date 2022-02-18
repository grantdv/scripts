#! /usr/bin/perl

#####################################################################
# Script to automatically deploy KVM guests to pools
#####################################################################


#####################################################################
# Modules
#####################################################################
use warnings;
use strict;
use Getopt::Long;
use YAML::XS qw (LoadFile DumpFile);
use Parallel::ForkManager;
use Net::Ping;

#####################################################################
# Main
#####################################################################

#Global Variables
my ($HELP,$LIST,$CONFIG,$DC,$POOL,$YAMLF,$SLIST) = undef;

my ($str,$hshref);

my ($CLUSTERS);
my (%GUESTS,%HOSTS);

GetOptions(
  "h|?"           =>  \$HELP,
  "l|list"        =>  \$LIST,
  "s|slist"        =>  \$SLIST,
  "c|config=s"      =>  \$CONFIG,
  "d|datacenter=s"  =>  \$DC,
  "p|pool=s"        =>  \$POOL,
  "f|file=s"      =>   \$YAMLF
);

print_usage() if($HELP);

if (!$YAMLF) { $YAMLF = "/usr/local/etc/clusters.yaml" };

$CLUSTERS = LoadFile "$YAMLF";  

build_list_all() if($LIST);

if(!$CONFIG) {
  $str = "Config file required (-c) of format:\n";
  $str .= "server_name ip_adress os_type disk_type(optional)\n";
  $str .= "\n\n";

  print_usage($str);
}

if(!$POOL) { 
  $str = "Pool required for deployment, one of :\n";
  $str .= join(" ",keys(%{$CLUSTERS}));
  $str .= "\n\n";
    
  print_usage($str);
}

if(!$DC) {
  $str = "Datacenter required for deployment, one of :\n";
  $str .= join(" ",keys(%{$CLUSTERS->{$POOL}}));
  $str .= "\n\n";

  print_usage($str);
}

build_list_pdc();

$hshref = run_config($CONFIG);

deploy_guests($hshref);

#####################################################################
# deploy_guests function
#####################################################################
# input, hshref with key = hosts, value = string to output on host
#####################################################################
sub deploy_guests {
  my $hosthsh = shift;

  my ($host,$server,$fout,$i,$size,$cmd);
  my @output;
  my $errlog = "kvm-deploy-guests.err";

  my $pm = new Parallel::ForkManager(16); 

  foreach $host (keys(%{$hosthsh})) {
    $pm -> start and next; 
    $size = scalar (@{$hosthsh->{$host}});
    for ($i = 0; $i < $size; $i+=2) {
      $server = $hosthsh->{$host}[$i];
      $fout = $hosthsh->{$host}[$i+1];

      eval {
        alarm(1200);
        $cmd = "ssh -l root $host \"echo \\\"$fout\\\" > /etc/kvm-deploy/guests/$server && /opt/wf/bin/kvm-deploy-type $server\" 2>&1";
        print "Creating $server on $host\n";
        @output = `$cmd`;
#        system($cmd);
        if($?) {
          print "Got an error deploying $server on $host, see error log ($errlog)\n";
          open(F1,">>$errlog") || die "Couldn't open error log for writing\n";
          print F1 join("\n",@output);
          close(F1);
        } else {
          print "Created $server on $host successfully\n";
        }
        alarm(0);
      };

      if($@) {
        print "Got an alarm when trying to contact $host\n";
      }
    
    }
    $pm -> finish;
  }
  $pm->wait_all_children;

}

#####################################################################
# run_config function
#####################################################################
# server_name ip_address os_type disk_type(optional)
#####################################################################
sub run_config {

  my ($server,$ipaddr,$ostype,$disktype,$host,$i,$str) = undef;

  my @hosts;

  my (%avail,%deploy);

  open (F1,$CONFIG) || die "Could not open $CONFIG for reading";

  while (<F1>) {
    chomp;
    ($server,$ipaddr,$ostype,$disktype) = split(' ',$_);

    @hosts = keys(%avail);

    sanity_check_server($server,$ipaddr);

    if($#hosts < 0) {
      foreach $i (keys(%{$CLUSTERS->{$POOL}->{$DC}})) {
        $avail{$i} = 1;
      }
    }

    $host = find_deploy_host(keys(%avail));

    if(!$host) {
      print "Could not find a host to deploy $host on\n";
      delete($avail{$host});
    } else {
      $str = "GUEST=$server\n";
      $str .= "IP=$ipaddr\n";
      $str .= "TYPE=$ostype\n";
      if($disktype) {
        if($disktype =~ m/cache/i) {
          $str .= "CACHE=$disktype\n";
        } elsif($disktype =~ m/mysql/i) {
          $str .= "MYSQL=$disktype\n";
        } elsif($disktype =~ m/data/i) {
          $str .= "DATA=$disktype\n";
        } else {
          print "Invalid DISKTYPE!\n";
        }
      }
      push(@{$deploy{$host}},$server);
      push(@{$deploy{$host}},$str);
      #$deploy{$server}[0] = "$host"; 
      #$deploy{$server}[1] = "$str"; 
      delete($avail{$host});
    }

    ($server,$ipaddr,$ostype,$disktype) = undef;

  }

  return(\%deploy);
}

#####################################################################
# sanity_check_server function
#####################################################################
# server_name 
#####################################################################
sub sanity_check_server {
  my ($server,$ipaddr) = @_;

  my $p = Net::Ping->new();

  if($GUESTS{$server}) {
    die "Won't deploy $server as it is already defined in $POOL/$DC\n";
  }

  if ($p->ping($ipaddr,2) == 1) {
    die "Won't deploy $server as $ipaddr is pinging\n";
  }

}

#####################################################################
# find_deploy_host function
#####################################################################
sub find_deploy_host {
  my @arr = @_;

  my ($host,$rthst,$hostc);

  my $min = 16;

  foreach $host (@arr) {
    $hostc = $CLUSTERS->{$POOL}->{$DC}->{$host};

    if($CLUSTERS->{$POOL}->{$DC}->{$host} < $min) {
      $min = $CLUSTERS->{$POOL}->{$DC}->{$host};
      $rthst = $host;
    }
  }

  $CLUSTERS->{$POOL}->{$DC}->{$rthst} += 1;
  
  return $rthst;
}

#####################################################################
# print_usage function
#####################################################################
sub print_usage {
  my($str) = @_;

  print $str if($str);

  print "Proper Usage: kvm-deploy-guests.pl -h -l -c -d -p\n";
  print "\t-h = print out this message\n";
  print "\t-l = print out the cluster/node counts\n";
  print "\t-c = config file with the following fields:\n";
  print "server_name ip_address os_type disk_type(optional)\n";
  print "\t-d = datacenter to deploy in the pool selected\n";
  print "\t-p = pool to deploy guests\n";
  print "\t-f = yaml file for cluster information\n";
  print "\t-s = list servers instead of count (requires -l)\n";

  exit(0);
}

#####################################################################
# build_list_all function
# input : global CLUSTER function
#####################################################################
sub build_list_all {
  my ($pool,$dc,$host,$hstref);
  my ($poolc,$dcc,$hostc) = 0;
  my (@pools);

  @pools = keys(%{$CLUSTERS});

  foreach $pool (@pools) {

    $poolc = 0;

    foreach $dc (keys(%{$CLUSTERS->{$pool}})) {

      $dcc = 0;

      foreach $host (keys(%{$CLUSTERS->{$pool}->{$dc}})) {

        $hostc = count_host($host);
        $dcc += $hostc;
        $poolc += $hostc;

        $CLUSTERS->{$pool}->{$dc}->{$host} = $hostc;

        if($SLIST) {
          print "    $host : $hostc ",join(" ",@{$HOSTS{$host}}),"\n";
        } else {
          print "    $host : $hostc\n";
        }
        
      }

      print "  $dc : $dcc\n";

    }

    print "$pool : $poolc\n";

  }

#  DumpFile("clusters.yaml.new",$CLUSTERS);  

  exit(0);
}

#####################################################################
# build_list_pdc function
# input : global CLUSTER,DC,POOl variables
#####################################################################
sub build_list_pdc {
  my ($host,$hostc);

  foreach $host (keys(%{$CLUSTERS->{$POOL}->{$DC}})) {

    $hostc = count_host($host);

    if($hostc == -1 || $hostc >= 16) {
      delete($CLUSTERS->{$POOL}->{$DC}->{$host});
    } else {
      $CLUSTERS->{$POOL}->{$DC}->{$host} = $hostc;
    }

  }

}

#####################################################################
# count_host function
# input : host name
#####################################################################
sub count_host {
  my ($host) = @_;

  my ($guestlist,$line,$i);
  my $hostc = undef;
  my (@tmp,@tmp2);

  push(@{$HOSTS{$host}},":");
  eval {
    alarm(60);
    #$hostc = `virsh -c qemu+ssh://root\@$host/system list --all |tail -n +3 |head -n -1 |wc -l`;
    $guestlist = `virsh -c qemu+ssh://root\@$host/system list --all`;
    if($?) {
      print "Got an error with $host\n";
      $hostc = -1;
      push(@{$HOSTS{$host}},"error");
    } else {
      @tmp = split("\n",$guestlist);
      $hostc = $#tmp - 1;
      for ($i = 2 ; $i <= $#tmp ; $i++) {
        @tmp2 = split(' ',$tmp[$i]); 
        $GUESTS{$tmp2[1]} = 1;
        push(@{$HOSTS{$host}},$tmp2[1]);
      }
    }
    alarm(0);
  };

  if($@) {
    print "Got an alarm when trying to contact $host\n";
    $hostc = -1;
    push(@{$HOSTS{$host}},"error");
  }

  chomp($hostc);

  return $hostc;
}
