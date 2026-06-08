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
