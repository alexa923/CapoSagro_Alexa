#!/bin/bash
#SBATCH --job-name=01_quality_check
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/01_quality_check.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/01_quality_check.out"

#activer environnement conda
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

#créer des dossiers de sortie QC (avant et après concaténation)
