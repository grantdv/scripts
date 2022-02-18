#!/usr/bin/perl

$time = "6655";

$days = $time / 86400;
$hours = ($time / 3600) - ($days * 24);
$minutes = ($time / 60) - ($days * 1440) - ($hours * 60);
#$seconds = $time mod 60;
print "Days: $days\nHours: $hours\nMinutes: $minutes\n";
