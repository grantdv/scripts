#!/usr/bin/perl
#Grant Della Vecchia
#1-30-03
#Version 1.0
#This script will write forwarded tickets to a file and send an email to the
#forwardee and the manager.
#
#
#Variables-------------------------------------------------
$ff = "forward_tickets";

#Variables-------------------------------------------------
$ts = localtime;
$manager = "root";
$user = `whoami`; # <-- Using shell info to determine who user is (part of multi user support)
chomp($hd = `echo \$HOME`); # <-- Figures out users home directory
chomp($file = "$hd/forwards.$user"); # <-- File it will open to write its info.
#End-------------------------------------------------------

user(); # <-- Process the user info
get_info(); # <-- Collect the pertinant info
who(); # <-- Process who we are forwarding the ticket to
work(); # <-- Actually doing the work
fmail(); # <-- Figure out the email addresses.
why(); # <-- Explanation
mail(); # <-- Sending the mail

# Usually you do not use sub routines for things like this, but I used them
# for scalability. I want to be able to expand functionality without having to
# re-write the code.
sub user {
        chomp($user);
        if ($user eq "root") { # <-- Multi User support
                $user = "Grant";
        }elsif ($user eq "allen") {
                $user = "Allen";
        }elsif ($user eq "alvin") {
                $user = "Alvin";
        }elsif ($user eq "ryan") {
                $user = "Ryan";
        }
}


sub get_info {
        print "What is the server ID?\n";
        chomp($server = <STDIN>); # <-- Collecting server ID
        print "What is the ticket number?\n";
        chomp($ticket = <STDIN>); # <-- Collecting Ticket number
}


sub who {
        print "Who was it forwarded to?\n";
        print "Valid names are\n ad = Alesandro ; h = Hardware ; ct = Corlone ; ds = Dave Shanker ; cm = Camilo ; sr = Scott ; ll = Larry\n";
        chomp($who = <STDIN>); # <-- Collecting Who we are sending the ticket to.
        if ($who eq "ad") { 
                $who1 = "Alessandro Douvis";
        }elsif ($who eq "h") {
                $who1 = "Hardware";
        }elsif ($who eq "ct") {
                $who1 = "Corlone Tomlinson";
        }elsif ($who eq "gd") {
                $who1 = "Grant Della Vecchia";
        }elsif ($who eq "ds") {
                $who1 = "Dave Shanker";
        }elsif ($who eq "cm") {
                $who1 = "Camilo Marrguo";
        }elsif ($who eq "sr") { 
                $who1 = "Scott Ramshaw";
        }elsif ($who eq "nt") { 
                $who1 = "Nelson Tallaferro";
        }elsif ($who eq "ll") { # <-- At this point I am sure you can see what we are doing here...
                $who1 = "Larry Long";
        }else{
                $who1= $who; # <-- Making the variables the same incase you type in a name that is not in the list.
        }
}


sub work {
        if (-e $file) { # <-- There is no reason why this file should be gone, that is why I want to know that it is...
	        open (FILE, ">>$file");
	        print FILE "$user forwarded Ticket $ticket for server $server to $who1 on $ts\n";
	        close (FILE); # <-- Good perl, close your files....
        }else{
	        print "File does not exist, I am going to create it.\n";
	        open (FILE, ">>$file");
	        print FILE "$user forwarded Ticket $ticket for server $server to $who1 on $ts\n";
	        close (FILE); # <-- Good perl, close your files....
        }
}
if (!-e $file) {
        print "I was not able to create the file.\nThis is where I tried to write it\n$file";
}

sub mail {
        open (UMAIL, "|sendmail -t $eaddr");
        print UMAIL "From: grant\@dialtone.com\n";
        print UMAIL "Subject: $user forwarded a ticket to $who1\n";
        print UMAIL "Hello $who1!\n\n";
        print UMAIL "$user has forwarded a ticket ($ticket) for server $server to $who1 on $ts\n";
        print UMAIL "\n$why\n";
        print UMAIL "Your prompt attention to the matter is greatly appericiated.\n";
        print UMAIL "\n\nThank you,\n$user\n";
        close (UMAIL);

        open (MMAIL, "|sendmail -t $manager");
        print MMAIL "From: grant\@dialtone.com\n";
        print MMAIL "Subject: $user forwarded a ticket to $who1\n";
        print MMAIL "Larry,\n";
        print MMAIL "The following was sent to $who1. This is your copy\n\n";
        print MMAIL "$user has forwarded a ticket ($ticket) for server $server to $who1 on $ts\n";
        print MMAIL "\n$why\n";
        print MMAIL "Your prompt attention to the matter is greatly appericiated.\n";
        print MMAIL "\n\nThank you,\n$user\n";
        close (MMAIL);
}

sub fmail {
        if ($who eq "ad") { 
                $eaddr = "alessandro\@dialtone.com";
        }elsif ($who eq "h") {
                $eaddr = "kenny\@dialtone.com";
        }elsif ($who eq "ct") {
                $eaddr = "ctomlinson\@dialtone.com";
        }elsif ($who eq "gd") {
                $eaddr = "grant\@dialtone.com";
        }elsif ($who eq "ds") {
                $eaddr = "dave\@dialtone.com";
        }elsif ($who eq "cm") {
                $eaddr = "camilo\@dialtone.com";
        }elsif ($who eq "sr") { 
                $eaddr = "sramshaw\@dialtone.com";
        }elsif ($who eq "ll") { # <-- At this point I am sure you can see what we are doing here...
                $eaddr = "larry\@dialtone.com";
        }else{
                $eaddr= $who; # <-- Making the variables the same incase you type in a name that is not in the list.
        }
       
}

sub why {
        print "Why\n";
        $why = <STDIN>;
}
