# Prepare and Run Sequenza from Bam file
Will create mpileup files from both tumor and normal using 2-cores, create necessary files that are needed for `Sequenza` and run R script that will run `Sequenza` on a command line interphase. 

## From Bam file usage
```bash
sh sequenza_fromBam.sh <normal.bam> <tumor.bam> <sampleName> <reference.fasta>
```
This command will generate all sequenza input files, and output files in the current working directory with prefix as <sampleName>. 


## From mpileup file usage
For whatever reason, if an mpileup file already exists, and there's no need to re-generate bamfile, one can use the following command instead. 
```bash
sh sequenza_fromMpileup.sh <normal.pileup> <tumor.pileup> <sampleName>

## From seqz file usage
For whatever reason, if you already have a seqz file to be used for `Sequenza` you can use the following script
```bash
Rscript run_sequenza.R --seqz_file <seqzFile> --output_dir <output_dir> --sample_name <sampleName>
```
