# 1. FastQC on raw RNA-seq data

After downloading from the sequencing platform, the quality of forward and reverse RNA-seq reads was controlled with [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

**FastQC version 0.11.9**

```ruby
#load modules
module load java
module load fastqc

#command
srun fastqc 184786_S1_L004_R1_001.fastq.gz
srun fastqc 184786_S1_L004_R2_001.fastq.gz
```
The command was repeated for each forward(R1) and reverse(R2) read files of the remaining 17 RNA-seq samples.

# 2. Trimmomatic

The initial FastQC results suggest that adaptors of the reads have not been trimmed properly, and that the lennght of these adaptors differ between forward and reverse read files. We therefore perfom TRIMMOMATIC single-end first, with the HEADCROP option customised to trimm these adaptors. And finally perform TRIMMOMATIC paired-end.

**Trimmomatic version 0.36**

### 2.1. Forward reads

```ruby
#load modules
module load java

#command
srun java -jar [PATH]/Trimmomatic-0.36/trimmomatic-0.36.jar SE -threads 40 184786_S1_L004_R1_001.fastq.gz 184786_S1_L004_R1_001_SE.fastq.gz HEADCROP:30
```
The command was repeated for the 17 other forward read files (i.e. 17 other "R1" RNA-seq samples)

### 2.2. Reverse reads

```ruby
#load modules
module load java
#command

srun java -jar [PATH]/Trimmomatic-0.36/trimmomatic-0.36.jar SE -threads 40 184786_S1_L004_R2_001.fastq.gz 184786_S1_L004_R2_001_SE.fastq.gz HEADCROP:8
```
The command was repeated for the 17 other forward read files (i.e. 17 other "R2" RNA-seq samples)

### 2.3. Paired-end Trimmomatic

Using the single-end trimmed forward and reverse read files produced in steps 2.1. and 2.2. above, we ran TRIMMOMATIC paired-end.

```ruby 
#!/bin/bash
#SBATCH --account=vicosgrp
#SBATCH --reservation=vicosgrp_131
#SBATCH --job-name=trimmo_PE_reads
#SBATCH -c 5
#SBATCH -t 24:00:00
#SBATCH --mail-user=clementine.lasne@ist.ac.at
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --ntasks=1
#SBATCH -N 1
#SBATCH --mem=10GB
#SBATCH --output=outcome_trimm_PE_1.out
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

#Set the number of threads to the SLURM internal variable

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

#load modules
module load java
#command

srun java -jar [PATH]/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 40 184786_S1_L004_R1_001_SE.fastq.gz 184786_S1_L004_R2_001_SE.fastq.gz 184786_S1_L004_R1_001_PE_paired.fastq.gz 184786_S1_L004_R1_001_PE_unpaired.fastq.gz 184786_S1_L004_R2_001_PE_paired.fastq.gz 184786_S1_L004_R2_001_PE_unpaired.fastq.gz ILLUMINACLIP:[PATH]/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:22 MINLEN:36 LEADING:3 TRAILING:3 
```
We repeated this command for each sample. The trimmomatic command for paired-end reads reads as follow (for each sample):
`srun java -jar [PATH]/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 40 <forward reads file(R1)> <reverse reads file(R2)> <Output file that contains surviving pairs from the R1 file> <	Output file that contains orphaned reads from the R1 file> <Output file that contains surviving pairs from the R2 file> <	Output file that contains orphaned reads from the R2 file> ILLUMINACLIP:[PATH]/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:22 MINLEN:36 LEADING:3 TRAILING:3`


# 3. FastQC on trimmed and paired reads

```ruby
#load modules
module load java
module load fastqc

#command
srun fastqc 184786_S1_L004_R1_001_PE_paired.fastq.gz
srun fastqc 184786_S1_L004_R2_001_PE_paired.fastq.gz
```
The command was repeated for each forward(R1) and reverse(R2) read files of the remaining 17 RNA-seq samples. Read quality was then deemed satisfying to perform **transcriptome assembly** and **gene expression quantification**
