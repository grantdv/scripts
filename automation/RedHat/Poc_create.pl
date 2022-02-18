#!/usr/bin/perl
#===============================================================================
#
#         FILE:  poc_create.pl
#
#        USAGE:  This script will create the POC enviornment for RHS Gluster
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Grant Della Vecchia <gdellavecchia@redhat.com>
#      COMPANY:  Red Hat
#      VERSION:  1.0
#      CREATED:  1/21/2015
#     REVISION:  ---
#===============================================================================
#Variables-------------------------------------------------

#End-------------------------------------------------------

scribe();
create_lvm();
install_ctdb();


#Subscribe to repos
sub scribe{
    print "Registering System with Redhat\n";
    system "subscription-manager register --username=grantdv1 --password=Ru88\!esT --auto-attach";
    print "Enableing required repos\n";
    system "subscription-manager repos --enable=rhel-scalefs-for-rhel-6-server-rpms --enable=rhs-3-for-rhel-6-server-rpms --enable=rhel-6-server-rpms";
}

#Create Logical Volumes
sub create_lvm {
   print "Creating First Logical Volume\n";
    system "vgcreate RHS_VG /dev/sdb";
    system "lvcreate -L 19G -T RHS_VG/RHS_POOL -c 256k --poolmetadatasize 100M";
    system "lvcreate -V 20G -T RHS_VG/RHS_POOL -n rhslv";
    system "mkfs.xfs -i size=512 /dev/RHS_VG/rhslv";
    print "Creating Mount Point\n";
    system "mkdir -p /rhs/xfs";
    print "Adding entry to fstab\n";
    system "echo '/dev/RHS_VG/rhslv /rhs/xfs xfs defaults,noatime,inode64 0 0' >> /etc/fstab";
    print "Mouting Logical Volume\n";
    system "mount -a";
}
#On All servers


#Create RHS Volumes
sub create_volumes{
    print "Creating RHS Volumes\n";
    # make CTDB volume
    #gluster volume create ctdb replica 2 lab-rhs10:/rhs/xfs/ctdb lab-rhs11:/rhs/xfs/ctdb
    #gluster volume start ctdb
}
#install CTDB
sub install_ctdb {
    print "Installing and Configuring CTDB\n";
    print "Removing old CTDB\n";
    system "yum remove ctdb";
    print "Installing new CTDB\n";
    system "yum install ctdb2.5 -y";
    
}