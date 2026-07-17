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


KRAKEN_FILE="home/amartin3/07_kraken2/clean_sed6_concat_dedup_merged.kraken"
