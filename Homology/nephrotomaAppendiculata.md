Download genome
```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/947/310/385/GCA_947310385.1_idNepAppe1.1/GCA_947310385.1_idNepAppe1.1_genomic.fna.gz
gzip -d GCA_947310385.1_idNepAppe1.1_genomic.fna.gz
```
Map genome 
```
module load blat
srun blat -t=dnax -q=dnax -minScore=50 GCA_947310385.1_idNepAppe1.1_genomic.fna ~/Panorpa_transcriptome_500bp.cds CDS_vs_genome.blat
```
Best hit and remove redundancy
```
#Step 1: sort by query name
sort -k 10 CDS_vs_genome.blat > CDS_vs_genome.sorted

#Step 2: keep only the best hit on the genome for each gene
perl ~/1-besthitblat.pl CDS_vs_genome.sorted 

#Step 3: sort by database name
sort -k 14 CDS_vs_genome.sorted.besthit > CDS_vs_genome.sortedbyDB

#Step 4: keep only genes that do not overlap or overlap by <20bps 
#in case of overlap keep only gene with highest mapping score
perl ~/2-redremov_blat_V2.pl CDS_vs_genome.sortedbyDB 
```