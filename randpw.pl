#!/usr/bin/perl

@chars = (  "a" .. "z", "A" .. "Z", "0" .. "9", "?","@","\$","!"); #<-- Which charaters to use
$password = join("", @chars[ map { rand @chars } ( 1 .. 8 ) ]);#<-- Making the password from the random characters
print "Password: $password\n";#<-- Displaying the password on the screen

#This section is for creating the encrypted passwords. If interested in this, uncomment the next 5 lines
#@schars = ("a" .. "z", "A" .. "Z", "0" .. "9");
#$salt = join("", @schars[ map { rand @schars } ( 1 .. 2 ) ]);
#$password = $word;
#$cpwd = crypt($word, $salt);
#print "Enrypted: $cpwd\n";


