#!/usr/bin/perl
#Grant Della Vecchia
#06/19/02 zerorem.pl
#Version 1.0
#This script will remove any file in CWD that has 0 byte file size.
#
# Variables ------------------------------------------------
chomp($dir = $ARGV[0]); 
# End ------------------------------------------------------




opendir(DIR, $dir) or die "Can't open $dir: $!";
while( defined ($file = readdir DIR) ) {
        next if $file =~ /^\.\.?$/;     # skip . and ..
        $size = (stat($file))[7];
        if ($size <= 0) {
		 print "$file\n";
                 unlink $file;
	 }
 }
closedir(DIR);
