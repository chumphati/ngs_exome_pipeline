#!/bin/bash

MPILEUP="results/VARIANT_CALLING"
VARIANT_CALLING="results/PROCESS_VARIANT_CALLING"
MAPPING_REF="results/DATA_REF"
MAPPING="results/MAPPING"

#créer le répertoire si nécessaire
if [ ! -d results/VARIANT_CALLING ];then
  mkdir -p $VARIANT_CALLING
fi

echo "Mpileup ............................. 0%"

#créer le répertoire si nécessaire
if [ ! -d results/MPILEUP ];then
  mkdir -p $MPILEUP
fi

gunzip $MAPPING_REF/chr16.fa.gz
sample_list=("TCRBOA7-N-WEX-chr16" "TCRBOA7-T-WEX-chr16")
x=0
for i in ${sample_list[*]};do
  ((x=x+15))
  echo -e "\033[1AMpileup ............................. ${x}%"
  samtools mpileup -B -A -f $MAPPING_REF/chr16.fa $MAPPING/${i}_sorted.bam -o $MPILEUP/${i}.vcf > /dev/null 2>&1
done
echo -e "\033[1AMpileup ............................. 100%"

echo "Variant calling ............................. 0%"
varscan somatic $MPILEUP/TCRBOA7-N-WEX-chr16.vcf $MPILEUP/TCRBOA7-T-WEX-chr16.vcf $VARIANT_CALLING/TCRBOA7_compare > /dev/null 2>&1
echo -e "\033[1AVariant calling ............................. 100%"

echo "Annotation VCF ............................. 0%"
join $VARIANT_CALLING/TCRBOA7_compare.snp $VARIANT_CALLING/TCRBOA7_compare.indel > $VARIANT_CALLING/TCRBOA7_joined.vcf
grep -i 'somatic' $VARIANT_CALLING/TCRBOA7_joined.vcf > $VARIANT_CALLING/TCRBOA7_filtered.vcf
awk '{OFS="\t"; if (!/^#/){print $1,$2-1,$2,$4"/"$5,"+"}}' $VARIANT_CALLING/TCRBOA7_filtered.vcf > $VARIANT_CALLING/TCRBOA7_filtered.bed
echo -e "\033[1AAnnotation VCF ............................. 50%"
bedtools intersect -a $MAPPING_REF/gencode.v24lift37.basic.annotation.gtf -b $VARIANT_CALLING/TCRBOA7_filtered.bed > $VARIANT_CALLING/TCRBOA7_intersect.txt /dev/null 2>&1
grep '\sgene\s' $VARIANT_CALLING/TCRBOA7_intersect.txt | awk '{print " " $1 " " $4 " " $5 " " $16}' > $VARIANT_CALLING/final_genes.txt


