#!/usr/bin/perl
# This program will add the following domain, or email address to the access file with a REJECT statement.
#
# Variables------------------------------------------------
$accfile = "/etc/mail/access";
$info = $ARGV[0];
# End------------------------------------------------------
#
	open (FILE, ">>$accfile");
	print FILE "$info	REJECT\n";
	close (FILE);
