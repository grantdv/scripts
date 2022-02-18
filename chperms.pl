#!/usr/bin/perl
#This script will change permissions for the logs and stats directory.

#Variables-------------------------------------------------
$userdirs = "/svc/data/d1/web"; #<-- User directories
$statspath = "www/stats/"; #<-- stats dir
$logspath = "logs/"; #<--logs dir
#END-------------------------------------------------------
$count=1;
work();





sub work {
        while  {
        	$dir = $_;
        	$owner = (stat($dir))[4]; #<-- collecting the UID for the directory
		if ("$dir" ne /\w/"DELETED"/) {
			if ("$dir" ne "*log") {
        			if (-e "$dir/$statspath") { #<-- making sure the directory exists
#        				system "chown -R $owner:webowner $dir/$statspath"; #<-- doing the work
#       				print "chown -R $owner:webowner $dir/$statspath\n"; #<-- debugging code
        				$count=0;
        			}else{
        				print "$dir/$statspath\n";
        			#	mkstats();
        			}
			}
		}
        	if (-e "$dir/$logspath") { #<-- same as above
#        		system "chown -R $owner:webowner $dir/$logspath"; #<-- same as above
#       		print "chown -R $owner:webowner $dir/$logspath\n"; #<-- same as above
        	}
        }
}

sub mkstats {
        if ($count < "2") {
                if (!-e "$dir/$statspath") {
                print "Making Directory $dir/$statspath\n";
                mkdir "$dir/$statspath",0755;
                print "$count\n";
                $count++;
                print "$count\n";
                work();
                }
        }else{
                die;
        }
}

