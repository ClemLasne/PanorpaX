## DE NOVO TRANSCRIPTOME ASSEMBLY FOR NEPHROTOMA APPENDICULATA AND LOCUSTA MIGRATORIA 

### Get Reads from SRA 
`module load SRA-Toolkit/2.11.2`

# N. appendiculata
`fasterq-dump --threads 4 --split-files ERR10378025`

# L. migratoria
`fasterq-dump --threads 4 --split-files SRR22110765`


### Trimming reads
```ruby
module load trimmomatic/0.39 
java -jar trimmomatic-0.39.jar PE sample_1.fastq sample_2.fastq sample_1.paired.fq sample_1.unpaired.fq sample_2.paired.fq sample_2.unpaired.fq ILLUMINACLIP:TruSeq2-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36
```



## Building Genome index and aligning reds with hisat2, make gtf file with stringtie
```ruby
module load hisat2/2.11.2
module load tophat/2.1.1
module load cufflinks/2.2.1
module load bowtie2/2.4.4
module load python/2.7
module load samtools/1.16
module load stringtie/2.2.1

# building genome index for hisat2
hisat2-build genome.fna genome_index

# align reads with hisat
hisat2 --phred33 -p 50 --novel-splicesite-outfile hisat2/splicesite.txt -S hisat2/accepted_hits.sam -x genome_index -1 sample_1.paired.fq -2 sample_2.paired.fq

# convert samfiles to bamfiles
samtools view -bS -o hisat2/accepted_hits.bam hisat2/accepted_hits.sam

# sort samfile
samtools sort -o hisat2/accepted_hits.sorted.bam hisat2/accepted_hits.bam

# create gtf file from sorted bamfile using stringtie
stringtie hisat2/accepted_hits.sorted.bam -o transcripts.gtf
```



## Transdecoder to get amino acid sequences from stringie gtf
```ruby
module load ncbi-blast/2.2.31+ 
module load R

# gtf to cDNA
Transdecoder5.5TransDecoder-TransDecoder-v5.5.0/util/gtf_genome_to_cdna_fasta.pl transcripts.gtf genome.fna > transcripts.TDCL.fasta 

# obtaining the longest ORFs from cDNA
Transdecoder5.5/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs -t transcripts.TDCL.fasta

#blast longest orfs to uniprot database
blastp -query transcripts.TDCL.fasta.transdecoder_dir/longest_orfs.pep  -db uniprot_sprot.fasta  -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 16 > blastp.outfmt6

#using blast results to predict transcripts
Transdecoder5.5/TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict -t transcripts.TDCL.fasta --retain_blastp_hits blastp.outfmt6
```


## SpliceFinder_2.pl (custom perl script, included) to retain the longest isoform 
`perl SpliceFinder_2.pl transcripts.TDCL.fasta.transdecoder.pep`

**output: transcripts.TDCL.fasta.transdecoder.pep.long**



### Input for Genespace ###
#peptide sequence: transcripts.TDCL.fasta.transdecoder.pep.long
#gff: transcripts.gtf (from stringtie)
