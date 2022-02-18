#!/usr/bin/perl
# This script will send an email to a user that has been assigned a ticket.
# Written by: Grant Della Vecchia
#             Turner Broadcasting - DMT - WFServer-Ops
#             2-23-2009
# Variables-------------------------------------------------
$emlist = "pe = Philip Enteles, dn = David Nicklay, rs = Richard Schneider, gd = Grant Della Vecchia, cc = CC,\nkg = Keving Gathers, jt = Jason Tolsma, rj = Randy Joiner, kr = Kenneth Rhodes";
# End-------------------------------------------------------

print "Who are we sending this email to?\n";
print "$emlist\n";
chomp($who = <STDIN>);
print "What is the Ticket number?\n";
chomp($tn = <STDIN>);
print "Comment?\n";
chomp($comment = <STDIN>);
Who();
email();

sub Who {
    if ($who eq "pe") {
        $email = "philip.enteles\@turner.com";
    }elsif ($who eq "dn"){
        $email = "david.nicklay\@turner.com";
    }elsif ($who eq "rs") {
        $email = "richard.schneider\@turner.com";
    }elsif ($who eq "cc") {
        $email = "chaleta.wilson-bell\@turner.com";
    }elsif ($who eq "kg") {
        $email = "kevin.gathers\@turner.com";
    }elsif ($who eq "jt") {
        $email = "jason.tolsma\@turner.com";
    }elsif ($who eq "rj") {
        $email = "randy.joiner\@turner.com";
    }elsif ($who eq "kr") {
        $email = "kenneth.rhodes\@turner.com";
    }elsif ($who eq "gd") {
        $email = "grant.dellavecchia\@turner.com";
    }
}
sub email {
        open (EMAIL, "|/usr/sbin/sendmail -t $email");
        print EMAIL "Subject: Ticket $tn Assignment\n";
        print EMAIL "I have assigned ticket $tn to you, $comment\n";
        close EMAIL;
}