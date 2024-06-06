#!/bin/bash
# Script to enable ease of use of QIIME2 pipeline
# Written by Joshua Wells
# Latest Update: 6/6/2024

echo -e "Welcome to Bash for QIIME."

echo -e "Please ensure that all sample files have been placed into the QIIME Input folder on the desktop: "

# insert path of your samples here
sampleloc=/mnt/c/users/mjbea/onedrive/desktop/QIIME_Input

# this runs the renaming program on the files in the QIIME_Input folder
gcc rename.c
for file in "$sampleloc"/*; do
  if [ -f "$file" ]; then
    curfile=$(./a.out <<< $file -n 1)
    cp $file /home/frank/bashForQIIME/$curfile
  fi
done

gzip *.fastq # zip up files

# make new directory and move zipped files
# over to it
mkdir datafolder 
mv *.gz datafolder

# import all files in datafolder into qiime 
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path datafolder \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path newfile-paired-demux.qza
