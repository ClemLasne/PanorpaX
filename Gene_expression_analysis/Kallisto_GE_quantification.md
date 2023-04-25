In a directory containing
(1) the indexed transcriptome "indexed_panorpa500_transcriptome.idx" 
(2) forward and reversed read files for each RNA-seq sample (previouly trimmed in Trimmomatic)
Run the following script:

```ruby
#load any module you need here
module load kallisto

#run commands on SLURM's srun
srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184786_MALE_1_HEAD -b 100 184786_S1_L004_R1_001_PE_paired.fastq.gz 184786_S1_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184787_MALE_1_GONAD -b 100 184787_S2_L004_R1_001_PE_paired.fastq.gz 184787_S2_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184788_MALE_1_CARCASS -b 100 184788_S3_L004_R1_001_PE_paired.fastq.gz 184788_S3_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184789_MALE_2_HEAD -b 100 184789_S4_L004_R1_001_PE_paired.fastq.gz 184789_S4_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184790_MALE_2_GONAD -b 100 184790_S5_L004_R1_001_PE_paired.fastq.gz 184790_S5_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184791_MALE_2_CARCASS -b 100 184791_S6_L004_R1_001_PE_paired.fastq.gz 184791_S6_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184792_MALE_3_HEAD -b 100 184792_S7_L004_R1_001_PE_paired.fastq.gz 184792_S7_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184793_MALE_3_GONAD -b 100 184793_S8_L004_R1_001_PE_paired.fastq.gz 184793_S8_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184794_MALE_3_CARCASS -b 100 184794_S9_L004_R1_001_PE_paired.fastq.gz 184794_S9_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184795_FEMALE_1_HEAD -b 100 184795_S10_L004_R1_001_PE_paired.fastq.gz 184795_S10_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184796_FEMALE_1_GONAD -b 100 184796_S11_L004_R1_001_PE_paired.fastq.gz 184796_S11_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184797_FEMALE_1_CARCASS -b 100 184797_S12_L004_R1_001_PE_paired.fastq.gz 184797_S12_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184798_FEMALE_2_HEAD -b 100 184798_S13_L004_R1_001_PE_paired.fastq.gz 184798_S13_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184799_FEMALE_2_GONAD -b 100 184799_S14_L004_R1_001_PE_paired.fastq.gz 184799_S14_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184800_FEMALE_2_CARCASS -b 100 184800_S15_L004_R1_001_PE_paired.fastq.gz 184800_S15_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184801_FEMALE_3_HEAD -b 100 184801_S16_L004_R1_001_PE_paired.fastq.gz 184801_S16_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184802_FEMALE_3_GONAD -b 100 184802_S17_L004_R1_001_PE_paired.fastq.gz 184802_S17_L004_R2_001_PE_paired.fastq.gz

srun kallisto quant -t 16 -i indexed_panorpa500_transcriptome.idx -o 184803_FEMALE_3_CARCASS -b 100 184803_S18_L004_R1_001_PE_paired.fastq.gz 184803_S18_L004_R2_001_PE_paired.fastq.gz
```
For each fo the 18 samples, a new directory is produced containing 3 files: abundance.h5, abundance.tsv, run_info.json.
