#!/bin/bash
#SBATCH --job-name=08_bracken
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/08_bracken.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/08_bracken.out"


KRAKEN2_DB="/storage/groups/gdec/shared/Kraken_database/k2_core_nt_20250609"
ENTREE="/home/amartin3/ 07_kraken2"

bracken -d "$KRAKEN2_DB" -i
