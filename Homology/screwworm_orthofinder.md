# Orthofinder to find C. hominivorax and P. cognata orthologs
## Prepare files for Orthofinder
Get protein sequences for outgroup species (mosquito):
```
wget http://ftp.ensemblgenomes.org/pub/metazoa/release-55/fasta/aedes_aegypti_lvpagwg/pep/Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
gzip -d Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
```
Sort protein file:
```
cat Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa | perl -pi -e 's/>.*gene:/>/gi'| perl -pi -e 's/ .*//gi'| perl -pi -e 's/\n/ /gi'| perl -pi -e 's/>/\n/gi'| sort | perl -pi -e 's/\n/\n>/gi'| perl -pi -e 's/ /\n/gi'| perl -pi -e 's/^\n//gi' > Aedes_aegypti_sortedprots.fa

```
Remove a blank line in the file so that GetLongestCDS_v2.pl can be executed:
```
perl -pi -e 's/>$//gi' Aedes_aegypti_sortedprots.fa
```
Extract largest isoform. This will output the file Aedes_aegypti_sortedprots.fa.longestCDS:
```
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/GetLongestCDS_v2.pl Aedes_aegypti_sortedprots.fa
```
Change file name:
```
mv Aedes_aegypti_sortedprots.fa.longestCDS Aedes_aegypti_prots.fa
```
to be deleted
```
Panorpa_prots.fa
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
cat Panorpa_prots__v__Chominivorax_prot.tsv | awk '($2 ~/TRINITY/ && $3 ~/g/ && $4 !~/g/)' | awk '{print $2, $3}' | sort > Panorpa_chomini_1to1.txt
```
To obtain orthologs with N. appendiculata, we include the protein sequences and then extract the corresponding file from Orthofinder:
```
cat Panorpa_prots__v__Chominivorax_prot.tsv | awk '($2 ~/TRINITY/ && $3 ~/g/ && $4 !~/g/)' | awk '{print $2, $3}' | sort > Panorpa_chomini_1to1.txt
```
