#!/usr/bin/perl

# Written by Grant Della Vecchia
# 6/21/2011
# PayPal (Contractor)
# ilo_config.pl
# Version 1.6
# This script will generate the iLO syntax to configure a new iLO.

use Expect;
#$Expect::Log_Stdout=0;

# Variables------------------------------------------------
$servers = $ARGV[0];
$pw = $ARGV[1];
$newpass = "Lghsf0k";
$defaultpw = "PASSW0RD";
# End------------------------------------------------------
if ($servers eq "") { # <-- If no options on CL, obviously you don't know how to run the program.
        usage()||die;
}
if ($pw eq "np"){ #<-- Which password should we use?
    $pass = $newpass;
} else{
    $pass = $defaultpw;
}
@hosts=`cat $servers`;
$cmd = "/usr/bin/ssh -l console";
my $stdin = Expect->exp_init(\*STDIN); #<-- Start of expect code.
print "@hosts\n";
foreach $host (@hosts) {
    chomp($host);
    print "Cmd = $cmd $host.con.slc.paypal.com\n"; #<-- SSH command
    $ssh = Expect->spawn("$cmd $host.con.slc.paypal.com") || die "Couldn't spawn ssh, $!"; #<-- spawning the SSH session.
    if (! $ssh->expect(5, '-re', 'password: ')) {print "Couldn't get login prompt for $host\n"; next; }; #<-- Looking for the password prompt to enter the password.
    print $ssh "$pass\r"; #<-- Sending the password chosen above.
    if (! $ssh->expect(5,'-re',"O->")) {print "Could not get Prompt\n"; next; }; #<-- Unable to get the prompt it was looking for.
    print $ssh "set /map1/config1 oemhp_minpwdlen=7\r"; #<-- Start of the config syntax.
    print $ssh "set /map1/accounts1/console password=$newpass\r";
    print $ssh "set /system1 oemhp_server_name=$host\r";
    print $ssh "set /system1/bootconfig1/bootsource1 bootorder=1\r";
    print $ssh "set /system1/bootconfig1/bootsource2 bootorder=2\r";
    print $ssh "set /system1/bootconfig1/bootsource3 bootorder=3\r";
    print $ssh "set /system1/bootconfig1/bootsource4 bootorder=4\r";
    print $ssh "set /system1/bootconfig1/bootsource5 bootorder=5\r";
    print $ssh "set /map1 license=35R78SDWMX9HV4KJZ7SDHK8JR\r";
    print $ssh "set /map1/enetport1 SystemName=$host\r";
    sleep 5;
    $ssh->expect(5,'-re',"CLI session stopped") || die "Never got prompt on host, $!\n"; #<-- Waiting for the session to complete.
    #print $ssh "exit\r";
    $ssh->hard_close(); #<-- Closing the SSH session
}

sub usage { # <-- Yep, you guessed it...
    print "Usage: ilo_config.pl <list of hostnames> (optional np)\n";
    print "Usage: The list of hosts needs to be one hostname per line\n";
    print "Usage: The second option is to tell the script to use the new password in the event you want to run the script againts a server that has it password changed already\n";
    print "Usage: If you do not supply a 'np' as the second argument, it will use the default password.\n";
}