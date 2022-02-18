#!/usr/bin/perl
#Grant Della Vecchia

#variables
$dir = $ARGV[0];
$tmpf = "$dir/.tt.grant";
#end

while (<$dir/*>) {
	system ("grep -v NameVirtualHost $_ > $tmpf ; mv $tmpf $_");
}
unlink $tmpf
