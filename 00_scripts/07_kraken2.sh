#!/bin/bash
#SBATCH --job-name=07_kraken2
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/07_kraken2.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/07_kraken2.out"


module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

ENTREE="/home/amartin3/05_fastp"
KRAKEN_DB="/storage/groups/gdec/shared/Kraken_database/k2_core_nt_20250609"
SORTIE="/home/amartin3/07_kraken2"
THREADS=36

mkdir -p "$SORTIE"

#Analyse des merged (single end) 
echo "analyse des merged"

for merged in "$ENTREE"/*_fastp_merged.fastq.gz
do
