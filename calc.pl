#!/usr/bin/perl
#Grant Della Vecchia
# This script will ask some questions and make some calculations for disk
# space.

# Variables------------------------------------------------
$ks = 1024;
$bs = 1024;
$ts = $ARGV[0];
#End-------------------------------------------------------

#print "What is the block size?\n";
#chomp($bs = <STDIN>);
#testing line
#chomp($bs);

chomp($ts);
math();

sub math{
if ($bs =~ "1024") {
        print "\n";
        $msize = $ts/$ks;
        $gsize = $msize/10240;
        $bsize = $msize*102400;

}elsif ($bs =~ "512"){
        print "\n";
        $tmp1 = $ts/2;
        $tmp = $tmp1/$ks;
        $msize = $tmp;
        $gsize = $msize/1024;
        $bsize = $msize*1024;
}else{
        print "I do not understand your block size, please try agian\n";
        die;
}

print "$bsize b\n";
print "$msize Mb\n";
print "$gsize Gb\n";
print "Enter total Space (in Kb)\n";
chomp($ts = <STDIN>);
math();
}

