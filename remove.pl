#!/usr/bin/perl
#
$tmp = ".tmp.remove";
chomp($fn = $ARGV[0]);
open (TMP, "> $tmp");
while (<>) {
        $_ =~ s/\cM\n/\n/g;
        print TMP $_;
}
close (TMP);
system ("cat $tmp > $fn");
unlink $tmp;
#
#This is an old script