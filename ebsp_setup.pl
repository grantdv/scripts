#!/usr/bin/perl
# This script was written by:
# Grant Della Vecchia
# AIS Media 2005
# Version 3.0

# This script will facilitate our new eBSP process. It will ask for the info, then format it correctly for each section then inset the pertinent info into the paste buffers.

#Variables-------------------------------------------------
chomp($xsel = `which xsel`);     #<-- Setting paths into Variables
chomp($cat = `which cat`);
#chomp($hd = `echo \$HOME`); # <-- figure out who is running me...
$tmpfs = ".tt.tt"; # <-- Temp file...
#End-------------------------------------------------------
info_collection();    #<-- Calling the Subroutines
username_creation();
password();
#print "$tmpfs\n";    #<-- Debug Code
system "clear";       #<-- Moving the operator through the sections
print "OpenSRS\n";
OPENSRS();
system "clear";
print "CAMS\n";
CAMS();
system "clear";
print "Specs\n";
specs();
system "clear";
print "Hosting\n";
hosting_account();
system "clear";
print "Population\n";
population();
system "clear";
print "Cerberus\n";
cerberus();
system "clear";
print "LeadManager\n";
leadmgt();
system "clear";
print "Do the Work\n";
dothework();

#print "\n";                        #<-- Debug Code
#print "Username = $uname\n";       #<-- Debug Code
#print "Password: $password\n";     #<-- Debug Code
#print "$fn\n";                     #<-- Debug Code



sub password {                         #<-- Password generation sub routine
	@chars = (  "a" .. "z");
	$password = join("", @chars[ map { rand @chars } ( 1 .. 8 ) ]);
}

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
}

sub username_creation {            #<-- This section splits the first and last name then joins them to create the username
	#Still working on this section   # Tom Jones --> tjones
	$fn = $fname;
	$fn =~ tr/A-Z/a-z/;
	@tt = split(//,$fn);
	$ln = $lname;
	$ln =~ tr/A-Z/a-z/;
	$ln =~ s/\s//;
	$uname = "$tt[0]$ln";
}

sub Open {              #<-- We are opening the tmp file to write the data then closing it after it dumps the data to the copy buffer
	open(TMP, ">$tmpfs");
}

sub Close {             #<-- See previous comment ^
	close(TMP);
	unlink $tmpfs;
}
	
sub CAMS {        #<-- Performing the CAMS Section
	Open(); print "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$fname"; print TMP "$fname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$lname"; print TMP "$lname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$uname"; print TMP "$uname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$phone"; print TMP "$phone"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$addr"; print TMP "$addr"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$city"; print TMP "$city"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$st"; print TMP "$st"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$zip"; print TMP "$zip"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$co"; print TMP "$co"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}
sub OPENSRS {     #<-- Performing the OpenSRS section
	Open(); print "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$uname"; print TMP "$uname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$fname"; print TMP "$fname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$lname"; print TMP "$lname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$addr"; print TMP "$addr"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$city"; print TMP "$city"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$st"; print TMP "$st"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$zip"; print TMP "$zip"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$phone"; print TMP "$phone"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}
sub specs {                   #<-- Specs section for the account creating
	if ($type eq "Premier") {
		Open(); print "Disk Space"; print TMP "100000"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Bandwidth"; print TMP "2000"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "FTP"; print TMP "8"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Email"; print TMP "800"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Email space"; print TMP "2"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Mailing List"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "DB"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	}elsif ($type eq "Executive") {
		Open(); print "Disk Space"; print TMP "75000"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Bandwidth"; print TMP "1500"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "FTP"; print TMP "8"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Email"; print TMP "800"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Email space"; print TMP "2"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Mailing List"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "DB"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	}elsif ($type eq "Associate") {
		Open(); print "Disk Space"; print TMP "50000"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Bandwidth"; print TMP "1000"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "FTP"; print TMP "8"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Email"; print TMP "800"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Email space"; print TMP "2"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "Mailing List"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
		Open(); print "DB"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	}
}

sub hosting_account {            #<-- Adding the hosting account
	@dom = split(/\./,$domain);
	Open(); print "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$fname"; print TMP "$fname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$lname"; print TMP "$lname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$dom[0]"; print TMP "$dom[0]"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$phone"; print TMP "$phone"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$addr"; print TMP "$addr"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$city"; print TMP "$city"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$st"; print TMP "$st"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$zip"; print TMP "$zip"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$co"; print TMP "$co"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "Disk Space"; print TMP "500"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "Bandwidth"; print TMP "10"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "FTP"; print TMP "8"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "Email"; print TMP "800"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "Email space"; print TMP "2"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "DB"; print TMP "0"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}

sub population {               #<-- Populating the DB for the eBSP account
	Open(); print "$uname"; print TMP "$uname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print  "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}

sub cerberus {                  #<-- Adding the login info for Cerberus
	Open(); print "$fname"; print TMP "$fname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$lname"; print TMP "$lname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$addr"; print TMP "$addr"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$city"; print TMP "$city"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$st"; print TMP "$st"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$zip"; print TMP "$zip"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$co"; print TMP "$co"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$phone"; print TMP "$phone"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$type"; print TMP "$type"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}

sub leadmgt {                   #<-- Config leadmanager for the seal
	Open(); print "$lname"; print TMP "$lname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$uname"; print TMP "$uname"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$email"; print TMP "$email"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$password"; print TMP "$password"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$biz_name"; print TMP "$biz_name"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$addr"; print TMP "$addr"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$city"; print TMP "$city"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$st"; print TMP "$st"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$zip"; print TMP "$zip"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$co"; print TMP "$co"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
	Open(); print "$domain"; print TMP "$domain"; system ("$cat $tmpfs |$xsel -p"); Close(); <STDIN>;
}

sub dothework {                          #<-- This section will format the commands and spit them on the screen for easy copy and paste to the server.
	
print "cd /svc2/data/d1/web/$domain\n";
print "cp -r /svc/web/reseller-template/ebsp4/skel/www/ www\n";
print "chown -R \`ls -ld www|awk '{print\$3}'\`:webowner www/\n";
print "chmod 777 www/templates_c/\n";
print "cat /svc/web/reseller-template/ebsp3_site_skeleton.vhost >> /svc/web/apache/conf/vhosts/$domain.conf\n";
print "vi /svc/web/apache/conf/vhosts/$domain.conf\n";
print "/usr/local/etc/rc.d/apache.sh graceful\n\n";
#sleep 10;     #<-- Debug
#clear         #<-- Debug
#print " \n";  #<-- Debug

# The following is the welcome letter that this script generates and sends to the operator
system "echo \"Congratulations! Your application to become an eBusiness Solutions
Provider with AIS Media, the nation's leading eBSP(SM) Licensor has
been approved. Your new Virtual Private Server has been configured
and activated.

This message contains the technical information for your account.
Please read this entire message carefully, print it, and store it in a safe
place for future reference.

If you share a computer with another person and they can access your
email, we recommend that after printing this email, you delete this email for
ecurity reasons.

Only you can distribute your password to others. If you suspect that
your password has been exposed to an unauthorized party, or you wish to change it,
please use the web-based control panel or contact AIS Media technical support via the
channels listed below as soon as possible.



TECHNICAL SUPPORT
-----------------------------------------------------------------------
Our knowledge based ticketing system is your gateway to a wealth of
information and support team. Our system is designed to track your questions
and allows you to contact subject matter experts by using ticketing queues.

Once we have your account activated you will be able to access the ticketing
system by using your approved email address. This is the only address
authorized to access the knowledge based ticketing system. Gated ticketing
queues offer you the ability to review your tickets and see past responses
for better knowledge management. We also have an SLA (service level
agreement) for response times through the system, which ensures prompt and
dependable service.

Your resources area also offers a wealth of knowledge and tools. Many of our
guides include step-by-step instructions. This area was designed exclusively
for our licensees and offers timely updates and communication from our
staff.

   Ticketing system access - ebsp.aismedia.com


QUICK START EMAIL GUIDE
-----------------------------------------------------------------------
Email
Please reference the Help guide in your email client
program for assistance in adding email accounts to your program.
Email account names and passwords are located in CAMS.


Email Account Information

  POP3 Server: mail.$domain
  SMTP Server: use your ISP's outgoing/SMTP server


IMPORTANT CONTACT INFORMATION
-----------------------------------------------------------------------

If you need technical support for your web hosting account, visit the
support area within the Resource area.

You will be assigned a ticket number for your request, please write this
ticket number down for reference should you need to contact our office.

YOUR eBSP ACCOUNT INFORMATION
-----------------------------------------------------------------------

eBSP Username: $uname
eBSP Password: $password
eBSP Login: http://ebsp.aismedia.com

The eBSP Account Information is the designated eBSP administration
username and password.  You will use this username and password to log
into the licensee extranet where you can access, CAMS, ODIN, Support,
Resources and Account information.


SYSTEM POLICIES
-----------------------------------------------------------------------
The following offenses may result in the immediate termination of your
web hosting account, with the possibility of prosecution to the fullest
extent of applicable law:

 1) Transmission of Unsolicited Bulk Email (UBE) through your account,
    website, or any equipment owned or operated by AIS Media.

 2) Attempts to compromise system security, including, but not limited
    to: unauthorized portscanning, attempts to eavesdrop on network
    traffic, and attempts to access the systems or accounts that you do
    not have explicit authority to access.

 3) The use of equipment owned or operated by AIS Media for any
    purposes unrelated to the services provided by AIS Media,
    including, but not limited to: facilitation of a Denial of Service
    (DoS) attack against any party, portscanning, pinging, or otherwise
    probing any other party of system, and facilitating illegal
    activities.

These guidelines are here for your protection.  If you have any
questions about any system policies, are worried you may be
inadvertently violating a system policy, or you wish to determine if a
specific activity is permitted under system policy, please contact
our technical support department.

Welcome to the AIS eBusiness Solutions Provider (eBSP) program!
We look forward to a long-term, mutually beneficial business
relationship.
If you have any questions, comments or suggestions, please contact our
office.

Sincerely,

AIS eBSP Support Team\"|mail grantd\@aismedia.com";
}
