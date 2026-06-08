#!/bin/bash
#SBATCH --job-name=06_kraken_db
##SBATCH --time=96:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/06_kraken2.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/06_kraken2.out"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic


# Aller sur https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/
# et télécharger:
# nucl_gb.accession2taxid.gz
# nucl_wgs.accession2taxid.gz
# pdb.accession2taxid.gz
# dead_nucl.accession2taxid.gz
# ex: wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/dead_nucl.accession2taxid.gz

wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz 
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/nucl_wgs.accession2taxid.gz
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/pdb.accession2taxid.gz 
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/dead_nucl.accession2taxid.gz 
