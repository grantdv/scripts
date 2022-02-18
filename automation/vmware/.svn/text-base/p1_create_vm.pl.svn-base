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
#      VERSION:  2.0
#      CREATED:  6/4/2010
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmname=$ARGV[0]; #VMname
chomp($username = `whoami`); #Who am I??
$xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
#End-------------------------------------------------------
print "This script will create a VM in P1 using our standard config, 12G disk 2G ram 2 CPU\n";
print "Please enter your P1 Virtual Center password\n";
system "stty -echo";
chomp($password=<STDIN>);
system "stty echo";
$password="\"" . $password . "\""; # To address other characters in passwords.

Get_IP(); #Aquiring the IP Address of the new server via DNS.
Choose_OS(); #Which OS, RHEL5 or Ubuntu
Network_Select(); #Which network to use.
Datastore_Select(); #Query Virtual Center, select and display the datastores based on which OS.
XML(); #Generate the XML file for the vmcreate script.
sub Get_IP{
	open HOST, "host $vmname|";
	$results = <HOST>;
	close HOST or die $! ? "DNS Seems to be a Problem: $!" : "Server Name does not appear to be in DNS: $?.";
	($ip) = reverse split ' ',$results;
#	print $ip;
}
sub Choose_OS{
	print "Please choose OS you wish to deploy\n";
	print "RHEL5 (1), Ubuntu (2)\n";
	chomp($distro=<STDIN>);	
	if ($distro==1) {
		$dist="RHEL5";
		$os_type="rhel5_64Guest";
		$deploy_host="esxp1-65.turner.com";
	}elsif ($distro==2){
		$dist="RHEL5";
		$os_type="ubuntu64Guest";
		$deploy_host="esxp1-65.turner.com";
	}
}
sub Network_Select {
    $p1vl106 = "VL106_10.189.136_137";
    $p1vl104 = "VL104_10.165.185-24";
    $p1vl101 = "VL101_10.165.184-24";
    $p1vl100 = "VL100_10.189.140_141";
    #Select Network
    print "You have selected P1.\n";
    print "Please select your network\n";
    print "$p1vl101 (1), $p1vl104 (2), $p1vl106 (3), $p1vl100 (4)\n";
    chomp($network = <STDIN>);
    if ($network == 1) {
        $network = "$p1vl101";
    }elsif($network == 2) {
        $network = "$p1vl104";
    }elsif($network == 3) {
        $network = "$p1vl106";
    }elsif($network == 4) {
        $network = "$p1vl100";
    } else {
        print "I did not understand your network selection.\n";
        die;
    }
}
sub Datastore_Select {
     #Select Datastore
    print "Selecting Datastore\n";
    @datastores = system ("/usr/local/bin/getVMsPerDatastore.pl --server vcenterp1app1.turner.com --username $username --password $password |grep $dist|awk '{print\$1\" \" \"Number of Guests\" \" \"\$3}'");
    pop(@datastores);
    
    foreach $datastore (@datastores) {
        print "$datastore";
    }
    print "Please select the Datastore with the lest number of VM's (Please copy and Paste)\n";
    chomp($ds=<STDIN>);
}
sub XML{
    #Time to do the work..
    open (XML, ">$xmlfile") ||die;
    print XML "<?xml version=\"1.0\"?>\n";
    print XML "<Virtual-Machines>\n";
    print XML "         <Virtual-Machine>\n";
    print XML "            <Name>$vmname</Name>\n";
    print XML "                <Host>$deploy_host</Host>\n";
    print XML "                <Datacenter>P1</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>12582912</Disksize>\n"; #12GB Disk
    print XML "                <Memory>2048</Memory>\n";
    print XML "                <Number-of-Processor>2</Number-of-Processor>\n";
    print XML "                <Nic-Network>$network</Nic-Network>\n";
    print XML "                <Nic-Poweron>0</Nic-Poweron>\n";
    print XML "         </Virtual-Machine>\n";
    print XML "</Virtual-Machines>\n";
    close (XML);
}
#Doing the Work.
system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server vcenterp1app1 --username $username --password $password --filename $xmlfile");
system ("/usr/local/bin/getAllVMMacs.pl --server vcenterp1app1.turner.com --username $username --password $password|grep $vmname|awk '{print\"host $vmname \{ hardware ethernet \"\$6\"; fixed-address $ip; \}\"}'");







