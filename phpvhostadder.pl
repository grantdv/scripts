#!/usr/bin/perl
# This script was written by:
# Grant Della Vecchia
# AIS Media 7-26-06
# Version 1.0

#This script will add php security to vhost confs
#Variables-------------------------------------------------
$confdir = "/svc/web/apache/conf/vhosts";        #<-- Directory where the vhost files are stored
$of = "$confdir/$domain";    #<-- Setting the original file variable
$nf = "$confdir/.$domain";   #<-- Setting the temp file variable
#End-------------------------------------------------------

while (<$confdir/*>) {    #<-- Reading the directory for file names
	@dom = split(/\//,$_);  #<-- Splitting the file name to get the domain name foo.com.conf
#	print "$domain[6]\n";   #<-- Debug code
	conf($domain=$dom[6]);  #<-- Passing the domain name along to the sub routine
}

sub conf {                #<-- Doing the Work!
	print "$confdir/$domain\n\n"; #<-- Debug code
	if (-e "$confdir/$domain") {  #<-- Cheking to see if the file does infact exist, although technically it would not be here if it did not
		open (OF,"$of");            #<-- Opening the original file
		open (NF, ">$nf");          #<-- Creating the temp file
		while ($line = <OF>) {      #<-- While there are lines in the file....
			$line =~ s/\<\/virtualhost\>/\<IfModule mod_php4.c\>/;      #<-- We are looking for this line to signify the end of the vhost container
			print NF $line;            #<-- Other wise, print the lines back to the temp file
		}
#			print NF "<IfModule mod_php4.c>\n";       #<-- Debug Code
			print NF "  php_admin_flag safe_mode on\n";     #<-- What we are inserting
			print NF "  php_admin_flag safe_mode_gid on\n"; #<-- What we are inserting
			print NF "</IfModule>\n";                       #<-- What we are inserting
			print NF "</virtualhost>\n";                    #<-- What we are inserting
		close(OF);                       #<-- Close the file
		close(NF);                       #<-- Close the file
		open (FF, "$nf");                # This section will open the new file once it has been created on the server and display
		while ($content = <FF>) {        # it on the screen for the operator to visually inspect the new file. This is critical as
			print "$content";              # some of the vhosts are not exactly the same. Also we do not want to change AIS Media's vhosts.
		}                                # Once the data is dumped to the screen, it will ask for validation of the changes (y or anything else)
		print "Is this ok?\n";           # If the answer is 'y' it will remove the original file and replace it with the temp file
		chomp($ans = <STDIN>);           # or it will do nothing and tell you its doing nothing
		if ($ans eq "y") {
			unlink $of;
			rename $nf, $of;
		}else{
			unlink $nf;
			print "Doing Nothing\n";
			system "clear";
		}
	}else{
		print "Conf files does not exist\n";         #<-- Die if the conf files does not exist.
	}	

}

