#! /usr/bin/perl -w
use strict;
use warnings;

########################################################################################
# isp-report.pl v1.0 jd@labgeek.net 08/06/2003 
#---------------------------------------------------------------------------------------
#
# What this script does?
#       1. Reads the logfile created by gatemon.pl
#	2. Does various calculation like percentage, frequency of downtime
#	3. publishes to static web page (configurable)
#
# Updated:  12-20-05
# rewrite and packaged
#
#######################################################################################

use Time::HiRes qw(gettimeofday);
use Date::Calc qw(Day_of_Week Week_Number Day_of_Week_to_Text);
use Net::Ping;
use File::DosGlob 'glob';


# MAKE CONFIGURATION CHANGES HERE - All of these vars should be modified to meet the configuration of your system
# SRC_DIR and OUTPUT are global vars and travel throughout the other functions
#============================================================

$SRC_DIR="/opt/www/htdocs/PING";                    	# location of where you will put the source code perl scripts
$OUTPUT="/opt/www/htdocs/PING/output";              	# location of the .html files (where the html files will be viewed from)
my $mainlog = "$OUTPUT/mainlog.txt";                            # location and name of file that will be logged to by isp-check.pl
my $servername = "puffy.labgeek.net";                         # name of server (ie. webserver)

#=============================================================

# don't make changes below here

require "$SRC_DIR/generate_index_html.pl";			# generates the index.html file
require "$SRC_DIR/create_html.pl";				# create / initializes the html files
require "$SRC_DIR/generate_nav_html.pl";			# generates the navigation frame
require "$SRC_DIR/isp_uptime_summary.pl";			# creates the summary.html file which contains the downtime for the current month
require	"$SRC_DIR/daily_stat_html.pl";				# gets the daily statistics
require "$SRC_DIR/hourly_stat_html.pl";				# gets the hourly statistics based on a 24 hour day (1 hour ranges)
require "$SRC_DIR/archive.pl";					# creates year stats by each month for the current year


#              CONFIGURATION VARS
#-------------------------------------------------------------------------------------------------------------------------
my $start = gettimeofday;
my $day;
my $summary;
my $log_date;
my $processing_time;
my @dailystats;
my @downmin;
my $totaldownmin;

my $monthhours;
my %conf;
my $totalminperday = 60*24;

my ($sec,$min,$hour,$mday,$month,$year,$wday,$ydat,$isdst) = localtime(time);
$current_day = $wday;

$mod_month = $month+1;

%months = (
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December');

%days_in_month = (
         1 => '31',
        2 => '29',
        3 => '31',
        4 => '30',
        5 => '31',
        6 => '30',
        7 => '31',
        8 => '31',
        9 => '30',
        10 => '31',
        11 => '30',
        12 => '31');

my $CURRENT_MONTH_DAYS = $days_in_month{$mod_month};
my $CURRENT_MONTH = $months{$mod_month};
$permissions = "0755";
#----------------------------------------------------------------------------------------------------------------------------------


#first things first, make sure the directory for output exists - if it doesn't we will create one for you with 0755 permissions

if ( -d $OUTPUT ){
        print "$OUTPUT exists\n";
	
}
else{
        mkdir $dir, $permissions;
}


create_html();
generate_index_html($OUTPUT);
generate_nav_html($OUTPUT);
clean_dir();

$run_time = sprintf("%02d:%02d:%02d", $hour, $min, $sec);
my ($DAY, $MONTH, $YEAR) = (localtime)[3,4,5];
$MONTH = $MONTH+1;
$YEAR = $YEAR+1900;
my $title = "ISP Downtime Summary Information";

if(($MONTH < 10) and ($DAY < 10)){
	$log_date = "0$MONTH-0$DAY-$YEAR";
}
else{
	$log_date = "$MONTH-$DAY-$YEAR";
}


# initialize array
for($day = 1; $day <= $CURRENT_MONTH_DAYS; $day++){
        $downmin[$day] = 0;
}

# this piece does all the parsing for us

open LOGFILE, "< $mainlog";
$k=1;
my $reads = 0;
my $down = 0;

while (<LOGFILE>) {
   my @splitline = split(' ',$_);
   if ($splitline[0] == "0") {
      		$down++;
      		@downmin[@splitline[1]]++; 				# Increment count for this date.
      		@tempdown = split(/:/,$splitline[2]);	
      		open(WRITE_DOWN, ">>$OUTPUT/$splitline[1].txt");	# gives you the ability to link and see when the downtimes were
      		print (WRITE_DOWN "$_");
      		close WRITE_DOWN;

		if(( $tempdown[0] >= 0) && ($tempdown[0] <=24 )){
			$hour = $tempdown[0];
        		push(@temparray, $hour);
		}
   }
   $reads++;					# counts total number of entries processed
} # Parsing file
close LOGFILE;



for ($day = 1; $day <= $CURRENT_MONTH_DAYS; $day++){
		$totaldownmin += $downmin[$day];
		$totaldownpercent = ($downmin[$day] / $reads)*100;
		$totaldownpercent = sprintf("%.2f%", $totaldownpercent);
		push (@percent_array, $totaldownpercent);

}

$tdown = $totaldownmin;

#measure time it took to run perl script
my $end = gettimeofday;
my $finaltime = $end-$start;
$finaltime = sprintf("%.4f seconds", $finaltime);

$to_sec = $totaldownmin * 60;
$to_days = int($to_sec/(24*60*60));
$to_hours = (($to_sec/(60*60))%24);
$to_mins = (($to_sec/60)%60);

$combined_time = "$to_days day(s),$to_hours hr(s),$to_mins min(s)";
hourly_stat_html($CURRENT_MONTH, $totaldownmin, @temparray);
isp_uptime_summary($title, $log_date, $servername, $finaltime, $reads, $run_time, $totaldownmin);
daily_stat_html($CURRENT_MONTH, $CURRENT_MONTH_DAYS, @downmin, $totaldownmin, @percent_array);
archive(%months);
#------------------------------------------------------------------------------------------------

sub clean_dir{
for($i = 1; $i<32; $i++){
$file = "$OUTPUT/$i.txt";
        if ( -e $file ){
                unlink $file;
        }
        else{
                next;
        }
}

}       # end of subroutine





# Rotate from month to month - test function, not working right now (not being used)


#sub rotate{
#my ($current_day, $current_month, $hour, %mos) = @_;
#my $OUTPUT="/usr/local/apache/htdocs/PING/archive";
my $mainlog = "/usr/local/apache/htdocs/PING/output/mainlog.txt";
my $total_mos = 12;
print "Current day = $DAY\n";
$current_month = $month+1;
print "Current month = $current_month\n";
print "hour = $hour\n";
print "min = $min\n";
#my $month = $current_month;
#$next_month = $current_month+1;
#print "next month = $next_month\n";


# should only go off on 1st of every new month

if(($current_day = 2) && ($hour=18) && ($min < 16)){

#	if ( -e $mainlog ){
		#rename ( 'mainlog.txt', $mos{$current_month} ) or die ("Error renaming : $!" )
#	}
	print "This worked\n";

}


#open MONTHFILE, ">$OUTPUT/$mos{$current_month}";
#print MONTHFILE "$totaldownmin\n";
#close MONTHFILE;



#}		# end of rotate function
