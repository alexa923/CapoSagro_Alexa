#!/bin/bash
#SBATCH --job-name=11_mapdamage
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage.out"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

##installer mapdamage_py39

BRACKEN_DIR="home/amartin3/08_bracken"
FASTQ_DIR="home/amartin3 #à quoi sert ce chemin 
DAMAGE_BASE= #??
KRACKENTOOL_DIR="/home/amartin3/08_bracken/KrakenTools"

