For SI:
# Orthofinder:
Download protein sequences of D. melanogaster
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
perl ~/GetLongestCDS_v2.pl Drosophila_melanogaster_sortedprots.fa
```
Remove last line
```
perl -pi -e 's/>$//gi' Drosophila_melanogaster_sortedprots.fa.longestCDS
```
## Run Orthofinder
files_orthofinder_dmel is a directory that must contain the protein sequences for the three species
- We used the protein sequences predicted from the Panorpa transcripts (Panorpa_transcriptome_500bp.faa)
- Also, the protein sequences for the outgroup species Aedes aegypti (Aedes_aegypti_sortedprots.fa)
```
module load orthofinder
orthofinder -f files_orthofinder_dmel
