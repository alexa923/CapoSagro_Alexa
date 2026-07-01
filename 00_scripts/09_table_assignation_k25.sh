#!/bin/bash
#SBATCH --job-name=09_table_assignation_k25
#SBATCH --ntasks=1
#SBATCH -p gdec
#SBATCH --time=10-00:00:00
#SBATCH --mem=400G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/09_table_assignation_k25.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/09_table_assignation_k25.out"

#################################ASSIGNATION SANS BRACKEN###########################################################################

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic


cd /home/amartin3/07_kraken2_k25

#git clone https://github.com/jenniferlu717/KrakenTools.git


#Creation de la table d assignation
echo "creation de la table"
python3 /home/amartin3/07_kraken2_k25/KrakenTools/kreport2mpa.py -r clean_sed6_concat_dedup_merged_kraken.report -o clean_sed6_concat_dedup_merged_kraken.mpa
python3 /home/amartin3/07_kraken2_k25/KrakenTools/kreport2mpa.py -r clean_sed6_concat_dedup_unmerged_kraken.report -o clean_sed6_concat_dedup_unmerged_kraken.mpa
python3 /home/amartin3/07_kraken2_k25/KrakenTools/kreport2mpa.py -r clean_sed8_concat_dedup_merged_kraken.report -o clean_sed8_concat_dedup_merged_kraken.mpa
python3 /home/amartin3/07_kraken2_k25/KrakenTools/kreport2mpa.py -r clean_sed8_concat_dedup_unmerged_kraken.report -o clean_sed8_concat_dedup_unmerged_kraken.mpa
echo "table creee"

echo "Combinaison en un seul fichier"


python3 /home/amartin3/07_kraken2_k25/KrakenTools/combine_mpa.py -i clean_sed6_concat_dedup_merged_kraken.mpa clean_sed6_concat_dedup_unmerged_kraken.mpa clean_sed8_concat_dedup_merged_kraken.mpa clean_sed8_concat_dedup_unmerged_kraken.mpa -o combined_mpa.tsv

echo "Analyse terminee avec succes !"
