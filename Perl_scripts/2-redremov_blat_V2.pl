#!/usr/bin/perl

#this program is meant to remove overlapping contigs from blat results
#by reciprocal best blatx hit
#when contigs overlap on target, the one with the highest score is kept (unless the overlap <20bps)

#the input file should be a best hit blat file:
#match	mismatch	rep	Ns	Qgapcount	Qgapbases	Tgapcount	Tgapbases	strand	Qname	Qsize	Qstart	Qend	Tname	Tsize	Tstart	Tend	blockcount	blockSizes	qStarts	tStarts
#and sorted by Tname!!! sort -k 14!!!

#BUG fixed in V2: before it was not printing the last scaffold

#usage: perl 1-removeredundancy.pl inputfile

print "make sure your input file is sorted by Tname -k 14!";
my $input = $ARGV[0];

open (INPUT, "$input"); 
open (RESULTS, ">>$input.nonredundant");

$name0="lalala";
system "echo 'lalala' >> lalala.temp";

while ($line = <INPUT>) 
	{
	($blatscore, $mismatch, $rep, $Ns, $Qgapcount, $Qgapbases, $Tgapcount, $Tgapbases, $strand, $Qname, $Qsize, $Qstart, $Qend, $Tname, $Tsize, $Tstart, $Tend, $blockcount, $blockSizes, $qStarts, $tStarts)=split(/\t/, $line);

	if ($Tname eq $name0)
		{
		open (TEMP, ">>$Tname.temp");
		print TEMP $line;	
		close(TEMP);	
		}
	else
		{
		
		#first let's deal with gene name0

		#let's find non-overlapping contigs for genes name0
		$sortname="\Q$name0\E";
		system "sort -nr -k 1 $sortname.temp >> $sortname.temp.sorted";
		open(TEMPREAD, "$name0.temp.sorted") or die "could not open tempread";
		print "just opened $name0.temp.sorted\n";
		@start="";
		@end="";
		@counts="";
		$counter=0;
		

		while ($tempread = <TEMPREAD>)
			{
			print "counter $counter\n";
			$verifier=0;
			($blatscoret, $mismatcht, $rept, $Nst, $Qgapcountt, $Qgapbasest, $Tgapcountt, $Tgapbasest, $strandt, $Qnamet, $Qsizet, $Qstartt, $Qendt, $Tnamet, $Tsizet, $Tstartt, $Tendt, $blockcountt, $blockSizest, $qStartst, $tStartst)=split(/\t/, $tempread);
		
			if ($counter==0)
				{
				print RESULTS $tempread;
				push (@start, $Tstartt);
				push (@end, $Tendt);
				$counter=$counter+1;
				push(@counts, $counter);
				}
			elsif ($counter>0)
				{
				print "starts: @start\n";
				print "counts: @counts\n";
				
				#let's test if the contig overlaps contigs with higher scores
				foreach $count(@counts)
					
					{
					$Ne_start="";
					$Ne_end="";

					#allow for 20bp overlap
					#But first make sure there is something in $count, it seems to run the cycle on empty count first
					if ($count ne "")
						 {
						$Ne_start=$start[$count]+20;
						$Ne_end=$end[$count]-20;
						}
					else
						{
					 	$verifier=0;

						}

					
					print "count $count start $Tstartt end $Tendt teststart $Ne_start testend $Ne_end verifier $verifier\n";
					if ($Tstartt >= $Ne_start && $Tstartt <= $Ne_end)
						{
						$verifier=$verifier+1;
						}
					elsif ($Tendt >= $Ne_start && $Tendt <= $Ne_end)
						{
						$verifier=$verifier+1;
						}
					elsif ($Tstartt <= $Ne_start && $Tendt >= $Ne_end)
						{
						$verifier=$verifier+1;
						}
					else
						{
						$verifier=$verifier+0;
						}
					}
				
				
				if ($verifier==0)
					{
					print RESULTS $tempread;
					push (@start, $Tstartt);
					push (@end, $Tendt);
										
					$counter=$counter+1;
					push(@counts, $counter);
					}
				else
					{
					#push (@start, $Tstartt);
					#push (@end, $Tendt);
					#$counter=$counter+1;
					#push(@counts, $counter);
					}
				}
			

		
			
			}
			
		

		close(TEMPREAD);
		system "rm \Q$name0\E.temp";
		system "rm \Q$name0\E.temp.sorted";

		$name0=$Tname;

		#finally let's start filling the new file
		open (TEMP, ">>$Tname.temp");
		print TEMP $line;	
		close(TEMP);	
		}
		
	
	}


#Process last scaffold!

		#first let's deal with gene name0

		#let's find non-overlapping contigs for genes name0
		$sortname="\Q$name0\E";
		system "sort -nr -k 1 $sortname.temp >> $sortname.temp.sorted";
		open(TEMPREAD, "$name0.temp.sorted") or die "could not open tempread";
		print "just opened $name0.temp.sorted\n";
		@start="";
		@end="";
		@counts="";
		$counter=0;
		

		while ($tempread = <TEMPREAD>)
			{
			print "counter $counter\n";
			$verifier=0;
			($blatscoret, $mismatcht, $rept, $Nst, $Qgapcountt, $Qgapbasest, $Tgapcountt, $Tgapbasest, $strandt, $Qnamet, $Qsizet, $Qstartt, $Qendt, $Tnamet, $Tsizet, $Tstartt, $Tendt, $blockcountt, $blockSizest, $qStartst, $tStartst)=split(/\t/, $tempread);
		
			if ($counter==0)
				{
				print RESULTS $tempread;
				push (@start, $Tstartt);
				push (@end, $Tendt);
				$counter=$counter+1;
				push(@counts, $counter);
				}
			elsif ($counter>0)
				{
				print "starts: @start\n";
				print "counts: @counts\n";
				
				#let's test if the contig overlaps contigs with higher scores
				foreach $count(@counts)
					
					{
					$Ne_start="";
					$Ne_end="";

					#allow for 20bp overlap
					#But first make sure there is something in $count, it seems to run the cycle on empty count first
					if ($count ne "")
						 {
						$Ne_start=$start[$count]+20;
						$Ne_end=$end[$count]-20;
						}
					else
						{
					 	$verifier=0;

						}

					
					print "count $count start $Tstartt end $Tendt teststart $Ne_start testend $Ne_end verifier $verifier\n";
					if ($Tstartt >= $Ne_start && $Tstartt <= $Ne_end)
						{
						$verifier=$verifier+1;
						}
					elsif ($Tendt >= $Ne_start && $Tendt <= $Ne_end)
						{
						$verifier=$verifier+1;
						}
					elsif ($Tstartt <= $Ne_start && $Tendt >= $Ne_end)
						{
						$verifier=$verifier+1;
						}
					else
						{
						$verifier=$verifier+0;
						}
					}
				
				
				if ($verifier==0)
					{
					print RESULTS $tempread;
					push (@start, $Tstartt);
					push (@end, $Tendt);
										
					$counter=$counter+1;
					push(@counts, $counter);
					}
				else
					{
					#push (@start, $Tstartt);
					#push (@end, $Tendt);
					#$counter=$counter+1;
					#push(@counts, $counter);
					}
				}
			

		
			
			}
			
		

		close(TEMPREAD);
		system "rm \Q$name0\E.temp";
		system "rm \Q$name0\E.temp.sorted";
