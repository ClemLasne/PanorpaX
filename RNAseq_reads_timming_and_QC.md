# 1. FASTQC on raw data

After downloading from the sequencing platform, the quality of forward and reverse RNA-seq reads was controlled with [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

**FastQC version 0.11.9

```ruby
#load modules
module load java
module load fastqc

#command
srun fastqc 184786_S1_L004_R1_001.fastq.gz
srun fastqc 184786_S1_L004_R2_001.fastq.gz
srun fastqc 184787_S2_L004_R1_001.fastq.gz
srun fastqc 184787_S2_L004_R2_001.fastq.gz
srun fastqc 184788_S3_L004_R1_001.fastq.gz
srun fastqc 184788_S3_L004_R2_001.fastq.gz
srun fastqc 184789_S4_L004_R1_001.fastq.gz
srun fastqc 184789_S4_L004_R2_001.fastq.gz
srun fastqc 184790_S5_L004_R1_001.fastq.gz
srun fastqc 184790_S5_L004_R2_001.fastq.gz
srun fastqc 184791_S6_L004_R1_001.fastq.gz
srun fastqc 184791_S6_L004_R2_001.fastq.gz
srun fastqc 184792_S7_L004_R1_001.fastq.gz
srun fastqc 184792_S7_L004_R2_001.fastq.gz
srun fastqc 184793_S8_L004_R1_001.fastq.gz
srun fastqc 184793_S8_L004_R2_001.fastq.gz
srun fastqc 184794_S9_L004_R1_001.fastq.gz
srun fastqc 184794_S9_L004_R2_001.fastq.gz
srun fastqc 184795_S10_L004_R1_001.fastq.gz
srun fastqc 184795_S10_L004_R2_001.fastq.gz
srun fastqc 184796_S11_L004_R1_001.fastq.gz
srun fastqc 184796_S11_L004_R2_001.fastq.gz
srun fastqc 184797_S12_L004_R1_001.fastq.gz
srun fastqc 184797_S12_L004_R2_001.fastq.gz
srun fastqc 184798_S13_L004_R1_001.fastq.gz
srun fastqc 184798_S13_L004_R2_001.fastq.gz
srun fastqc 184799_S14_L004_R1_001.fastq.gz
srun fastqc 184799_S14_L004_R2_001.fastq.gz
srun fastqc 184800_S15_L004_R1_001.fastq.gz
srun fastqc 184800_S15_L004_R2_001.fastq.gz
srun fastqc 184801_S16_L004_R1_001.fastq.gz
srun fastqc 184801_S16_L004_R2_001.fastq.gz
srun fastqc 184802_S17_L004_R1_001.fastq.gz
srun fastqc 184802_S17_L004_R2_001.fastq.gz
srun fastqc 184803_S18_L004_R1_001.fastq.gz
srun fastqc 184803_S18_L004_R2_001.fastq.gz
```

# 2. Trimmomatic

The initial FastQC results suggest that adaptors of the reads have not been trimmed properly. We therefore used TRIMMOMATIC single-end HEADCROP option to trimm these adaptors.

### 2.1. Forward reads

```ruby
#load modules
module load java

#command
srun java -jar [PATH]/Trimmomatic-0.36/trimmomatic-0.36.jar SE -threads 40 184786_S1_L004_R1_001.fastq.gz 184786_S1_L004_R1_001_SE.fastq.gz ILLUMINACLIP:[PATH]/Trimmomatic-0.36/adapters/TruSeq3-SE:2:30:10 HEADCROP:30 SLIDINGWINDOW:4:22 MINLEN:36 LEADING:3 TRAILING:3

srun java -jar /nfs/scistore03/vicosgrp/Bioinformatics_2018/Beatriz/0-Software/Trimmomatic-0.36/trimmomatic-0.36.jar SE -threads 40 184787_S2_L004_R1_001.fastq.gz 184787_S2_L004_R1_001_SE.fastq.gz ILLUMINACLIP:/nfs/scistore03/vicosgrp/Bioinformatics_2018/Beatriz/0-Software/Trimmomatic-0.36/adapters/TruSeq3-SE:2:30:10 HEADCROP:30 SLIDINGWINDOW:4:22 MINLEN:36 LEADING:3 TRAILING:3
