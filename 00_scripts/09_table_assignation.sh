#!/bin/bash
#SBATCH --job-name=09_table_assignation
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/09_table_assignation.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/09_table_assignation.out"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic


cd /home/amartin3/08_bracken

#git clone https://github.com/jenniferlu717/KrakenTools.git

mkdir -p "$SORTIE"

#Creation de la table d assignation
echo "creation de la table"
python3 /home/amartin3/08_bracken/KrakenTools/kreport2mpa.py -r clean_sed6_concat_dedup_merged_bracken.report -o clean_sed6_concat_dedup_merged_bracken.mpa
python3 /home/amartin3/08_bracken/KrakenTools/kreport2mpa.py -r clean_sed6_concat_dedup_unmerged_bracken.report -o clean_sed6_concat_dedup_unmerged_bracken.mpa
python3 /home/amartin3/08_bracken/KrakenTools/kreport2mpa.py -r clean_sed8_concat_dedup_merged_bracken.report -o clean_sed8_concat_dedup_merged_bracken.mpa
python3 /home/amartin3/08_bracken/KrakenTools/kreport2mpa.py -r clean_sed8_concat_dedup_unmerged_bracken.report -o clean_sed8_concat_dedup_unmerged_bracken.mpa
echo "table creee"

echo "Combinaison en un seul fichier"

python3 /home/amartin3/08_bracken/KrakenTools/combine_mpa.py -i clean_sed6_concat_dedup_merged_bracken.mpa clean_sed6_concat_dedup_unmerged_bracken.mpa clean_sed8_concat_dedup_merged_bracken.mpa clean_sed8_concat_dedup_unmerged_bracken.mpa" -o combined_mpa.tsv

echo "analyse terminee"
