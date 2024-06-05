#!/bin/bash
# Script to enable ease of use of QIIME2 pipeline
# Written by Joshua Wells
# Latest Update: 5/24/2024

echo -e "Welcome to Bash for QIIME."

echo -e "Please ensure that all sample files have been placed into the QIIME Input folder on the desktop: "
sampleloc = /mnt/c/users/mjbea/onedrive/desktop/QIIME_Input

for file in "$sampleloc"/*; do
  if [ -f "$file" ]; then
    echo "$file"
  fi
done

# Need to prompt user for sample file names so that they may be renamed to the .fastq format

#gzip *.fastq