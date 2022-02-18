#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  ebsp_upgrade.pl
#
#        USAGE:  ./ebsp_upgrade.pl 
#
#  DESCRIPTION:  Use this script to upgrade the eBSP site to the 2006 version.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@aismedia.com>
#      COMPANY:  AIS Media
#      VERSION:  1.0
#      CREATED:  08/08/2006 02:24:14 PM EDT
#     REVISION:  ---
#===============================================================================

#use warnings;
# Variables------------------------------------------------
$confdir = "/apache/conf/vhosts";
chomp($xsel = `which xsel`);     #<-- Setting paths into Variables
chomp($cat = `which cat`);
$tmpfs = ".tt.tt"; # <-- Temp file...
# End------------------------------------------------------
info_collection();
#username_creation();
leadmgt();
population();
ID_collect();

#Step 1 Collect the info
# username
# Password
# URL
# email

sub info_collection {                             #<-- Initial info collect to push through the rest of the script
        print "Account Type: "; chomp($type = <STDIN>);
        print "Domain Name: "; chomp($domain = <STDIN>);
        print "Business Name: "; chomp($biz_name = <STDIN>);
        print "First Name: "; chomp($fname = <STDIN>);
        print "Last Name: "; chomp($lname = <STDIN>);
        print "Address: "; chomp($addr = <STDIN>);
        print "City: "; chomp($city = <STDIN>);
        print "State: "; chomp($st = <STDIN>);
        print "Zip: "; chomp($zip = <STDIN>);
        print "Phone: "; chomp($phone = <STDIN>);
        print "Email: "; chomp($email = <STDIN>);
        print "Country: "; chomp($co = <STDIN>);
        print "Period: "; chomp($period = <STDIN>);
}

#Step 2
# Populate the leadmanager info for certificate 
# then the eBSP tab
sub leadmgt {                   #<-- Config leadmanager for the seal
        Open(); print "$lname"; print TMP "$lname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	print "What is the users current username?\n"; chomp($uname = <STDIN>);
	print "What is the users current password?\n"; chomp($password = <STDIN>);
        Open(); print "$type"; print TMP "$type"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$period"; print TMP "$period"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "staging.$domain"; print TMP "staging.$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
#        Open(); print "$uname"; print TMP "$uname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
#        Open(); print "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
#        Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
#        Open(); print "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
#        Open(); print "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$addr"; print TMP "$addr"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$city"; print TMP "$city"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$st"; print TMP "$st"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$zip"; print TMP "$zip"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print "$co"; print TMP "$co"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
#        Open(); print "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}



#Step 3
# Run the population script

sub population {               #<-- Populating the DB for the eBSP account
        Open(); print "$uname"; print TMP "$uname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print  "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print  "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print  "staging.$domain"; print TMP "staging.$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
        Open(); print  "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}

#Step 4
# Collect the ID number from the population output
sub ID_collect {
	print "Enter ID from Population script\n";
	chomp($id = <STDIN>);
	print "Enter directory version for $domain\n";
	chomp($ver = <STDIN>);
}

print "staging_vhost.pl $domain $ver $id\n";
#Step 5
# edit the vhosts file and add the /assets/ alias if applicable
# graceful restart apache

#Step 6
# create the directory the new site will be added to
#Step 7
# copy the skeleton to their directory
#Step 8
# change the index.php file and add the ID number to this file
#Step 9
# copy over the logo

sub Open {              #<-- We are opening the tmp file to write the data then closing it after it dumps the data to the copy buffer
        open(TMP, ">$tmpfs");
}

sub Close {             #<-- See previous comment ^
        close(TMP);
        unlink $tmpfs;
}

system "echo \"Congratulations! Your new eBSP site has been staged for your review.
You can access the new site by visiting the following URL,
http://staging.$domain
You can reach the editor by visiting the following link,
http://staging.$domain/admin/
The editor is password protected and it has been configured with your extranet username and password,
Username = $uname
Password = $password

This staging site will remain up until you provide us with the proper release form at which time we will make the new site live.
If you have any questions, comments or suggestions, please contact our
office.

Sincerely,

AIS eBSP Support Team\"|mail grantd\@aismedia.com";
