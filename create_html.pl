sub create_html{
my @output_files;
my $dir = "/opt/www/htdocs/PING/output";
my $i;
@output_files = ("uptime.html", "summary.html", "nav.html", "hourly.html", "archive.html");

for($i = 0; $i <=$#output_files; $i++){
        open(FILE, ">$dir/$output_files[$i]");
        close FILE;

}                               # end of for loop


}
1;
