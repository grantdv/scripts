#!/usr/bin/perl
use strict;
use warnings;

my $f1 = $ARGV[0];
my $f2 = $ARGV[1];
my $outfile = 'out.txt';
my %results = ();

open FILE1, "$f1" or die "Could not open file: $! \n";
while(my $line = <FILE1>){
   $results{$line}=1;
}
close(FILE1);

open FILE2, "$f2" or die "Could not open file: $! \n";
while(my $line =<FILE2>) {
   $results{$line}++;
}
close(FILE2);


open (OUTFILE, ">$outfile") or die "Cannot open $outfile for writing \n";
foreach my $line (keys %results) {
   print OUTFILE $line if $results{$line} == 1;
}
close OUTFILE;
