#!/usr/bin/perl 
#Grant Della Vecchia

use DBI;

$d = `date +\%F`;
datestuff();

$dbh = DBI->connect("DBI:mysql:wonderdesk:mymanagedhosting.com",
"portal", "p0r496mG") ||
   die $DBI::errstr;

   $SQL = "select ClosedBy, Count(*) from Calls where ClosedDate = ? group by ClosedBy;";
   $SQL1 = "select Count(*) from Calls where Date = ?;";

   $sth = $dbh->prepare($SQL);
   $sth->execute($mts);
   $sth1 = $dbh->prepare($SQL1);
   $sth1->execute($mts);



   dircreation();
   open (LOG, ">$repdir/$dir/$fname");
   
   while(@row = $sth->fetchrow_array) {
        print LOG "$row[0] $row[1]\n";
        #print "$row[0] $row[1]\n";

   }

   while(@tt = $sth1->fetchrow_array) {
        print LOG "Total Opened $tt[0]\n";
        #print  "Total Opened $tt[0]\n";
        print LOG "$ts\n";
        #print  "$ts\n";
}
close (LOG);


sub datestuff {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
        $year += 1900;
        $mon = $mon+1;
        $mts = "$year-$mon-$mday";
        $ts = "$mon-$mday/$hour-$min";
        $dir = "$mon-$mday";
        $fname = "$hour-$min";
}
sub dircreation {
        $repdir = "/reps";
        if (!-e "$repdir\/$dir") {
                print "Creating $repdir/$dir\n"; 
                mkdir "$repdir/$dir";
        }
}
