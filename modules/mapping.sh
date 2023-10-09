#!/bin/bash

FILTERED_FASTQ="results/FASTQ/FILTERED"
MAPPING="results/MAPPING"
MAPPING_REF="results/DATA_REF"
MPILEUP="results/MPILEUP"

echo "Download reference and annotation file ............................. 0%"

#créer le répertoire si nécessaire
if [ ! -d results/MAPPING ];then
  mkdir -p $MAPPING_REF
fi

wget -P $MAPPING_REF http://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/chr16.fa.gz > /dev/null 2>&1
wget -P $MAPPING_REF ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_24/GRCh37_mapping/gencode.v24lift37.basic.annotation.gtf.gz > /dev/null 2>&1
gunzip $MAPPING_REF/gencode.v24lift37.basic.annotation.gtf.gz > /dev/null 2>&1
echo -e "\033[1ADownload reference and annotation file ............................. 100%"

echo "Index reference ............................. 0%"
bwa index -a bwtsw $MAPPING_REF/chr16.fa.gz > /dev/null 2>&1
echo -e "\033[1AIndex reference ............................. 100%"

echo "Mapping and process alignement files ............................. 0%"
sample_list=("TCRBOA7-N-WEX-chr16" "TCRBOA7-T-WEX-chr16")
x=0
for i in ${sample_list[*]};do
  ((x=x+15))
  echo -e "\033[1AMapping and process alignement files ............................. ${x}%"
  bwa mem -M -t 2 -A 2 -E 1 $MAPPING_REF/chr16.fa.gz $FILTERED_FASTQ/${i}_1P.fastq $FILTERED_FASTQ/${i}_2P.fastq -o $MAPPING/${i}.sam > /dev/null 2>&1
  samtools view -S -b $MAPPING/${i}.sam -o $MAPPING/${i}.bam > /dev/null 2>&1
  samtools flagstat $MAPPING/${i}.bam > /dev/null 2>&1
  samtools sort $MAPPING/${i}.bam -o $MAPPING/${i}_sorted.bam > /dev/null 2>&1
  samtools index $MAPPING/${i}_sorted.bam > /dev/null 2>&1
done
echo -e "\033[1AMapping and process alignement files ............................. 100%"

echo "Pileup files ............................. 0%"

#créer le répertoire si nécessaire
if [ ! -d results/MPILEUP ];then
  mkdir -p $MPILEUP
fi

gunzip $MAPPING_REF/chr16.fa.gz
sample_list=("TCRBOA7-N-WEX-chr16" "TCRBOA7-T-WEX-chr16")
x=0
for i in ${sample_list[*]};do
  ((x=x+15))
  echo -e "\033[1APileup files ............................. ${x}%"
  samtools mpileup -B -A -f $MAPPING_REF/chr16.fa $MAPPING/${i}_sorted.bam -o $MPILEUP/${i}.bcf > /dev/null 2>&1
done
echo -e "\033[1APileup files ............................. 100%"