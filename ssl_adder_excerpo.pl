#!/usr/bin/perl
# This script was written by;
# Grant Della Vecchia
# AIS Media, Inc. 7-31-2006
# Version 1.2

#This script will add the SSL info for each excerpo customer.

# Variables------------------------------------------------
$confdir = "/etc/httpd/conf/vhosts";      #<-- Conf Directory
$subnet = "64.94.225";       #<-- Subnet that it is going to add
chomp($domain = $ARGV[0]);   #<-- Domain name supplied on command line
chomp($oct = $ARGV[1]);      #<-- Last octet supplied on command line
# End------------------------------------------------------
print "$confdir/$domain.conf\n";       #<-- Debug
if (-e "$confdir/$domain.conf") {       #<-- Checking to see if the file exists
  open (VHOST, ">>$confdir/$domain.conf");                      #<-- Doing the work!
  print VHOST "\n";
  print VHOST "<VirtualHost $subnet.$oct:443>\n";
  print VHOST "SSLEngine On\n";
  print VHOST "SSLCertificateFile /etc/httpd/conf/ssl.crt/wildcard.crt\n";
  print VHOST "SSLCertificateKeyFile /etc/httpd/conf/ssl.key/wildcard.key\n";
  print VHOST "servername $domain\n";
  print VHOST "serveradmin webmaster\@$domain\n";
  print VHOST "customlog /svc/data/d1/web/$domain/logs/logs-access combined\n";
  print VHOST "errorlog /svc/data/d1/web/$domain/logs/logs-error\n";
  print VHOST "DocumentRoot \"/svc/data/d1/web/$domain/www\"\n";
  print VHOST "</VirtualHost>\n";
  close (VHOST);                                 #<-- Closing the conf file
} else {                                         #<-- What do we do if the file does not exist!
  print "File $domain.conf does not exist\n";    #<-- This is what we do!!
}