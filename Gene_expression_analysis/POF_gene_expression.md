In R:
```ruby
### 1. load packages
library(tidyverse)
library(ggplot2)

### 2. load datasets

# loads HAEDS dataset
GE_heads<- read.table("~/PATH/Normalised_HEADS_GE_25scaf_no_TPM_filtering.txt", head=T, sep="")
head(GE_heads)
str(GE_heads) 
str(GE_heads[GE_heads$Transcript == "TRINITY_DN1501_c0_g2_i2",])

# load CARCASSES dataset
GE_carcasses <- read.table("~/PATH/Normalised_CARCASSES_GE_25scaf_no_TPM_filtering.txt", head=T, sep="")
head(GE_carcasses)
str(GE_carcasses) 
str(GE_carcasses[GE_carcasses$Transcript == "TRINITY_DN1501_c0_g2_i2",])

# laod GONADS dataset
GE_gonads<- read.table("~/PATH/Normalised_GONADS_GE_25scaf_no_TPM_filtering.txt", head=T, sep="")
head(GE_gonads)
str(GE_gonads) 
str(GE_gonads[GE_gonads$Transcript == "TRINITY_DN1501_c0_g2_i2",])


### 3. Merge datasets 

# put all data frames into list
df_list <- list(GE_heads, GE_gonads, GE_carcasses)      

# merge all data frames together
merged_df <- df_list %>% reduce(full_join, by='Transcript')
str(merged_df[merged_df$Transcript == "TRINITY_DN1501_c0_g2_i2",])

### 4. Subset for POF transcript only

POF <- gather(merged_df[merged_df$Transcript == "TRINITY_DN1501_c0_g2_i2", 2:ncol(merged_df)], key="sample", value="gene_exp" ) # key and value are the by-default names given to the columns by the function
POF


### 5. add sex variable

POF$sex <- c("MALE","MALE","MALE",
             "FEMALE","FEMALE","FEMALE",
             "MALE","MALE","MALE",
             "FEMALE","FEMALE","FEMALE",
             "MALE","MALE","MALE",
             "FEMALE","FEMALE","FEMALE")
POF


### 6. organise samples before plotting

POF$sample <- factor(POF$sample, levels = c("head_F1", "head_F2","head_F3",
                                            "head_M1","head_M2","head_M3",
                                            "ovaries1","ovaries2","ovaries3",
                                            "testes1","testes2","testes3",
                                            "carcass_F1","carcass_F2","carcass_F3",
                                            "carcass_M1","carcass_M2","carcass_M3"))


### 7. Plot

PLOT <- ggplot(POF, aes(x=sample, y=log2(gene_exp+1), fill = sex)) + 
  
  scale_fill_manual(values = c("#00718B","#7CCBA2"), labels = c('FEMALE', 'MALE')) +
  
  geom_bar(stat = "identity") +
  ylab("Log2 (TPM+1)") +
  xlab("Sample") +

theme(
  legend.position = c(.99, .99),
  legend.justification = c("right", "top"),
  legend.text = element_text(size=12),
  legend.title = element_blank(),
  
  axis.line = element_line(colour = "black"),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.border = element_rect(color = "black",fill = NA,size = 1),
  panel.background = element_blank(),
  
  plot.title = element_text(hjust = 0, size=14, face = "bold"),
  
  axis.text.y = element_text(size=12),
  axis.title.y = element_text(margin=margin(r=3), size = 13, face ="bold"),
  
  axis.text.x = element_text(vjust = 0.2, angle=90, hjust=1, size = 12, face ="bold", color = "black"),
  axis.title.x = element_text(size = 13, face ="bold"))

PLOT

#To save the plot in high quality on computer:
#jpeg("POF_plot.jpg", width = 8, height = 5, units = "in", res = 400)
#PLOT
#dev.off()


### 8. detach packages
detach("package:tidyverse", unload=TRUE)
detach("package:ggplot2", unload=TRUE)
``` 
