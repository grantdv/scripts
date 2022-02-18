#!/usr/bin/perl
#Grant Della Vecchia
# This script will change the name of a directory. 
# THis is a supporting script for the stats.

# Variables------------------------------------------------
chomp($year = $ARGV[0]); # <-- What year to prepend to the directory
# End------------------------------------------------------

while (<*>) {
	print "$_\n";
	system "mv $_ $_-$year";
}
