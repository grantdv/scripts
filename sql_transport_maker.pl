#!/usr/bin/perl

#This script will make the SQL statements needed to change the MX records for the domains we are pushing to the spam and virus filtering program.

$domains = "/home/grantd/hosted";
$out = "/home/grantd/sql_MX_changes";
$MX = "elara.acs.aismedia.com";

open (DOMAIN, "$domains");
open (OUT, ">$out");

while (<DOMAIN>) {
	$dom = $_;
	chomp($dom);
	print OUT "update records set content = '$MX' where name = '$dom' and type = 'MX';\n";
	}
close (OUT);
close (DOMAIN);

