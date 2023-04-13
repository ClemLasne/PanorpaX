Indexing genome and mapping females reads to it to generate the SAM files to be used later on for the coverage analysis:
```
module load bowtie2/2.4.5
srun bowtie2-build yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa ScorpGenome
srun bowtie2 -x ScorpGenome -1 /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/199208_S1_L003_R1_001.fastq.gz -2 /nfs/scistore1
8/vicosgrp/llayanaf/Scorpionflies/199208_S1_L003_R2_001.fastq.gz --end-to-end --sensitive -p 100 -S Female.sam
srun bowtie2 -x ScorpGenome -1 /nfs/scistore18/vicosgrp/llayanaf/Scorpionflies/199205_S2_L003_R1_001.fastq.gz -2 /nfs/scistore1
8/vicosgrp/llayanaf/Scorpionflies/199205_S2_L003_R2_001.fastq.gz --end-to-end --sensitive -p 100 -S Male.sam
```
Clean and merge files for scaffolded coverage analysis:
```
cat Female.soapcov | awk '{print $1, $2, $4}' | perl -pi -e 's/:.*\// /gi' | perl -pi -e 's/Depth://gi' | sort > Female.soapfinal
cat Male.soapcov | awk '{print $1, $2, $4}' | perl -pi -e 's/:.*\// /gi' | perl -pi -e 's/Depth://gi' | sort > Male.soapfinal
join Female.soapfinal Male.soapfinal | perl -pi -e 's/^\n.*//gi' > FemaleMale.soapfinal
```
Window-based covege:

```
module load soap/coverage
srun soap.coverage -sam -cvg -i Female.sam -onlyuniq -p 100 -refsingle yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa -window Female.soapcov 10000
srun soap.coverage -sam -cvg -i Male.sam -onlyuniq -p 100 -refsingle yahs.out_scaffolds_final_hicpro_multimapping_matlock_0_13_03_2023.fa -window Male.soapcov 10000 
```
Clean and merge files for window-based coverage analysis:
```
cat Female.soapcov | awk '{print $1, $2, $4}' | perl -pi -e 's/:.*\// /gi' | perl -pi -e 's/Depth://gi' | sort > Female.soapfinal
cat Male.soapcov | awk '{print $1, $2, $4}' | perl -pi -e 's/:.*\// /gi' | perl -pi -e 's/Depth://gi' | sort > Male.soapfinal
join Female.soapfinal Male.soapfinal | perl -pi -e 's/^\n.*//gi' > FemaleMale.soapfinal
```
