#!/usr/bin/perl 

# ----------------------------------------------------------------------------------------------------
# Written by Grant Della Vecchia
# 6.28.2011 Version 1.0
# ip_config.pl
# Paypal, Inc. (Contractor)
# This script will connect to RackTables and supply the necessary info to get a rack location, prod IP, and PPP IP.
# After that, this script will call build_dns.pl and create the syntax for the DNS CR.
# ---------------------------------------------------------------------------------------------------
# Variables -----------------------------------------------
$hlist=$ARGV[0];
# End -----------------------------------------------------

# Example curl command ;
# curl --user username:pw --silent --show-error http://10.249.56.142/cgi/RackNewServers.cgi?host=host1%2Chost2%2Chost3%2Chost4%2Chost5%2Chost6&dc_side=SLC-02_B&pod=web&contact=Joe&project=testing&pool=&clarityid=666&execute=yes

if (-e $hlist) {
    print "Please select the Datacenter. 1=PHX, 2=SLC\n";
    chomp($dc = <STDIN>);
    if ($dc == 1) {
        phxdc();
    } else {
        slcdc();
    }
} else {
    print "I was not able to find the file with the list of hostnames\n"||die;
}

sub phxdc {
    print "Currently this script only works for SLC DC\n";
    print "I will bounce you over to the SLC portion of the script, or press ctrl+c to exit\n";
    slcdc()
}

sub slcdc {
    print "You have selected SLC DC\n";
    print
    ""
}

sub curl {
    print "You got to the Curl Section of the Code\n";
}