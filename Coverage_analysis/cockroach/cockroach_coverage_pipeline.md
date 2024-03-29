Blatella germanica genome:
```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/762/945/GCA_000762945.2_Bger_2.0/GCA_000762945.2_Bger_2.0_genomic.fna.gz
gzip -d GCA_000762945.2_Bger_2.0_genomic.fna.gz  
```
## Download female and male reads
Reads from paper (https://doi.org/10.1186/s12915-019-0721-x)

- Male reads: SRR1566154, SRR1566155, SRR1566159
- Female read: SRR1566152

Other reads found on NCBI:
- Male reads: SRR9160163, SRR9160164
- Female reads: SRR9160166, SRR9160167, SRR9160168, SRR9160165

```
module load SRA-Toolkit/2.8.1-3
srun fastq-dump --skip-technical --readids --split-files SRR1566154
srun fasterq-dump SRR1566155
srun fasterq-dump SRR1566159
srun fasterq-dump SRR1566152
srun fastq-dump --skip-technical --readids --split-files SRR9160163
srun fastq-dump --skip-technical --readids --split-files SRR9160164
srun fastq-dump --skip-technical --readids --split-files SRR9160166
srun fastq-dump --skip-technical --readids --split-files SRR9160167
srun fastq-dump --skip-technical --readids --split-files SRR9160168
wget https://sra-pub-sars-cov2.s3.amazonaws.com/sra-src/SRR9160165/Blatella_germanica_WT_6_female_heads_AGTATAGCGC_L007_R1_001.fastq.1
wget https://sra-pub-sars-cov2.s3.amazonaws.com/sra-src/SRR9160165/Blatella_germanica_WT_6_female_heads_AGTATAGCGC_L007_R2_001.fastq.1

```
## Index genome and map reads to it
```
module load bowtie2/2.4.5
srun bowtie2-build GCA_000762945.2_Bger_2.0_genomic.fna BlatGenome
srun bowtie2 -x BlatGenome -1 SRR1566152_1.fastq -2 SRR1566152_2.fastq --end-to-end --sensitive -p 50 -S Female.sam
srun bowtie2 -x BlatGenome -1 SRR1566154_1.fastq -2 SRR1566154_2.fastq --end-to-end --sensitive -p 50 -S Male54.sam
srun bowtie2 -x BlatGenome -1 SRR1566155_1.fastq -2 SRR1566155_2.fastq --end-to-end --sensitive -p 50 -S Male55.sam
srun bowtie2 -x BlatGenome -1 SRR1566159_1.fastq -2 SRR1566159_2.fastq --end-to-end --sensitive -p 50 -S Male59.sam
srun bowtie2 -x BlatGenome -1 SRR9160163_1.fastq -2 SRR9160163_2.fastq  --end-to-end --sensitive -p 50 -S Male63.sam
srun bowtie2 -x BlatGenome -1 SRR9160164_1.fastq -2 SRR9160164_2.fastq  --end-to-end --sensitive -p 50 -S Male64.sam
SRR9160166_1.fastq -2 SRR9160166_2.fastq  --end-to-end --sensitive -p 50 -S Female66.sam
srun bowtie2 -x BlatGenome -1 SRR9160167_1.fastq -2 SRR9160167_2.fastq  --end-to-end --sensitive -p 50 -S Female67.sam
srun bowtie2 -x BlatGenome -1 SRR9160168_1.fastq -2 SRR9160168_2.fastq  --end-to-end --sensitive -p 50 -S Female68.sam
srun bowtie2 -x BlatGenome -1 Blatella_germanica_WT_6_female_heads_AGTATAGCGC_L007_R1_001.fastq.1 -2 Blatella_germanica_WT_6_female_heads_AGTATAGCGC_L007_R2_001.fastq.1 --end-to-end --sensitive -p 50 -S Female65.sam
```
## Coverage for every individual
```
## the two data sets were in different directories*
module load soap/coverage
srun soap.coverage -sam -cvg -i Female.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Female.soapcov
srun soap.coverage -sam -cvg -i Male54.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male54.soapcov
srun soap.coverage -sam -cvg -i Male55.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male55.soapcov
srun soap.coverage -sam -cvg -i Male59.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male59.soapcov
srun soap.coverage -sam -cvg -i Female65.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Female65.soapcov
srun soap.coverage -sam -cvg -i Male54.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male54.soapcov
srun soap.coverage -sam -cvg -i Male55.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male55.soapcov
srun soap.coverage -sam -cvg -i Male59.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male59.soapcov
srun soap.coverage -sam -cvg -i Male63.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male63.soapcov
srun soap.coverage -sam -cvg -i Male64.sam -onlyuniq -p 50 -refsingle ~/GCA_000762945.2_Bger_2.0_genomic.fna -o Male64.soapcov

```
Clean files

