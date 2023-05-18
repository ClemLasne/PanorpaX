# Copy files in new directory

## transcriptome
```ruby
cp /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/PAIRED_PE_trimmomatic_files/TRINITY_panorpa_transcriptome_assembly/EVIGENE_Panorpa_tanscriptome_okayset/Panorpa_transcriptome_500bp/TRANSCRIPTOME_TO_USE/Panorpa_transcriptome_500bp.cds .
```

## male and female HEAD PE fasta.gz files
Path to PE reads: `/nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/PAIRED_PE_trimmomatic_files`

In there, create a slrum script to copy HEAD samples from the directory containing the fasta.gz files to the `Pixy_SNP_diversity` directory.

```ruby
pico copy_files.sh
```

Content
```ruby
#!/bin/bash
#SBATCH --partition=defaultp
#SBATCH --job-name=copying
#SBATCH -c 20
#SBATCH -t 24:00:00
#SBATCH --mail-user=clementine.lasne@ist.ac.at
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --ntasks=1
#SBATCH -N 1
#SBATCH --mem=200GB
#SBATCH --output=copy_files.out
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

#Set the number of threads to the SLURM internal variable

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

## command 
cp 184786_S1_L004_R1_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184786_S1_L004_R2_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184789_S4_L004_R1_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184789_S4_L004_R2_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184792_S7_L004_R1_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184792_S7_L004_R2_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184795_S10_L004_R1_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184795_S10_L004_R2_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184798_S13_L004_R1_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184798_S13_L004_R2_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184801_S16_L004_R1_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
cp 184801_S16_L004_R2_001_PE_paired.fastq.gz /nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/
```


# Make .bam files for each sample from the fasta read files

Slurm script:
```ruby
pico mapping_script.sh
```

Content of the script:
```ruby
#!/bin/bash
#SBATCH --partition=defaultp
#SBATCH --job-name=mapping
#SBATCH -c 20
#SBATCH -t 24:00:00
#SBATCH --mail-user=clementine.lasne@ist.ac.at
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --ntasks=1
#SBATCH -N 1
#SBATCH --mem=200GB
#SBATCH --output=output_mapping.out
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

#Set the number of threads to the SLURM internal variable
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# load modules
module load bwa
module load samtools

# commands
bwa index Panorpa_transcriptome_500bp.cds

bwa mem -M -t 30 Panorpa_transcriptome_500bp.cds 184786_S1_L004_R1_001_PE_paired.fastq.gz 184786_S1_L004_R2_001_PE_paired.fastq.gz | samtools view -F 4 -b | samtools sort -T individual > 184786_Male1.bam
bwa mem -M -t 30 Panorpa_transcriptome_500bp.cds 184789_S4_L004_R1_001_PE_paired.fastq.gz 184789_S4_L004_R2_001_PE_paired.fastq.gz | samtools view -F 4 -b | samtools sort -T individual > 184789_Male2.bam
bwa mem -M -t 30 Panorpa_transcriptome_500bp.cds 184792_S7_L004_R1_001_PE_paired.fastq.gz 184792_S7_L004_R2_001_PE_paired.fastq.gz | samtools view -F 4 -b | samtools sort -T individual > 184792_Male3.bam
bwa mem -M -t 30 Panorpa_transcriptome_500bp.cds 184795_S10_L004_R1_001_PE_paired.fastq.gz 184795_S10_L004_R2_001_PE_paired.fastq.gz | samtools view -F 4 -b | samtools sort -T individual > 184795_Fem1.bam
bwa mem -M -t 30 Panorpa_transcriptome_500bp.cds 184798_S13_L004_R1_001_PE_paired.fastq.gz 184798_S13_L004_R2_001_PE_paired.fastq.gz | samtools view -F 4 -b | samtools sort -T individual > 184798_Fem2.bam
bwa mem -M -t 30 Panorpa_transcriptome_500bp.cds 184801_S16_L004_R1_001_PE_paired.fastq.gz 184801_S16_L004_R2_001_PE_paired.fastq.gz | samtools view -F 4 -b | samtools sort -T individual > 184801_Fem3.bam
```


*Time it took to create the .bam files: at least 1 hour*



# Pixy part

## Generating AllSites VCFs using BCFtools (mpileup/call)

https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html

### companion file
```ruby
pico bam_files_list.txt
```

Content of the file
```ruby
184786_Male1.bam
184789_Male2.bam
184792_Male3.bam
184795_Fem1.bam
184798_Fem2.bam
184801_Fem3.bam
```

### AllSites_scripts.sh

```ruby
pico AllSites_scripts.sh
```
Content of the script:
```ruby
#load any module you need here
module load bcftools

#commands to run
bcftools mpileup -f Panorpa_transcriptome_500bp.cds -b bam_files_list.txt | bcftools call -m -Oz -f GQ -o AllSites_Panorpa_SNP.vcf
```

## SNP_calling_less_filtering.sh
```ruby
SNP_calling_less_filtering.sh
``` 
Content of the script
```ruby
#load any module you need here
module load bwa
module load samtools
module load bcftools
module load vcftools

#commands to run

srun samtools faidx Panorpa_transcriptome_500bp.cds

srun vcftools --vcf AllSites_Panorpa_SNP.vcf --remove-indels --minQ 30 --minDP 4 --maxDP 200 --recode --stdout >  AllSites_Panorpa_SNP_filtered.vcf
```

### tabix and bgzip step - check with Beatriz why we needed to do this

```ruby
pico zip_and_index_vcf_script.sh
```

```ruby
#modules
module load samtools

#commands
bgzip -c AllSites_Panorpa_SNP_filtered.vcf > AllSites_Panorpa_SNP_filtered.vcf.gz
tabix -p vcf AllSites_Panorpa_SNP_filtered.vcf.gz
```



## Create a compagnon populations file


```ruby
pico populations.txt
```

Content of the file (remember that this is TAB and not SPACE separated)
```ruby
184786_Male1.bam  male
184789_Male2.bam  male
184792_Male3.bam  male
184795_Fem1.bam female
184798_Fem2.bam female
184801_Fem3.bam female
```


## run pixy

Make a script

```ruby
pico pixy_script.sh
```

Content of the script:
```ruby
#!/bin/bash
#SBATCH --partition=defaultp
#SBATCH --job-name=pixy
#SBATCH -c 20
#SBATCH -t 24:00:00
#SBATCH --mail-user=clementine.lasne@ist.ac.at
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --ntasks=1
#SBATCH -N 1
#SBATCH --mem=200GB
#SBATCH --output=output_PIXY.out
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

#Set the number of threads to the SLURM internal variable
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

#modules 
module load anaconda2/4.7.12.1
source /mnt/nfs/clustersw/Debian/bullseye/anaconda3/2021.11/activate_anaconda3_2022.05.txt
conda activate pixy

# command
pixy --stats pi fst dxy \
--vcf AllSites_Panorpa_SNP_filtered.vcf.gz \
--populations populations.txt \
--window_size 28000 \
--n_cores 4 \
--output_folder output_PIXY \
--output_prefix pixy_output
conda deactivate
```

**PATH TO PIXY OUTPUT DIRECTORY:** 
```ruby
/nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/output_PIXY
```

Dowload all 3 files - in a new terminal window:

```ruby
scp -r -o ProxyJump=clasne@bea81.hpc.ista.ac.at clasne@bea81:/nfs/scistore18/vicosgrp/clasne/Panorpa_project/RNAseq_March2022/Pixy_SNP_diversity/output_PIXY/pixy_output_dxy.txt ~/Documents/MECOPTERA/SNP_Pi_diversity/post_hack_check_2023/pixy/
```
Do the same with **pixy_output_fst.txt** and **pixy_output_pi.txt**
