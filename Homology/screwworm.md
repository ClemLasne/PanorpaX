## Extract CDS from gff file

Download and unzip gff file and genome
```
wget https://datadryad.org/stash/downloads/file_stream/1853920
wget https://datadryad.org/stash/downloads/file_stream/1853921
```
Now, we can use gff read to extract info we need.
```
module load anaconda3/2022.05
conda activate gffread
## extarct CDS
gffread -x CDS_no_stop_codons.fasta -g 1853921 1853920 -V
```
## Get the longest CDS
First, we need to sort the names in the fasta file. Then we cna use ther perl script. In this case, only 1 gene will be removed.
```
cat CDS_no_stop_codons.fasta | perl -pi -e 's/\n/ /gi' | perl -pi -e 's/>/\n>/gi' | sort | perl -pi -e 's/ /\n/gi' | perl -pi -e 's/^\n//gi' > CDS_no_stop.sorted
perl ~/getlongestCDS_v2.pl CDS_no_stop.sorted

#this generates the file CDS_no_stop.sorted.longestCDS
```
## get gene location
```
awk '$3=="transcript"{print $1,$9}' 1853920 > transcript_names
## file would be processed in textEdit to import it as a dataframe in Python, name: transcript_names_final
```

