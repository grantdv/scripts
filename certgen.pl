#!/usr/bin/perl
# Grant Della Vecchia
$hostname = `hostname`;
#
#
open(OPENSSL,
  "|openssl req -new -x509 -keyout /tmp/newreq.key -out /tmp/newreq.pem \ -days 365")
       or die "Can't pipe to OpenSSL!";

       open(STDIN,">&OPENSSL");

       sleep(1);

       select(OPENSSL); $| = 1;

       print OPENSSL "BOGUSPASS\n";
       print OPENSSL "BOGUSPASS\n";
       print OPENSSL "US\n";
       print OPENSSL "Florida\n";
       print OPENSSL "Miami\n";
       print OPENSSL "$hostname\n";
       print OPENSSL "Webmaster\n";
       print OPENSSL "$hostname\n";
       print OPENSSL "admin\@$hostname\n";

       sleep(3);
       close(OPENSSL);

       open(OPENSSL,
         "|openssl rsa -in /tmp/newreq.key -out /tmp/ssl.cert")
           or die "Can't pipe to OpenSSL!";

           open(STDIN,">&OPENSSL");

           select(OPENSSL); $| = 1;

           print OPENSSL "BOGUSPASS\n";
           print OPENSSL "BOGUSPASS\n";

           sleep(3);

           close(OPENSSL);

          system "cat /tmp/newreq.key /tmp/ssl.cert > /tmp/interface.cert";
