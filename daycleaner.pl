#!/usr/bin/perl
#Grant Della Vecchia
#This script will clean out the otbbackup/clients directory.
#The script will run from cron and will purge the files that are older than 30 days.


chomp($days = $ARGV[0]);
chomp($switch = $ARGV[1]);

while(<*>) {
        chomp;
        $age = -M;
       next if $_ =~ /^\.\.?$/;     # skip . and ..
       next if $_ =~ /^\.ssh/;     # skip . and ..
        if ($age >= $days) {
                print "$_ $age\n";
                if ($switch eq "del") {
                        system ("rm -R $_");
                        #unlink $_;
                }
        }
}

