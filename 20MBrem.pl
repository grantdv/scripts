#!/usr/bin/perl
#Grant Della Vecchia
#04/06/2003 20MBrem.pl
#Version 1.0
#This script will remove any file in CWD that is over 20Mb file size.
#
# Variables ------------------------------------------------
chomp($dir = $ARGV[0]); 
# End ------------------------------------------------------




opendir(DIR, $dir) or die "Can't open $dir: $!";
while( defined ($file = readdir DIR) ) {
        next if $file =~ /^\.\.?$/;     # skip . and ..
        $size = (stat($file))[7];
        if ($size >=21299200) {
		 print "$file\n";
                 unlink $file;
	 }
 }
closedir(DIR);
