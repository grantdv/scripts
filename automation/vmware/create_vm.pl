#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  p1_create.pl
#
#        USAGE:  p1_create.pl <vmname>
#
#  DESCRIPTION:  This script will create the XML file to create a new VM.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <grant.dellavecchia@cnn.com>
#      COMPANY:  Turner (ServerOps)
#      VERSION:  1.3
#      CREATED:  6/4/2010
#     REVISION:  ---
#===============================================================================

#Below is the sample XML that needs to be created.
#<?xml version="1.0"?>
#
#<!-- This is a sample xml file for creating a virtual machine
#Following default values of the tags are set
#Name                 TestVM
#Host                 ABC.XXX.XXX
#Datacenter           ha-datacenter
#Guest-Id             winXPProGuest
#Datastore            storage1
#Disksize(in KB)      4194304(4GB)
#Memory(in MB)        256 
#Number-of-Processor  1
#Nic-Network          VM Network
#Nic-Poweron          0
#These values can be changed according to the requirement and network-->#
#
#<Virtual-Machines>
#         <Virtual-Machine>
#            <Name>granttest5</Name>
#                <Host>10.165.187.27</Host>
#                <Datacenter>Lab</Datacenter>
#                <Guest-Id>rhel5_64Guest</Guest-Id>
#                <Datastore>Storage1</Datastore>
#                <Disksize>1318912</Disksize>
#                <Memory>4096</Memory>
#                <Number-of-Processor>2</Number-of-Processor>
#                <Nic-Network>VM Network</Nic-Network>
#                <Nic-Poweron>0</Nic-Poweron>
#         </Virtual-Machine>
#</Virtual-Machines>

use IO::File;

my $Debug = 1;

# This following variable should probably be stored in a separate ini file....
my $CLUSTERS = {
    'P1'=> { # Datacenter
	'Development' => { # Cluster
	    'networks'=>[
		"VL106_10.189.136_137",
		"VL104_10.165.185-24",
		"VL101_10.165.184-24",
		"VL100_10.189.140_141"
	    ],
	    'host'=>'esxp1-73.turner.com',
	    'server'=>'vcenterp1app1',
	    'dsregex'=>'RHEL5',
	    'metric'=>'NumberOfGuests',
	    'defaultmemory'=>'2048'
	}
    },
    'S1'=>{
	'External Production' => {
	    'networks'=>[
		"VL100_10.61.1.0-27", #External
		"VL101_10.61.1.32-27", #External
		"VL102_157.166.252.0-28", #External
		"VL112_10.61.1.192-28", #External
		"VL122_10.61.5.0-24", #External
		"VL125_157.166.252.128-25" #External
	    ],
	    'host'=>'esxs1extprd1.turner.com',
	    'server'=>'vcenters1app1',
	    'dsregex'=>'SVC_S1|grep -v SAN',
	},
	'Internal Production' => {
	    'networks'=>[
		"VL100" #Internal
	    ],
	    'host'=>'esxs1intprd1.turner.com',
	    'server'=>'vcenters1app1',
	    'dsregex'=>'SAN_SVC'
	}
    },
    '8 South'=>{
	'External Production (L16A)' => {
	    'networks'=>[
		"VL103_10.165.25.128-25", #External
		"VL101_157.166.228.32-28", #External
		"VL100_10.165.24.0-24" #External
	    ],
	    'host'=>'esx8ext1.turner.com',
	    'dsregex'=>'L16A',
	    'server'=>'vcenter8app1'
	},
	'External Production (L16B)' => {
	    'networks'=>[
		"VL103_10.165.25.128-25", #External
		"VL101_157.166.228.32-28", #External
		"VL100_10.165.24.0-24" #External
	    ],
	    'host'=>'esx8ext8.turner.com',
	    'dsregex'=>'L16B',
	    'server'=>'vcenter8app1'
	},
	'Internal Production (S54C)' => {
	    'networks'=>[
		"VL151_10.165.139.0-24" #Internal
	    ],
	    'host'=>'esx8int1.turner.com',
	    'dsregex'=>'S54C',
	    'server'=>'vcenter8app1'
	},
	'Internal Production (S54D)' => {
	    'networks'=>[
		"VL151_10.165.139.0-24" #Internal
	    ],
	    'host'=>'esx8int8.turner.com',
	    'dsregex'=>'S54D',
	    'server'=>'vcenter8app1'
	}
    }
};

&main();

# Which datastore should we use given the datacenter chosen?
sub Datastore_Select {
    my($username,$password,$cluster) = @_;
    #Select Datastore
    my @output;
    my $server = $cluster->{'server'};
    my $dsregex = $cluster->{'dsregex'};
    @output = system ("/usr/local/bin/getVMsPerDatastore.pl --server $server --username $username --password $password |grep $dsregex");
    if (not $#output > 0) {
	die "ERROR: No datastores returned by our query"
    }
    if (exists $cluster->{'metric'} and $cluster->{'metric'} eq 'NumberOfGuests') {
	print "Please select the Datastore with the least number of VM's\n";
    } else {
	print "Please select the Datastore with the most amount of free space\n";
    }
    my @datastores;
    print join("\t","Datastore","PercentFree","NumofVMs"),"\n";
    foreach (@output) {
	my @columns = split(/\s+/);
	push @datastores,$columns[0];
	print join("\t",$columns[0],$columns[1],$columns[2]),"\n";
    }
    print "===============================================\n";
    return &Get_Selection('datastore',@datastores);
}

# Generate the XML file to use to create the VM guest.
sub XML{
    my($xmlfile,$vmname,$datastore,$network,$datacenter,$host,$memory,$guestid,$disksize,$nprocessors)=@_;
    my $xmlfh = new IO::File;
    $xmlfh->open("> $xmlfile") || die "Unable to open xml file ($xmlfile): $?";
    print $xmlfh "<?xml version=\"1.0\"?>\n";
    print $xmlfh "<Virtual-Machines>\n";
    print $xmlfh "         <Virtual-Machine>\n";
    print $xmlfh "            <Name>$vmname</Name>\n";
    print $xmlfh "                <Host>$host</Host>\n";
    print $xmlfh "                <Datacenter>$datacenter</Datacenter>\n";
    print $xmlfh "                <Guest-Id>$guestid</Guest-Id>\n";
    print $xmlfh "                <Datastore>$datastore</Datastore>\n";
    print $xmlfh "                <Disksize>",$disksize * 1024 * 1024,"</Disksize>\n"; #12GB Disk (normally)
    print $xmlfh "                <Memory>$memory</Memory>\n";
    print $xmlfh "                <Number-of-Processor>$nprocessors</Number-of-Processor>\n";
    print $xmlfh "                <Nic-Network>$network</Nic-Network>\n";
    print $xmlfh "                <Nic-Poweron>0</Nic-Poweron>\n";
    print $xmlfh "         </Virtual-Machine>\n";
    print $xmlfh "</Virtual-Machines>\n";
    $xmlfh->close();
    if ($Debug) {
	my $debugxmlfh = new IO::File;
	$debugxmlfh->open("< $xmlfile") || die "Unable to open xml file ($xmlfile): $?";
	print while(<$debugxmlfh>);
	$debugxmlfh->close();
    }
}

# Prompt the user to select from a list of options (passed as an array)
sub Get_Selection {
    my($type,@selections)=@_;
    print "-----------------------------\n";
    my $selected = undef;
    while (!defined $selected) {
	my $i = 0;
	my $selection;
	my $indexes = {};
	foreach $selection (@selections) {
	    $i++;
	    print "($i) ",$selection,"\n";
	    $indexes->{$i} = $selection;
	}
	print "Please select your $type: \n";
	my $index = <STDIN>;
	chomp($index);
	if (not exists $indexes->{$index}) {
	    print STDERR "I did not understand your selection.\n";
	} else {
	    $selected = $indexes->{$index};
	}
    }
    print "You have selected $type: ",$selected,"\n";
    return $selected;
}

sub Get_Password {
    my($datacenter)=@_;
    print "Please enter your $datacenter Virtual Center password\n";
    my $password;
    system "stty -echo";
    chomp($password=<STDIN>);
    system "stty echo";
    $password="\"" . $password . "\""; # To address other characters in passwords.
    return $password;
}

sub main {
    my $vmname=$ARGV[0]; #VMname
    if(!length $vmname) {
	die "No hostname given for VM Guest! (Usage: create_vm.pl <vmname>";
    }
    my $username = `whoami`;
    my $guestid = 'rhel5_64Guest';
    my $disksize = 12;
    my $nprocessors = 2;
    chomp($username);
    my $xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
    print "This script will create a RH5 VM in $datacenter datacenter using our standard config, ",$disksize,"G disk ",$memory,"G ram ",$nprocessors," CPU\n";
    my $datacenter = &Get_Selection('datacenter',keys %{ $CLUSTERS });
    my $clustername = &Get_Selection('cluster',keys %{$CLUSTERS->{$datacenter}});
    my $cluster = $CLUSTERS->{$datacenter}->{$clustername};
    my $network = &Get_Selection('network',@{$cluster->{'networks'}});
    my $password = &Get_Password($datacenter);
    my $datastore = &Datastore_Select($username,$password,$cluster);
    my $memory = 4096;
    if (exists $cluster->{'defaultmemory'} and $cluster->{'defaultmemory'} > 0) {
	$memory = $cluster->{'defaultmemory'};
    }
    &XML($xmlfile,$vmname,$datastore,$network,$datacenter,$cluster->{'host'},$memory,$guestid,$disksize,$nprocessors);
    system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server ".$cluster->{'server'}." --username $username --password $password --filename $xmlfile");
}

