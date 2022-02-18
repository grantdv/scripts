#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  poweronvm.pl
#
#        USAGE:  poweronvm.pl <datacenter> <vmname>
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
#      CREATED:  9/24/2010
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
chomp($dc=$ARGV[0]);
chomp($vmname=$ARGV[1]);
chomp($username = `whoami`); #Who am I??
#End-------------------------------------------------------
print "Please enter your $dc Virtual Center password\n";
system "stty -echo";
chomp($password=<STDIN>);
system "stty echo";
$password="\"" . $password . "\""; # To address other characters in passwords.

if ($dc eq "8" or "8s"){
	$vcserver="vcenter8app1.turner.com";
}elsif($dc eq "p1") {
	$vcserver = "vcenterp1app1.turner.com";
}elsif($dc eq "s1"){
	$vcserver ="vcenters1app1.turner.com";
}


print "Powering on $vmname, if I am not back in 5 minutes, just wait longer!\n";
system ("/usr/lib/vmware-vcli/apps/vm/vmcontrol.pl --server $vcserver --username $username --password $password --vmname $vmname --operation poweron");
