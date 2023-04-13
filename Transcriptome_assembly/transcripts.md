The working directory:
```
cd /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/paper/transcripts
```
Copy the transcripts file assembled by Clem:
```
cp /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/PAIRED_PE_trimmomatic_files/TRINITY_panorpa_transcriptome_assembly/EVIGENE_Panorpa_tanscriptome_okayset/Panorpa_transcriptome_500bp/TRANSCRIPTOME_TO_USE/Panorpa_transcriptome_500bp.cds .
```
Map transcripts to the panorpa genome:
```
srun blat -minScore=50 /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/paper/final/yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa Panorpa_transcriptome_500bp.cds CDS_vs_Genome.blat
```
Remove redundancy of transcripts:
```
#Step 1: sort by query name
sort -k 10 CDS_vs_genome.blat > CDS_vs_genome.sorted

#Step 2: keep only the best hit on the genome for each gene
perl /nfs/scistore18/vicosgrp/bvicoso/Afranciscana_remov_redund/1-besthitblat.pl CDS_vs_genome.sorted 

#Step 3: sort by database name
sort -k 14 CDS_vs_genome.sorted.besthit > CDS_vs_genome.sortedbyDB

#Step 4: keep only genes that do not overlap or overlap by <20bps 
#in case of overlap keep only gene with highest mapping score
perl /nfs/scistore18/vicosgrp/bvicoso/Afranciscana_remov_redund/2-redremov_blat_V2.pl CDS_vs_genome.sortedbyDB 
```
