#!/usr/bin/perl
#Grant Della Vecchia
#A y
#b y
#c 5000
#d 30000
#e 2000
#f 1000
#g 5000
#k 8

#!/usr/bin/perl
$output = ".tt";
open (OUT ,">$output");
print "How many do you want?\n";
chomp($num = <STDIN>);
print "What is the starting number?\n";
chomp($stn = <STDIN>);
$count = $stn+$num;
$count1 = $count-1;
$tt = $stn;
system "clear";
while ($tt <= $count1) {

$c = int( rand(5000));
$d = int( rand(30000));
$e = int( rand(2000));
$f = int( rand(1000));
$g = int( rand(5000));
$k = int( rand(8));


print OUT "F $tt\n";
print OUT "A y \n";
print OUT "B y \n";
print OUT "C $c\n";
print OUT "D $d\n";
print OUT "E $e\n";
print OUT "F $f\n";
print OUT "G $g\n";
print OUT "K $k\n";
print OUT "Q\n";
$tt++;
}
close (OUT);
system "cat $output |xsel -p";
