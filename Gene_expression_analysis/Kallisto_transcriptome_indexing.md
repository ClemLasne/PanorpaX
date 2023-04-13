First rename Panorpa_transcriptome_500bp.cds to Panorpa_transcriptome_500bp.fa and then zip it for Kallisto indexing.

**We used Kallisto version 0.46.2**

```ruby
#load any module you need here
module load kallisto

#command
srun kallisto index -i indexed_panorpa500_transcriptome.idx Panorpa_transcriptome_500bp.fa.gz
```
File produced: "indexed_panorpa500_transcriptome.idx"
