# Pipeline du TP Exome Sequencing Pipeline

__Fiona Hak<sup>1</sup>__
<br>
<sub>1. Université Paris-Saclay

Ce dépôt contient un pipeline bash d'analyse de données NGS allant de l'importation des données du TP à l'identification de variants.
Les consignes du TP sont disponibles : https://ecampus.paris-saclay.fr/pluginfile.php/2618507/mod_resource/content/1/TP-variants.html

## Installation
Ce dépôt doit être cloné :

    git clone git@github.com:chumphati/ngs_exome_pipeline.git

## Usage
Le pipeline peut être lancé via ses executables directement dans le dossier d'installation :

    cd ngs_exome_pipeline
    conda activate analyzer
    bash analyzer.sh <options> [--download_data | --import_data]

Pour plus d'information sur les options disponible :

    bash analyzer.sh --help

Il faut obligatoirement spécifier en argument si on souhaite télécharger de novo les données ou fournir un dossier des fichiers fastq.

## Dépendances
Ce pipeline est basé sur plusieurs dépendances, contenus dans des environnements conda  :

- fastqc v.0.12.1
- trimmomatic v.0.39
- bwa v0.7.17
- samtools v1.17.24
- varscan v2.4.3
- bedtools v2.31.0

Ces dépendances peuvent être installées via :

    conda create -n analyzer
    conda activate analyzer
    conda install -c bioconda fastqc
    conda install -c bioconda trimmomatic
    conda install -c bioconda bwa
    conda install -c bioconda samtools
    conda install -c bioconda varscan
    conda install -c bioconda bedtools
    conda deactivate


