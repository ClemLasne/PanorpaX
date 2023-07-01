#!/usr/local/bin/perl

#this script goes through a multi-fasta file and for each gene picks the largest sequence
#it assumes that CDSs are ordered by gene
#and that the first element in the fasta definition is the gene name
#

$/ = ">";


my $input = $ARGV[0];
open (INPUT, "$input") or die "can't find $input";
open (RESULTS, ">>$input.longestCDS");

print RESULTS ">";

$name0="";
$length0=0;
$fasta0="";

while ($line=<INPUT>)
	{
	#get sequence length
	(@dnas)=split ("\n", $line);
	$definition=$dnas[0];
	shift @dnas;
	$sequence=join ("", @dnas);
	$cdslength=length($sequence);
	
	#get gene name
	(@defs)=split (" ", $definition);
	$genename=$defs[0];
	chomp $genename;
	print "$genename $cdslength $length0\n";

	if ($genename eq $name0)
		{
		if ($cdslength > $length0)
			{
			$name0=$genename;
			$length0=$cdslength;
			$fasta0=$line;
			}
		else
			{
			}
		}
	else 
		{
		print RESULTS $fasta0;
		$name0=$genename;
		$length0=$cdslength;
		$fasta0=$line;
		}

	}

print RESULTS $fasta0;


