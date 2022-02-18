#!/usr/bin/perl 

# Written by Grant Della Vecchia
# 6-14-2011
# build_dns.pl - This script will build the DNS syntax for adding DNS to PHX or SLC.
# Version 1.8

# Variables------------------------------------------------
$ipfile = $ARGV[0];
$dc = $ARGV[1];
$changenum= $ipfile;
$ppp = $ARGV[2];
# END------------------------------------------------------
# Examples-------------------------------------------------
#/named/tools/dns-work.pl --view=internal --local=10.73.100.35 --add --domainname=slc.paypal.com --type=a --recordname=test --record=123.4.56.78
#/named/tools/dns-work.pl --view=internal --local=10.73.100.35 --add --domainname=slc.paypal.com --type=ptr --recordname=test --record=123.4.56.78
# End------------------------------------------------------

if (!-e $ipfile){
    print "I can't find your host:ip list, please try again\n";
    usage();
    die;
}else{
    @ips = `cat $ipfile`;
    open OUTFILE, ">dns_out_$changenum"; # <-- Name of the output file.
    open BOUTFILE, ">dns_backout_$changenum"; # <-- Name of the output file.
    open VOUTFILE, ">dns_verifyout_$changenum"; # <-- Name of the output file.
}
if($dc==1) {
    $datacenter = "phx";
    phx();
}elsif ($dc==2) {
    $datacenter = "slc";
    slc();
}else{
    print "I do not understand your datacenter selection. 1 for PHX, 2 for SLC\n";
    usage();
    die;
}
sub phx{
    #print $datacenter;
    foreach $ip (@ips) {
        @sip=split(/ /,$ip); # <-- Splitting the IP from hostname
        chomp($sip[0]); # <-- Removing the CR if any.
        chomp($sip[1]);
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=phx.paypal.com. --type=a --recordname=$sip[0] --record=$sip[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile.
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=phx.paypal.com. --type=ptr --recordname=$sip[0] --record=$sip[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=phx.paypal.com. --type=a --recordname=$sip[0] --record=$sip[1]\n"; #<-- Backout line.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=phx.paypal.com. --type=ptr --recordname=$sip[0] --record=$sip[1]\n"; # <-- Backout line.
        print VOUTFILE "dig $sip[0].phx.paypal.com +short\n"; # <-- Verification line.
    }
    if ($ppp eq "con") {
        con();
    }
}

sub slc {
    #print $datacenter;
    foreach $ip (@ips) {
        @sip=split(/ /,$ip); # <-- Splitting the IP from hostname
        chomp($sip[0]); # <-- Removing the CR if any.
        chomp($sip[1]);
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=slc.paypal.com. --type=a --recordname=$sip[0] --record=$sip[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile.
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=slc.paypal.com. --type=ptr --recordname=$sip[0] --record=$sip[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=slc.paypal.com. --type=a --recordname=$sip[0] --record=$sip[1]\n"; # <-- Backout Line.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=slc.paypal.com. --type=ptr --recordname=$sip[0] --record=$sip[1]\n"; # <-- Backout line.
        print VOUTFILE "dig $sip[0].slc.paypal.com +short\n"; # <-- Verify line.
    }
    if ($ppp eq "ppp"){
        ppp();
    }
}

sub ppp {
    @ips1 = `cat $ipfile.ppp`;
#    open OUTFILE1, ">dns_out_$changenum.ppp"; # <-- Name of the output file.
    foreach $ip1 (@ips1) {
        @sip1=split(/ /,$ip1); # <-- Splitting the IP from hostname
        chomp($sip1[0]); # <-- Removing the CR if any.
        chomp($sip1[1]);
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=ppp.slc.paypal.com. --type=a --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile.
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=ppp.slc.paypal.com. --type=ptr --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=ppp.slc.paypal.com. --type=a --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Backout line.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=ppp.slc.paypal.com. --type=ptr --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Backout Line.
        print VOUTFILE "dig $sip1[0].ppp.slc.paypal.com +short\n"; # <-- Verification line
    }
}
sub con {
    @ips1 = `cat $ipfile.con`;
#    open OUTFILE1, ">dns_out_$changenum.ppp"; # <-- Name of the output file.
    foreach $ip1 (@ips1) {
        @sip1=split(/ /,$ip1); # <-- Splitting the IP from hostname
        chomp($sip1[0]); # <-- Removing the CR if any.
        chomp($sip1[1]);
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=con.phx.paypal.com. --type=a --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile
        print OUTFILE "/named/tools/dns-work.pl --view=internal --add --domainname=con.phx.paypal.com. --type=ptr --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Formatting and writing the rules for each line in the ipfile
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=con.phx.paypal.com. --type=a --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Backout line.
        print BOUTFILE "/named/tools/dns-work.pl --view=internal --delete --domainname=con.phx.paypal.com. --type=ptr --recordname=$sip1[0] --record=$sip1[1]\n"; # <-- Backout line
        print VOUTFILE "dig $sip1[0].con.phx.paypal.com +short\n"; # <-- Verification line
    }
}

sub usage {
    print "To use this program, run build_dns.pl <name of hostnames and ipaddresses> <1|2> <ppp|con>\n";
    print "The host:ip list should be one hostname and ipaddress per line. Just the hostname, not the FQDN\n";
    print "The 1|2 at the end of the line is to select the Datacenter, 1 = PHX 2 = SLC\n";
    print "For PPP or Console IP's, on the CL, add \"ppp\" or \"con\" and to the end of the file with the ppp or console IP addresses.\n";
}

print "Your output file is 'dns_out_$changenum', dns_backout_$changenum, dns_verify_$changenum\n";