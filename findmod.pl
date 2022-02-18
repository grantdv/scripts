#!/usr/bin/perl
#Grant Della Vecchia
#findmod.pl Version 1.0
#06/12/02
#This script will cycle through last modified times by 24 hour increments.
#
#Variables ------------------------------------------------
use Shell qw(find cat echo ps);
$inc = "0";
$dir = $ARGV[0];
#End ------------------------------------------------------
#
while ($inc <= 24) {
        @res = find "$dir -name \"*\" -ctime $inc  -print";
        $inc++;
        #sub find;
        #print find ("$dir -name "*" -ctime $inc -print");
        print "$inc day\n";
        print "@res";
}
