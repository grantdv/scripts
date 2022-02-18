#!/usr/bin/perl
#Grant Della Vecchia
#This script will collect the following;
#DIsk info
#	All partitions
#	Human Format
#	Warnings
#Memory info
#	Total Memory
#	Total Free
#	Swap Used
#	Warnings
#Load
#	uptime
#	warnings/recommendations
#Services
#	which are running
#	which are starting auto
#	how services are running (init script or inet or manually)
#	how long they are running (maybe or in next version)
#	warnings/recommendations

# The script will ask for the following info
# server ID
# Customer e-mail
# tech e-mail
#
# FInally the script will send an e-mail to the customer and the tech (bcc).
# so they tech can see what the script found also.
# There will be a swich that allows for output to a file, but not send the
# e-mails
#
# Variables -----------------------------------------------
use Shell qw (clear, uptime, free, df, cat);
$clear = `clear`;
# End -----------------------------------------------------
&find_host();



sub find_host {
        print "Looking for /etc/HOSTNAME, Please wait\n";
        if (-e "/etc/HOSTNAME") {
                $host = cat "/etc/HOSTNAME";
                chomp($host);
                print $clear;
	        print "Hostname is $host\n";
                sleep 2;

        } elsif (-e "/etc/hostname") {
                sleep 1;
                print "No /etc/HOSTNAME, Still Looking\n";
                $host = cat "/etc/hostname";
                chomp($host);
                print $clear;
	        print "Hostname is $host\n";
                sleep 2;


        } else {
	        print "Host file does not exist\n";
	        print "Please provide a hostname\n";
	        chomp($host = <STDIN>);
	        print "Hostname is $host\n";
        }
}

