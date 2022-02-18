#!/usr/bin/perl
#Grant Della Vecchia

use DBI;

$dbh = DBI->connect("DBI:mysql:wonderdesk:mymanagedhosting.com",
"portal", "p0r496mG") ||
   die $DBI::errstr;

   $SQL = "SELECT Server_Password,Date FROM Calls WHERE ServerID= ? ORDER
   BY Date ASC LIMIT 10";

   $sth = $dbh->prepare($SQL);
   $sth->execute($ARGV[0]);



   while(@row = $sth->fetchrow_array)
   {
   print "$row[0] $row[1]\n";
   }

