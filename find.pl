#!/usr/bin/perl
#Grant Della Vecchia
#06/19/02 zerorem.pl
#Version 1.0
#This script will remove any file in CWD that has 0 byte file size.
#
# Variables ------------------------------------------------
 
# End ------------------------------------------------------
$ts=time;
$tsm=time;
while (<*>) {
	 $date = (stat($_))[9];
	 if ($date <= $tsm) {
		 print "$_ was modified on $date\n";
	 }else{
	 }
 }
