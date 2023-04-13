#!/usr/bin/perl
print "make sure your input file is sorted by scaffoldname! sort -k 10";
my $input = $ARGV[0];

open (INPUT, "$input"); 
open (RESULTS, ">$input.besthit");

print RESULTS "match\tmismatch\trep\tNs\tQgapcount\tQgapbases\tTgapcount\tTgapbases\tstrand\tQname\tQsize\tQstart\tQend\tTname\tTsize\tTstart\tTend\tblockcount\tblockSizes\tqStarts\ttStarts\n";

$name0="";
$score0=0;
$line0="";

while ($line = <INPUT>) {
($match, $mismatch, $rep, $Ns, $Qgapcount, $Qgapbases, $Tgapcount, $Tgapbases, $strand, $Qname, $Qsize, $Qstart, $Qend, $Tname, $Tsize, $Tstart, $Tend, $blockcount, $blockSizes, $qStarts, $tStarts)=split(/\t/, $line);
	
	if ($Qname eq $name0)
		{
		if ($match > $score0)
			{
			$name0=$Qname;
			$score0=$match;
			$line0=$line;
			}
		else
			{
			}

		}
	else
		{
		print RESULTS $line0;
		$name0=$Qname;
                $score0=$match;
                $line0=$line;

		}
		
	
	}

print RESULTS $line0;

system "perl -pi -e 's/^[^0-9].*//gi' $input.besthit";
system "perl -pi -e 's/^\n//gi' $input.besthit";
