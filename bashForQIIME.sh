#!/bin/bash
# Script to enable ease of use of QIIME2 pipeline
# Written by Joshua Wells
# Latest Update: 6/20/2024

echo -e "Welcome to Bash for QIIME."

echo -e "Please ensure that all fastq and metadata files have been placed in the appropriate directories in the QIIME Input folder on the desktop."

echo -e "Enter a name for the working directory for this project: "
read dirname
mkdir $dirname 

echo -e "Enter a prefix for all generated files for this project (Files will be named Prefix-description.qza/v): "
read prefix

echo -e "What classifier would you like to use? Enter '1' for GreenGenes515f806r, '2' for GreenGenesFullLength, or '3' for Silva138"
read classifierchoice

if [ "$classifierchoice" == "1" ]; then
  classifierchoice=#PATH_TO_PROGRAM_DIRECTORY/bashForQIIME/Classifiers/GreenGenes515f806rClassifier.qza
fi

if [ "$classifierchoice" == "2" ]; then
  classifierchoice=#PATH_TO_PROGRAM_DIRECTORY/bashForQIIME/Classifiers/GreenGenesFullLengthClassifier.qza
fi

if [ "$classifierchoice" == "3" ]; then
  classifierchoice=#PATH_TO_PROGRAM_DIRECTORY/bashForQIIME/Classifiers/Silva138Classifier.qza
fi

# insert path of your samples and metadata here
sampleloc=#YOUR PATH HERE
metadataloc=#YOUR PATH HERE

# this copies over the metadata file from the QIIME_Input folder into the working directory
for file in "$metadataloc"/*; do
  if [ -f "$file" ]; then
    cp $file #YOUR_PATH/$dirname/$prefix-metadata.tsv
  fi
done

# this runs the renaming program on the files in the QIIME_Input folder
gcc rename.c
for file in "$sampleloc"/*; do
  if [ -f "$file" ]; then
    curfile=$(./a.out <<< $file -n 1)
    cp $file #YOUR_PATH/$dirname/$curfile
  fi
done

cd $dirname
gzip *.fastq # zip up files

# make new directory and move zipped files
# over to it
mkdir datafolder 
mv *.gz datafolder

# import all files in datafolder into qiime 
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path datafolder \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $prefix-paired-demux.qza

# Create visualization for read quality and move it to Output folder on desktop
qiime demux summarize \
  --i-data $prefix-paired-demux.qza \
  --o-visualization $prefix-paired-demux.qzv

mv $prefix-paired-demux.qzv #YOUR_OUTPUT_PATH

# Take input for denoising parameters
echo -e "Please take a moment to analyze the paired-demux visualization that was moved to the output folder on the desktop."

echo -e "Enter a value to be used for --p-trim-left-f: "
read trim_left_f

echo -e "Enter a value to be used for --p-trim-left-r: "
read trim_left_r

echo -e "Enter a value to be used for --p-trunc-len-f: "
read trunc_len_f

echo -e "Enter a value to be used for --p-trunc-len-r: "
read trunc_len_r

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $prefix-paired-demux.qza \
  --p-trim-left-f $trim_left_f \
  --p-trim-left-r $trim_left_r \
  --p-trunc-len-f $trunc_len_f \
  --p-trunc-len-r $trunc_len_r \
  --o-table $prefix-table.qza \
  --o-representative-sequences $prefix-rep-seqs.qza \
  --o-denoising-stats $prefix-denoising-stats.qza

qiime feature-table summarize \
  --i-table $prefix-table.qza \
  --o-visualization $prefix-table.qzv \
  --m-sample-metadata-file $prefix-metadata.tsv \

cd $dirname

# Convert qza into biom file
qiime tools export \
  --input-path $prefix-table.qza \
  --output-path $prefix-table

cd $prefix-table
biom convert -i feature-table.biom -o feature-table.tsv --to-tsv
mv feature-table.tsv #PROGRAM_HOME_DIRECTORY
cd ..
cd ..

# Compile and run C program to get minimum sampling depth
gcc samplingdepth.c
sampling_depth=$(./a.out)
cd $dirname

qiime feature-table tabulate-seqs \
  --i-data $prefix-rep-seqs.qza \
  --o-visualization $prefix-rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file $prefix-denoising-stats.qza \
  --o-visualization $prefix-denoising-stats.qzv

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences $prefix-rep-seqs.qza \
  --o-alignment $prefix-aligned-rep-seqs.qza \
  --o-masked-alignment $prefix-masked-alignment-rep-seqs.qza \
  --o-tree $prefix-unrooted-tree.qza \
  --o-rooted-tree $prefix-rooted-tree.qza

# Will grab sampling depth from -table.qzv
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny $prefix-rooted-tree.qza \
  --i-table $prefix-table.qza \
  --p-sampling-depth $sampling_depth \
  --m-metadata-file $prefix-metadata.tsv \
  --output-dir $prefix-core-metrics-results

qiime feature-classifier classify-sklearn \
  --i-classifier $classifierchoice \
  --i-reads $prefix-rep-seqs.qza \
  --o-classification $prefix-taxonomy.qza

qiime metadata tabulate \
  --m-input-file $prefix-taxonomy.qza \
  --o-visualization $prefix-taxonomy.qzv

qiime taxa barplot \
  --i-table $prefix-table.qza \
  --i-taxonomy $prefix-taxonomy.qza \
  --m-metadata-file $prefix-metadata.tsv \
  --o-visualization $prefix-taxa-bar-plots.qzv

# Done!
cd datafolder
mv * #YOUR_OUTPUT_PATH
cd ..
rm -r datafolder

cd $prefix-table
mv * #YOUR_OUTPUT_PATH
cd ..
rm -r $prefix-table

mv * #YOUR_OUTPUT_PATH
cd ..
rm feature-table.tsv

rm -r $dirname
