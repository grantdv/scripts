#!/usr/bin/perl
#Grant Della Vecchia

use DBI;

$d = `date +\%F`;

$dbh = DBI->connect("DBI:mysql:wonderdesk:mymanagedhosting.com",
"portal", "p0r496mG") ||
   die $DBI::errstr;

   $SQL = "select ClosedBy, Count(*) from Calls where ClosedDate in (\"2002-10-20\",\"2002-10-21\",\"2002-10-22\",\"2002-10-23\",\"2002-10-24\",\"2002-10-25\",?) and ClosedBy in (\"ruebengarcia\",\"alvinramos\",\"ryancaudill\",\"grantdellavecchia\",\"allenbrand\",\"addiellopez\") group by ClosedBy;";
#   $SQL = "select ClosedBy, Count(*) from Calls where ClosedDate = ? and ClosedBy in (\"ruebengarcia\",\"alvinramos\",\"ryancaudill\",\"grantdellavecchia\",\"allenbrand\",\"addiellopez\") group by ClosedBy;";
#   $SQL = "SELECT Server_Password,Date FROM Calls WHERE ServerID= ? ORDER BY Date ASC LIMIT 10";

   $sth = $dbh->prepare($SQL);
   $sth->execute($d);


   while(@row = $sth->fetchrow_array)
   {
   print "$row[0] $row[1]\n";
   }
