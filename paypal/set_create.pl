#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  set_create.pl
#
#        USAGE:  set_create.pl <vmname>
#
#  DESCRIPTION:  This script will create the XML file to create a new VM.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@paypal.com>
#      COMPANY:  PayPal
#      VERSION:  3.1
#      CREATED:  6/21/2012
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmname = $ARGV[0]; #VMname
#chomp($username = `whoami`); #Who am I??
#$xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
$xmlfile =".$vmname.xml"; #location of the XML file.
$vcserver ="vcmlvs03.qa.paypal.com";
$username ="Administrator";
$password = "Welcome511";
$size = $ARGV[1];
#End-------------------------------------------------------
#print "This script will create a VM using our the standard PPSB config, 230G disk 16G ram 4 CPU\n";
#print "Please enter your Virtual Center password\n";
#system "stty -echo";
#chomp($password=<STDIN>);
#system "stty echo";
#$password="\"" . $password . "\""; # To address other characters in passwords.
if ($vmname eq undef) {
	usage();
	die;
}else{
	$os_type="rhel5_64Guest";
	Get_IP(); #Aquiring the IP Address of the new server via DNS.
	Cluster_Select(); #Which cluster to use.
	Size(); #Routine to select the size.
	Network_Select(); #Which network to use.
	Datastore_Select(); #Query Virtual Center, select and display the datastores based on which OS.
	XML(); #Generate the XML file for the vmcreate script.	
}



sub Get_IP{
	open HOST, "host $vmname|";
	$results = <HOST>;
	close HOST or die $! ? "DNS Seems to be a Problem: $!" : "Server Name does not appear to be in DNS: $?.";
	($ip) = reverse split ' ',$results;
#	print $ip;
}

sub Cluster_Select {
	$clu1 = "SET_520030502";
	$clu2 = "SET_520030503";
	$clu3 = "SET_520030504";
	$clu4 = "SET_520030701";
	print "Please select the desired Cluster\n";
	print "(1) $clu1, (2) $clu2, (3) $clu3, (4) $clu4\n";
	chomp($clus = <STDIN>);
	if ($clus == 1) {
		$gstring = "502_vmvol";
		$deploy_host = "lvs-set-esx01.qa.paypal.com";
	}elsif ($clus == 2) {
		$gstring = "503_vmvol";
		$deploy_host = "lvs-set-esx10.qa.paypal.com";
	}elsif ($clus == 3) {
		$gstring = "504_vmvol";
		$deploy_host = "lvs-set-esx17.qa.paypal.com";
	}elsif ($clus == 4) {
		$gstring = "701_vmvol";
		$deploy_host = "lvs-set-esx25.qa.paypal.com";
	}else {
		print "I did not understand your Cluster selection, please try again\n";
		die;
	}
}
sub Size {
	if ($size == undef) { #<-- Default small size
		print "As a size was not specified, I will use the default size options: 2 CPU's, 8GB Ram, 100GB Disk\n";
		$disk = "104857600"; #<-- 100GB 
		$ram = "8192";
		$cpu = "2";
	}elsif ($size == 1) { #<-- Medium with 2CPU
		print "You have selected a medium VM, 2 CPU's, 12GB Ram and 100GB Disk\n";
		$disk = "104857600"; #<-- 100GB 
		$ram = "12288";
		$cpu = "2";
	}elsif ($size == 2) { #<-- Large with 2CPU
		print "You have selected a Large VM, 2 CPU's, 16GB Ram and 100GB Disk\n";
		$disk = "104857600"; #<-- 100GB 
		$ram = "16384";
		$cpu = "2";
	}elsif ($size == 3) { #<-- Stage2 Size
		print "You have selected a \"Stage2\" VM, 4CPU's, 16GB Ram and 220GB Disk\n";
		$disk = "230686720"; #<-- 230GB
		$ram = "16384";
		$cpu = "4";
	}
}
sub Network_Select { #<-- This sub wil figure out which network to select from the IP address.
	chomp($network = `/usr/local/bin/get_network-mod.pl $ip`); #<-- This script figures out the vmware network lable based on IP address.
	print "IP is: $ip ; Network is: $network\n";
}

sub Datastore_Select {
	$ds = `/usr/local/bin/getVMsPerDatastore.pl --server $vcserver --username $username --password $password|grep $gstring|awk '{print \$1\"	\"\$3}'|sort +1 -n|head -1|awk '{print\$1}'`;
	chomp($ds);

	print "The Datastore that will be used for $vmname is $ds\n";
}
sub XML{
    #Time to do the work..
    open (XML, ">$xmlfile") ||die;
    print XML "<?xml version=\"1.0\"?>\n";
    print XML "<Virtual-Machines>\n";
    print XML "         <Virtual-Machine>\n";
    print XML "            <Name>$vmname</Name>\n";
    print XML "                <Host>$deploy_host</Host>\n";
    print XML "                <Datacenter>LVS_SET</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>$disk</Disksize>\n"; 
    print XML "                <Memory>$ram</Memory>\n"; 
    print XML "                <Number-of-Processor>$cpu</Number-of-Processor>\n";
    print XML "                <Nic-Network>$network</Nic-Network>\n";
    print XML "                <Nic-Poweron>0</Nic-Poweron>\n";
    print XML "         </Virtual-Machine>\n";
    print XML "</Virtual-Machines>\n";
    close (XML);
}
#Doing the Work.
system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server $vcserver --username $username --password $password --filename $xmlfile"); #creting the VM
chomp($mac= `/usr/local/bin/vmNICManagement.pl --server $vcserver --username $username --password $password --operation query --vnic 1 --vmname $vmname|grep MAC|awk '{print\$3}'`); #collecting the MacAddress
system ("ssh root\@kickstartlvs01.qa.paypal.com \"/x/cobbler/scripts/pp_cobbler.pl -a -n $vmname -m $mac\""); #<-- Configuring KS.
sleep 1; # Giving cobbler tile to restart the DHCP server
system ("/usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --server $vcserver --username $username --password $password --operation poweron --vmname $vmname"); #powering on the VM
unlink $xmlfile;


sub usage {
	print "This script will create a guest in the SET enviornment.\n";
	print "Expected syntax is set_create.pl <vmname> <size number>\n";
	print "The vmname needs to have DNS already, if it doesn't, the script will fail.\n";
	print "The default size is 2 CPU's, 8GB Ram and 100GB Disk. If you leave the size field blank, this is the size you will get.\n";
	print "The other size options are: 1 - 2 CPU's, 12GB ram, 100GB disk. 2 - 2 CPU's, 16GB Ram, 100GB Disk. 3 - 4 CPU's, 16GB Ram, 220GB Disk.\n";
}
