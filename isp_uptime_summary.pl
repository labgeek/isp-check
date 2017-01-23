sub isp_uptime_summary{

($title, $log_date, $servername, $processing_time, $reads, $run_time, $downtime) = @_;
my $summary = "$OUTPUT/summary.html";


open OUT, ">$summary" or die "can't open \$summary for writing: $!\n";
print OUT << "EOHTML";
<html>
<head>
<title>$title</title>
<body>

<table border="1" cellpadding="2" cellspacing="1" align=" ">
        <tr bgcolor="black">
                <td colspan=2><font face="arial,helvetica" size="2" color="white"><center>
 UPTIME LOG</center></font></td>
        </tr>
        <tr bgcolor="silver">
                <td><font face="arial,helvetica" color="black">Log Date (time of last run)</font></td>
                <td><font face="arial,helvetica" color="black">$log_date [$run_time]</font></td>
        </tr>
        <tr bgcolor="silver">
                <td><font face="arial,helvetica" color="black">Server Name</font></td>
                <td><font face="arial,helvetica" color="black">$servername</font></td>
        </tr>
        <tr bgcolor="silver">
                <td><font face="arial,helvetica" color="black">Entries Processed</font></td>
                <td><font face="arial,helvetica" color="black">$reads</font></td>
        </tr>

        <tr bgcolor="silver">
                <td><font face="arial,helvetica" color="black">Log Processing Time</font></td>
                <td><font face="arial,helvetica" color="black">$processing_time</font></td>
    	</tr>
	 <tr bgcolor="silver">
                <td><font face="arial,helvetica" color="black">Total Downtime</font></td>
                <td><font face="arial,helvetica" color="black">$downtime minute(s)</font></td>
        </tr>


</table>
</body>
<br>
<br>
</html>
EOHTML


}
1;
