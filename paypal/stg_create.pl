#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  stg_create.pl
#
#        USAGE:  stg_create.pl <vmname>
#
#  DESCRIPTION:  This script will create the XML file to create a new VM.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@paypal.com>
#      COMPANY:  PayPal
#      VERSION:  1.6
#      CREATED:  6/14/2012
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmname=$ARGV[0]; #VMname
#chomp($username = `whoami`); #Who am I??
$xmlfile=".$vmname.xml"; #location of the XML file.
$vcserver="vcmlvs02.qa.paypal.com";
$username = "Administrator";
$password = "Welcome511";
#End-------------------------------------------------------
#print "This script will create a VM using our the standard PPSB config, 230G disk 16G ram 4 CPU\n";
#print "Please enter your Virtual Center password\n";
#system "stty -echo";
#chomp($password=<STDIN>);
#system "stty echo";
#$password="\"" . $password . "\""; # To address other characters in passwords.

$os_type="rhel5_64Guest";
Get_IP(); #Aquiring the IP Address of the new server via DNS.
Cluster_Select(); #Which cluster to use.
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

sub Cluster_Select { #<-- This section will figure out which string to grep the datastores and which host to deploy to from a cluster selection. If more clusters are added to Vmware, they need to be added here.
	$clu1 = "STG_520030101";
	$clu2 = "STG_520030102";
	$clu3 = "STG_520030103";
	$clu4 = "STG_520030104";
	$clu5 = "STG_520030201";
	$clu6 = "STG_520030202";
	$clu7 = "STG_520030203";
	$clu8 = "STG_520030204";
	$clu9 = "STG_520030302";
	$clu10 = "STG_520030303";
	print "Please select the desired Cluster\n";
	print "(1) $clu1, (2) $clu2, (3) $clu3, (4) $clu4, (5) $clu5\n(6) $clu6, (7) $clu7, (8) $clu8, (9) $clu9, (10) $clu10\n";
	chomp($clus = <STDIN>);
	if ($clus == 1) {
		$gstring = "101_vmvol";
		$deploy_host = "lvs-stg-esx25.qa.paypal.com";
	}elsif ($clus == 2) {
		$gstring = "102_vmvol";
		$deploy_host = "lvs-stg-esx17.qa.paypal.com";
	}elsif ($clus == 3) {
		$gstring = "103_vmvol";
		$deploy_host = "lvs-stg-esx09.qa.paypal.com";
	}elsif ($clus == 4) {
		$gstring = "104_vmvol";
		$deploy_host = "lvs-stg-esx01.qa.paypal.com";
	}elsif ($clus == 5) {
		$gstring = "201_vmvol";
		$deploy_host = "lvs-stg-esx57.qa.paypal.com";
	}elsif ($clus == 6) {
		$gstring = "202_vmvol";
		$deploy_host = "lvs-stg-esx49.qa.paypal.com";
	}elsif ($clus == 7) {
		$gstring = "203_vmvol";
		$deploy_host = "lvs-stg-esx41.qa.paypal.com";
	}elsif ($clus == 8) {
		$gstring = "204_vmvol";
		$deploy_host = "lvs-stg-esx33.qa.paypal.com";
	}elsif ($clus == 9) {
		$gstring = "302_vmvol";
		$deploy_host = "lvs-stg-esx65.qa.paypal.com";
	}elsif ($clus == 10) {
		$gstring = "303_vmvol";
		$deploy_host = "lvs-stg-esx73.qa.paypal.com";
	}else {
		print "I did not understand your Cluster selection, please try again\n";
		die;
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
    print XML "                <Datacenter>LVS_STG</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>230686720</Disksize>\n"; #220GB
    print XML "                <Memory>16384</Memory>\n"; #16GB
    print XML "                <Number-of-Processor>4</Number-of-Processor>\n";
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