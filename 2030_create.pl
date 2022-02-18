#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  2030_create.pl
#
#        USAGE:  2030_create.pl <vmname>
#
#  DESCRIPTION:  This script will create the XML file to create a new VM.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@paypal.com>
#      COMPANY:  PayPal
#      VERSION:  1.0
#      CREATED:  5/18/2012
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmname=$ARGV[0]; #VMname
$username = "ceiadmin"; #Who am I??
#chomp($username = `whoami`); #Who am I??
#$xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
$xmlfile=".$vmname.xml"; #location of the XML file.m
$vcserver="sc4vc2-2030.sc4.paypal.com";
#End-------------------------------------------------------
#print "This script will create a VM using our standard config, 12G disk 2G ram 2 CPU\n";
#print "Please enter your Virtual Center password\n";
#system "stty -echo";
#chomp($password=<STDIN>);
#system "stty echo";
#$password="\"" . $password . "\""; # To address other characters in passwords.
$password = "blank";

$os_type="rhel5_64Guest";
$deploy_host="sc4-ppdovmqa-311.sc4.paypal.com";
Get_IP(); #Aquiring the IP Address of the new server via DNS.
#Network_Select(); #Which network to use.
Datastore_Select(); #Query Virtual Center, select and display the datastores based on which OS.
XML(); #Generate the XML file for the vmcreate script.
sub Get_IP{
	open HOST, "host $vmname|";
	$results = <HOST>;
	close HOST or die $! ? "DNS Seems to be a Problem: $!" : "Server Name does not appear to be in DNS: $?.";
	($ip) = reverse split ' ',$results;
	print $ip;
}
#sub Network_Select {
#	$vl396="VL396_10.57.96_23";
#	$vl398="VL398_10.57.98_23"
#    $p1vl106 = "VL106_10.189.136_137";
#    $p1vl104 = "VL104_10.165.185-24";
#    $p1vl101 = "VL101_10.165.184-24";
#    $p1vl100 = "VL100_10.189.140_141";
#    #Select Network
#    print "You have selected P1.\n";
#    print "Please select your network\n";
#    print "$p1vl101 (1), $p1vl104 (2), $p1vl106 (3), $p1vl100 (4)\n";
#    chomp($network = <STDIN>);
#    if ($network == 1) {
#        $network = "$p1vl101";
#    }elsif($network == 2) {
#        $network = "$p1vl104";
#    }elsif($network == 3) {
#        $network = "$p1vl106";
#    }elsif($network == 4) {
#        $network = "$p1vl100";
#    } else {
#        print "I did not understand your network selection.\n";
#        die;
#    }
#}
sub Datastore_Select {
	$ds = `/usr/local/bin/getVMsPerDatastore.pl --server $vcserver --username $username --password $password|grep head|awk '{print \$1\"	\"\$3}'|sort +1 -n|head -1|awk '{print\$1}'`;
	chomp($ds);
	print"$ds\n";
}
sub XML{
    #Time to do the work..
    open (XML, ">$xmlfile") ||die;
    print XML "<?xml version=\"1.0\"?>\n";
    print XML "<Virtual-Machines>\n";
    print XML "         <Virtual-Machine>\n";
    print XML "            <Name>$vmname</Name>\n";
    print XML "                <Host>$deploy_host</Host>\n";
    print XML "                <Datacenter>POD11</Datacenter>\n";
    print XML "                <Guest-Id>$os_type</Guest-Id>\n";
    print XML "                <Datastore>$ds</Datastore>\n";
    print XML "                <Disksize>230686720</Disksize>\n"; #220GB
    print XML "                <Memory>16384</Memory>\n"; #16GB
    print XML "                <Number-of-Processor>4</Number-of-Processor>\n";
    print XML "                <Nic-Network>VM Network21</Nic-Network>\n";
    print XML "                <Nic-Poweron>0</Nic-Poweron>\n";
    print XML "         </Virtual-Machine>\n";
    print XML "</Virtual-Machines>\n";
    close (XML);
}
#Doing the Work.
system ("/usr/lib/vmware-vcli/apps/vm/vmcreate.pl --server $vcserver --username $username --password $password --filename $xmlfile"); #creting the VM
chomp($mac= `/usr/local/bin/vmNICManagement.pl --server $vcserver --username $username --password $password --operation query --vnic 1 --vmname $vmname|grep MAC|awk '{print\$3}'`); #collecting the MacAddress
system ("ssh root\@v3cobbler01.sc4.paypal.com \"/x/cobbler/scripts/cobbler_wrapper.pl add $vmname $mac\""); #adding server to cobbler
#print "ssh cobbler\@v3cobbler01.sc4.paypal.com \"/x/cobbler/scripts/cobbler_wrapper.pl add $vmname $mac\""; #adding server to cobbler
sleep 2; # Giving cobbler time to restart the DHCP server
system ("/usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --server $vcserver --username $username --password $password --operation poweron --vmname $vmname"); #poweing on the VM
