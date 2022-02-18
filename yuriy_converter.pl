#!/usr/bin/perl 
#use strict;
use Date::Manip; #<-- Perl Module to manupilate the date stamps.

# Written by Grant Della Vecchia
# 6-14-2011 Version 1.0
# yuriy_converter.pl <-- This script will tell the amount of hours a ticket took to complete from a csv file.
# Paypal, Inc. (Contractor)

#exapmle file format
#HWTSK13514647,Equipment_Management,HWREQ budget approval and backfill,jwaldron,03/16/11 14:20 PM,03/16/11 14:20 PM,,,,,,

#Variables-------------------------------------------------
$csv_file = "p1.csv";
#End-------------------------------------------------------

open (DATAFILE, "$csv_file"); #<-- Open the data file
while (<DATAFILE>) {
    @rdata = split(/\,/,$_); #<-- File is csv, break it into its elements
    @sdata1 = split(/ /,@rdata[4]); #<-- splitting the first date stamp into its elements
    @sdata2 = split(/ /,@rdata[5]); #<-- splitting the second date into its elements
    @fdate1 = @sdata1[0,1]; #<-- removing the "PM" from the array
    @fdate2 = @sdata2[0,1]; #<-- same as above..
    $ftime1 ="$fdate1[0] $fdate1[1]"; #<-- Putting the date into a format UnixDate expects
    $ftime2 ="$fdate2[0] $fdate2[1]"; #<-- same as above for second date
   my $time1 = UnixDate($ftime1, "%s"); #<-- converting first date to the epoch
   my $time2 = UnixDate($ftime2, "%s"); #<-- same as above but second date
   $diff=$time2-$time1; #<-- Math..
   $hours = $diff/3600; #<-- Math again
   print "$rdata[0] took $hours hours to complete\n"; #<-- Final output
}
