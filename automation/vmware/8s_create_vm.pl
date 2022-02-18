#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  8s_create.pl
#
#        USAGE:  8s_create.pl <vmname>
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
print "This script will create a RH5 VM in 8S using our standard config, 12G disk 4G ram 2 CPU\n";
print "Please enter your 8S Virtual Center password\n";
system "stty -echo";
chomp($password=<STDIN>);
system "stty echo";
$password="\"" . $password . "\""; # To address other characters in passwords.

Get_IP(); #Aquiring the IP Address of the new server via DNS.
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
    $ext1 = "ext_prod8sl16aa";
    $ext2 = "ext_prod8sl16bc";
    $int1 = "int_prod8ss54ca";
    $int2 = "int_prod8ss54dc";
    #Select Cluster
    print "Please select cluster\n";
    print "$ext1 (1), $ext2 (2), $int1 (3), $int2 (4)\n";
    chomp($cluster=<STDIN>);
    if ($cluster == 1 ) {
        $host = "esx8ext1.turner.com";
        $dsreg = "L16A";
    }elsif($cluster == 2) {
        $host = "esx8ext8.turner.com";
        $dsreg = "L16B";
    }elsif($cluster == 3) {
        $host = "esx8int1.turner.com";
        $dsreg = "S54C";
    }elsif($cluster == 4) {
        $host = "esx8int8.turner.com";
        $dsreg = "S54D";
    }else{
        print "I did not understand your Cluster Selection\n";
        die;
    }
}

sub Network_Select {
    $vl103 = "VL103_10.165.25.128-25"; #External
    $vl101 = "VL101_157.166.228.32-28"; #External
    $vl100 = "VL100_10.165.24.0-24"; #External
    $vl151 = "VL151_10.165.139.0-24"; #Internal
    
    if ($cluster == 1){
        print "Please select your network\n";
        print "$vl100 (1), $vl103 (2), $vl101 (3)\n";
        chomp($network = <STDIN>);
    }elsif($cluster == 2){
        print "Please select your network\n";
        print "$vl100 (1), $vl103 (2), $vl101 (3)\n";
        chomp($network = <STDIN>);
    }elsif($cluster ==3){
        print "Please select your network\n";
        print "$vl151 (4)\n";
        chomp($network = <STDIN>);
    }elsif($cluster ==4){
        print "Please select your network\n";
        print "$vl151 (4)\n";
        chomp($network = <STDIN>);
    }
    #Select Network
    if ($network == 1) {
        $network = "$vl100";
    }elsif($network == 2) {
        $network = "$vl103";
    }elsif($network == 3) {
        $network = "$vl101";
    }elsif($network == 4){
        $network = "$vl151";
    } else {
        print "I did not understand your network selection.\n";
        die;
    }
    
}

sub Datastore_Select {
     #Select Datastore
    print "Retrieving Datastore\n";
    @datastores = system ("/usr/local/bin/getVMsPerDatastore.pl --server vcenter8app1.turner.com --username $username --password $password |grep $dsreg|awk '{print\$1\" \" \"Percent Free\" \" \"\$2}'");
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
    print XML "                <Datacenter>8 South</Datacenter>\n";
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
system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server vcenter8app1.turner.com --username $username --password $password --filename $xmlfile");
system ("/usr/local/bin/getAllVMMacs.pl --server vcenter8app1.turner.com --username $username --password $password|grep $vmname|awk '{print\"host $vmname \{ hardware ethernet \"\$6\"; fixed-address $ip; \}\"}'");
