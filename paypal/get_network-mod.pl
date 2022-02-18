#!/usr/bin/perl
#===============================================================================
#
#         FILE:  get_network-mod.pl
#
#        USAGE:  get_network-mod.pl <ip>
#
#  DESCRIPTION:  This script will figure out which vmware lable to use based on the IP address found in DNS for the guest name.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Kalin Nikolov (Primary)  - Modifications by: Grant Della Vecchia <gdellavecchia@paypal.com>
#      COMPANY:  PayPal
#      VERSION:  1.0
#      CREATED:  6/14/2012
#     REVISION:  ---
#===============================================================================

my $ip_address = $ARGV[0];

my $networks_file = "/usr/local/bin/networks.txt"; #<-- This file holds the networks and subnets. If a new network is added to Vmware, it needs to be added here as well.

my $found_router;
my $found_netmask;

my %Netmasks = (
       24 => "255.255.255.0",
       23 => "255.255.254.0",
       22 => "255.255.252.0",
       21 => "255.255.248.0",
);

my @NetworksFile = `cat $networks_file`;
my @PossibleSubnets = ();
foreach my $key (keys %Netmasks) {
    my $subnet = `/usr/bin/ipcalc -n $ip_address/$key | grep Network: | awk '{print \$2}'`;
    chomp($subnet);
    my $possible_line = "$subnet";
    push @PossibleSubnets, $possible_line;
}

foreach my $line (@NetworksFile) {
    chomp($line);
    foreach my $possible_line (@PossibleSubnets) {
        if ($line eq $possible_line) {
            if ($line =~ m/(.*)\/(.*)/) {
                $network = $1;
                #print "$network"; 
                last;
            }
        }
    }
}
if ($network eq "10.57.96.0") { #<-- This is the section that figures out which Network label needs to be used for the guest.
	$lable = "VL396_10.57.96_23";
}elsif ($network eq "10.57.72.0") {
	$lable = "VL372_10.57.72_22";
}elsif ($network eq "10.57.76.0") {
	$lable = "VL376_10.57.76_22";
}elsif ($network eq "10.57.80.0") {
	$lable = "VL380_10.57.80_22";
}elsif ($network eq "10.57.84.0") {
	$lable = "VL384_10.57.84_22";
}elsif ($network eq "10.57.88.0") {
	$lable = "VL388_10.57.88_22";
}elsif ($network eq "10.57.92.0") {
	$lable = "VL392_10.57.92_22";
}elsif ($network eq " " ) {
	print "I was not able to determine the network!\n";
	die;
}
print $lable;
