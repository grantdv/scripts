#!/usr/bin/perl
#This script will install the Vmware Tools on a vmware guest.
#Written by:
#Grant Della Vecchia
#3/19/2009
#Turner Broadcasting WfServer-Ops

#Variables-------------------------------------------------
use Expect;
@hosts=`cat tools_guests`; #<-- File name with a list of hosts
#End-------------------------------------------------------


$cmd = "/usr/bin/ssh -l root";
my $stdin = Expect->exp_init(\*STDIN);
print "@hosts\n";
foreach $host (@hosts) {
chomp($host);
       $ssh = Expect->spawn("$cmd $host") || die "Couldn't spawn ssh, $!";
       $ssh->expect(10,'-re','#');
       print $ssh "rsync -avz 10.165.5.11::kickstart/vmware/rc.d/ /etc/rc.d && rpm -Uvh http://10.165.5.11/kickstart/vmware/VMwareTools.rpm && /usr/bin/vmware-config-tools.pl && /etc/init.d/network restart\r";
       $ssh->expect(300,'-re','\[no\]') || die "Could not find prompt\n";
       print $ssh "yes\r";
       $ssh->expect(300,'-re','#');
       print $ssh "exit\r";                                                                                                                    
       $ssh->hard_close();
	}
