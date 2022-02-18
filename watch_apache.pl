#!/usr/bin/perl
#This script will check to see if Apache is running and start it if it is not running, then it will notify someone.
#path to pid =/svc/web/apache_1.3.31/logs/httpd.pid
#Variables-------------------------------------------------
$pid = "/svc/web/apache_1.3.31/logs/httpd.pid";
$email = "grantpp\@aismedia.com";
#End-------------------------------------------------------

if (-e $pid) {
	die;
}else{
	#system "/usr/local/etc/rc.d/apache.sh startssl";
	print "/usr/local/etc/rc.d/apache.sh startssl\n";
	email();
}
sub email {
	open (EMAIL, "|/usr/sbin/sendmail -t $email");
	if (-e $pid) {
		print EMAIL "Subject: Apache Restarted\n";
		print EMAIL "Apache died on webhost1 and I restarted it\n";
		print EMAIL "successfully\n";
	}else{
		print EMAIL "Subject: Apache needs Attention\n";
		print EMAIL "Apache died on webhost1 and I was unable to\n";
		print EMAIL "restart it successfully\n";
	}
	close EMAIL;
}
