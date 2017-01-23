sub daily_stat_html {

#declaration of vars
#-------------------------	
my ($sec,$min,$hour,$mday,$month,$year,$wday,$ydat,$isdst) = localtime(time);
my $i;
($CURRENT_MONTH, $CURRENT_MONTH_DAYS, @downmin, $totaldownmin, $percent_array, $out_put) = @_; #pass in data
my $summary = "$OUTPUT/summary.html";
#----------------------------

$year  = $year+1900;
$month = $month+1;

# open summary.html file for appending

open OUT, ">>$summary" or die "can't open \$summary for appending: $!\n";
print OUT << "EOHTML";
<p> The table below breaks down the amount of downtime I have had in the month of $CURRENT_MONTH.  The logfile (mainlog.txt) has been reset as of March 18th, 2005.  </p>
<br>
<table border="1" cellpadding="2" cellspacing="1" align=" ">
        <tr bgcolor="black">
                <td colspan=6><center><font face="arial,helvetica" size="4" color="white">Daily Breakdown [Near Real-time]</font></center></td>
        </tr>
        <tr bgcolor="brown">
                <td><center><font face="arial,helvetica" size="2" color="white">Day of Month/Weekday</font></center></td>
                <td><center><font face="arial,helvetica" size="2" color="white">Minutes Down</font></center></td>
		<td><center><font face="arial,helvetica" size="2" color="white">Percentage of Total Downtime</font></center></td>

        </tr>
EOHTML

for($i = 1; $i <= $CURRENT_MONTH_DAYS; $i++){
$day = $i;
$wday = Day_of_Week($year, $month, $day);
#print "$month/$day/$year was a ", Day_of_Week_to_Text($wday), "\n";
$weekday = Day_of_Week_to_Text($wday);


print OUT << "EOHTML";
<tr bgcolor = "silver" align=" ">
                <td><font face="arial,helvetica" color="black">$months{$mod_month}-$i [$weekday]&nbsp</font></td>
		<td><font face="arial,helvetica" color="black"><a href="$i.txt">$downmin[$i]</a></font></td>
		<td><font face="arial,helvetica" color="black">$percent_array[$i-1]</font></td>
        </tr>

EOHTML
}			#end of for

print OUT <<"EOHTML";
<tr bgcolor = "silver" align=" ">
                <td><font face="arial,helvetica" color="black"><b>TOTAL(running)</b>&nbsp</font></td>
                <td><font face="arial,helvetica" color="black">$combined_time&nbsp</font></td>
        </tr>
EOHTML


} # hourly_stat_html
1;
