#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  bulk_create.pl
#
#        USAGE:  bulk_create.pl <vmname>
#
#  DESCRIPTION:  This script will create the XML file to create a new VM.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@paypal.com>
#      COMPANY:  PayPal
#      VERSION:  3.0
#      CREATED:  5/29/2012
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$server_file = $ARGV[0];
$username = "Administrator";
$password = "Welcome511";
$os_type="rhel5_64Guest";
$delay = $ARGV[1];
#End-------------------------------------------------------

if ($delay == undef) {
	$delay = "2"
}
	

Get_hostname (); #<-- Getting hostname and cluster from txt file;


sub Get_hostname {
	open (HF,"$server_file")|| die;
	while  (<HF>){
		@line = split (/ /);
		$vmname = $line[0];
		chomp($cluster = $line[1]);
		@env = split (/_/,$line[1]);
		$xmlfile=".$vmname.xml"; #location of the XML file.
		print "Working on $vmname\n";
		#print "$vmname is the name and $cluster is the cluster\n";
		Env_Select();
		Get_IP();
		Network_Select();
		Datastore_Select();
		XML();
		Do_the_work();
	}
	
}
sub Get_IP{ #<-- This sub will figure out the IP address of the hostname
	open HOST, "host $vmname.qa.paypal.com|";
	$results = <HOST>;
	close HOST or die $! ? "DNS Seems to be a Problem: $!" : "Server Name does not appear to be in DNS: $?.";
	($ip) = reverse split ' ',$results;
}

sub Env_Select {
	#print "Selecting which Enviornment\n";
	if ($env[0] eq "SET") {
		$disk_size = "230686720"; #230GB
		$ram_size = "16384"; #16GB
		$cpus = "4";
		$dc_name = "LVS_SET";
		$vcserver = "vcmlvs03.qa.paypal.com";
		SET_Select($cluster);
	}elsif ($env[0] eq "STG"){
		$disk_size = "230686720"; #230GB
		$ram_size = "16384"; #16GB
		$cpus = "4";
		$dc_name = "LVS_STG";
		$vcserver = "vcmlvs02.qa.paypal.com";
		STG_Select();
	}elsif ($env[0] eq "CORE") {
		$disk_size = "52428800"; #50GB
		$ram_size = "12288"; #12GB
		$cpus = "2";
		$dc_name = "LVS_CORE";
		$vcserver = "vcmlvs01.qa.paypal.com";
		CORE_Select();
	}
}

sub SET_Select { #<-- If the Env is Set, this sub will select the correct host and datastore search string.
	if ($cluster eq "SET_520030502") {
		$gstring = "502_vmvol";
		$deploy_host = "lvs-set-esx01.qa.paypal.com";
	}elsif ($cluster eq "SET_520030503") {
		$gstring = "503_vmvol";
		$deploy_host = "lvs-set-esx10.qa.paypal.com";
	}elsif ($cluster eq "SET_520030504") {
		$gstring = "504_vmvol";
		$deploy_host = "lvs-set-esx17.qa.paypal.com";
	}elsif ($cluster eq "SET_520030701") {
		$gstring = "701_vmvol";
		$deploy_host = "lvs-set-esx25.qa.paypal.com";
	}else {
		print "I did not understand your Cluster selection, please try again\n";
		die;
	}

}

sub STG_Select { #<-- If the Env is STG, this sub will select the correct host and datastore search string.
	if ($cluster eq "STG_520030103") {
		$gstring = "103_vmvol";
		$deploy_host = "lvs-stg-esx09.qa.paypal.com";
	}elsif ($cluster eq "STG_520030104") {
		$gstring = "104_vmvol";
		$deploy_host = "lvs-stg-esx01.qa.paypal.com";
	}elsif ($cluster eq "STG_520030101") {
		$gstring = "101_vmvol";
		$deploy_host = "lvs-stg-esx25.qa.paypal.com";
	}elsif ($cluster eq "STG_520030102") {
		$gstring = "102_vmvol";
		$deploy_host = "lvs-stg-esx17.qa.paypal.com";
	}elsif ($cluster eq "STG_520030201") {
		$gstring = "201_vmvol";
		$deploy_host = "lvs-stg-esx57.qa.paypal.com";
	}elsif ($cluster eq "STG_520030202") {
		$gstring = "202_vmvol";
		$deploy_host = "lvs-stg-esx49.qa.paypal.com";
	}elsif ($cluster eq "STG_520030203") {
		$gstring = "203_vmvol";
		$deploy_host = "lvs-stg-esx41.qa.paypal.com";
	}elsif ($cluster eq "STG_520030204") {
		$gstring = "204_vmvol";
		$deploy_host = "lvs-stg-esx33.qa.paypal.com";
	}elsif ($cluster eq "STG_520030302") {
		$gstring = "302_vmvol";
		$deploy_host = "lvs-stg-esx65.qa.paypal.com";
	}elsif ($cluster eq "STG_520030303") {
		$gstring = "303_vmvol";
		$deploy_host = "lvs-stg-esx73.qa.paypal.com";
	}else {
		print "I did not understand your Cluster specification, please try again\n";
		die;
	}
}


sub CORE_Select { #<-- If the Env is Core, this sub will select the correct host and datastore search string.
	if ($cluster eq "CORE_520030702") {
		$gstring = "702_vmvol";
		$deploy_host = "lvs-core-esx01.qa.paypal.com";
	}else {
		print "I did not understand your Cluster specification, please try again\n";
		die;
	}
}
sub Network_Select { #<-- This sub wil figure out which network to select from the IP address.
	chomp($network = `/usr/local/bin/get_network-mod.pl $ip`); #<-- This script figures out the vmware network lable based on IP address.
	print "IP is: $ip ; Network is: $network\n";
}
sub Datastore_Select { #<-- This sub will determing which Datastore to use by least number of guests on each DS.
	$ds = `/usr/local/bin/getVMsPerDatastore.pl --server $vcserver --username $username --password $password|grep $gstring|awk '{print \$1\"	\"\$3}'|sort +1 -n|head -1|awk '{print\$1}'`;
	chomp($ds);
	print "This is the Datastore that will be used $ds\n";
}
sub XML{
    print "Making the XML\n";
    open (XML, ">$xmlfile") ||die;
    print XML "<?xml version=\"1.0\"?>\n";
    print XML "<Virtual-Machines>\n";
    print XML "         <Virtual-Machine>\n";
    print XML "            <Name>$vmname</Name>\n";
    print XML "                <Host>$deploy_host</Host>\n";
    print XML "                <Datacenter>$dc_name</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>$disk_size</Disksize>\n"; 
    print XML "                <Memory>$ram_size</Memory>\n"; 
    print XML "                <Number-of-Processor>$cpus</Number-of-Processor>\n";
    print XML "                <Nic-Network>$network</Nic-Network>\n";
    print XML "                <Nic-Poweron>0</Nic-Poweron>\n";
    print XML "         </Virtual-Machine>\n";
    print XML "</Virtual-Machines>\n";
    close (XML);
}
sub Do_the_work{
	print "Doing the Work.\n";
	system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server $vcserver --username $username --password $password --filename $xmlfile"); #creting the VM
	chomp($mac= `/usr/local/bin/vmNICManagement.pl --server $vcserver --username $username --password $password --operation query --vnic 1 --vmname $vmname|grep MAC|awk '{print\$3}'`); #collecting the MacAddress
	system ("ssh root\@kickstartlvs01.qa.paypal.com \"/x/cobbler/scripts/pp_cobbler.pl -a -n $vmname -m $mac\""); #adding server to cobbler
	sleep 2; # Giving cobbler tile to restart the DHCP server. Changed 1 to 2
	system ("/usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --server $vcserver --username $username --password $password --operation poweron --vmname $vmname"); #powering on the VM
	#cleaning Up
	unlink $xmlfile;
	print "Sleeping for $delay seconds\n"; #<-- Sleep statement to keep from over running the KS server.
	sleep $delay;
}


