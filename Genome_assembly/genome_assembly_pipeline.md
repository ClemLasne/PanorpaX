### Generate consensus from raw bam file:

The first step is to generate the fastq file of the consensus reads from the raw reads using the CCS tool:
```
module load anaconda3/2022.05
source ~/anaconda3/2022.05/activate_anaconda3_2022.05.txt
conda activate pbccs
ccs --minLength=100 ~/r64046_20230118_140133_C02/m64046_230121_101921.subreads.bam ccs.fastq.gz -j 40
conda deactivate
```

