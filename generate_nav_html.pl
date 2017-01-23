sub generate_nav_html{
($output) = @_;

open NAV, ">$output/nav.html" or die "can't open nav.html for writing: $!\n";
print NAV << "EOHTML";


<html>
<P>CHOOSE FROM BELOW:</P>
<body bgcolor="gray" alink=blue hlink=blue vlink=blue>
<table align=center cellpadding=2 cellspacing=0 border=1 bgcolor=white width=180>
        <tr>
                <td bgcolor="black">
                <a href="summary.html" target="main">
                <font color=white size=2><b>
                SUMMARY
                </b></font>
                </a>
                </td>
        </tr>
        <tr>
                <td bgcolor="black">
                <a href="hourly.html" target="main">
                <font color=white size=2><b>
                HOURLY STATS
                </b></font>
                </a>
                </td>
        </tr>
 <tr>
                <td bgcolor="black">
                <a href="archive.html" target="main">
                <font color=white size=2><b>
                ARCHIVE
                </b></font>
                </a>
                </td>
        </tr>


</table>
</body>
</html>
EOHTML
        }
1;
