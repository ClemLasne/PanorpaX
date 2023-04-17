### Generate consensus from raw bam file:

The first step is to generate the fastq file of the consensus reads from the raw reads using the CCS tool:
```
module load anaconda3/2022.05
source ~/anaconda3/2022.05/activate_anaconda3_2022.05.txt
conda activate pbccs
ccs --minLength=100 ~/r64046_20230118_140133_C02/m64046_230121_101921.subreads.bam ccs.fastq.gz -j 40
conda deactivate
```
### Assemble the reads using hifiasm:

```
module load hifiasm
hifiasm  -t 100 -o panorpa_cognata.asm ccs.fastq.gz -D 10.0 -N 200
```
### Purge haplotigs
```
module load python/3.7

export PATH=~/minimap2/minimap2:$PATH

~/minimap2/minimap2 -t 50 -xmap-pb panorpa_cognata.asm.bp.p_ctg.fasta ccs.fastq.gz | gzip -c - > panorpa_cognata.asm.bp.p_ctg.paf.gz
~/purge_dups/bin/pbcstat *.paf.gz
~/purge_dups/bin/calcuts PB.stat > cutoffs 2>calcults.log
~/purge_dups/bin/split_fa panorpa_cognata.asm.bp.p_ctg.fasta  > panorpa_cognata.asm.bp.p_ctg.fasta.split
~/minimap2/minimap2 -t 50 -xasm5 -DP panorpa_cognata.asm.bp.p_ctg.fasta.split panorpa_cognata.asm.bp.p_ctg.fasta.split | gzip -c - > panorpa_cognata.asm.bp.p_ctg.fasta.split.self.paf.gz
~/purge_dups/bin/purge_dups -2 -T cutoffs -c PB.base.cov panorpa_cognata.asm.bp.p_ctg.fasta.split.self.paf.gz > dups.bed 2> purge_dups.log
~/purge_dups/bin/get_seqs -e dups.bed panorpa_cognata.asm.bp.p_ctg.fasta
```
### Hi-C pro
config file 
```
# Please change the variable settings below if necessary

#########################################################################
## Paths and Settings  - Do not edit !
#########################################################################

TMP_DIR = tmp
LOGS_DIR = logs
BOWTIE2_OUTPUT_DIR = bowtie_results
MAPC_OUTPUT = hic_results
RAW_DIR = rawdata

#######################################################################
## SYSTEM - PBS - Start Editing Here !!
#######################################################################
N_CPU = 40
LOGFILE = hicpro.log
JOB_NAME = IMR90_split
JOB_MEM = 200GB
JOB_WALLTIME = 240:00:00
JOB_QUEUE = gpu
JOB_MAIL = melkrewi@ist.ac.at

#########################################################################
## Data
#########################################################################

PAIR1_EXT = _R1_001
PAIR2_EXT = _R2_001

#######################################################################
## Alignment options
#######################################################################

FORMAT = phred33
MIN_MAPQ = 0

BOWTIE2_IDX_PATH = /nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/64.hifiasm_ultralong/purge/hic-pro/
BOWTIE2_GLOBAL_OPTIONS = --very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder
BOWTIE2_LOCAL_OPTIONS =  --very-sensitive -L 20 --score-min L,-0.6,-0.2 --end-to-end --reorder

#######################################################################
## Annotation files
#######################################################################

REFERENCE_GENOME = purged.fa
GENOME_SIZE = /nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/64.hifiasm_ultralong/purge/hic-pro/purged.fa.length

#######################################################################
## Allele specific
#######################################################################

ALLELE_SPECIFIC_SNP = 

#######################################################################
## Digestion Hi-C
#######################################################################

GENOME_FRAGMENT = /nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/64.hifiasm_ultralong/purge/hic-pro/purged_digest.bed
LIGATION_SITE = GATCGATC,GANTGATC,GATCANTC,GANTANTC
MIN_FRAG_SIZE = 
MAX_FRAG_SIZE = 
MIN_INSERT_SIZE = 
MAX_INSERT_SIZE = 

#######################################################################
## Hi-C processing
#######################################################################

MIN_CIS_DIST =
GET_ALL_INTERACTION_CLASSES = 1
GET_PROCESS_SAM = 1
RM_SINGLETON = 1
RM_MULTI = 1
RM_DUP = 1

#######################################################################
## Contact Maps
#######################################################################

BIN_SIZE = 50000 100000 200000 300000 500000 700000 1000000
MATRIX_FORMAT = upper

#######################################################################
## ICE Normalization
#######################################################################
MAX_ITER = 100
FILTER_LOW_COUNT_PERC = 0.02
FILTER_HIGH_COUNT_PERC = 0
EPS = 0.1
```
Commands:
```
module load java
module load python
module load R
module load bowtie2
module load samtools
export PATH=/nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/31.EndHiC/here/HiC-Pro_3.1.0/:$PATH

/nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/31.EndHiC/here/HiC-Pro_3.1.0/bin/utils/digest_genome.py -r ^GATC G^ANTC -o purged_digest.bed purged.fa
bowtie2-build purged.fa purged.fa
/nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/31.EndHiC/here/HiC-Pro_3.1.0/bin/HiC-Pro -i /nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/64.hifiasm_ultralong/purge/hic-pro/read_2/ -o output/ -c config_test_latest.txt
```

### Matlock
```
module load anaconda3/2022.05
source /mnt/nfs/clustersw/Debian/bullseye/anaconda3/2022.05/activate_anaconda3_2022.05.txt
conda activate matlock
/nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/28.matlock/matlock/bin/matlock bamfilt -e 0 -m 0 -i 184468_S1_purged_N80.fa.bwt2pairs_interaction_filtered.bam -o 184468_S1_purged_N80.fa.bwt2pairs_interaction_filtered_matlock_0_edit.bam 
```
### YaHS
```
/nfs/scistore18/vicosgrp/melkrewi/panorpa_assembly_v2/44.YaHS_1.2/yahs-1.2a.1.patch/yahs purged_N80.fa 184468_S1_purged_N80.fa.bwt2pairs_interaction_filtered_matlock_0_edit.bam -q 0 --no-contig-ec -r 200000,300000,400000,450000,500000,600000,700000,800000,900000,1000000,1100000,1200000,1500000,2000000,2500000,3000000
```
