#!/usr/bin/perl

#this program takes as input
#a fasta file of transcripts
#for each transcript it will output the longest AA that can be produced from it
print "usage: perl GetLongestAA_vX.pl fastafile\n";

my $fasta = $ARGV[0];
open (FASTAFILE, "$fasta") or die "could not find fasta";
open (RESULTS, ">$fasta.aa");

$/ = ">";
        while ($seqs=<FASTAFILE>) 
	{
	#skip first (empty) line
	next if $. < 2; # Skip first line

	#separate name and sequence
	@stuff=split("\n", $seqs);
	$nameofsequence=$stuff[0];	
	$nameofsequence =~ s/ .*//;
	shift @stuff;
        $fullsequence=join("", @stuff);
	#clean sequence of spaces and newlines
	$fullsequence =~ s/\n//g;
	$fullsequence =~ s/ //g;

	#get reverse complement already
	$rcsequence=&reversecomplement($fullsequence);

	#start with frame 1
	$longestframe1=&longestaa($fullsequence);

	#frame 2
	my @foo = split (//, $fullsequence);
   	shift @foo;
    	$frame2 = join '', @foo;
	$longestframe2=&longestaa($frame2);

	#frame 3
	my @foo = split (//, $frame2);
   	shift @foo;
    	$frame3 = join '', @foo;
	$longestframe3=&longestaa($frame3);

	#frame 4
	$longestframe4=&longestaa($rcsequence);

	#frame 5
	my @foo = split (//, $rcsequence);
   	shift @foo;
    	$frame5 = join '', @foo;
	$longestframe5=&longestaa($frame5);

	#frame 6
	my @foo = split (//, $frame5);
   	shift @foo;
    	$frame6 = join '', @foo;
	$longestframe6=&longestaa($frame6);


#Let's keep the longest of the 6 frames
$finalseq = $longestframe1;
$finalframe = "frame1";

if(length $longestframe2 > length $finalseq) 
	{
        $finalseq = $longestframe2;
   	 }
if (length $longestframe3 > length $finalseq)
	{
	$finalseq = $longestframe3;
	}
if (length $longestframe4 > length $finalseq)
	{
	$finalseq = $longestframe4;
	}
if (length $longestframe5 > length $finalseq)
	{
	$finalseq = $longestframe5;
	}
if (length $longestframe6 > length $finalseq)
	{
	$finalseq = $longestframe6;
	}

print RESULTS ">$nameofsequence\n$finalseq\n";




#this returns the reverse complement of a fasta sequence
sub reversecomplement
{

	my ($dna, @sites, @rev_sites, $rcfasta);
	$dna=$_[0];
	$dna =~ s/>//g;
	@sites=split ("", $dna);
	@rev_sites=reverse(@sites);
	foreach $rev_site (@rev_sites)
		{
		if ($rev_site =~ m/A/)
			{
			$rev_site =~ s/A/T/g;
			}
		elsif ($rev_site =~ m/a/)
			{
			$rev_site =~ s/a/T/g;
			}
		elsif ($rev_site =~ m/T/)
			{
			$rev_site =~ s/T/A/g;
			}
		elsif ($rev_site =~ m/t/)
			{
			$rev_site =~ s/t/A/g;
			}
		elsif ($rev_site =~ m/G/)
			{
			$rev_site =~ s/G/C/g;
			}
		elsif ($rev_site =~ m/g/)
			{
			$rev_site =~ s/g/C/g;
			}
		elsif ($rev_site =~ m/C/)
			{
			$rev_site =~ s/C/G/g;
			}
		elsif ($rev_site =~ m/c/)
			{
			$rev_site =~ s/c/G/g;
			}
		else
			{$rev_site = $rev_site;}
		}
	$rev_sites_joined=join ("", @rev_sites);
	$rcfasta= join ("\n", $definition, $rev_sites_joined);
	$rcfasta =~ s/\n//g;

	return "$rcfasta";
	 $/ = "\n";
}


#this returns the longest AA for a sequence/frame
sub longestaa
{

	my ($dna, @nums, @codons, @peptides, $longestaa);
	$dna=$_[0];
	$dna =~ s/>//g;

	#get codons
	my @nums = ($dna =~ m/.../g);
	foreach (@nums)
		{
		$codon="";

		if ($_ =~ m/TCA/ || $_ =~ m/TCC/ || $_ =~ m/TCG/ || $_ =~ m/TCT/  )
			{
			$codon = "S";
			}
		elsif ($_ =~ m/TTC/ || $_ =~ m/TTT/)
			{
			$codon = "F";
			}
		elsif ($_ =~ m/TTA/ || $_ =~ m/TTG/ )
			{
			$codon = "L";
			}
		elsif ($_ =~ m/TAC/ || $_ =~ m/TAT/ )
			{
			$codon = "Y";
			}
		elsif ($_ =~ m/TAA/ || $_ =~ m/TAG/ || $_ =~ m/TGA/ )
			{
			$codon = "_";
			}
		elsif ($_ =~ m/TGC/ || $_ =~ m/TGT/ )
			{
			$codon = "C";
			}
		elsif ($_ =~ m/TGG/)
			{
			$codon = "W";
			}
		elsif ($_ =~ m/CTA/ || $_ =~ m/CTC/ || $_ =~ m/CTG/ || $_ =~ m/CTT/ )
			{
			$codon = "L";
			}
		elsif ($_ =~ m/CCA/ || $_ =~ m/CCC/ || $_ =~ m/CCG/ || $_ =~ m/CCT/ )
			{
			$codon = "P";
			}
		elsif ($_ =~ m/CAC/ || $_ =~ m/CAT/ )
			{
			$codon = "H";
			}
		elsif ($_ =~ m/CAA/ || $_ =~ m/CAG/ )
			{
			$codon = "Q";
			}
		elsif ($_ =~ m/CGA/ || $_ =~ m/CGC/ || $_ =~ m/CGG/ || $_ =~ m/CGT/ )
			{
			$codon = "R";
			}
		elsif ($_ =~ m/ATA/ || $_ =~ m/ATC/ || $_ =~ m/ATT/ )
			{
			$codon = "I";
			}
		elsif ($_ =~ m/ATG/)
			{
			$codon = "M";
			}
		elsif ($_ =~ m/ACA/ || $_ =~ m/ACC/ || $_ =~ m/ACG/ || $_ =~ m/ACT/ )
			{
			$codon = "T";
			}
		elsif ($_ =~ m/AAC/ || $_ =~ m/AAT/ )
			{
			$codon = "N";
			}
		elsif ($_ =~ m/AAA/ || $_ =~ m/AAG/ )
			{
			$codon = "K";
			}
		elsif ($_ =~ m/AGC/ || $_ =~ m/AGT/ )
			{
			$codon = "S";
			}
		elsif ($_ =~ m/AGA/ || $_ =~ m/AGG/ )
			{
			$codon = "R";
			}
		elsif ($_ =~ m/GTA/ || $_ =~ m/GTC/ || $_ =~ m/GTG/ || $_ =~ m/GTT/ )
			{
			$codon = "V";
			}
		elsif ($_ =~ m/GCA/ || $_ =~ m/GCC/ || $_ =~ m/GCG/ || $_ =~ m/GCT/ )
			{
			$codon = "A";
			}
		elsif ($_ =~ m/GAC/ || $_ =~ m/GAT/ )
			{
			$codon = "D";
			}
		elsif ($_ =~ m/GAA/ || $_ =~ m/GAG/ )
			{
			$codon = "E";
			}
		elsif ($_ =~ m/GGA/ || $_ =~ m/GGC/ || $_ =~ m/GGG/ || $_ =~ m/GGT/ )
			{
			$codon = "G";
			}

		else
			{$codon = "X";}
		
		push (@codons, $codon);
		}


        $aaseq=join("", @codons);
	@peptides = split ("_", $aaseq);


my $len = length $peptides[0];
my $longest = 0;
for my $i (1 .. $#peptides) {
    my $i_len = length $peptides[$i];
    if($i_len > $len) {
        $longest = $i;
        $len = $i_len;
    }
}
	my $longestaa = $peptides[$longest];

	chomp $longestaa;

	return "$longestaa";

	$/ = "\n";


	}


}


#this just translates DNA
sub translate
{

	my ($dna, @nums, @codons, @peptides, $longestaa);
	$dna=$_[0];
	$dna =~ s/>//g;

	#get codons
	my @nums = ($dna =~ m/.../g);
	foreach (@nums)
		{
		$codon="";

		if ($_ =~ m/TCA/ || $_ =~ m/TCC/ || $_ =~ m/TCG/ || $_ =~ m/TCT/  )
			{
			$codon = "S";
			}
		elsif ($_ =~ m/TTC/ || $_ =~ m/TTT/)
			{
			$codon = "F";
			}
		elsif ($_ =~ m/TTA/ || $_ =~ m/TTG/ )
			{
			$codon = "L";
			}
		elsif ($_ =~ m/TAC/ || $_ =~ m/TAT/ )
			{
			$codon = "Y";
			}
		elsif ($_ =~ m/TAA/ || $_ =~ m/TAG/ || $_ =~ m/TGA/ )
			{
			$codon = "_";
			}
		elsif ($_ =~ m/TGC/ || $_ =~ m/TGT/ )
			{
			$codon = "C";
			}
		elsif ($_ =~ m/TGG/)
			{
			$codon = "W";
			}
		elsif ($_ =~ m/CTA/ || $_ =~ m/CTC/ || $_ =~ m/CTG/ || $_ =~ m/CTT/ )
			{
			$codon = "L";
			}
		elsif ($_ =~ m/CCA/ || $_ =~ m/CCC/ || $_ =~ m/CCG/ || $_ =~ m/CCT/ )
			{
			$codon = "P";
			}
		elsif ($_ =~ m/CAC/ || $_ =~ m/CAT/ )
			{
			$codon = "H";
			}
		elsif ($_ =~ m/CAA/ || $_ =~ m/CAG/ )
			{
			$codon = "Q";
			}
		elsif ($_ =~ m/CGA/ || $_ =~ m/CGC/ || $_ =~ m/CGG/ || $_ =~ m/CGT/ )
			{
			$codon = "R";
			}
		elsif ($_ =~ m/ATA/ || $_ =~ m/ATC/ || $_ =~ m/ATT/ )
			{
			$codon = "I";
			}
		elsif ($_ =~ m/ATG/)
			{
			$codon = "M";
			}
		elsif ($_ =~ m/ACA/ || $_ =~ m/ACC/ || $_ =~ m/ACG/ || $_ =~ m/ACT/ )
			{
			$codon = "T";
			}
		elsif ($_ =~ m/AAC/ || $_ =~ m/AAT/ )
			{
			$codon = "N";
			}
		elsif ($_ =~ m/AAA/ || $_ =~ m/AAG/ )
			{
			$codon = "K";
			}
		elsif ($_ =~ m/AGC/ || $_ =~ m/AGT/ )
			{
			$codon = "S";
			}
		elsif ($_ =~ m/AGA/ || $_ =~ m/AGG/ )
			{
			$codon = "R";
			}
		elsif ($_ =~ m/GTA/ || $_ =~ m/GTC/ || $_ =~ m/GTG/ || $_ =~ m/GTT/ )
			{
			$codon = "V";
			}
		elsif ($_ =~ m/GCA/ || $_ =~ m/GCC/ || $_ =~ m/GCG/ || $_ =~ m/GCT/ )
			{
			$codon = "A";
			}
		elsif ($_ =~ m/GAC/ || $_ =~ m/GAT/ )
			{
			$codon = "D";
			}
		elsif ($_ =~ m/GAA/ || $_ =~ m/GAG/ )
			{
			$codon = "E";
			}
		elsif ($_ =~ m/GGA/ || $_ =~ m/GGC/ || $_ =~ m/GGG/ || $_ =~ m/GGT/ )
			{
			$codon = "G";
			}

		else
			{$codon = "X";}
		
		push (@codons, $codon);
		}


        $aaseq=join("", @codons);
	chomp $aaseq;

	return "$aaseq";

	$/ = "\n";



}
