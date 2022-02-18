#!/usr/bin/perl
#Grant Della Vecchia
# This script will move files and increment them bu number on the move.


# Example of readdir


#chomp($srcdir = $ARGV[0]);
chomp($destdir = $ARGV[0]);
chomp($dom = $ARGV[1]);
#opendir(BIN, $srcdir) or die "Can't open $dir: $!";
$num=1;
while (<STDIN>) {
#while( defined ($file = readdir BIN) ) {
#while (<$dom*>){
#    next if $file =~ /^\.\.?$/;     # skip . and ..
    next if $file =~ /error/;     # skip . and ..
#    next if $file =! //$dom/;     # skip . and ..
	chomp($_);
    @file = split(/\//,$_);
   
    print "Orig File Name $_\nNew File Name $destdir/$file[2].$num\n";
    print "mv $_  $destdir/$file[2].$num";
    #system ("mv $_  $destdir/$filei[2].$num");
    ++$num;
}
closedir(BIN);
