#!/bin/bash
# March 14 2018, Chris Yoon (cjyoon@kaist.ac.kr)

normalBam=$1
tumorBam=$2
sampleName=$3
reference=$4

# create mpileup for each
for bam in $normalBam $tumorBam; 
#do sambamba mpileup -t 10 $bam --samtools  -B -Q 20 -q 20 -f $reference | gzip 1> $bam.mpileup.gz
do samtools mpileup -B -Q 20 -q 20 -f $reference $bam | gzip -f 1> $bam.mpileup.gz & 
done
wait
# prepare for smoothened CNV
echo smoothened CNV prep
/usr/bin/python /home/users/sypark/03_Tools/Smoothened_CN/01_get_coverage.py $normalBam.mpileup.gz & 
/usr/bin/python /home/users/sypark/03_Tools/Smoothened_CN/01_get_coverage.py $tumorBam.mpileup.gz 

# create seqz file from the two mpileups
echo pileup2seqz
sequenza-utils bam2seqz -gc /home/users/data/01_reference/human_g1k_v37/human_g1k_v37.gc50Base.txt.gz -n $normalBam.mpileup.gz -t $tumorBam.mpileup.gz -p -o  $sampleName.seqz
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
Rscript run_sequenza.R --seqz_file $sampleName.comp.seqz.rmGLMT.gz -o . -s $sampleName

# cleanup
#rm $normalBam.mpileup.gz $tumorBam.mpileup.gz $sampleName.seqz $sampleName.comp.seqz  

