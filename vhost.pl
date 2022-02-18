#!/usr/local/bin/perl
#
# change all occurances of a string in a file to another string
#

if ($#ARGV != 3) {
    print "usage: chstring oldfile newfile oldstring newstring\n";
    exit;
}

$oldfile = $ARGV[0];
$newfile = $ARGV[1];
$old = $ARGV[2];
$new = $ARGV[3];

open(OF, $oldfile);
open(NF, ">$newfile");

# read in each line of the file
while ($line = <OF>) {
    $line =~ s/$old/$new/;
    print NF $line;
}

close(OF);
close(NF);
