#!/usr/bin/perl

my $ip_address = $ARGV[0];

my $networks_file = "/usr/local/bin/networks.txt";

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
                my $network = $1;
                print "$network"; 
                last;
            }
        }
    }
}
