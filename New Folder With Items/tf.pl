#!/usr/bin/perl

$ts = localtime;
@sts = split(/ /,$ts);
$dir = "/tmp";
$email = "grantpp\@aismedia.com";
$tdir = "/home/grantd/tmp";


if (-e "$dir/x.txt"){
#	print "Found x.txt file\n";
	email($name="x.txt");
	rmf($file="x.txt");
}
if (-e "$dir/udp.pl") {
#	print "Found udp.pl file\n";
	email($name="udp.pl");
	rmf($file="udp.pl");
}
if (-e "$dir/bd.txt"){
#	print "Found bd.txt file\n";
	email($name="bd.txt");
	rmf($file="bd.txt");
}

if (-e "$dir/bd.c"){
#	print "Found bd.txt file\n";
	email($name="bd.c");
	rmf($file="bd.c");
}
sub email {
        open (EMAIL, "|/usr/sbin/sendmail -t $email");
        print EMAIL "Subject: Found $name\n";
        print EMAIL "I found $name in /tmp\n";
        close EMAIL;
}


if (-e "$dir/Sem.perl.txt"){
#	print "Found bd.txt file\n";
	email($name="Sem.perl.txt");
	rmf($file="Sem.perl.txt");
}
if (-e "$dir/hdr.txt"){
#	print "Found bd.txt file\n";
	email($name="hdr.txt");
	rmf($file="hdr.txt");
}
if (-e "$dir/ramp.txt"){
#	print "Found bd.txt file\n";
	email($name="ramp.txt");
	rmf($file="ramp.txt");
}
if (-e "$dir/udp.perl.txt"){
#	print "Found bd.txt file\n";
	email($name="udp.perl.txt");
	rmf($file="udp.perl.txt");
}
sub rmf {
#	print "(mv $dir/$file $tdir/$file.$sts[3])";
	system "(mv $dir/$file $tdir/$file.$sts[3])";
#	opendir(DIR,$dir) or die "Can't open $dir: $!";
#	while (defined ($file = readdir DIR) ) {
#		print "$file\n";
#		next if $file != /x.txt/;  #find .txt files
#		print "$file found\n";
		#$print "(mv $file $tdir/$file )\n";
		#system (mv $file $tdir/$file );
	#}
}	


#Sem.perl.txt
#back
#cr
#hdr.txt
#hdr.txt.1
#hdr.txt.2
#netstat
#ramp.txt
#region.php
#udp.perl.txt
