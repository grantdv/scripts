#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  disk_mover.pl
#
#        USAGE:  disk_mover.pl <list_of_vm's>
#
#  DESCRIPTION:  This script will svmotion a vm from one datastore to another.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <grant.dellavecchia@cnn.com>
#      COMPANY:  Turner (ServerOps)
#      VERSION:  1.0
#      CREATED:  1/11/2011
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------
$vmlist=$ARGV[0]; #List of VM's
$sds=$ARGV[1]; #List of VM's
$dds=$ARGV[2]; #List of VM's
@vmname=`cat $vmlist`; #List of VM's
#chomp($username = `whoami`); #Who am I??
#$xmlfile="/home/$username/.$vmname.xml"; #location of the XML file.
#End-------------------------------------------------------
#print "This script will a VM from one datastore to another.\n";
#print "Please enter your Virtual Center password\n";
#system "stty -echo";
#chomp($password=<STDIN>);
#system "stty echo";
#$password="\"" . $password . "\""; # To address other characters in passwords.

#dc_select();
#datastore();
do_the_work();

sub dc_select{
    print "Which datacenter would you like to work in?\n";
    print "P1=1, 8S=2, S1=3\n";
    chomp($dcr=<STDIN>);
    if ($dcr==1){
        $dc="P1";
        $vc_server="vcenterp1app1.turner.com";
    }elsif ($dcr==2){
        $dc="8S";
        $vc_server="vcenter8app1.turner.com";
    }elsif($dc==3){
        $dc="S1";
        $vc_server="vcenters1app1.turner.com";
    }
}

sub datastore{
    print "Please enter source datastore\n";
    chomp($sds=<STDIN>);
    print "Please enter destination datastore\n";
    chomp($dds=<STDIN>);
}

sub do_the_work{
    foreach $vmname (@vmname) {
        chomp($vmname);
        #print "Starting the Migration for $vmname\n";
#        print "/usr/bin/svmotion --server $vc_server --username $username --password $password --datacenter=$dc --vm=\'\[$sds\] $vmname\/$vmname.vmx:$dds\'\n";
        system ("/usr/bin/svmotion --server vcenterp1app1.turner.com --username gdellavecchia --password d412294a --datacenter=P1 --vm=\'\[$sds\] $vmname\/$vmname.vmx:$dds\'");
    }
}









#/usr/bin/svmotion --server vcenterp1app1.turner.com --username gdellavecchia --password d412294a --datacenter=P1 --vm='[RHEL2_F4_01] $i/$i.vmx:RHEL2_F4_01'; done;