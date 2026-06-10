#!/bin/bash
#SBATCH --job-name=09_table_assignation
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/09_table_assignation.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/09_table_assignation.out"


cd /home/amartin3/08_bracken

#git clone https://github.com/jenniferlu717/KrakenTools.git

python 3  /home/amartin3/08_bracken/KrakenTools/kreport2mpa.py -r
