#!/bin/bash

RAW_FASTQ="results/FASTQ/RAW"
FILTERED_FASTQ="results/FASTQ/FILTERED"

echo "Clean reads ............................. 0%"

#créer le répertoire si nécessaire
if [ ! -d $FILTERED_FASTQ ];then
  mkdir -p $FILTERED_FASTQ
fi

sample_list=("TCRBOA7-N-WEX-chr16" "TCRBOA7-T-WEX-chr16")
x=0
for i in "${sample_list[@]}"; do
  ((x=x+15))
  echo -e "\033[1AClean reads ............................. ${x}%"
  trimmomatic PE "$RAW_FASTQ/${i}_r1F.fastq" "$RAW_FASTQ/${i}_r2F.fastq" -baseout "$FILTERED_FASTQ/${i}.fastq" LEADING:20 TRAILING:20 MINLEN:50 > /dev/null 2>&1
done

echo -e "\033[1AClean reads ............................. 100%"
