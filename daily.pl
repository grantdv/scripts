#!/usr/bin/perl
#Grant Della Vecchia

use DBI;

$d = `date +\%F`;

$dbh = DBI->connect("DBI:mysql:wonderdesk:mymanagedhosting.com",
"portal", "p0r496mG") ||
   die $DBI::errstr;

   $SQL = "select ClosedBy, Count(*) from Calls where ClosedDate = ? and ClosedBy in (\"ruebengarcia\",\"alvinramos\",\"ryancaudill\",\"grantdellavecchia\",\"allenbrand\",\"addiellopez\") group by ClosedBy;";
#   $SQL = "SELECT Server_Password,Date FROM Calls WHERE ServerID= ? ORDER BY Date ASC LIMIT 10";

   $sth = $dbh->prepare($SQL);
   $sth->execute($d);



   chop ($d);
   while(@row = $sth->fetchrow_array)
   {
   open (LOG, ">>/reps/$d.txt");
   print LOG "$row[0] $row[1]\n";
   close (LOG);
   }
