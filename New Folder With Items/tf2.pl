#!/usr/bin/perl
$email = "grantpp\@aismedia.com";
$dir = "/tmp";
$ts = localtime;
@sts = split(/ /,$ts);
$tdir = "/home/grantd";

while(<$dir/*>) {
	$file = $_;
	chomp($file);
#	print "$file\n";
	if (-T $file) {
	next if $file != /sess.*?/;
#	next if $file != /cerbfile.*?/;
#	next if $file == /.*?txt/;
		if (-f $file) {
#			print "$file\n";
			email($file);
			rmf($file);
		}
	}
}
sub email {
        open (EMAIL, "|/usr/sbin/sendmail -t $email");
        print EMAIL "Subject: Found $name\n";
        print EMAIL "I found $name in /tmp\n";
        close EMAIL;
}

sub rmf {
        system "(mv $file $tdir$file.$sts[3])";
        #print "mv $file $tdir$file.$sts[3]\n";
}
