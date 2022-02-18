#!/usr/bin/perl

$incr = "67";
chomp($cat = `which cat`);
$tmpfs = "/home/grantd/scripts/temporary.file";
chomp($xsel = `which xsel`);
while ($incr <= 255) {
open (FILE, "> $tmpfs");
print "73-$incr.vhost\n";
print FILE "73-$incr.vhost";
system ("$cat $tmpfs |$xsel -p");
sleep 10;
close(FILE);
open (FILE, "> $tmpfs");
print "63.251.73.$incr\n";
print FILE "63.251.73.$incr";
system ("$cat $tmpfs |$xsel -p");
sleep 3;
++$incr;
close (FILE);
}
unlink $tmpfs;

