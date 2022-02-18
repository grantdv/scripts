#!/usr/bin/perl
#Grant Della Vecchia
#$pwd = (getpwuid ($<))[1];
#$salt = substr $pwd, 0, 2; system "stty -echo";
print "Password: ";
chop($word = <STDIN>);
print "Salt: ";
chop($salt = <STDIN>);
print "\n";
#system "stty echo";
$cpwd = crypt($word, $salt);
print "$cpwd\n";
#if (crypt($word, $salt) ne $pwd) {
#            die "Sorry...\n";
#    } else {
#                print "ok\n";
#        }
