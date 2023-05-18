## Download and unzip gff file and genome
```
wget https://datadryad.org/stash/downloads/file_stream/1853920
wget https://datadryad.org/stash/downloads/file_stream/1853921
```
Get genes location
```
awk '$3=="transcript"{print $1,$9}' 1853920 > transcript_names
## file would be processed in textEdit to import it as a dataframe in Python, name: transcript_names_final.txt
```
## Get protein sequences from gff file
```
module load anaconda3/2022.05
conda activate gffread
## by adding -S we replace '.' by '*' for the stop codons and then orthofinder can be executed
gffread -y prot3.fasta -g 1853921 1853920 -S
```
## Get predicted aminoacids from Panorpa transcripts
```
perl ~/GetLongestAA_v1_July2020.pl Panorpa_transcriptome_500bp.cds
```
For each transcript it will output the longest AA that can be produced from it. The output file would be: Panorpa_transcriptome_500bp.cds.aa
# Orthofinder

Get protein sequences and get longest isoforms for outgroup species (mosquito):
```
wget http://ftp.ensemblgenomes.org/pub/metazoa/release-55/fasta/aedes_aegypti_lvpagwg/pep/Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
gzip -d Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
```

Sort protein files
```
cat Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa | perl -pi -e 's/>.*gene:/>/gi'| perl -pi -e 's/ .*//gi'| perl -pi -e 's/\n/ /gi'| perl -pi -e 's/>/\n/gi'| sort | perl -pi -e 's/\n/\n>/gi'| perl -pi -e 's/ /\n/gi'| perl -pi -e 's/^\n//gi' > Aedes_aegypti_sortedprots.fa

cat prot3.fasta | perl -pi -e 's/\n/ /gi' | perl -pi -e 's/>/\n>/gi' | sort | perl -pi -e 's/ /\n/gi' | perl -pi -e 's/^\n//gi' > screwworm_sortedprots3.fa

```
filter for longest isoform
```
perl ~/GetLongestCDS_v2.pl Aedes_aegypti_sortedprots.fa
```
delete the last line of each longestCDS file created before running Orthofinder
```
perl -pi -e 's/>$//gi' Aedes_aegypti_sortedprots.fa.longestCDS
perl -pi -e 's/>$//gi' prot3.fasta
```
change files names
```
mv Aedes_aegypti_sortedprots.fa.longestCDS Aedes_aegypti_sortedprots.fa
mv prots3.fasta screwworm_sortedprots3.fa
```

rename Panorpa transcripts and rename
```
mv Panorpa_transcriptome_500bp.cds.aa Panorpa_transcriptome_500bp.faa
```
## run Orthofinder
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
Line end trimming
```
perl ~/linendings.pl --unix Panorpa_screw_1to1.txt
```

