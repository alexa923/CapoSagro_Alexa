#!/bin/bash
#SBATCH --job-name=03_fastuniq
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/03_fastuniq.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/03_fastuniq.out"

ENTREE="/home/amartin3/02_bbduk"
SORTIE="/home/amartin3/03_fastuniq"

mkdir -p "$SORTIE"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

cd "$ENTREE" || exit 1 # terminate a script  (an error has occurred)

TMP="/tmp/fastuniq_tmp" #?
#créer le dossier s'il n'existe pas deja
mkdir -p "$TMP"

for R1_gz in clean_*_R1.fastq.gz; do #on met pas .fastq.gz? 
    base=$(echo "$R1_gz" | sed 's/_R1\.fastq\.gz//') #la aussi?
    R2_gz="${base}_R2.fastq.gz"


    if [[ -f "$R2_gz" ]]; then
        echo "Traitement de la paire: $base"

        R1_tmp="${TMP}/${base}_R1.fastq"
        R2_tmp="${TMP}/${base}_R2.fastq"
        listfile="${TMP}/${base}.list"

        zcat "$ENTREE/$R1_gz" > "$R1_tmp" #regarder le contenu des fichiers compressés ?
        zcat "$ENTREE/$R2_gz" > "$R2_tmp"

        echo -e "$R1_tmp\n$R2_tmp" > "$listfile" #? 

        fastuniq -i "$listfile" -t q \ #lancement de fastuniq?
            -o "${SORTIE}/${base}_dedup_R1.fastq" \
            -p "${SORTIE}/${base}_dedup_R2.fastq"

        rm -f "$R1_tmp" "$R2_tmp" "$listfile" # suppression définitive? 

    else
        echo "ATTENTION: fichier R2 manquant pour $base"
    fi
done

echo "Terminé."

#controle qualité à la fin 
