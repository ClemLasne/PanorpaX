# 1. Trinity

Run Trinity to assemble the transcriptome. Run in the directory containing the forward(R1) and reverse(R2) reads of each RNA-seq sample that were previously trimmed with Trimmomatic and had their quality controlled for with FastQC. 

**We used version [trinityrnaseq-v2.11.0](https://github.com/trinityrnaseq/trinityrnaseq/releases)** 

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

This pipeline produces a "Tinitiy.fasta" file.


# 2. Evigene

Run the **[tr2aacds.pl](http://arthropods.eugenes.org/EvidentialGene/evigene/scripts/prot/) script from Evigene on the Trinity.fasta file.** to further remove some duplicated sequences.

**We used version 2022.01.20** 

Script:
```ruby
#load modules:
module load java
module load blast
module load exonerate
module load cdhit

#command:
perl [PATH]/evigene/scripts/prot/tr2aacds.pl -cdnaseq [PATH]/Trinity.fasta
```
This pipeline produces a "Tinity.okay.cds" file.

# 3. faFilter

Run [Fafilter](https://bioconda.github.io/recipes/ucsc-fafilter/README.html) on "Tinity.okay.cds" to keep transcripts of 500bp minimum size 

Script:
```ruby
#load modules
module load faFilter     
module load bioconda/20210115        
module load ucscGenomeBrowser/20220420   

#command:
faFilter -minSize=500 Trinity.okay.cds Panorpa_transcriptome_500bp.cds
```


# 4. Stats on Panorpa_transcriptome_500bp.cds

Run [assembly-stats](https://github.com/sanger-pathogens/assembly-stats/blob/master/README.md) on Panorpa_transcriptome_500bp.cds to obtain N50 and other stats on the Panorpa transcriptome assembly.

Script:
```ruby
#load modules
module load assembly-stats/20170224

#run commands on SLURM's srun
assembly-stats Panorpa_transcriptome_500bp.cds
```

# 5. BUSCO on Panorpa_transcriptome_500bp.cds

Run [BUSCO](https://busco.ezlab.org/) to assess the quality of the transcriptome assembly. 

**We used BUSCO version is: 5.2.2.**

Script:
```ruby
#load modules
module load ncbi-blast
module load hmmer
module load anaconda3/2021.07
source [PATH]/anaconda3/2021.07/activate_anaconda3_2021.07.txt
source activate [PATH]/.conda/envs/busco/

#run commands on SLURM's srun
srun busco -f --in Panorpa_transcriptome_500bp.cds --out BUSCO_Panorpa_transcriptome -l arthropoda_odb10 -m tran -c 40
conda deactivate
```

Results:
```
***** Results: *****

        C:92.7%[S:66.3%,D:26.4%],F:0.8%,M:6.5%,n:1013      
        939     Complete BUSCOs (C)                        
        672     Complete and single-copy BUSCOs (S)        
        267     Complete and duplicated BUSCOs (D)         
        8       Fragmented BUSCOs (F)                      
        66      Missing BUSCOs (M)                         
        1013    Total BUSCO groups searched  
```
        

