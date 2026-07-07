#!/bin/bash
#SBATCH --job-name=repare_sed6_k29
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/repare_sed6_k29.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/repare_sed6_k29.out"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic
THREADS=36

# On cible spécifiquement le fichier unique qui a plante
MERGED="/home/amartin3/05_fastp/clean_sed6_concat_dedup_merged.fastq.gz"
KRAKEN2_DB="/storage/groups/gdec/shared/Kraken_database/core_nt_k29"
SORTIE="/home/amartin3/07_kraken2_k29"
THREADS=36

# Fichiers de sortie (on ajoute .gz pour le fichier kraken)
SORTIE_REPORT="$SORTIE/clean_sed6_concat_dedup_merged.report"
SORTIE_KRAKEN="$SORTIE/clean_sed6_concat_dedup_merged.kraken.gz"

echo "Relancement exclusif de sed6_merged avec compression à la volée..."


kraken2 --conf 0.2 --db "$KRAKEN2_DB" --threads $THREADS \
    --output - --report "$SORTIE_REPORT" "$MERGED" | gzip > "$SORTIE_KRAKEN"

echo "Réparation terminée avec succès."
