#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  openrep.pl
#
#        USAGE:  ./openrep.pl 
#
#  DESCRIPTION:  This script will search the apache logs for the the URL's that indicate opens and clicks for our email news letter blast. 
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@aismedia.com>
#      COMPANY:  AIS Media
#      VERSION:  1.0
#      CREATED:  09/02/2006 10:38:00 AM EDT
#     REVISION:  ---
#===============================================================================

use warnings;

#Variables-------------------------------------------------
$clog = "/var/www/logs/ebusinessnews.aismedia.com-access_log";
chomp($url1 = $ARGV[0]);
chomp($url2 = $ARGV[1]);
chomp($grep = `which grep`);
chomp($wc = `which wc`);
#End-------------------------------------------------------

if (-e $clog ) {
	$res1 = system ("$grep $url1 $clog |$wc -l");
	$res2 = system ("$grep $url2 $clog |$wc -l");
}
print "$res1\n";
print "$res2\n";

