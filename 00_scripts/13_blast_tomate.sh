#!/bin/bash
#SBATCH --job-name=13_blast_tomate
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/13_blast_tomate.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/13_blast_tomate.out"

# Chargement de l'environnement
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

#git clone https://github.com/jenniferlu717/KrakenTools.git

KRAKEN_FILE="home/amartin3/07_kraken2/clean_sed6_concat_dedup_merged.kraken"
FASTQ_FILE="home/amartin3/05_fastp/clean_sed6_concat_dedup_fastp_merged.fastq.gz"
TAXID=4081

cd /home/amartin3/07_kraken2/KrakenTools
echo "Début de l'extraction des reads (TaxID: ${TAXID}) - $(date)"

# Extraction des reads avec KrakenTools
extract_kraken_reads.py \
    -k "$KRAKEN_FILE" \
    -s "$FASTQ_FILE" \
    -o "reads_tomate.fastq" \
    -t "$TAXID" \
    --include-children

echo "Extraction terminée. Conversion au format FASTA - $(date)"

## Conversion du FASTQ en FASTA pour le BLAST
#awk 'NR%4==1{sub(/^@/ ,">");print;getline;print}' reads_tomate.fastq > reads_tomate.fasta

#echo " Fin du job - $(date)"
