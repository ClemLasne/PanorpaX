# 1. Trinity

Run Trinity in the directory containing the forward and reverse reads of each sample. 

In a slurm script:
```ruby
#load modules
module load java
module load samtools/1.10
module load jellyfish/2.3.0
module load bowtie2/2.4.4
module load python/3.8.5
module load salmon/0.13.1

#run commands on SLURM's srun

[PATH]/trinityrnaseq-v2.11.0/Trinity --seqType fq --left 184786_S1_L004_R1_001_PE_paired.fastq.gz,184787_S2_L004_R1_001_PE_paired.fastq.gz,184788_S3_L004_R1_001_PE_paired.fastq.gz,184789_S4_L004_R1_001_PE_paired.fastq.gz,184790_S5_L004_R1_001_PE_paired.fastq.gz,184791_S6_L004_R1_001_PE_paired.fastq.gz,184792_S7_L004_R1_001_PE_paired.fastq.gz,184793_S8_L004_R1_001_PE_paired.fastq.gz,184794_S9_L004_R1_001_PE_paired.fastq.gz,184795_S10_L004_R1_001_PE_paired.fastq.gz,184796_S11_L004_R1_001_PE_paired.fastq.gz,184797_S12_L004_R1_001_PE_paired.fastq.gz,184798_S13_L004_R1_001_PE_paired.fastq.gz,184799_S14_L004_R1_001_PE_paired.fastq.gz,184800_S15_L004_R1_001_PE_paired.fastq.gz,184801_S16_L004_R1_001_PE_paired.fastq.gz,184802_S17_L004_R1_001_PE_paired.fastq.gz,184803_S18_L004_R1_001_PE_paired.fastq.gz --right 184786_S1_L004_R2_001_PE_paired.fastq.gz,184787_S2_L004_R2_001_PE_paired.fastq.gz,184788_S3_L004_R2_001_PE_paired.fastq.gz,184789_S4_L004_R2_001_PE_paired.fastq.gz,184790_S5_L004_R2_001_PE_paired.fastq.gz,184791_S6_L004_R2_001_PE_paired.fastq.gz,184792_S7_L004_R2_001_PE_paired.fastq.gz,184793_S8_L004_R2_001_PE_paired.fastq.gz,184794_S9_L004_R2_001_PE_paired.fastq.gz,184795_S10_L004_R2_001_PE_paired.fastq.gz,184796_S11_L004_R2_001_PE_paired.fastq.gz,184797_S12_L004_R2_001_PE_paired.fastq.gz,184798_S13_L004_R2_001_PE_paired.fastq.gz,184799_S14_L004_R2_001_PE_paired.fastq.gz,184800_S15_L004_R2_001_PE_paired.fastq.gz,184801_S16_L004_R2_001_PE_paired.fastq.gz,184802_S17_L004_R2_001_PE_paired.fastq.gz,184803_S18_L004_R2_001_PE_paired.fastq.gz --CPU 20 --max_memory 200G --trimmomatic
```
