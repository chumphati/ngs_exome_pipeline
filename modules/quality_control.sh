#!/bin/bash

RAW_FASTQ="results/FASTQ/RAW"
FILTERED_FASTQ="results/FASTQ/FILTERED"
RAW_FASTQC="results/QUALITY_CONTROL/RAW_FASTQ"
FILTERED_FASTQC="results/QUALITY_CONTROL/FILTERED_FASTQ"

echo "Quality control (fastqc) ............................. 0%"

#créer le répertoire si nécessaire
if [ ! -d $RAW_FASTQC ];then
  mkdir -p $RAW_FASTQC
fi
if [ ! -d $FILTERED_FASTQC ];then
  mkdir -p $FILTERED_FASTQC
fi

fastqc -o $RAW_FASTQC $RAW_FASTQ/* > /dev/null 2>&1
echo -e "\033[1AQuality control (fastqc) ............................. 50%"
fastqc -o $FILTERED_FASTQC $FILTERED_FASTQ/* > /dev/null 2>&1

echo -e "\033[1AQuality control (fastqc) ............................. 100%"
