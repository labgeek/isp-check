sub archive{
use GD;      # for font names
use GD::Graph::bars;


#---------------------------------------------------------
my $ARCHIVE="/opt/www/htdocs/PING/archive";
my @arc_array;
my ($sec,$min,$hour,$mday,$month,$year,$wday,$ydat,$isdst) = localtime(time);
my $i, $down;
my $mos=12;
my (%months) = @_;
my $archive = "$OUTPUT/archive.html";
#----------------------------

$year  = $year+1900;
$month = $month+1;



# initialize to zero and create month files
# if file already exists, don't touch it, else create the month-file with "0" as the data

for($i = 0; $i<=11;$i++){
	if( -e "$ARCHIVE/$months{$i}"){
		next;
	}
	else{
		open(MONTH, ">$ARCHIVE/$months{$i}") or die "Unable to open $months{$i}: $!";
		print (MONTH "0\n");
		close (MONTH);

	}
}


# keeps current months totals
open MONTHFILE, ">$ARCHIVE/$months{$month}";
print MONTHFILE "$tdown\n";
close MONTHFILE;

my $filecnt = 0;

@Access = ( glob("$ARCHIVE/*") );

foreach $File (@Access)
{
	open ( LOG, $File );
	my ($arg1);
	$filecnt++;
	while(<LOG>){

                chomp;
                if (($_ =~ /\s*\#/) || ($_ eq "")){             # if # of blank space, then skip
                        next;
                }
                ($arg1) = split(/\s+/);          # split per line according to space
		$total += $arg1;
		push(@arc_array, $arg1);
		

        }                               # end of while loop
}   					# end of for loop


$to_sec = $total * 60;
$to_days = int($to_sec/(24*60*60));
$to_hours = (($to_sec/(60*60))%24);
$to_mins = (($to_sec/60)%60);

$yearly_down = "$to_days day(s),$to_hours hr(s),$to_mins min(s)";


# create the GRAPH of the data

my @data = ( [ qw(JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ) ], \@arc_array);
my $graph = new GD::Graph::bars(800,500);

$graph->set(
        title             => "ISP-CHECK Archived Data",
        x_label           => 'Months of the Year',
        y_label           => 'Minutes of Downtime',
        y_max_value       => 3500,
        y_tick_number     => 25,
        x_all_ticks       => 1, 
        y_all_ticks       => 1, 
        x_label_skip      => 1,
    );
$graph->set_legend_font(GD::gdFontTiny);
$graph->set_title_font(gdGiantFont);
                    

my $gd = $graph->plot( \@data );	# plot the data on the graph

open OUT, ">$OUTPUT/year_down.png" or die "Couldn't open for output: $!";
binmode(OUT);
print OUT $gd->png();
close OUT;

# open up archive.html and write to the html file

open ARC, ">>$archive" or die "can't open \$summary for appending: $!\n";
print ARC << "EOHTML";
<p> The table below lists total downtime for each of the months in $year.  </p>
<br>
<table border="1" cellpadding="2" cellspacing="1" align=" ">
        <tr bgcolor="black">
                <td colspan=6><center><font face="arial,helvetica" size="4" color="white">Yearly ($year) Breakdown</font></center></td>

        </tr>
        <tr bgcolor="brown">
                <td><center><font face="arial,helvetica" size="2" color="white">Month</font></center></td>
                <td><center><font face="arial,helvetica" size="2" color="white">Total Minutes Down</font></center></td>

        </tr>
EOHTML

for($i = 1; $i <= 12; $i++){		# off by one error, needs to be fixed later
$getsec = $arc_array[$i] * 60;
$getdays = int($getsec/(24*60*60));
$gethours = (($getsec/(60*60))%24);
$convert_to_mins = (($getsec/60)%60);
$final_time = "$getdays day(s),$gethours hr(s),$convert_to_mins min(s)";

$totalmin += $arc_array[$i];
$avgdown = $totalmin / ($i+1);
$avgdown = sprintf("%.2f", $avgdown);
print "[$i]\n";
print ARC << "EOHTML";
<tr bgcolor = "silver" align=" ">
                <td><font face="arial,helvetica" color="black">$months{$i}</font></td>
		<td><font face="arial,helvetica" color="black">$arc_array[$i-2]</font></td>
        </tr>

EOHTML
}			#end of for

print ARC <<"EOHTML";
<tr bgcolor = "silver" align=" ">
                <td><font face="arial,helvetica" color="black">Total Down</font></td>
		<td><font face="arial,helvetica" color="black">$totalmin</font></td>
        </tr>
EOHTML

print ARC <<"EOHTML";
<a href="year_down.png">Click here</a> for a full graph of your archived data.
<br>
<br>
EOHTML

} 




1;
