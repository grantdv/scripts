#!/usr/bin/perl

# Written by Grant Della Vecchia
# 6-5-2011 Version 1.4
# lb_rules.pl <-- This script will format and output the LB rules with input from the user.
# Paypal, Inc. (Contractor)

#Variables-------------------------------------------------
chomp($ipfile = "$ARGV[0]");
chomp($pool = "$ARGV[1]");
chomp($port = "$ARGV[2]");
#End-------------------------------------------------------

if ($ipfile eq "") { # <-- If no options on CL, obviously you don't know how to run the program.
        usage()||die;
}else{
    print "Your output file will be $pool.lb.rules in CWD\n"; # <-- Tell the user the name of output file with rules to copy and paste.
    @ips = `cat $ipfile`;
    open OUTFILE, ">$pool.lb.rules"; # <-- Name of the output file.
    print OUTFILE "pool pool_$pool-$port { lb method member ratio monitor all tcp members {"; # <-- First line in the LB config.
    process_file(); # <-- If you looking at this, you should know what this is...
}

#Time to do the work.
sub process_file {
    foreach $ip (@ips) {
        @sip=split(/ /,$ip); # <-- Splitting the IP from the Ratio.
        chomp($sip[0]); # <-- Removing the CR if any.
        chomp($sip[1]);
        print OUTFILE " $sip[0]:$port {ratio $sip[1]}"; # <-- Formatting and writing the rules for each line in the ipfile.
    }
}
sub usage { # <-- Yep, you guessed it...
    print "Usage: lb_rules.pl <list of ip's and ratios> <poolname> <port number>\n";
    print "Usage: The list of ip's and ratios needs to be IP RATIO ex. 192.168.1.1 11\n";
    print "Usage: Only one IP and Ratio per line with a CR at the end of the line.\n";
}

print OUTFILE "} }"; # <-- This is the last 2 braces in the file, very important...
print OUTFILE "\n\n";
print "What is the VIP for the Pool?\n";
chomp($vip=<STDIN>);
print OUTFILE "b virtual vs_$pool-$port {snat automap pool $pool-$port destination $vip:$port ip protocol tcp profiles {pr_tcp_client_9000_timeout {clientside} pr_tcp_server_9000_timeout {serverside}} }\n";
print OUTFILE "\n";
print OUTFILE "b save\n";
close OUTFILE; # <-- Always close your files.


#ChangeLog
#v1.4 removed syntax based on Tom's input.
#v1.3 Added part to create the VIP.
#v1.2 Added comments
#v1.1 Corrected formating issues with spacing on line 30.
#v1.0 Beginning.