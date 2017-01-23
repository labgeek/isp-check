sub generate_index_html{
($output) = @_;

# open uptime.html file for writing
open INDEX, ">$output/uptime.html" or die "can't open  uptime.html for writing: $!\n";
print INDEX << "EOHTML";

<html>
<head>
        <title>GATEHOUSE NETWORKS DOWNTIME LOG</title>
</head>

<frameset cols="200,*">
        <frame src="nav.html" noresize>
        <frame src="summary.html" name="main">
</frameset>
</html>
EOHTML
}
1;
