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

gunzip nucl_gb.accession2taxid.gz
gunzip nucl_wgs.accession2taxid.gz
gunzip pdb.accession2taxid.gz
gunzip dead_nucl.accession2taxid.gz

mkdir -p /home/amartin3/nt_kraken2_db/taxonomy/

mv nucl_gb.accession2taxid /home/amartin3/nt_kraken2_db/taxonomy/
mv nucl_wgs.accession2taxid /home/amartin3/nt_kraken2_db/taxonomy/
mv pdb.accession2taxid /home/amartin3/nt_kraken2_db/taxonomy/
mv dead_nucl.accession2taxid /home/amartin3plstenge/nt_kraken2_db/taxonomy/

mkdir -p /home/amartin3/nt_kraken2_db_big
mkdir -p /home/amartin3/nt_kraken2_db_parts

#Diviser le fasta en 10 fichier; pourquoi ?
seqkit split -p 10 /storage/biodatabanks/ncbi/NT/ncbi_blast_nt_2024-8-24/fasta/All/all.fasta -O /home/amartin3/nt_kraken2_db_parts/

#Ajouter chaque morceau à la base 
for f in /home/amartin3/nt_kraken2_db_parts/*.fasta; do
  kraken2-build --add-to-library "$f" --db /home/amartin3/nt_kraken2_db_big
done

#Telecharger taxonomie 
kraken2-build --download-taxonomy --db /home/amartin3/nt_kraken2_db_big

# Construire la base
kraken2-build --build --db /home/amartin3/nt_kraken2_db_big --threads 36

