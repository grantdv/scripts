#!/usr/bin/perl
# This script will process a list of domains and create the transport map for a postfix MTA. It will send the email to mail.domainname

$out = "/home/grantd/transport_file";
$domains = "/home/grantd/hosted";
$ips = "/home/grantd/ips";
use Shell "host";


open (OUT, ">$out");
open (FILE, "$domains");
open (OUT1, ">$ips");
while (<FILE>) {
	$dom = $_;
	chomp($dom);
	print OUT "$dom		smtp:[mail.$dom]\n";
}
open (FILE1, "$domains");
while (<FILE1>) {
	$dom1 = $_;
	chomp($dom1);
	$res = host $dom1; 
	chomp($res);
	@sres = split(/ /,$res);
	#print "$sres[3]\n";
	print OUT1 "$dom1, $sres[3]\n";
}

close (OUT);
close (FILE);
close (FILE1);
