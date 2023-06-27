Map panorpa transcripts to the panorpa genome:
```
module load blat
srun blat -minScore=50 yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa Panorpa_transcriptome_500bp.cds CDS_vs_Genome.blat
```
Remove redundancy of transcripts:
```
#Step 1: sort by query name
sort -k 10 CDS_vs_genome.blat > CDS_vs_genome.sorted

#Step 2: keep only the best hit on the genome for each gene
perl 1-besthitblat.pl CDS_vs_genome.sorted 

#Step 3: sort by database name
sort -k 14 CDS_vs_genome.sorted.besthit > CDS_vs_genome.sortedbyDB

#Step 4: keep only genes that do not overlap or overlap by <20bps 
#in case of overlap keep only gene with highest mapping score
perl 2-redremov_blat_V2.pl CDS_vs_genome.sortedbyDB 
```
