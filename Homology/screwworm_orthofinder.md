## Download and unzip gff file and genome of the screwworm
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
## Get protein sequences from gff file
```
module load anaconda3/2022.05
conda activate gffread
## by adding -S we replace '.' by '*' for the stop codons and then orthofinder can be executed
gffread -y protseq.fasta -g 1853921 1853920 -S
```
## Remove everything after '.' in sequences names
```
cut -d"." -f1 protseq.fasta > screwworm_prots.fasta
```

## Get predicted aminoacids from Panorpa transcripts
```
## For each transcript it will output the longest AA that can be produced from it. The output file would be: Panorpa_transcriptome_500bp.cds.aa
perl ~/GetLongestAA_v1_July2020.pl Panorpa_transcriptome_500bp.cds
```

# Prepare files for Orthofinder

Get protein sequences for outgroup species (mosquito):
```
wget http://ftp.ensemblgenomes.org/pub/metazoa/release-55/fasta/aedes_aegypti_lvpagwg/pep/Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
gzip -d Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
```
Sort protein files
```
cat Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa | perl -pi -e 's/>.*gene:/>/gi'| perl -pi -e 's/ .*//gi'| perl -pi -e 's/\n/ /gi'| perl -pi -e 's/>/\n/gi'| sort | perl -pi -e 's/\n/\n>/gi'| perl -pi -e 's/ /\n/gi'| perl -pi -e 's/^\n//gi' > Aedes_aegypti_sortedprots.fa

cat screwworm_prots.fasta | perl -pi -e 's/\n/ /gi' | perl -pi -e 's/>/\n>/gi' | sort | perl -pi -e 's/ /\n/gi' | perl -pi -e 's/^\n//gi' > screwworm_sortedprots.fa

```
Remove a blank line in the file:
```
perl -pi -e 's/>$//gi' Aedes_aegypti_sortedprots.fa
```
Extract largest isoform. This will output the file Aedes_aegypti_sortedprots.fa.longestCDS and screwworm_sortedprots.fa.longest:
```
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/GetLongestCDS_v2.pl Aedes_aegypti_sortedprots.fa
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/GetLongestCDS_v2.pl screwworm_sortedprots.fa
```

Change files names:
```
mv Aedes_aegypti_sortedprots.fa.longestCDS Aedes_aegypti_sortedprots.fa
mv Panorpa_transcriptome_500bp.cds.aa Panorpa_transcriptome_500bp.faa
```
## Execute Orthofinder
```
#files_for_orthofinder: directory must contain the protein sequences for all three species.
module load orthofinder
orthofinder -f files_for_orthofinder

```
## Extract 1:1 orthologous genes
```
#extract genes:
cat Panorpa_transcriptome_500bp__v__screwworm_sortedprots3.tsv | awk '($2 ~/TRINITY/ && $3 ~/g/ && $4 !~/g/)' | awk '{print $2, $3}' | sort > Panorpa_screw_1to1.txt
```

