Map Panorpa transcripts to Blatella genome:
```
module load blat
srun blat -t=dnax -q=dnax -minScore=50 GCA_000762945.2_Bger_2.0_genomic.fna ~/Panorpa_transcriptome_500bp.cds CDS_vs_genome.blat
```
Pipeline to remove redundancy:
```
sort -k 10 CDS_vs_genome.blat > CDS_vs_genome.sorted

perl /nfs/scistore18/vicosgrp/bvicoso/Afranciscana_remov_redund/1-besthitblat.pl CDS_vs_genome.sorted 

sort -k 14 CDS_vs_genome.sorted.besthit > CDS_vs_genome.sortedbyDB

#Step 4: keep only genes that do not overlap or overlap by <20bps 
#in case of overlap keep only gene with highest mapping score

perl /nfs/scistore18/vicosgrp/bvicoso/Afranciscana_remov_redund/2-redremov_blat_V2.pl CDS_vs_genome.sortedbyDB 
```
