#!/bin/bash

MPILEUP="results/MPILEUP"
VARIANT_CALLING="results/VARIANT_CALLING"
MAPPING_REF="results/DATA_REF"

#créer le répertoire si nécessaire
if [ ! -d results/VARIANT_CALLING ];then
  mkdir -p $VARIANT_CALLING
fi

echo "Variant calling ............................. 0%"
varscan somatic $MPILEUP/TCRBOA7-N-WEX-chr16.bcf $MPILEUP/TCRBOA7-T-WEX-chr16.bcf $VARIANT_CALLING/TCRBOA7_compare.vcf > /dev/null 2>&1
echo -e "\033[1AVariant calling ............................. 100%"

echo "Annotation VCF ............................. 0%"
grep -i 'somatic' $VARIANT_CALLING/TCRBOA7_compare.vcf > $VARIANT_CALLING/TCRBOA7_compare_filtered.vcf
awk '{OFS="\t"; if (!/^#/){print $1,$2-1,$2,$4"/"$5,"+"}}' $VARIANT_CALLING/TCRBOA7_compare_filtered.vcf > $VARIANT_CALLING/TCRBOA7_compare_filtered.bed
echo -e "\033[1AAnnotation VCF ............................. 50%"
bedtools intersect -a $MAPPING_REF/gencode.v24lift37.basic.annotation.gtf -b $VARIANT_CALLING/TCRBOA7_compare_filtered.bed > $VARIANT_CALLING/TCRBOA7_intersect.txt /dev/null 2>&1
grep '\sgene\s' $VARIANT_CALLING/TCRBOA7_intersect.txt | awk '{print " " $1 " " $4 " " $5 " " $16}'


