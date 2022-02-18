#!/usr/bin/perl
#
# This script is used to check machines in our network for the SSL vulnerability
# The script will output the results to /tmp/team*
# checkssl.c is just renamed from: openssl-sslv2-master.c 
# it has an update to set a timeout use setsockopt and the timeval struct
# 
# Roberto Mendez 2002-17-09


use DBI;

$dbh = DBI->connect("DBI:mysql:portal:mymanagedhosting.com", "portal", "p0r496mG") || 
   die "could not connect\n";

$sql = "SELECT ItemNumber, ProjectManager, PrimaryIP from IM_1A_InventoryMasterfileAddl WHERE MonitoringExt NOT LIKE 'CANCEL%'";

$sth = $dbh->prepare($sql);

$sth->execute();

while(@row = $sth->fetchrow_array)
{
   my($pid) = fork();
   if($pid > 0)
   {
      $child++;
      if($childs > 75)
      {
         while(1)
         {
             my($res) = waitpid(-1,&WNOHANG);
            last if ($res == 0 || $res == -1);
         }
      }
      
   }
   elsif ($pid == 0)
   {
      &check($row[0], $row[2], $row[1]);
      exit;
   }   
}

sub check
{
   my($id, $ip, $team) = @_;
   $command = "/usr/local/bin/checkssl";
   $ret = `$command $ip`;
   $stat = (split(/\s/, $ret))[2];
   $stat =~ s/://;
   open(A, ">>/tmp/teamA");
   open(B, ">>/tmp/teamB");
   open(C, ">>/tmp/teamC");
   open(D, ">>/tmp/teamD");
   open(ALL, ">>/tmp/teamALL");
   if($stat eq 'VULNERABLE')
   {
      if($team eq 'A')
      {
         print A "$id\t$ip Vulnerable to SSL\n";
      }
      elsif($team eq 'B')
      {
         print B "$id\t$ip Vulnerable to SSL\n";
      }
      elsif($team eq 'C')
      {
         print C "$id\t$ip Vulnerable to SSL\n";
      }
      elsif($team eq 'D')
      {
         print D "$id\t$ip Vulnerable to SSL\n";
      }
      else
      {
         print ALL "$id\t$ip Vulnerable to SSL\n";
      }
      return $stat;
   }
}
