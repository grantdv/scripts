#!/usr/bin/perl

# Written by:
# Grant Della Vecchia
# AIS Media 2006 Version 2.2

# This script will add cgi access to a hosting account.
# 1. It will create the cgi-bin directory
# 2. It will change the permissions on the cgi directory.
# 3. It will generate the script alias directive for the vhost.
# Variables-------------------------------------------------
$parpath = "/svc/data/d1/web";
chomp($domain = $ARGV[0]);
$cgi = "www/cgi-bin/";
$confdir = "/svc/web/apache/conf/vhost";
$of = "$confdir/$domain.conf";
$nf = "$confdir/.$domain.conf";
# End-------------------------------------------------------

if (-e "$parpath/$domain/$cgi") {
	print "CGI-Bin Already exists!\n";
	intest();
	perms();
	conf();
}else{
	mkdir "$parpath/$domain/$cgi",0755;
	print "$parpath/$domain/$cgi\n"; #<-- Debug code
	intest();
	perms();
	conf();
}
sub perms {
	system "chown -R \`ls -ld $parpath/$domain/www|awk '{print\$3}'\`:webowner $parpath/$domain/$cgi/";
}

sub intest {
	open (FILE, ">$parpath/$domain/$cgi/test.cgi");
	print FILE "#!/usr/bin/perl\n";
	print FILE "print \"Content-type: text/html\\n\\n<html>\\n<head>\\n<title>CGI Test Script</title>\\n</head>\\n\";\n";
	print FILE "print \"<body>If you see this, the CGI interface on the server is working correctly</body></html>\\n\";\n";
	close (FILE);
	chmod 0755,"$parpath/$domain/$cgi/test.cgi";
}

sub conf {
#	print "scriptalias /cgi-bin/ /svc/data/d1/web/inspectplus.com/www/cgi-bin/\n";
#	print "vi /svc/web/apache/conf/vhosts/$domain.conf\n";
#	print "/usr/local/etc/rc.d/apache.sh graceful\n";
	print "$confdir/$domain.conf"; #<-- Debug code
	if (-e "$confdir/$domain.conf") {
		open (OF,"$of");
		open (NF, ">$nf");
		while ($line = <OF>) {
			$line =~ s/\/svc\/cams\/cgi-bin\//$parpath\/$domain\/$cgi/;
			print NF $line;
		}
		close(OF);
		close(NF);
		open (FF, "$nf");
		while ($content = <FF>) {
			print "$content";
		}
		print "Is this ok?\n";
		chomp($ans = <STDIN>);
		if ($ans eq "y") {
			unlink $of;
			rename $nf, $of;
		}else{
			unlink $nf;
			print "Doing Nothing\n";
		}
	}else{
		print "Conf files does not exist\n";
	}	

}

