#! /usr/bin/perl -w

use Getopt::Std;    # Use the Getopt::Long package
use Net::Ping;      # use the Net::Ping package
use strict;
use warnings;

#######################################################################################
# isp-check.pl v1.1 jd@labgeek.net 08/06/2003
#--------------------------------------------------------------------------------------
#
#   What this script does?
# 	1. Test the connectivity between your host and and upstream router of choice
# 	2. Count number of minutes you were down in a per day
# 	3. Checks if your connectivity is UP or DOWN
#	4. Converts number of minutes to "days, hours, and minutes" for that month
#	5. Counts the number of minutes per 24 hour period (0-24)
#	6. Publishes results to static web page that can be created via a crontab file
#	7. Logs downtime to file (configurable)
#
# Todo
#	1.  Clean up code
#
#
# HISTORY:
#	v0.1a - 08-06-2003:  This is the initial release and needs plenty of work!  Basically, I put this together in a night but will keep playing with it as long as #       I have some time....
#
#	v0.2a - 08-26-2003:  Added link to daily minutes breakdown which takes you to another file listing when the connectivity dropped.  Also added function to conve#       rt overall minutes down to days, hours, minutes, and seconds down
#
#	v0.3 - 04-28-04:  modularized each of the function into separate perl files
#
#   v1.0 - 05-26-04 - Added graph functionality/archive data
#
#   v1.1 - 12-20-05 - rewrite and package
######################################################################################

# configuration variables
my %options     = ();
my $index       = 1;
my $packet_wait = 2;
my $numPackets  = 10;
my $threshold   = 3;
my $up          = 0;
my $version     = "1.1";

getopts( 'hdo:r:', \%options );

#'h' - help flag
#'r' - Select which router you want to ping
#'o' - Output filename
#'d' - Directory location

my $router    = $options{r} || "66.92.162.1";
my $mainlog   = $options{o} || "mainlog.txt";
my $outputdir = $options{d} || "output";
mkdir $outputdir unless -d $outputdir;
my $location = "$outputdir/$mainlog";

print STDERR "\nISP-Check - Version $version\n";
print STDERR "Author:  JD Durick <jd\@labgeek.net>\n\n";

# Uses the Net::Ping package from CPAN.org to send 10 icmp packets to router of choice
# $packet_wait is interval between packets sent

my $pinger = Net::Ping->new("icmp");
for ( $index .. $numPackets ) {
	if ( $pinger->ping( $router, $packet_wait ) ) {
		$up++;
	}
}
$pinger->close;

&logger($location);

#--------------------------------------------------------
# Function name:  logger()
# Description: logs up or down values in file
# INPUT:  File location ($location) passed from main
# OUTPUT: print to file then exits out
#--------------------------------------------------------

sub logger {
	my $mlog = $_[0];
	open LOGFILE, ">>$mlog";

# if $up value is >= $threshold value, print 1 in log file, else print 0 (considered down)

	print LOGFILE ( ( $up >= $threshold ) ? '1' : '0' ) . " ";
	my ( $sec, $min, $hour, $mday, $month, $year, $wday, $ydat, $isdst ) =
	  localtime(time);
	$min = sprintf( "%0.2d", $min );    # make 0 into 00
	print LOGFILE $mday, " ", $hour, ":", $min, " - ", $numPackets - $up,
	  " lost\n";
	close LOGFILE;
	exit 1;
}

