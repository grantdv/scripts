#!/usr/bin/perl

#This script will move the logs from where they are into the customers directory.

#Variables-------------------------------------------------
chomp($logdir = "$ARGV[0]");
chomp($date = "$ARGV[1]");
$docroot = "/svc/data/d1/web";
#End-------------------------------------------------------

if (-e "$logdir") {
	while (<$logdir/*>) {
		$file = $_;
		@domain = (split/\//, $file);
		@fullpath = (split/-/,$file);
#		print "$fullpath[0]\n";
		print "$domain[1]\n";
#		print "$docroot/$domain[1]\n";
		if (-e "$docroot/$domain[1]/logs/") {
#			print "$domain[1]\n";
#			print "$file\n";
			print "mv $file $docroot/$domain[1]/logs/$domain[1]-$fullpath[1].$date\n";
#			system "mv $file $docroot/$domain[1]/logs/$domain[1]-$fullpath[1].$date\n";
		}
	}
}else{
	print "I can not find that log directory\n";
}

