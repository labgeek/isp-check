sub hourly_stat_html{

($curr_month, $totaldownmin, @temparray) = @_;		# pass in temparray and total dowm minutes

my (@hours, @hourly_stats);

print "current month = $curr_month\n" if $conf{'debug'}; #debugging statment

for($i = 0; $i<24; $i++){
	$hours[$i] = sprintf("%2d:00 - %2d:59", $i, $i);
}

foreach( @temparray){
	++$freq[$_];
}
        
open HOURLY, ">$OUTPUT/hourly.html" or die "can't open for writing: $!\n";
print HOURLY << "EOHTML";

<p>The table below shows the number of minutes down by hour in the month of $curr_month. The logfile has been reset as of March 18th.</p>
<table border="1" cellpadding="2" cellspacing="1" align=" ">
        <tr bgcolor="black">
                <td colspan=6><center><font face="arial,helvetica" size="4"
 color="white">Hourly Breakdown of Downtime Minutes</font></center></td>
 </tr>
        <tr bgcolor="brown">
                <td><center><font face="arial,helvetica" size="2" color="white">Hour</font></center></td>
                <td><center><font face="arial,helvetica" size="2" color="white">Minutes Down</font></center></td>
		 <td><font face="arial,helvetica" size="2" color="white">Downtime per hour / total downtime ($totaldownmin)</font></td>
        </tr>
EOHTML

for($i = 0; $i < 24; $i++){	
	if($freq[$i] < 1){
			$freq[$i] = 0;
	}
if($totaldownmin == 0){
$hourly_percent = "0.0%";
}
else{
$hourly_percent = ($freq[$i] / $totaldownmin)*100;
$hourly_percent = sprintf("%.2f%", $hourly_percent);
}


	print HOURLY << "EOHTML";

        <tr bgcolor="silver" align="right">
                <td><font face="$CELL_FONT" color="$CELL_FG">$hours[$i]&nbsp;</font></td>
                <td><font face="$CELL_FONT" color="$CELL_FG"><center>$freq[$i]&nbsp;</center></font></td>
		<td><font face="$CELL_FONT" color="$CELL_FG"><center>$hourly_percent&nbsp;</center></font></td>

        </tr>
EOHTML
}				#end of for loop

print HOURLY << "EOHTML";
        <tr bgcolor="silver" align="right">
                <td><font face="$CELL_FONT" color="$CELL_FG"><b>Total</b>&nbsp;</font></td>
                <td><font face="$CELL_FONT" color="$CELL_FG">$combined_time&nbsp;</font></td>
		 <td><font face="$CELL_FONT" color="$CELL_FG"><center>100.00%&nbsp;</center></font></td>

        </tr>
EOHTML



} # hourly_stat_html
1;
