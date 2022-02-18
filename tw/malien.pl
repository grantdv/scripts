#!/usr/bin/perl

print "How many do you want?\n";
chomp($num = <STDIN>);
print "What is the starting number?\n";
chomp($stn = <STDIN>);
$count = $stn+$num;
$tt = $stn;
system "clear";
while ($tt <= $count) {

$c = int( rand(9));
$d = int( rand(5000));
$e = int( rand(30000));
$f = int( rand(2000));
$g = int( rand(1000));
$h = int( rand(250));
$i = int( rand(999999999));
$j = int( rand(32786));
$k = int( rand(32767));


print "A $tt\n";
print "A y \n";
print "B y \n";
print "C $c\n";
print "D $d\n";
print "E $e\n";
print "F $f\n";
print "G $g\n";
print "H $h\n";
print "I $i\n";
print "J $j\n";
print "K $k\n";
print "Q\n";
$tt++;
}
