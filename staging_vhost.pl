#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  staging_vhost.pl
#
#        USAGE:  ./staging_vhost.pl 
#
#  DESCRIPTION:  This script will add the subdomain "staging"  for the new eBSP site upgrade
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@aismedia.com>
#      COMPANY:  AIS Media
#      VERSION:  1.0
#      CREATED:  08/09/2006 07:54:59 AM EDT
#     REVISION:  ---
#===============================================================================

use warnings;

# Variables------------------------------------------------
$confdir = "/svc/web/apache/conf/vhosts";
chomp($domain = $ARGV[0]);
chomp($ver = $ARGV[1]);
$parpath = "/svc/data/d$ver/web";
chomp($id = $ARGV[2]);
# End------------------------------------------------------
#print "$domain $ver\n";
if (-e "$confdir/staging.$domain.conf") {
	print "Subdomain already exists, exiting!\n";
	die;
}else{
	vhost();
}

system ("touch /svc/web/apache/logs/staging.$domain-error_log");
if (!-e "$parpath/$domain/staging") {
	mkdir "$parpath/$domain/staging";
	system ("cp -r /svc/web/reseller-template/ebsp4/skel/www/* $parpath/$domain/staging/");
	Index();
	perms();
}else{
	print "Staging directory already exists, Exiting!\n";
	die;
}


sub Index {
	$nf = "$parpath/$domain/staging/.tt.tt";
	$of = "$parpath/$domain/staging/index.php";
	if (-e "$parpath/$domain/staging/index.php") {
		print "$parpath/$domain/staging/index.php\n";
		open (OF, "$of");
		open (NF, ">$nf");
        	while ($line = <OF>) {
        		$line =~ s/XXXX/$id/;
        		print "$line";
        		print NF $line;
        	}
		close(OF);
		close(NF);
		rename $nf, $of;
	}else{
		print "index.php does not exist\n";
	}

}

sub perms {
        system "chown -R \`ls -ld $parpath/$domain/www|awk '{print\$3}'\`:webowner $parpath/$domain/staging/";
}

sub vhost {
	open (VHOST, ">$confdir/staging.$domain.conf");
	print VHOST "<virtualhost *>\n";
	print VHOST "  servername staging.$domain\n";
	print VHOST "  serveradmin webmaster\@$domain\n";
	print VHOST "  customlog /svc/web/apache/logs/staging.$domain-access_log combined\n";
	print VHOST "  errorlog /svc/web/apache/logs/staging.$domain-error_log\n";
	print VHOST "  documentroot /svc$ver/data/d1/web/$domain/staging\n";
	print VHOST "  errordocument 401 /error_docs/401.html\n";
	print VHOST "  errordocument 403 /error_docs/403.html\n";
	print VHOST "  errordocument 404 /error_docs/404.html\n";
	print VHOST "  throttlepolicy original 128 1s\n";
	print VHOST "<IfModule mod_php4.c>\n";
	print VHOST "  php_admin_flag safe_mode on\n";
	print VHOST "  php_admin_flag safe_mode_gid on\n";
	print VHOST "</IfModule>\n";
	print VHOST "</virtualhost>\n";
	close(VHOST);
}
