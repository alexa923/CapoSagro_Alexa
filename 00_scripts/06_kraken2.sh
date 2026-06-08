#!/bin/bash
#SBATCH --job-name=06_krakené
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/plstenge/coprolites/00_scripts/06_kraken2.err"
#SBATCH --output="/home/plstenge/coprolites/00_scripts/06_kraken2.out"
