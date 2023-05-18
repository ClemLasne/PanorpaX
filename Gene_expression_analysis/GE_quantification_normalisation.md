# 1. Gene expression quantification


In a directory containing
(1) the indexed transcriptome "indexed_panorpa500_transcriptome.idx" 
(2) forward and reversed read files for each RNA-seq sample (previouly trimmed in Trimmomatic)

We used **Kallisto** to quantify gene expression and then the R package **Sleuth** produce "ExpressionSummary.txt" files.

### 1.1. Kallisto

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



## 1.2. Expression summary files with Sleuth

4 ExpressionSummary.txt files must be generated:
* 3 tissue-specific ExpressionSummary.txt files (i.e. gonads, heads, carcacasses separately): used for the dosage compensation analysis and POF expression
* 1 all tissues together ExpressionSummary.txt (i.e. gonads, heads, carcacasses together): used for tissue-specific expression

For each of these 4 dataset, do the following:

1. Create a new directory called **KalFiles** and containing exclusively the Kallisto gene expression dictories of interests. 

(e.g. with heads)
```ruby
184786_MALE_1_HEAD
184789_MALE_2_HEAD
184792_MALE_3_HEAD
184795_FEMALE_1_HEAD
184798_FEMALE_2_HEAD
184801_FEMALE_3_HEAD
```


2. Outside of this **KalFiles** directory, create a companion text file with the the Kallisto directory name for each sample to analyse, and the category this sample belongs to. Important: the samples must be listed in this companion flie *in the same order* as they are listed in the **KalFiles** directory.

(e.g. with heads, companion file called "KalFiles_HEADS_samples_info.txt", categories: Male(M_HEAD) and Female(F_HEAD) )

```ruby
run_accession condition
184786_MALE_1_HEAD M_HEAD
184789_MALE_2_HEAD M_HEAD
184792_MALE_3_HEAD M_HEAD
184795_FEMALE_1_HEAD F_HEAD
184798_FEMALE_2_HEAD F_HEAD
184801_FEMALE_3_HEAD F_HEAD
```

3. Still outside of this **KalFiles** directory, run the following R script.

(e.g. with heads)
```ruby
library("sleuth")
base_dir <- "/path/to/current/working/directory/" # not the KalFiles directory
sample_id <- dir(file.path(base_dir,"KalFiles"))
kal_dirs<- sapply(sample_id, function(id) file.path(base_dir, "KalFiles", id))
s2c <- read.table(file.path(base_dir, "KalFiles_HEADS_samples_info.txt"), header = TRUE, stringsAsFactors=FALSE) 
s2c <- dplyr::select(s2c, sample = run_accession, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)
s2c$sample <- substr(s2c$sample, 1,6)
print(s2c)

so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
write.table(sleuth_table, file = "DEgenes_HEAD_samples.txt") # write a differential expression file if needed
kallisto_table<-sleuth_to_matrix(so, "obs_norm", "tpm")

head(kallisto_table)
SummaryTPM <- cbind(rownames(kallisto_table), data.frame(kallisto_table, row.names=NULL))
colnames(SummaryTPM)[1] <- "gene"
write.table(SummaryTPM, file = "ExpressionSummary_HEAD_samples.txt") # file to use subsequently
final<-merge(sleuth_table, SummaryTPM, by.x="target_id", by.y="gene")
write.table(final, file = "DGE_HEAD_samples.txt")
head(sleuth_table)
```

Repeat for each dataset and obtain 4 Expression summary files:
* **ExpressionSummary_HEAD_samples.txt**
* **ExpressionSummary_GONADS_samples.txt**
* **ExpressionSummary_CARCASSES_samples.txt**
* **ExpressionSummary_ALLTISSUES_samples.txt**


# 3. Gene expression normalisation

Before normalising gene expression, the ExpressionSummary.txt files were each independently merged with a .txt file containing the scaffold number of each gene, focusing on the first 25 scaffolds of the genome assembly (see manuscript for justification). This step was done in R.

(e.g. with heads again)

```ruby
## LOAD the genomic location file called trans_location25.txt
chrom_location <- read.table("~/PATH/trans_location25.txt", head=T, sep=",") # 12357 transcripts: 1274 on the X, and 11083 autosomal
head(chrom_location)
colnames(chrom_location)<-c("Transcript", "Scaffold", "chromosome") 
str(chrom_location$chromosome)
chrom_location$chromosome <- factor(chrom_location$chromosome, levels = c("A", "X"))
levels(chrom_location$chromosome)
summary(chrom_location$chromosome)

# Load non-normalised Expression_Summary file
GE_HEADS_df <- read.table("~/Documents/MECOPTERA/post_hack_check_GE/25scaffolds_032023/GE_HEADS/ExpressionSummary_HEAD_samples.txt", head=T, sep="")
head(GE_HEADS_df)
str(GE_HEADS_df)
colnames(GE_HEADS_df)<-c("gene", "MALE1", "MALE2", "MALE3", "FEM1", "FEM2", "FEM3") 
head(GE_HEADS_df)

# merge each organ file with the chromosomal location of each transcript 
HEADS_merged_GE_loc <-merge(chrom_location,GE_HEADS_df, by.x="Transcript", by.y="gene") 

# Check the new datafram
head(HEADS_merged_GE_loc)

# write file
write.table(HEADS_merged_GE_loc,"~/Documents/MECOPTERA/post_hack_check_GE/25scaffolds_032023/GE_HEADS/NonNormalised_merged_GE_25scaffolds_HEADS.txt")
```
Repeat for the other 3 ExpressionSummary.txt files and obtain the 4 following files:
* **NonNormalised_merged_GE_25scaffolds_HEADS.txt**
* **NonNormalised_merged_GE_25scaffolds_GONADS.txt**
* **NonNormalised_merged_GE_25scaffolds_CARCASSES.txt**
* **NonNormalised_merged_GE_25scaffolds_ALLTISSUES.txt**


## 3.1. GE normalisation for Spearman correlation and tissue-specific expression analyses

Use **NonNormalised_merged_GE_25scaffolds_ALLTISSUES.txt** for these analyses

Used the R package **NormalyzerDE** to apply a quantile normalisation to gene expression across the dataset: normalise the data once across samples, then calculate averages, then apply a second normalisation on these averages, then save the new file.

In R:

```ruby
# open gene expression dataset to be normalised 
expf <- read.table("NonNormalised_merged_GE_25scaffolds_ALLTISSUES.txt", head=T, sep="")
# delete the column(s) that are not GE data (eg. gene name or chromosome location)
expf_1 <- expf[, -c(1:3)]
head(expf_1)
# create a new matrix that has a number of columns and rows that match the expression gene dataset
bolFMat_1<-as.matrix(expf_1, nrow = nrow(expf_1), ncol = ncol(expf_1))

# load the data normalisation package
library(NormalyzerDE)

# run data normalisation
expf_2<-performQuantileNormalization(bolFMat_1, noLogTransform = T)

# save the matrix containing normalised data as a dataframe
expf_2<-as.data.frame(expf_2)

# reintroduce the gene name column into the dataframe
expf_2 <- data.frame(expf[, c(1:3)], expf_2)
# check that the gene names match between expf and expf_2
head(expf)
head(expf_2)

# Make GE averages per organ (heads and carcasses are not considered as sex-specific organs, males and females are therefore pulled together)
expf_2$AVG_HEADS <- rowMeans(expf_2[ ,c("MALE1_HEAD", "MALE2_HEAD", "MALE3_HEAD", "FEM1_HEAD", "FEM2_HEAD", "FEM3_HEAD")])
expf_2$AVG_TESTES <- rowMeans(expf_2[ ,c("MALE1_GONADS", "MALE2_GONADS", "MALE3_GONADS")])
expf_2$AVG_OVARIES <- rowMeans(expf_2[ ,c("FEM1_GONADS", "FEM2_GONADS", "FEM3_GONADS")])
expf_2$AVG_CARCASSES <- rowMeans(expf_2[ ,c("MALE1_CARCASS", "MALE2_CARCASS", "MALE3_CARCASS", "FEM1_CARCASS", "FEM2_CARCASS", "FEM3_CARCASS")])

#check a few variables if needed
which(is.na(expf_2$AVG_HEAD))
which(is.na(expf_2$AVG_CARCASSES))
which(is.na(expf_2$AVG_TESTES))
which(is.na(expf_2$AVG_OVARIES))

# delete the column(s) that are not GE data (eg. gene name or chromosome location)
expf_3 <- expf_2[, -c(1:21)]
head(expf_3)
# create a new matrix that has a number of columns and rows that match the expression gene dataset
bolFMat_2 <- as.matrix(expf_3, nrow = nrow(expf_3), ncol = ncol(expf_3))

# run data normalisation
expf_4 <- performQuantileNormalization(bolFMat_2, noLogTransform = T)

# save the matrix containing normalised data as a dataframe
expf_4 <- as.data.frame(expf_4)
head(expf_4)

# reintroduce the gene name column into the dataframe
expf_4 <- data.frame(expf_2[, c(1:21)], expf_4)
# check that the gene names match between expf and expf_2
head(expf_2)
head(expf_4)

# save the new dataset of normalised data
write.table(expf_4, file = "Normalised_merged_GE_25scaffolds_ALLTISSUES.txt", quote=F)
```

From the resulting file "Normalised_merged_GE_25scaffolds_ALLTISSUES.txt", we used once-normalised gene expression for each sample (columns (4:21) of the dataset) to produce the **Spearman correlation heatmap** and twice-normalised per-tissue expression averages (columns (22:25) of the dataset) for the **tissue-specific gene expression analysis**


## 3.2. GE normalisation in each tissue sperately (for POF expression and dosage compensation analyses)

Use the previously created datasets:
* **NonNormalised_merged_GE_25scaffolds_HEADS.txt**
* **NonNormalised_merged_GE_25scaffolds_GONADS.txt**
* **NonNormalised_merged_GE_25scaffolds_CARCASSES.txt**


Used the R package **NormalyzerDE** to apply a quantile normalisation to gene expression within each dataset: normalise the data once across samples, then calculate sex averages, then apply filter for TPM > 0.5, then apply a second normalisation on these averages, then save the new files.

(e.g. with heads).

In R:
```ruby
# open gene expression dataset to be normalised 
expf <- read.table("NonNormalised_merged_GE_25scaffolds_HEADS.txt", head=T, sep="")
head(expf)
# delete the column(s) that are not GE data (eg. gene name or chromosome location)
expf_1 <- expf[, -c(1:3)]
head(expf_1)
# create a new matrix that has a number of columns and rows that match the expression gene dataset
bolFMat_1<-as.matrix(expf_1, nrow = nrow(expf_1), ncol = ncol(expf_1))

# load the data normalisation package
library(NormalyzerDE)

# run data normalisation
expf_2<-performQuantileNormalization(bolFMat_1, noLogTransform = T)

# save the matrix containing normalised data as a dataframe
expf_2<-as.data.frame(expf_2)
head(expf_2)

# reintroduce the gene name column into the dataframe
expf_2 <- data.frame(expf[, c(1:3)], expf_2)
# check that the gene names match between expf and expf_2
head(expf)
head(expf_2)

# Make GE averages per sex
expf_2$MALE_AVG <- rowMeans(expf_2[ ,c("MALE1", "MALE2", "MALE3")])
expf_2$FEM_AVG <- rowMeans(expf_2[ ,c("FEM1", "FEM2", "FEM3")])

# Make sure that all these new variables are Numeric and contain no NA (although no essential due to next step)
expf_2$MALE_AVG <- as.numeric(expf_2$MALE_AVG)
which(is.na(expf_2$MALE_AVG))
expf_2$FEM_AVG <- as.numeric(expf_2$FEM_AVG)
which(is.na(expf_2$FEM_AVG))
head(expf_2)

# filter for GE > 0.5 in male and female averages
library(plyr)
library(dplyr)

expf_filtered_0.5 <- expf_2 %>% filter(MALE_AVG > 0.5, FEM_AVG > 0.5)

# Sanity checks: should all return integer(0). If not, then something went wrong with the filtering step.
which(expf_filtered_0.5$FEM_AVG < 0.5)
which(expf_filtered_0.5$MALE_AVG < 0.5)

# delete the column(s) that are not GE data (eg. gene name or chromosome location)
expf_3_0.5 <- expf_filtered_0.5[, -c(1:9)]
head(expf_3_0.5)

# create a new matrix that has a number of columns and rows that match the expression gene dataset
bolFMat_2_0.5 <- as.matrix(expf_3_0.5, nrow = nrow(expf_3_0.5), ncol = ncol(expf_3_0.5))

# run data normalisation
expf_4_0.5 <- performQuantileNormalization(bolFMat_2_0.5, noLogTransform = T)

# save the matrix containing normalised data as a dataframe
expf_4_0.5 <- as.data.frame(expf_4_0.5)

# reintroduce the gene name column into the dataframe
expf_4_0.5 <- data.frame(expf_filtered_0.5[, c(1:9)], expf_4_0.5)

# check that the gene names match between before and after the second transformation
head(expf_filtered_0.5)
head(expf_4_0.5)

# save the new dataset of normalised data
write.table(expf_4_0.5, file = "Normalised_HEADS_GE_merged_25_scaffolds_filter_0.5.txt", quote=F)
```

Repeat for the other 2 tissues. In the you obtain the 3 following files:

* **Normalised_HEADS_GE_merged_25_scaffolds_filter_0.5.txt**
* **Normalised_GONADS_GE_merged_25_scaffolds_filter_0.5.txt**
* **Normalised_CARCASSES_GE_merged_25_scaffolds_filter_0.5.txt**


For each of these 3 files: columns 3, 10 and 11 will be used for the dosage compensation analysis; and columns 4 to 9 will be used for POF gene expression analysis.
