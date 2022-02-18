#!/usr/bin/perl
#
###############################################################################
#
# No modifications are required or should be made beyond this point
#
###############################################################################
# Copyright 1998-2002, Way to the Web Limited
# No part of the script may be copied or used for any purpose other than
# testing for the functionality of Way to the Web Limited Products
###############################################################################
$header = "Content-type: text/html\n\n<html>\n<head>\n<title>Way to the Web Product Tests</title>\n</head>\n<body bgcolor=\"\#FFFFCC\">\n<p><center><font face=\"Arial, Helvetica\" size=\"+2\" color=\"black\">Way to the Web Product Tests</font></p>\n";
$footer = "<p><center><font face=\"Arial, Helvetica\" size=\"-1\" color=\"black\">If you have any problems, email the information on this page to <a href=\"mailto:sales\@waytotheweb.com?subject=Way to the Web Product Tests\">sales\@waytotheweb.com</a> and we will be able to advise you further\n<p><a href=\"http://www.waytotheweb.com\">&copy;1998-2002, Way to the Web Limited</a></body>\n</html>";
###############################################################################
# start main
&process_input;

if ($form{action} eq "") {&start_page;}
elsif ($form{action} eq "Start Tests") {&test_one;}
elsif ($form{action} eq "To Test Two") {&test_two;}
elsif ($form{action} eq "Send Email") {&test_four;}
elsif ($form{action} eq "Finished") {&end_page;}
else {&strange_input;}

exit;
# end main
###############################################################################
# start process_input
sub process_input {

$buffer = $ENV{'QUERY_STRING'};
if ($buffer eq "") {read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});}
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	$form{$name} = $value;
}

}
# end process_input
###############################################################################
# start start_page
sub start_page {

print $header;
print "<form method=\"POST\">\n";
print "<p><center><font face=\"Arial, Helvetica\" color=\"black\"><b>Select all that apply</b>\n";
print "<table border=\"0\" cellpadding=\"8\" cellspacing=\"0\">\n";
print "<tr><td><input type=checkbox name=\"mail\" value=\"1\" checked></td><td><font face=\"Arial, Helvetica\" colour=\"black\">Perform Checks for WebUMake Mail</font></td></tr>\n";
print "<tr><td><input type=checkbox name=\"web\" value=\"1\" checked></td><td><font face=\"Arial, Helvetica\" color=\"black\">Perform Checks for WebUMake Web</font></td></tr>\n";
print "<tr><td><input type=checkbox name=\"ipn\" value=\"1\" checked></td><td><font face=\"Arial, Helvetica\" color=\"black\">Perform Checks for WebUMake PayPal IPN</font></td></tr>\n";
print "<tr><td><input type=checkbox name=\"wih\" value=\"1\" checked></td><td><font face=\"Arial, Helvetica\" color=\"black\">Perform Checks for WebUMake Instant Helper</font></td></tr>\n";
print "<tr><td><input type=checkbox name=\"linktree\" value=\"1\" checked></td><td><font face=\"Arial, Helvetica\" color=\"black\">Perform Checks for WebUMake LinkTree</font></td></tr>\n";
print "<tr><td colspan=2 align=center><input type=submit name=\"action\" value=\"Start Tests\"></td></tr>\n";
print "</table>\n";
print "</form>\n";
print $footer;

}
# end start_page
###############################################################################
# start test_one
sub test_one {

print $header;
print "<p><center><font face=\"Arial, Helvetica\" color=\"black\"><b>Required Modules Test Results</b><br><br>\n";
print "<table border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n";

$error = 0;
print "<tr><td><font face=\"Arial, Helvetica\" color=\"black\">Perl Version ($])</font></td>\n";
if ($] < 5.00402) {
	print "<td><font face=\"Arial, Helvetica\" color=\"red\">Failed - at least v 5.00402 required</font></td></tr>\n";
	$error = 1;
} else {
	print "<td><font face=\"Arial, Helvetica\" color=\"red\">OK</font></td></tr>\n";
}
&evaluate ('Socket module (Socket)','use Socket;');
if ($form{mail}) {&evaluate ('IO::Socket module (IO::Socket)','use IO::Socket;')}
&evaluate ('File module (File::Path)','use File::Path;');
&evaluate ('Time module (Time::Local)','use Time::Local;');
if ($form{ipn}) {&evaluate ('LWP::UserAgent module)','use LWP::UserAgent;')}

print "</table>\n";

if ($error) {print $footer; exit;}
if ($form{ipn} and !($form{mail} or $form{web} or $form{wih} or $form{linktree})) {print $footer; exit;}
print "<form method=\"POST\">\n";
print "<input type=hidden name=\"mail\" value=\"$form{mail}\">\n";
print "<input type=hidden name=\"web\" value=\"$form{web}\">\n";
print "<input type=hidden name=\"ipn\" value=\"$form{ipn}\">\n";
print "<input type=hidden name=\"wih\" value=\"$form{wih}\">\n";
print "<input type=hidden name=\"linktree\" value=\"$form{linktree}\">\n";
print "<p><center><input type=submit name=\"action\" value=\"To Test Two\">\n";
print "</form>\n";
print $footer;

}
# end test_one
###############################################################################
# start test_two
sub test_two {

$sendmail = "";
if (-e "/usr/sbin/sendmail") {$sendmail = "/usr/sbin/sendmail"}
elsif (-e "/usr/bin/sendmail") {$sendmail = "/usr/bin/sendmail"}
elsif (-e "/usr/lib/sendmail") {$sendmail = "/usr/lib/sendmail"}
elsif (-e "/bin/sendmail") {$sendmail = "/bin/sendmail"}
if ($sendmail eq "") {
	$smtpcheck = "checked";
	$sendcheck = "";
} else {
	$smtpcheck = "";
	$sendcheck = "checked";
}

$smtp = $ENV{HTTP_HOST};
if ($smtp eq "") {$smtp = $ENV{SERVER_NAME};}
$smtp =~ s/www\.//i;

print $header;
print "<p><center><font face=\"Arial, Helvetica\" color=\"black\"><b>Email Test</b><br><br>\n";
print "<form method=\"POST\">\n";
print "<table border=\"0\" cellpadding=\"4\" cellspacing=\"0\">\n";
print "<tr><td align=right><font face=\"Arial, Helvetica\" color=\"black\">SMTP Server (using Sockets)</font></td><td><input type=radio name=\"type\" value=\"SMTP\" $smtpcheck></td><td><input type=text name=\"smtp\" value=\"$smtp\"></td></tr>\n";
print "<tr><td align=right><font face=\"Arial, Helvetica\" color=\"black\">or SENDMAIL (UNIX-type OS's only)</font></td><td><input type=radio name=\"type\" value=\"SENDMAIL\" $sendcheck></td><td><input type=text name=\"sendmail\" value=\"$sendmail\"></td></tr>\n";
print "<tr><td align=right><font face=\"Arial, Helvetica\" color=\"black\">Enter <i>your</i> Email Address here</font></td><td>=></td><td><input type=text name=\"email\" value=\"test\@waytotheweb.com\"></td></tr>\n";
print "</table>\n";
print "<input type=hidden name=\"mail\" value=\"$form{mail}\">\n";
print "<input type=hidden name=\"web\" value=\"$form{web}\">\n";
print "<input type=hidden name=\"wih\" value=\"$form{wih}\">\n";
print "<input type=hidden name=\"linktree\" value=\"$form{linktree}\">\n";
print "<p><center><input type=submit name=\"action\" value=\"Send Email\">\n";
print "</form>\n";

print $footer;

}
# end test_two
###############################################################################
# start test_four
sub test_four {

if ($form{type} eq "SENDMAIL") {
	unless (-e $form{sendmail}) {&message ("Cannot find SENDMAIL at [<font color=\"black\">$form{sendmail}</font>]")}
}

&send_mail ($form{email},$form{email},"Way to the Web Product Test","Hello,\n\nThis is a test email from the Way to the Web Product Test Script.\n\nRegards,\nWay to the Web Limited - sales\@waytotheweb.com");

print $header;
print "<p><center><font face=\"Arial, Helvetica\" color=\"black\"><b>Tests Completed</b><br><br>\n";
print "<p>You should have received an email at $form{email}\n";
print "<p>If you did then your server environment has passed all tests and can host:<br>";
if ($form{mail}) {print "WebUMake Mail* ";}
if ($form{web}) {print "WebUMake Web ";}
if ($form{wih}) {print "WebUMake Instant Helper ";}
if ($form{linktree}) {print "WebUMake Linktree ";}
if ($form{mail}) {
	print "<p><table border=1 cellpadding=\"4\" width=\"75%\" cellspacing=\"0\">\n<tr><td><font face=\"Arial, Helvetica\" color=\"black\" size=-1>\* WebUMake Mail requires a catchall account (sometimes called a dump or default account). This is a POP3 email account that accepts email for any address in your domain. For example, email sent to fred\@mydomain.com and bill\@mydomain.com is delivered to mypopaccount\@mydomain.com. Any hosting provider should be able to provide you with a domain catchall account. WebUMake Mail uses this account to receive email for the user accounts created within it.</font></td></tr>\n</table>\n";
}
print "<p><b>For product orders please visit our <a href=\"http://www.webumake.com/purchase.htm\">Product Order Page</a></b>\n";
print "<p>For WebUMake Mail information please visit our <a href=\"http://www.webumake.com/wmail/\">WebUMake Mail Site</a>\n";
print "<p>For WebUMake Web information please visit our <a href=\"http://www.webumake.com/wweb/\">WebUMake Web Site</a>\n";
print "<p>For WebUMake Instant Helper information please visit our <a href=\"http://www.webumake.com/wih/\">WebUMake Instant Helper Site</a>\n";
print "<p>For WebUMake LinkTree information please visit our <a href=\"http://www.webumake.com/wlinktree/\">WebUMake LinkTree Site</a>\n";

print $footer;

}
# end test_four
###############################################################################
# start evaluate
sub evaluate {

my $title = shift;
my $command = shift;

print "<tr><td><font face=\"Arial, Helvetica\" color=\"black\">$title</font></td>\n";
eval ($command);
if ($@) {
	print "<td><font color=\"red\">Failed</font></td></tr>\n";
	print "<tr><td colspan=2 bgcolor=\"\#99CCFF\"><blockquote>$@</blockquote></td></tr>\n";
	$error = 1;
} else {
	print "<td><font face=\"Arial, Helvetica\" color=\"red\">OK</font></td></tr>\n";
}

}
# end evaluate
###############################################################################
# start message
sub message {

print $header;
print "<p><center><font face=\"Arial, Helvetica\" color=\"red\"><b>@_</b></font>\n";
print "<form method=\"POST\">\n";
print "<p><center><input type=submit value=\"Start Again\">\n";
print "</form>\n";
print $footer;

exit;

}
# end message
###############################################################################
# start send_mail
sub send_mail {

local($from, $to, $subject, $body) = @_;
local($error, $name, $status, $message) = '';

if ($form{type} eq "SMTP") {
	use Socket;

	if (!$WEB_SERVER) { $WEB_SERVER = $ENV{'SERVER_NAME'} }
	if (!$WEB_SERVER) {
		&message ("$WEB_SERVER is not set.");
	}
	local($CRLF) = "\015\012";
	local($smtp_server_PORT) = 25;
	local($AF_INET) = ($] > 5 ? AF_INET : 2);
	local($SOCK_STREAM) = ($] > 5 ? SOCK_STREAM : 1);
	$, = ', ';
	$" = ', ';

	local($local_address) = (gethostbyname($WEB_SERVER))[4];
	local($local_socket_address) = pack('S n a4 x8', $AF_INET, 0, $local_address);
	local($server_address) = (gethostbyname($form{smtp}))[4];
	local($server_socket_address) = pack('S n a4 x8', $AF_INET, $smtp_server_PORT, $server_address);

	local($protocol) = (getprotobyname('tcp'))[2];

	if (!socket(SMTP, $AF_INET, $SOCK_STREAM, $protocol)) {
	  &message ("Could not make socket filehandle ($!).");
	}

	bind(SMTP, $local_socket_address);

	if (!(connect(SMTP, $server_socket_address))) {
	  &message ("Could not connect to server ($!).");
	}

	local($old_selected) = select(SMTP); 
	$| = 1; 
	select($old_selected);

	select(undef, undef, undef, .75);
	sysread(SMTP, $_, 1024);

	print SMTP "HELO $form{smtp}$CRLF";
	sysread(SMTP, $_, 1024);
	while (/(^|(\r?\n))[^0-9]*((\d\d\d).*)$/g) { $status = $4; $message = $3}
	if ($status != 250) {&message ($message);}

	print SMTP "MAIL FROM:<$from>$CRLF";
	sysread(SMTP, $_, 1024);
	if (!/[^0-9]*250/) {&message ($_);}

	print SMTP "RCPT TO:<$to>$CRLF";
	sysread(SMTP, $_, 1024);
	/[^0-9]*(\d\d\d)/;
	if ($1 ne '250') {
		&message ("Invalid email address [$to] ($_).");
	}

	print SMTP "DATA$CRLF";
	sysread(SMTP, $_, 1024);
	if (!/[^0-9]*354/) {&message ($_);}
	print SMTP "To: $to$CRLF";
	print SMTP "From: <$from>$CRLF";
	print SMTP "Subject: $subject$CRLF$CRLF";
	$body =~ s/\r//g;
	$body =~ s/\n/$CRLF/g;
	print SMTP $body;
	print SMTP "$CRLF.$CRLF";
	sysread(SMTP, $_, 1024);
	if (!/[^0-9]*250/) {&message ($_);}
}

if ($form{type} eq "SENDMAIL") {
   open (MAIL, "|$form{sendmail} -t") or &message("Send Failed");
	print MAIL "From: $from\n";
	print MAIL "To: $to\n";
	print MAIL "Subject: $subject\n\n";
	print MAIL "$body\n";
	close (MAIL);
	return(0);
}

}
# end send_mail
###############################################################################
