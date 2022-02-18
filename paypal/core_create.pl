#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  core_create.pl
#
#        USAGE:  core_create.pl <vmname>
#
#  DESCRIPTION:  This script will create the XML file to create a new VM.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@paypal.com>
#      COMPANY:  PayPal
#      VERSION:  2.5
#      CREATED:  5/24/2012
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmname=$ARGV[0]; #VMname
#chomp($username = `whoami`); #Who am I??
#$xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
$xmlfile=".$vmname.xml"; #location of the XML file.
$vcserver="vcmlvs01.qa.paypal.com";
$username = "Administrator";
$gstring = "702_vmvol";	 #If another cluster is added to core, remove this line and the next.
$deploy_host = "lvs-core-esx01.qa.paypal.com";
#End-------------------------------------------------------
#Uncomment the following 6 lines when the hard coded user & pass aren't desired any longer.
#print "This script will create a VM using our the standard PPSB config, 230G disk 16G ram 4 CPU\n";
#print "Please enter your Virtual Center password\n";
#system "stty -echo";
#chomp($password=<STDIN>);
#system "stty echo";
#$password="\"" . $password . "\""; # To address other characters in passwords.
$password = "Welcome511";
if ($vmname eq undef) {
	usage();
	die;
}else{
	$os_type="rhel5_64Guest";
	Get_IP(); #Aquiring the IP Address of the new server via DNS.
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
	#print "The IP address of $vmname is $ip\n";
}

sub Size {
	if ($size == undef) { #<-- Default small size
		print "As a size was not specified, I will use the default size options: 2 CPU's, 8GB Ram, 50GB Disk\n";
		$disk = "52428800"; #<-- 50GB
		$ram = "8192";
		$cpu = "2";
	}elsif ($size == 1) { #<-- Medium with 2CPU
		print "You have selected a medium VM, 2 CPU's, 12GB Ram and 50GB Disk\n";
		$disk = "52428800"; #<-- 50GB 
		$ram = "12288";
		$cpu = "2";
	}elsif ($size == 2) { #<-- Large with 2CPU
		print "You have selected a Large VM, 2 CPU's, 16GB Ram and 50GB Disk\n";
		$disk = "52428800"; #<-- 50GB 
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
    print XML "                <Datacenter>LVS_CORE</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>$disk</Disksize>\n"; #50GB
    print XML "                <Memory>$ram</Memory>\n"; #12GB
    print XML "                <Number-of-Processor>$cpu</Number-of-Processor>\n";
    print XML "                <Nic-Network>$network</Nic-Network>\n";
    print XML "                <Nic-Poweron>0</Nic-Poweron>\n";
    print XML "         </Virtual-Machine>\n";
    print XML "</Virtual-Machines>\n";
    close (XML);
}
#Doing the Work.
print "Doing the work\n";
system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server $vcserver --username $username --password $password --filename $xmlfile"); #creting the VM
chomp($mac= `/usr/local/bin/vmNICManagement.pl --server $vcserver --username $username --password $password --operation query --vnic 1 --vmname $vmname|grep MAC|awk '{print\$3}'`); #collecting the MacAddress
print "Configuring Cobbler\n";
system ("ssh root\@kickstartlvs01.qa.paypal.com \"/x/cobbler/scripts/pp_cobbler.pl -a -n $vmname -m $mac\""); #<-- Configuring KS.
sleep 1; # Giving cobbler tile to restart the DHCP server
system ("/usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --server $vcserver --username $username --password $password --operation poweron --vmname $vmname"); #powering on the VM
unlink $xmlfile;

sub usage {
	print "This script will create a guest in the CORE enviornment.\n";
	print "Expected syntax is core_create.pl <vmname> <size number>\n";
	print "The vmname needs to have DNS already, if it doesn't, the script will fail.\n";
	print "The default size is 2 CPU's, 8GB Ram and 50GB Disk. If you leave the size field blank, this is the size you will get.\n";
	print "The other size options are: 1 - 2 CPU's, 12GB ram, 50GB disk. 2 - 2 CPU's, 16GB Ram, 50GB Disk. 3 - 4 CPU's, 16GB Ram, 220GB Disk.\n";
}