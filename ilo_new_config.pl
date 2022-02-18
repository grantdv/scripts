#!/usr/bin/perl -w
# This script will format the iloconfig from a new server using a file in the following format:
#Serial# hostname

use Expect;


#Variables-------------------------------------------------
$servers = $ARGV[0];
$pw = $ARGV[1];
$newpass = "Lghsf0k";
$defaultpw = "PASSW0RD";
#End-------------------------------------------------------
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
    @shost=split(/ /,$host); # <-- Splitting the IP from hostname
        chomp($shost[0]); # <-- Removing the CR if any.
        chomp($shost[1]);
        print $shost[0];
        print $shost[1] \n;
#    print "Cmd = $cmd ilo$shost[0].con.slc.paypal.com\n"; #<-- SSH command
#    $ssh = Expect->spawn("$cmd ilo$shost[0].con.slc.paypal.com") || die "Couldn't spawn ssh, $!"; #<-- spawning the SSH session.
#    if (! $ssh->expect(10, '-re', 'password: ')) {print "Couldn't get login prompt for $shost[1]\n"; next; }; #<-- Looking for the password prompt to enter the password.
# #   print $ssh "$pass\r"; #<-- Sending the password chosen above.
#    if (! $ssh->expect(2,'-re',"O->")) {print "Could not get Prompt\n"; next; }; #<-- Unable to get the prompt it was looking for.
#    print $ssh "set /map1/config1 oemhp_minpwdlen=7\r"; #<-- Start of the config syntax.
#    print $ssh "set /map1/accounts1/console password=$newpass\r";
#    print $ssh "set /system1 oemhp_server_name=$shost[1]\r";
#    print $ssh "set /system1/bootconfig1/bootsource1 bootorder=1\r";
#    print $ssh "set /system1/bootconfig1/bootsource2 bootorder=2\r";
#    print $ssh "set /system1/bootconfig1/bootsource3 bootorder=3\r";
#    print $ssh "set /system1/bootconfig1/bootsource4 bootorder=4\r";
#    print $ssh "set /system1/bootconfig1/bootsource5 bootorder=5\r";
#    print $ssh "set /map1 license=35R78SDWMX9HV4KJZ7SDHK8JR\r";
#    print $ssh "set /map1/enetport1 SystemName=$shost[1]\r";
#    sleep 5;
#    $ssh->expect(5,'-re',"CLI session stopped") || die "Never got prompt on host, $!\n"; #<-- Waiting for the session to complete.
    #print $ssh "exit\r";
#    $ssh->hard_close(); #<-- Closing the SSH session
}
