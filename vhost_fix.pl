#!/usr/bin/perl
#This script will fix the vhost statement in the apache conf files.
#Variables-------------------------------------------------
$parpath = "/svc/data/d1/web";
#chomp($domain = $ARGV[0]);
$cgi = "www/cgi-bin/";
$confdir = "/svc/web/apache/conf/vhost";
#End-------------------------------------------------------

 #if (-e "$confdir/$domain.conf") {
	while (<$confdir/*.conf>) {
		$file = $_;
                open (OF,"$file")|| die;
                open (NF, ">$file.new") ||die $!;
                while ($line = <OF>) {
                        $line =~ s/vhost.acs.aismedia.com/vhost.compuhost.com/;
                        print NF $line;
                }
                close(OF);
                close(NF);
                open (FF, "$$file.new");
                while ($content = <FF>) {
                        print "$content";
                }
       #         print "Is this ok?\n";
       #         chomp($ans = <STDIN>);
       #         if ($ans eq "y") {
                        unlink $file;
                        system "mv $file.new $file";
                        #rename $file.new, $file;
       #         }else{
       #                 unlink $nf;
       #                 print "Doing Nothing\n";
       #         }
#        }else{
#                print "Conf files does not exist\n";
        }


