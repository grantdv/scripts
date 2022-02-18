#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  s1_create.pl
#
#        USAGE:  s1_create.pl <vmname>
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
#      CREATED:  6/8/2010
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmname=$ARGV[0]; #VMname
chomp($username = `whoami`); #Who am I??
$xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
#End-------------------------------------------------------
print "This script will create a RH5 VM in s1 using our standard config, 12G disk 2G ram 2 CPU\n";
print "Please enter your s1 Virtual Center password\n";
system "stty -echo";
chomp($password=<STDIN>);
system "stty echo";
$password="\"" . $password . "\""; # To address other characters in passwords.

Get_IP(); #Aquiring the IP Address of the new server via DNS.=
Choose_OS();
Cluster_Select();
Network_Select();
Datastore_Select();
XML();
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
	}elsif ($distro==2){
		$dist="RHEL5";
		$os_type="ubuntu64Guest";
	}
}

sub Cluster_Select {
    $ext1 = "External Production";
    $int1 = "Internal Production";
    #Select Cluster
    print "Please select cluster\n";
    print "$ext1 (1), $int1 (2)\n";
    chomp($cluster=<STDIN>);
    if ($cluster == 1 ) {
        $host = "esxs1extprd1.turner.com";
        $dsreg = "SVC_S1|grep -v SAN";
    }elsif($cluster == 2) {
        $host = "esxs1intprd1.turner.com";
        $dsreg = "SAN_SVC";
    }else{
        print "I did not understand your Cluster Selection\n";
        die;
    }
}
sub Network_Select {
    $vl100int = "VL100"; #Internal
    $vl100ext = "VL100_10.61.1.0-27"; #External
    $vl101 = "VL101_10.61.1.32-27"; #External
    $vl102 = "VL102_157.166.252.0-28"; #External
    $vl112 = "VL112_10.61.1.192-28"; #External
    $vl122 = "VL122_10.61.5.0-24"; #External
    $vl125 = "VL125_157.166.252.128-25"; #External
    
    if ($cluster == 1){
        print "Please select your network\n";
        print "$vl122 (1), $vl125 (2), $vl112 (3), $vl102 (4), $vl101 (5), $vl101 (6), $vl100ext (7)\n";
        chomp($network = <STDIN>);
    }elsif($cluster == 2){
        print "Please select your network\n";
        print "$vl100int (8)\n";
        chomp($network = <STDIN>);
    }
    #Select Network
    if ($network == 1) {
        $network = "$vl122";
    }elsif($network == 2) {
        $network = "$vl125";
    }elsif($network == 3) {
        $network = "$vl112";
    }elsif($network == 4){
        $network = "$vl102";
    }elsif($network == 5){
        $network = "$vl101";
    }elsif($network == 6){
        $network = "$vl101";
    }elsif($network == 7){
        $network = "$vl100ext";
    }elsif($network == 8){
        $network = "$vl100int";
    } else {
        print "I did not understand your network selection.\n";
        die;
    }
    
}
sub Datastore_Select {
     #Select Datastore
    print "Retrieving Datastore\n";
    @datastores = system ("/usr/local/bin/getVMsPerDatastore.pl --server vcenters1app1.turner.com --username $username --password $password |grep $dsreg|awk '{print\$1\" \" \"Percent Free\" \" \"\$2}'");
    pop(@datastores);
    
    foreach $datastore (@datastores) {
        print "$datastore";
    }
    print "Please select the Datastore with the most amount of free space (Please copy and Paste)\n";
    chomp($ds=<STDIN>);
}


sub XML{
    #Time to do the work..
    open (XML, ">$xmlfile") ||die;
    print XML "<?xml version=\"1.0\"?>\n";
    print XML "<Virtual-Machines>\n";
    print XML "         <Virtual-Machine>\n";
    print XML "            <Name>$vmname</Name>\n";
    print XML "                <Host>$host</Host>\n";
    print XML "                <Datacenter>S1</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>12582912</Disksize>\n"; #12GB Disk
    print XML "                <Memory>4096</Memory>\n";
    print XML "                <Number-of-Processor>2</Number-of-Processor>\n";
    print XML "                <Nic-Network>$network</Nic-Network>\n";
    print XML "                <Nic-Poweron>0</Nic-Poweron>\n";
    print XML "         </Virtual-Machine>\n";
    print XML "</Virtual-Machines>\n";
    close (XML);
}
#Doing the Work.
system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server vcenters1app1.turner.com --username $username --password $password --filename $xmlfile");
system ("/usr/local/bin/getAllVMMacs.pl --server vcenters1app1.turner.com --username $username --password $password|grep $vmname|awk '{print\"host $vmname \{ hardware ethernet \"\$6\"; fixed-address $ip; \}\"}'");