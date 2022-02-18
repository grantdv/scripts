#!/usr/bin/perl
#Grant Della Vecchia
#filemkr.pl v. 1.0
#09/12/2002
#This script will make a bunch of files with different numbers.

# Variables------------------------------------------------
chomp($dir = $ARGV[0]);
chomp($count = $ARGV[1]);
# End------------------------------------------------------

$app = 1;
while ($app <=$count ) {
        #open(IN,  ">file-$app") or die "can't open $!";
        system "mkdir $dir/file-$app";
        system "mkdir $dir/file-$app/web/";
        system "mkdir $dir/file-$app/web/stats/";
        system "mkdir $dir/file-$app/logs/";
        system "mkdir $dir/file-$app/logs/Nov/";
       	system "touch $dir/file-$app/logs/Nov/";
	$app++;
        #close(IN);
}

