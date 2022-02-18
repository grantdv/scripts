#!/usr/bin/perl
#This script will run the stats for the server.

#Variables-------------------------------------------------
chomp($date = `date --date "yesterday" +%b/%d`);
#chomp($date = `date +%b/%d`);
$confdir = "/svc/stats/webalizer/etc";
$logdir = "/svc/web/apache/logs";
$webpath = "/svc/stats/webalizer/bin/webalizer";
#END-------------------------------------------------------

while (<$confdir/*>) {
        $dir = $_; #<-- pushing the while info into a variable
        @path = split (/\//,$dir); #<-- splitting the path to extract the domain name.
        $p = "$path[5]\n"; #<-- pusing the split into a new variable
        @domain = split (/\.conf/,$p); #<-- removing the .conf from he file names to get the domain name

$cust_logdir = "/svc/data/d1/web/$domain[0]/logs"; #<-- Building the customers log directories.

        #if (-e "$logdir/$date/$domain[0]-access.log") {
        if (-e "$cust_logdir/$date/$domain[0]-access.log") { #<-- added this condition in the event that there is no logfile for that day...

                system "$webpath -c $dir $cust_logdir/$date/$domain[0]-access.log"; #<-- doing the work!
#               print "$webpath -c $dir $cust_logdir/$date/$domain[0]-access.log\n"; #<-- debugging
        }
}

