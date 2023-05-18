Although the Pixy program developpers have written excellent guidelines on how to use Pixy to calculate nucleotide diversity (pi), here is our pipeline adapted from their code.

**In a directory, have the following files:**
* the transcriptome file **"Panorpa_transcriptome_500bp.cds"**
* the male and female  paired-end forward and reverse **fasta.gz HEADS files**


# 1. Make .bam files for each HEAD sample from the fasta read files

Slurm script:
```ruby
pico mapping_script.sh
```

Content of the script:
```ruby
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

# 2. Pixy
https://pixy.readthedocs.io/en/latest/generating_invar/generating_invar.html

## Generating AllSites VCFs using BCFtools (mpileup/call)

### Make a companion file
In a .txt file:
```ruby
184786_Male1.bam
184789_Male2.bam
184792_Male3.bam
184795_Fem1.bam
184798_Fem2.bam
184801_Fem3.bam
```

### AllSites_scripts.sh
In a slurm script:
```ruby
#load any module you need here
module load bcftools

#commands to run
bcftools mpileup -f Panorpa_transcriptome_500bp.cds -b bam_files_list.txt | bcftools call -m -Oz -f GQ -o AllSites_Panorpa_SNP.vcf
```

## SNP_calling_less_filtering.sh
In a slurm script:
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

## tabix and bgzip step 
In a slurm script:
```ruby
#modules
module load samtools

#commands
bgzip -c AllSites_Panorpa_SNP_filtered.vcf > AllSites_Panorpa_SNP_filtered.vcf.gz
tabix -p vcf AllSites_Panorpa_SNP_filtered.vcf.gz
```
## Create a companion populations.txt file

Content of the file (remember that this is TAB and not SPACE separated)
```ruby
184786_Male1.bam  male
184789_Male2.bam  male
184792_Male3.bam  male
184795_Fem1.bam female
184798_Fem2.bam female
184801_Fem3.bam female
```


## Run pixy
Content of the script:
```ruby
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

**Pixy created 3 files: pixy_output_dxy.txt, pixy_output_fst.txt and pixy_output_pi.txt**. Only **pixy_output_pi.txt** is of interest for our analysis.

# 3. Plot and stats

In R: 
```ruby
library(ggplot2)
library(ggsignif)

## Load scaffold genomic location dataset
chrom_location <- read.table("~/Documents/MECOPTERA/post_hack_check_GE/25scaffolds_032023/trans_location25.txt", head=T, sep=",") 
head(chrom_location)
# rename columns
colnames(chrom_location)<-c("Transcript","scaffold","chromosome") 
# simplify the scaffold variable
chrom_location$scaffold <- substr(chrom_location$scaffold ,10, nchar(chrom_location$scaffold))
# Make location (scaffolds) as factors
chrom_location$scaffold <- factor(chrom_location$scaffold, levels =  c("1","22","2","3","4","5","6",
                                                                       "7","8","9","10","11","12",
                                                                       "13","14","15","16","17","18",
                                                                       "19","20","21","23","24","25"))

# make chromosome as factors and re-order them so that X comes first
chrom_location$chromosome <- factor(chrom_location$chromosome, levels = c("A", "X"))

# sanity checks
str(chrom_location$chromosome)
summary(chrom_location$chromosome)


# Load pi_diversity pixy dataset
pixy_FM_df <- read.table("~/Documents/MECOPTERA/SNP_Pi_diversity/post_hack_check_2023/pixy/pixy_output_pi.txt", head=T, sep="")
head(pixy_FM_df)

# make a female subset and filter for number of sites (no_sites) >500
pixy_female <- pixy_FM_df[ which(pixy_FM_df$pop=='female' & pixy_FM_df$no_sites > 500), ]
head(pixy_female)
str(pixy_female)

# keep only essential columns: "chromosome" (which is in fact Transcript! Pixy called in chromosome) and "avg_pi"
pixy_female = pixy_female[, -c(1,3,4,6:9)]
colnames(pixy_female)<-c("Transcript", "avg_pi")
head(pixy_female)

# make a male subset and filter for number of sites (no_sites) >500
pixy_male <- pixy_FM_df[ which(pixy_FM_df$pop=='male' & pixy_FM_df$no_sites > 500), ]
head(pixy_male)
str(pixy_male)
pixy_male = pixy_male[, -c(1,3,4,6:9)]
colnames(pixy_male)<-c("Transcript", "avg_pi")
head(pixy_male)

## Merge male and female pixy dataset with chrom loc
pixy_female_loc <-merge(chrom_location, pixy_female, by.x="Transcript", by.y="Transcript")
head(pixy_female_loc)
pixy_male_loc <-merge(chrom_location, pixy_male, by.x="Transcript", by.y="Transcript")
head(pixy_male_loc)

###########################
#### Descriptive STATS ####
###########################

#### DESCRIPTIVE STATS custom function for each stratum ####
summary.by.group <- function(grouping,continuous_variable){
  summary<-rbind(
    tapply(continuous_variable, grouping, FUN = function(x) min(x, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) quantile(x,0.1, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) range(x[x > (quantile(x,0.25)-(1.5*(quantile(x,0.75)-quantile(x,0.25)))) & x < (quantile(x,0.75)+(1.5*(quantile(x,0.75)-quantile(x,0.25))))],na.rm = TRUE)[1]),
    tapply(continuous_variable, grouping, FUN = function(x) quantile(x,0.25, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) mean(x, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) median(x, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) quantile(x,0.75, na.rm=TRUE) - quantile(x,0.25, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) quantile(x,0.75, na.rm=TRUE)),
    tapply(continuous_variable, grouping, FUN = function(x) range(x[x > (quantile(x,0.25)-(1.5*(quantile(x,0.75)-quantile(x,0.25)))) & x < (quantile(x,0.75)+(1.5*(quantile(x,0.75)-quantile(x,0.25))))],na.rm = TRUE)[2]),
    tapply(continuous_variable, grouping, FUN = function(x) quantile(x,0.9, na.rm=TRUE)),       
    tapply(continuous_variable, grouping, FUN = function(x) max(x, na.rm=TRUE))
  )
  Stat <- c("Min","Q10","Low.Whisker","Q25","Mean","Median","IQR","Q75","High.Whisker","Q90","Max")
  sum.out <- data.frame(Stat,summary)
  return(sum.out)
}

# outcome DESCRIPTIVE STATS FUNCTION 
options(scipen = 999) # options(scipen = 0) # default = 0 # suppresses scientific notation

#### descriptive stats for males MALES
descriptive_stats_males <- summary.by.group( pixy_male_loc$chromosome, pixy_male_loc$avg_pi)
descriptive_stats_males

median_males_A <-descriptive_stats_males [6, 2]
median_males_A
median_males_X <-descriptive_stats_males [6, 3]
median_males_X
median_males_X/median_males_A # result: 0.1202689


#### descriptive stats for males FEMALES
descriptive_stats_females <- summary.by.group( pixy_female_loc$chromosome, pixy_female_loc$avg_pi)
descriptive_stats_females

median_females_A <- descriptive_stats_females [6, 2]
median_females_A
median_females_X <- descriptive_stats_females [6, 3]
median_females_X

median_females_X/median_females_A # result: 0.22738

### Wilcoxon tests
# FEMALES p-value 
wilcox.test(pixy_female_loc$avg_pi[which(pixy_female_loc$chromosome=="A")], pixy_female_loc$avg_pi[which(pixy_female_loc$chromosome=="X")])

# MALES p-value 
wilcox.test(pixy_male_loc$avg_pi[which(pixy_male_loc$chromosome=="A")], pixy_male_loc$avg_pi[which(pixy_male_loc$chromosome=="X")])


##########################
######## PLOTS ###########
##########################

### female plot ###
Pixy_FEM_X_A <- ggplot(pixy_female_loc, aes(x = chromosome, y = avg_pi, fill = chromosome)) +
  
  scale_fill_manual(values = c( "#969696","#ffd92f"), labels = c( 'Autosomes', 'X')) +
  
  geom_boxplot(outlier.shape = NA, notch = TRUE) + 
  
  coord_cartesian(ylim = c(0, 0.011))+
  
  ggtitle("(a) Pi-diversity")+
  xlab("genomic location") + 
  ylab(expression(bold(paste("Nucleotide diversity (", pi, ")")))) +
  
  geom_signif(comparisons = list( c("A","X")), 
              map_signif_level = TRUE,
              y_position = 0.00001, 
              vjust = .1,
              tip_length = 0.001, 
              size = 0.5, 
              textsize = 4) +
  guides(fill=FALSE)+
  
  theme(plot.margin = margin(0.2,0.5,0.5,0.2, "cm"),
        
        legend.position = c(.9, .8),
        legend.justification = c("right", "top"),
        legend.text=element_text(size=11),
        legend.title=element_blank(),
        
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "black",fill = NA,size = 1),
        panel.background = element_blank(),
        
        plot.title = element_text(hjust = 0, size=14, face = "bold"),
        
        axis.text.y = element_text(size=11),
        axis.title.y = element_text(size = 13, face ="bold"),
        
        axis.text.x = element_text(vjust = 0.2, size = 11, color = "black"),
        axis.title.x = element_text(vjust = -1, size = 13, face ="bold"))

Pixy_FEM_X_A 

#jpeg("Pi_diversity_FEM_X_A_plot.jpg", width = 2.8, height = 5, units = "in", res = 400)
#Pixy_FEM_X_A 
#dev.off()


### Male plot ###
Pixy_MALE_X_A <- ggplot(pixy_male_loc, aes(x = chromosome, y = avg_pi, fill = chromosome)) +
  
  scale_fill_manual(values = c( "#969696", "#ffd92f"), labels = c('Autosomes', 'X')) +
  
  geom_boxplot(outlier.shape = NA, notch = TRUE) + 
  
  coord_cartesian(ylim = c(0, 0.011))+
  
  ggtitle("(a) Pi-diversity")+
  xlab("genomic location") + 
  ylab(expression(bold(paste("Nucleotide diversity (", pi, ")")))) +
  
  geom_signif(comparisons = list( c("A","X")), 
              map_signif_level = TRUE,
              y_position = 0.0017, 
              vjust = .1,
              tip_length = 0.001, 
              size = 0.5, 
              textsize = 4) +
  guides(fill=FALSE)+
  
  theme(plot.margin = margin(0.2,0.5,0.5,0.2, "cm"),
        
        legend.position = c(.9, .8),
        legend.justification = c("right", "top"),
        legend.text=element_text(size=11),
        legend.title=element_blank(),
        
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "black",fill = NA,size = 1),
        panel.background = element_blank(),
        
        plot.title = element_text(hjust = 0, size=14, face = "bold"),
        
        axis.text.y = element_text(size=11),
        axis.title.y = element_text(size = 13, face ="bold"),
        
        axis.text.x = element_text(vjust = 0.2, size = 11, color = "black"),
        axis.title.x = element_text(vjust = -1, size = 13, face ="bold"))

Pixy_MALE_X_A


#jpeg("Pi_diversity_MALE_X_A_plot.jpg", width = 2.8, height = 5, units = "in", res = 400)
#Pixy_MALE_X_A 
#dev.off()



### plot all 25 scaffolds

### female plot ###
FEM_auto_median <- median(pixy_female_loc$avg_pi[which(pixy_female_loc$chromosome=="A")])
FEM_auto_median

Pixy_FEM_25_scaffolds<- ggplot(pixy_female_loc, aes(x = scaffold, y = avg_pi, fill = chromosome)) +
  
  scale_fill_manual(values = c( "#969696", "#ffd92f"), labels = c('Autosomes', 'X')) +
  
  geom_boxplot(outlier.shape = NA, notch = TRUE) + 
  
  coord_cartesian(ylim = c(0, 0.026))+
  
  ggtitle("(a) Pi-diversity - Females")+
  xlab("scaffolds") + 
  ylab(expression(bold(paste("Nucleotide diversity (", pi, ")")))) +
  guides(fill=FALSE)+
  geom_hline(yintercept = FEM_auto_median, linetype="dashed", color = "#525252", size = 0.7)+
  
  theme(plot.margin = margin(0.2,0.5,0.5,0.2, "cm"),
        
        legend.position = c(.02, .8),
        legend.justification = c("left", "top"),
        legend.text=element_text(size=11),
        legend.title=element_blank(),
        
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "black",fill = NA,size = 1),
        panel.background = element_blank(),
        
        plot.title = element_text(hjust = 0, size=14, face = "bold"),
        
        axis.text.y = element_text(size=11),
        axis.title.y = element_text(size = 13, face ="bold"),
        
        axis.text.x = element_text(vjust = 0.2, size = 9, color = "black"),
        axis.title.x = element_text(vjust = -1, size = 13, face ="bold"))

Pixy_FEM_25_scaffolds

#jpeg("Pi_diversity_FEM_25_scaffolds_plot.jpg",  width = 6, height = 5, units = "in", res = 400)
#Pixy_FEM_25_scaffolds
#dev.off()



### Male plot ###

MALE_auto_median <- median(pixy_male_loc$avg_pi[which(pixy_male_loc$chromosome=="A")])
MALE_auto_median

Pixy_MALE_25_scaffolds <- ggplot(pixy_male_loc, aes(x = scaffold, y = avg_pi, fill = chromosome)) +
  
  scale_fill_manual(values = c("#969696", "#ffd92f"), labels = c('Autosomes', 'X')) +
  
  geom_boxplot(outlier.shape = NA, notch = TRUE) + 
  
  coord_cartesian(ylim = c(0, 0.026))+
  
  ggtitle("(a) Pi-diversity - Males")+
  xlab("scaffolds") + 
  ylab(expression(bold(paste("Nucleotide diversity (", pi, ")")))) +
  guides(fill=FALSE)+
  geom_hline(yintercept = MALE_auto_median, linetype="dashed", color = "#525252", size = 0.7)+
  
  theme(plot.margin = margin(0.2,0.5,0.5,0.2, "cm"),
        
        legend.position = c(.02, .8),
        legend.justification = c("left", "top"),
        legend.text=element_text(size=11),
        legend.title=element_blank(),
        
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "black",fill = NA,size = 1),
        panel.background = element_blank(),
        
        plot.title = element_text(hjust = 0, size=14, face = "bold"),
        
        axis.text.y = element_text(size=11),
        axis.title.y = element_text(size = 13, face ="bold"),
        
        axis.text.x = element_text(vjust = 0.2, size = 9, color = "black"),
        axis.title.x = element_text(vjust = -1, size = 13, face ="bold"))

Pixy_MALE_25_scaffolds


#jpeg("Pi_diversity_MALE_25_scaffolds_plot.jpg", width = 6, height = 5, units = "in", res = 400)
#Pixy_MALE_25_scaffolds
#dev.off()

detach(package:ggplot2,unload=TRUE)
detach(package:ggsignif,unload=TRUE)
```

