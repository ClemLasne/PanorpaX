Download genome for the species
```
#L. migratoria
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/026/315/105/GCA_026315105.1_CAU_Lmig_1.0/
gzip -d GCA_026315105.1_CAU_Lmig_1.0
#N. appendiculata
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/947/310/385/GCA_947310385.1_idNepAppe1.1/GCA_947310385.1_idNepAppe1.1_genomic.fna.gz
gzip -d GCA_947310385.1_idNepAppe1.1_genomic.fna.gz
#B. germanica
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/762/945/GCA_000762945.2_Bger_2.0/GCA_000762945.2_Bger_2.0_genomic.fna.gz
gzip -d GCA_000762945.2_Bger_2.0_genomic.fna.gz
#C. hominivorax
wget https://datadryad.org/stash/downloads/file_stream/1853921
```
Map Panorpa transcripts to the species genome
```
module load blat
srun blat -t=dnax -q=dnax -minScore=50 GCA_026315105.1_CAU_Lmig_1.0_genomic.fna ~/Panorpa_transcriptome_500bp.cds CDS_vs_genome.blat
srun blat -t=dnax -q=dnax -minScore=50 GCA_947310385.1_idNepAppe1.1_genomic.fna ~/Panorpa_transcriptome_500bp.cds CDS_vs_genome.blat
srun blat -t=dnax -q=dnax -minScore=50 GCA_000762945.2_Bger_2.0_genomic.fna ~/Panorpa_transcriptome_500bp.cds CDS_vs_genome.blat
srun blat -t=dnax -q=dnax -minScore=50 1853921 ~/Panorpa_transcriptome_500bp.cds CDS_vs_genome.blat
```
Best hit and remove redundancy for each blat results:
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
