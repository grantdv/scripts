#!/usr/bin/perl -w

# Written by: Grant Della Vecchia
# Lead Cloud Architect - CEI - 5.7.2012
# disk_test.pl - This script will run several iterations for to benchmark disks.
# Version 1.0

# Sample command time dd if=/dev/zero of=dd.out bs=32k count=10240

# Variables ------------------------------------------------
$outfile = "Test_Results.txt";
# End ------------------------------------------------------

open OUTFILE1, ">$outfile"; # <-- Name of the output file

chomp($fp = `time dd if=/dev/zero of=dd.out bs=32k count=10240|grep real &`);
print OUTFILE1 "First Pass 320mb $fp\n";
