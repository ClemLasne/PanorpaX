# Get protein sequences from gff file
```
module load anaconda3/2022.05
conda activate gffread
## by adding -S we replace '.' by '*' for the stop codons and then orthofinder can be executed
gffread -y prot3.fasta -g 1853921 1853920 -S
```

# Get predicted aminoacids from Panorpa transcripts
```
perl /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/PAIRED_PE_trimmomatic_files/TRINITY_panorpa_transcriptome_assembly/EVIGENE_Panorpa_tanscriptome_okayset/Panorpa_transcriptome_500bp/GetLongestAA_v1_July2020.pl Panorpa_transcriptome_500bp.cds
```
This would produce for each transcript it will output the longest AA that can be produced from it. The output file would be: Panorpa_transcriptome_500bp.cds.aa
# Orthofinder (from Clem's pipeline)
The program needs a folder containing only the protein sequences of the species. In this case, we've included mosquito as an outgroup species.

Directory:

```
cd /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/screwworm/files_for_orthofinder
```

## Get protein sequences and get longest isoforms for each:
```
wget http://ftp.ensemblgenomes.org/pub/metazoa/release-55/fasta/aedes_aegypti_lvpagwg/pep/Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz
gzip -d Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa.gz

cp /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/screwworm/prot3.fasta .
```

sort protein files
```
cat Aedes_aegypti_lvpagwg.AaegL5.pep.all.fa | perl -pi -e 's/>.*gene:/>/gi'| perl -pi -e 's/ .*//gi'| perl -pi -e 's/\n/ /gi'| perl -pi -e 's/>/\n/gi'| sort | perl -pi -e 's/\n/\n>/gi'| perl -pi -e 's/ /\n/gi'| perl -pi -e 's/^\n//gi' > Aedes_aegypti_sortedprots.fa

cat prot3.fasta | perl -pi -e 's/\n/ /gi' | perl -pi -e 's/>/\n>/gi' | sort | perl -pi -e 's/ /\n/gi' | perl -pi -e 's/^\n//gi' > screwworm_sortedprots3.fa

```
filter for longest isoform
```
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/GetLongestCDS_v2.pl Aedes_aegypti_sortedprots.fa
```
delete the last line of each longestCDS file created before running Orthofinder
```
perl -pi -e 's/>$//gi' Aedes_aegypti_sortedprots.fa.longestCDS
perl -pi -e 's/>$//gi' screwworm_sortedprots3.fa.longestCDS
```
change files names
```
mv Aedes_aegypti_sortedprots.fa.longestCDS Aedes_aegypti_sortedprots.fa
mv screwworm_sortedprots3.fa.longestCDS screwworm_sortedprots3.fa
```

## Bring Panorpa transcripts and rename
```
cp /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/PAIRED_PE_trimmomatic_files/TRINITY_panorpa_transcriptome_assembly/EVIGENE_Panorpa_tanscriptome_okayset/Panorpa_transcriptome_500bp/Panorpa_transcriptome_500bp.cds.aa .
mv Panorpa_transcriptome_500bp.cds.aa Panorpa_transcriptome_500bp.faa
```
## run Orthofinder
```
module load orthofinder
orthofinder -f files_for_orthofinder

```
## Extract 1:1 orthologous genes
```
#directory:
cd /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/screwworm/files_for_orthofinder/OrthoFinder/Results_Mar29/Orthologues/Orthologues_Panorpa_transcriptome_500bp

#extract genes:
cat Panorpa_transcriptome_500bp__v__screwworm_sortedprots3.tsv | awk '($2 ~/TRINITY/ && $3 ~/g/ && $4 !~/g/)' | awk '{print $2, $3}' | sort > Panorpa_screw_1to1.txt
```
Line end trimming
```
perl /nfs/scistore18/vicosgrp/bvicoso/scripts/linendings.pl --unix Panorpa_screw_1to1.txt
```

