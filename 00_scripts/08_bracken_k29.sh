#!/bin/bash
#SBATCH --job-name=08_bracken_k29
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/08_bracken_k29.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/08_bracken_k29.out"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

KRAKEN2_DB="/storage/groups/gdec/shared/Kraken_database/k2_core_nt_20250609"
ENTREE="/home/amartin3/07_kraken2_k29"
SORTIE="/home/amartin3/08_bracken_k29"
SORTIE_KRONA="/home/amartin3/08_bracken_k29/krona"


mkdir -p "$SORTIE"
mkdir -p "$SORTIE_KRONA"

for fichier_report in "$ENTREE"/*.report; do
    
    # On récupère le nom de l'échantillon
    base=$(basename "$fichier_report" .report)
    echo "Traitement Bracken pour : $base"
    
    # Lancement de Bracken 
    echo "lancement de bracken"
    bracken \
        -d "$KRAKEN2_DB" \
        -i "$fichier_report" \
        -o "$SORTIE/${base}_bracken.txt" \
        -w "$SORTIE/${base}_bracken.report" \
        -r 50

    echo "Bracken terminé pour $base"
   
done

echo "Bracken termine"

#krona
echo "Lancement de Krona"

ktImportTaxonomy \
    -t 5 \
    -m 3 \
    -o "$SORTIE_KRONA/multi-krona.html" \
    "$SORTIE"/*_bracken.report

echo "Graphique Krona termine"
