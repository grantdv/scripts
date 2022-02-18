#!/usr/bin/perl
# This script was written by:
# Grant Della Vecchia
# AIS Media 08-01-2006
# Version 1.2

# This script will create the config files for the hosts and services in a Nagios format.

# Variables------------------------------------------------
$confdir = "/etc/nagios/servers";   #<-- Conf Directory
chomp($servname = $ARGV[0]);        #<-- Server Name
chomp($template = $ARGV[1]);        #<-- Which Template to use?
chomp($service = $ARGV[2]);         #<-- What is the name of the service?
chomp($command = $ARGV[3]);         #<-- What is the check command?
# End------------------------------------------------------
print "$confdir/$servname.cfg\n";   #<-- Debug
if (-e "$confdir/$servname.cfg") {          #<-- Does the conf file exist?
  open (CONF, ">>$confdir/$servname.cfg");  #<-- Open it if it does
  if ($template eq "5") {                   # Which temkplate are we using?
      fivemin();
    }elsif ($template eq "10") {
      tenmin();
    }else {
      print "No template selected!\n";      #<-- No template selected, try again!
  }
}else{
  print "No conf file\n";                   #<-- Conf file does not exist
}

close (CONF);                               #<-- Remeber to close your files....
 

sub fivemin {                              # 5 Minute template output
  print "5 Minute template\n";          
  print CONF "define service{\n";
  print CONF "	use			5minute\n";
  print CONF "	host_name		$servname\n";
  print CONF "	service_description	$service\n";
  print CONF "	check_command		$command\n";
  print CONF "}\n";
}

sub tenmin {                             # 10 Minute template output
  print "10 Minute template\n";
  print CONF "define service{\n";
  print CONF "	use			10minute\n";
  print CONF "	host_name		$servname\n";
  print CONF "	service_description	$service\n";
  print CONF "	check_command		$command\n";
  print CONF "}\n";
}

# Changelog
#
# 1.2 - Added comments
# 1.1 - Bug fixes
# 1.0 - Initial