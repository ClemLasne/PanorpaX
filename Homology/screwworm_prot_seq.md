# Obtain protein sequences of C. hominivorax
Download and unzip gff file and genome of the screwworm
```
wget https://datadryad.org/stash/downloads/file_stream/1853920
wget https://datadryad.org/stash/downloads/file_stream/1853921
```
Get genes location:
```
awk '$3=="gene"{print $1,$9}' 1853920 > gene_names
cut -d";" -f1 gene_names > gene_names_mod
## file would be processed in textEdit, name: gene_names_true.txt
```
Get protein sequences from gff file
```
module load anaconda3/2022.05
conda activate gffread
## by adding -S we replace '.' by '*' for the stop codons and then orthofinder can be executed
gffread -y protseq.fasta -g 1853921 1853920 -S
```
Remove everything after '.' in sequences names so that GetLongestCDS_v2.pl can be executed:
```
cut -d"." -f1 protseq.fasta > screwworm_prots.fasta
```
Sort file so that GetLongestCDS_v2.pl can be executed:
```
cat screwworm_prots.fasta | perl -pi -e 's/\n/ /gi' | perl -pi -e 's/>/\n>/gi' | sort | perl -pi -e 's/ /\n/gi' | perl -pi -e 's/^\n//gi' > screwworm_sortedprots.fa
```
Extract largest isoform. This will output the file screwworm_sortedprots.fa.longest:
```
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/GetLongestCDS_v2.pl screwworm_sortedprots.fa
```
Change file name:
```
mv screwworm_sortedprots.fa.longestCDS Chominivorax_prots.fa
```

