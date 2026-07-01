#!/bin/bash
#SBATCH --job-name=07_kraken2_k29
#SBATCH --ntasks=1
#SBATCH -p gdec
#SBATCH --time=10-00:00:00
#SBATCH --mem=400G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/07_kraken2_k29.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/07_kraken2_k29.out"


module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

ENTREE="/home/amartin3/05_fastp"
KRAKEN2_DB="/storage/groups/gdec/shared/Kraken_database/core_nt_k29"
SORTIE="/home/amartin3/07_kraken2_k29"
THREADS=36

mkdir -p "$SORTIE"

#Analyse des merged (single end)
echo "analyse des merged"

for MERGED in "$ENTREE"/*_fastp_merged.fastq.gz
do
    SAMPLE=$(basename "$MERGED" _fastp_merged.fastq.gz)
    SORTIE_KRAKEN="$SORTIE/${SAMPLE}_merged.kraken"
    SORTIE_REPORT="$SORTIE/${SAMPLE}_merged.report"

    kraken2 --conf 0.2 --db "$KRAKEN2_DB" --threads $THREADS \
        --output "$SORTIE_KRAKEN" --report "$SORTIE_REPORT" "$MERGED"  
    echo "Termine: $SAMPLE (merged)"
done
    
#Analyse des unmerged (paired end)
echo "analyse des unmerged"

for R1 in "$ENTREE"/*_fastp_unmerged_R1.fastq.gz
do
    SAMPLE=$(basename "$R1" _fastp_unmerged_R1.fastq.gz)
    R2="$ENTREE/${SAMPLE}_fastp_unmerged_R2.fastq.gz"
   
    # Ne lance que si R2 existe
    if [[ -f "$R2" ]]; then
        SORTIE_KRAKEN="$SORTIE/${SAMPLE}_unmerged.kraken"
        SORTIE_REPORT="$SORTIE/${SAMPLE}_unmerged.report"

        kraken2 --conf 0.2 --paired --db "$KRAKEN2_DB" --threads $THREADS \
            --output "$SORTIE_KRAKEN" --report "$SORTIE_REPORT" "$R1" "$R2"

        echo "Termine : $SAMPLE (unmerged)"
    fi
done

echo "Analyse Kraken2 terminee pour tous les echantillons."

SORTIE_KRONA="/home/amartin3/07_kraken2_k29/krona"
mkdir -p "$SORTIE_KRONA"

echo "Lancement de krona"

# Graphique 1 : fichiers merged
echo "Generation du Krona pour les reads merged"
ktImportTaxonomy \
    -t 5 \
    -m 3 \
    -o "$SORTIE_KRONA/krona_merged.html" \
    "$SORTIE"/*_merged.report

# Graphique 2 : Uniquement pour les fichiers unmerged
echo "Génération du Krona pour les reads unmerged"
ktImportTaxonomy \
    -t 5 \
    -m 3 \
    -o "$SORTIE_KRONA/krona_unmerged.html" \
    "$SORTIE"/*_unmerged.report

echo "Analyse krona terminee"
