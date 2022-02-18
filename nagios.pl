#!/usr/bin/perl
#Grant Della Vecchia

use DBI;

$d = `date +\%F`;

$dbh = DBI->connect("DBI:mysql:nagios:localhost",
"root", "d412294a") ||
   die $DBI::errstr;

   $SQL = "select * from Host;";

   $sth = $dbh->prepare($SQL);
   $sth->execute($d);



   while(@row = $sth->fetchrow_array) {
   	print "$row[0] $row[1]\n";
   }
