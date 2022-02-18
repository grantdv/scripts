#!/usr/bin/perl

$domains = "/home/grantd/domains_list";
$out = "/home/grantd/hosted";
$bout = "/home/grantd/nothosted";
open(OUT, ">$out");
open(BOUT, ">$bout");
open(FILE, $domains);
while (<FILE>) {
	$dom = $_;	
	chomp($dom);
	$res = system ("dig $dom ns \@zipper.net|grep -A2 \"ANSWER SECTION\"|awk '{print\$5}'|grep -q ns1.acs.aismedia.com >/dev/null");
#	$res = system "whois -h whois.opensrs.net $dom |grep -q NS1.ACS.AISMEDIA.COM";
	#chomp($res);
	print "$dom, $res\n";
	if ($res eq 0) {
		print OUT "$dom\n";
	}else{
		print BOUT "$dom\n";
	}
	sleep 2;
}
close(OUT);
close(BOUT);
close(FILE);
