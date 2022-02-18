#!/usr/bin/perl

print "How many do you want?\n";
chomp($num = <STDIN>);
print "What is the starting number?\n";
chomp($stn = <STDIN>);
$output = ".tt";
$count = $stn+$num;
$tt = $stn;
open (OUT, ">$output");
system "clear";
while ($tt <= $count) {

$c = int( rand(9));
$d = int( rand(5000));
$e = int( rand(30000));
$f = int( rand(2000));
$g = int( rand(1000));
$h = int( rand(250));
$i = int( rand(999999999));
$j = int( rand(-32786));
$k = int( rand(32767));


print OUT "A $tt\n";
print OUT "A y \n";
print OUT "B y \n";
print OUT "C $c\n";
print OUT "D $d\n";
print OUT "E $e\n";
print OUT "F $f\n";
print OUT "G $g\n";
print OUT "H $h\n";
print OUT "I $i\n";
print OUT "J $j\n";
print OUT "K $k\n";
print OUT "Q\n";
$tt++;
}
close (OUT);
system "cat $output |xsel -p";
