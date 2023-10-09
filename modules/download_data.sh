#!/bin/bash

#créer le répertoire si nécessaire
if [ ! -d results/FASTQ/RAW ];then
  mkdir -p results/FASTQ/RAW
fi

download_data=""
import_data=""

download_data_specified=false
import_data_specified=false

for arg in "$@"; do
  if [[ "$arg" == "--download_data" ]]; then
    download_data_specified=true
  elif [[ "$download_data_specified" == true ]]; then
    download_data="$arg"
  elif [[ "$arg" == "--import_data" ]]; then
    import_data_specified=true
  elif [[ "$import_data_specified" == true ]]; then
    import_data="$arg"
  fi
done

if [[ "$download_data_specified" == true ]]; then
  echo "Data download ............................. 0%"
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1DM9g8OulE1ScBk-HoaREfUZs6gurtkBe' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1DM9g8OulE1ScBk-HoaREfUZs6gurtkBe" -O results/FASTQ/RAW/patient7.tar.gz > /dev/null 2>&1
  echo -e "\033[1AData download ............................. 50%"
  tar -zxvf "results/FASTQ/RAW/patient7.tar.gz" -C "results/FASTQ/RAW" > /dev/null 2>&1
  rm -rf "results/FASTQ/RAW/patient7.tar.gz" > /dev/null 2>&1
  mv results/FASTQ/RAW/patient7.exome/* results/FASTQ/RAW/
  rm -rf results/FASTQ/RAW/patient7.exome/
  gunzip results/FASTQ/RAW/*
  echo -e "\033[1AData download ............................. 100%"
elif [[ -n "$import_data" ]]; then
  echo "Data importation ............................. 0%"
  cp $import_data/* results/FASTQ/RAW/ > /dev/null 2>&1
  echo -e "\033[1AData importation ............................. 100%"
elif [[ "$import_data_specified" == false ]] && [[ "$download_data_specified" == false ]]; then
  echo "error : specify whether you wish to download or import your data."
  exit 1
fi
