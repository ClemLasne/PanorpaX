For SI:
# Orthofinder:
Working directory:
```
cd /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/screwworm/dmel_ortho 
```
Donwload files (protein sequences)
```
wget https://ftp.ensembl.org/pub/release-108/fasta/drosophila_melanogaster/pep/Drosophila_melanogaster.BDGP6.32.pep.all.fa.gz
gzip -d Drosophila_melanogaster.BDGP6.32.pep.all.fa.gz
```
Sort proteins to run the Perl script
```
cat Drosophila_melanogaster.BDGP6.32.pep.all.fa | perl -pi -e 's/>.*gene:/>/gi'| perl -pi -e 's/ .*//gi'| perl -pi -e 's/\n/ /gi'| perl -pi -e 's/>/\n/gi'| sort | perl -pi -e 's/\n/\n>/gi'| perl -pi -e 's/ /\n/gi'| perl -pi -e 's/^\n//gi' > Drosophila_melanogaster_sortedprots.fa
```
Get longest isoform
```
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/GetLongestCDS_v2.pl Drosophila_melanogaster_sortedprots.fa
```
Remove last line (?)
```
perl -pi -e 's/>$//gi' Drosophila_melanogaster_sortedprots.fa.longestCDS
```
