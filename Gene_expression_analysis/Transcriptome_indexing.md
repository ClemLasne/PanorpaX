We first rename Panorpa_transcriptome_500bp.cds to Panorpa_transcriptome_500bp.fa and then gunzip it for Kallisto indexing.

**We used Kallisto version**

```ruby
#load any module you need here
module load kallisto

srun kallisto index -i indexed_panorpa500_transcriptome.idx Panorpa_transcriptome_500bp.fa.gz
```