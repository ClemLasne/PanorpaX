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

### Matlock

### YaHS
