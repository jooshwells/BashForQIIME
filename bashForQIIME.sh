#!/bin/bash
# Script to enable ease of use of QIIME2 pipeline
# Written by Joshua Wells
# Latest Update: 5/24/2024

echo -e "Welcome to Bash for QIIME."

echo -e "Please enter a name for the folder for this session: "
read dirname
mkdir $dirname

echo -e "Please enter the name of your metadata file (CASE SENSITIVE): "
read metadata

# Will need to change this for more general use, moving pictures tutorial used as template
mkdir emp-single-end-sequences
echo -e "Enter the name of your barcodes file: "
read barcodes
echo -e "Enter the name of your sequences file: "
read seqs
echo -e "Please enter a name to use for the demultiplexed sequence file (include the file type as ".qza"): "
read demux
echo -e "Please enter a name to use for the demultiplexed sequence details file (include the file type as ".qza"): "
read demux_details
echo -e "Please enter a name to use for the demultiplexed sequence visualization (include the file type as a ".qzv"): "
read demux_vis

qiime tools import --type EMPSingleEndSequences --input-path emp-single-end-sequences --output-path emp-single-emd-sequences.qza


qiime demux emp-single --i-seqs emp-single-end-sequences.qza --m-barcodes-file $metadata --m-barcodes-column barcode-sequence ooo-per-sample-sequences $demux --o-error-correction-details $demux_details

qiime demux summarize --i-data $demux --o-visualization $demux_vis
cp $demux_vis /mnt/c/users/mjbea/onedrive/desktop

echo -e "The demultiplexed sequence visualization has been copied to your desktop for ease of viewing."
echo -e "After viewing this visualization, how many bases wo

