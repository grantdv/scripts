for i in `ls .*.xml|awk -F. '{print$2}'` ; do echo Removing $i; ssh cobbler@v3cobbler02.sc4.paypal.com "/x/cobbler/scripts/cobbler_wrapper.pl remove $i" ;rm .$i.xml; done;
