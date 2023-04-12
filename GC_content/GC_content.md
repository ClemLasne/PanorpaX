### Get GC content for windows of 1000 bp

The GC content was calculated used [GCcalc.py](https://github.com/WenchaoLin/GCcalc)
```
GCcalc.py -f yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa -w 1000 > GC_content_1000_1000.txt
```
The boxplot for all the longest 25 scaffolds was made using the following script:
```
library(tidyverse)
library(ggplot2)
GC_content <- read.table("GC_content_1000_1000.txt", head=F, sep="\t")
GC_content_25 <- GC_content %>% filter(V1 %in% c('scaffold_1','scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_22','scaffold_23','scaffold_24','scaffold_25'))
GC_content_25$chromosome <- with(GC_content_25, ifelse(V1 == 'scaffold_1' | V1 == 'scaffold_22' , 'X-linked', 'Autosomal'))
GC_content_autosomal <- GC_content %>% filter(V1 %in% c('scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_23','scaffold_24','scaffold_25'))
GC_content_25$V1 <- factor(GC_content_25$V1,c('scaffold_1','scaffold_22','scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_23','scaffold_24','scaffold_25'))
GC_plot <- ggplot(GC_content_25, aes(x = V1, y = V4, fill = chromosome)) +
  scale_fill_manual(values = c( "#969696","#ffd92f"), labels = c('Autosomal', 'X-linked')) +

  geom_boxplot(outlier.shape = NA, notch = TRUE) + 
  scale_x_discrete(labels=c('1','22','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','23','24','25'))+
  coord_cartesian(ylim = c(0.15, 0.5))+
  ggtitle("(c)")+
  xlab("Scaffolds") + 
  ylab("GC content (1000 bp windows)") +
  
  geom_hline(yintercept = median(GC_content_autosomal$V4), linetype="dashed", color = "black", size = 0.7)+
  
  theme(legend.position = c(.02, .99),
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
        axis.title.y = element_text(margin=margin(r=7), size = 13, face ="bold"),
        
        axis.text.x = element_text(vjust = 0.2, size = 11, color = "black"),
        axis.title.x = element_text(vjust = -1, size = 13, face ="bold"))
jpeg("GC_plot.jpg", width = 10, height = 3, units = "in", res = 400)
GC_plot
dev.off()
```
The boxplot for the X-linked vs autosomal scaffolds was made using the following script:
```
library(tidyverse)
library(ggplot2)
library(ggsignif)
GC_content <- read.table("GC_content_1000_1000.txt", head=F, sep="\t")
GC_content_25 <- GC_content %>% filter(V1 %in% c('scaffold_1','scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_22','scaffold_23','scaffold_24','scaffold_25'))
GC_content_25$chromosome <- with(GC_content_25, ifelse(V1 == 'scaffold_1' | V1 == 'scaffold_22' , 'X', 'A'))
GC_content_autosomal <- GC_content %>% filter(V1 %in% c('scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_23','scaffold_24','scaffold_25'))
GC_content_X <- GC_content %>% filter(V1 %in% c('scaffold_1','scaffold_22'))
GC_content_25$V1 <- factor(GC_content_25$V1,c('scaffold_1','scaffold_22','scaffold_2','scaffold_3','scaffold_4','scaffold_5','scaffold_6','scaffold_7','scaffold_8','scaffold_9','scaffold_10','scaffold_11','scaffold_12','scaffold_13','scaffold_14','scaffold_15','scaffold_16','scaffold_17','scaffold_18','scaffold_19','scaffold_20','scaffold_21','scaffold_23','scaffold_24','scaffold_25'))
GC_content_25$chromosome <- factor(GC_content_25$chromosome , levels=c("X", "A"))
GC_plot <- ggplot(GC_content_25, aes(x = chromosome, y = V4, fill = chromosome)) +
  scale_fill_manual(values = c( "#ffd92f","#969696"), labels = c('X-linked', 'Autosomes')) +

  geom_boxplot(outlier.shape = NA, notch = TRUE) + 
  #scale_x_discrete(labels=c('1','22','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','23','24','25'))+
  coord_cartesian(ylim = c(0.15, 0.5))+
  ggtitle("(c)")+
  xlab("Scaffolds") + 
  ylab("GC content (1000 bp windows)") +
  geom_signif(
    y_position = c(0.43), xmin = c(1), xmax = c(2),
    annotation = c("***"), tip_length = 0.01
  ) +
  #geom_hline(yintercept = median(GC_content_autosomal$V4), linetype="dashed", color = "black", size = 0.7)+
  
  theme(legend.position = c(.02, .99),
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
        axis.title.y = element_text(margin=margin(r=7), size = 13, face ="bold"),
        
        axis.text.x = element_text(vjust = 0.2, size = 11, color = "black"),
        axis.title.x = element_text(vjust = -1, size = 13, face ="bold"))
jpeg("GC_plot_simple.jpg", width = 3, height = 7, units = "in", res = 400)
GC_plot
dev.off()
wilcox.test(GC_content_autosomal$V4,GC_content_X$V4) 
```




