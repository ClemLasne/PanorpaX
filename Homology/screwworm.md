## Extract CDS from gff file

Download and unzip gff file and genome
```
wget https://datadryad.org/stash/downloads/file_stream/1853920
wget https://datadryad.org/stash/downloads/file_stream/1853921
```

```
Get genes location
```
awk '$3=="transcript"{print $1,$9}' 1853920 > transcript_names
## file would be processed in textEdit to import it as a dataframe in Python, name: transcript_names_final.txt
```

