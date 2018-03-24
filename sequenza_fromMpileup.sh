#!/bin/bash

normalPileup=$1
tumorPileup=$2
sampleName=$3
#reference=$4

# create seqz file from the two mpileups
echo pileup2seqz
sequenza-utils bam2seqz -gc /home/users/data/01_reference/human_g1k_v37/human_g1k_v37_noM.gc50Base.txt.gz -n $normalPileup -t $tumorPileup -p -o  $sampleName.seqz
wait
# binning
echo binning
sequenza-utils seqz_binning --window 100 --seqz $sampleName.seqz -o $sampleName.comp.seqz 

# remove unwanted contigs in reference fasta
echo mtglremove
cat $sampleName.comp.seqz | grep -v MT | grep -v GL > $sampleName.comp.seqz.rmGLMT

# gzip 
echo gzip
gzip $sampleName.comp.seqz.rmGLMT

# Run sequenza
echo Run Sequenza
Rscript run_sequenza.R --seqz_file $sampleName.comp.seqz.rmGLMT -o . -s $sampleName

echo done 
# cleanup
rm $normalBam.mpileup.gz $tumorBam.mpileup.gz $sampleName.seqz $sampleName.comp.seqz  
