#!/usr/bin/perl
#This script will add the mail users to the password file, create their home directory, and add a symbolic link to the user mbox file in their home directory.

#Variables-------------------------------------------------
$hdir = "/mailhome";
chomp($uid = "$ARGV[0]");
#End-------------------------------------------------------

if ($uid = "") {
	usage ();
}else{

	if (-e $hdir/$uid) {
		print "User $uid already exists!\n";
	else {
		system (adduser $uid -d $hdir/$uid -s /bin/false);
		system (ln -s /var/mail/$uid /$hdir/$uid/inbox);
	}
}
sub usage { # <-- Yep you guessed it, the usage!
        print "Usage\n";
        print "Sytax is as follows\n";
        print "sc [1-9]\n";
        print "To use no footer, use sc 8\n";
        print "To see the available footers, use sc 9\n";

