#!/bin/bash
#SBATCH --job-name=03_fastuniq
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error=/home/amartin3/CapoSagro_Alexa/00_scripts/03_fastuniq.err
#SBATCH --output=/home/amartin3/CapoSagro_Alexa/00_scripts/03_fastuniq.out

ENTREE="/home/amartin3/02_bbduk"
SORTIE="/home/amartin3/03_fastuniq"
QUALITE="/home/amartin3/03_fastuniq/controle_qualite"

mkdir -p "$SORTIE"
mkdir -p "$QUALITE"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

cd "$ENTREE" || exit 1 

TMP="/tmp/fastuniq_tmp" 
mkdir -p "$TMP"

for R1_gz in clean_*_R1.fastq.gz; do
    base=$(echo "$R1_gz" | sed 's/_R1\.fastq\.gz//')
    R2_gz="${base}_R2.fastq.gz"


    if [[ -f "$R2_gz" ]]; then
        echo "Traitement de la paire: $base"

        R1_tmp="${TMP}/${base}_R1.fastq"
        R2_tmp="${TMP}/${base}_R2.fastq"
        listfile="${TMP}/${base}.list"

        zcat "$ENTREE/$R1_gz" > "$R1_tmp" 
        zcat "$ENTREE/$R2_gz" > "$R2_tmp"

        echo -e "$R1_tmp\n$R2_tmp" > "$listfile" #? 

        fastuniq -i "$listfile" -t q \ 
            -o "${SORTIE}/${base}_dedup_R1.fastq" \
            -p "${SORTIE}/${base}_dedup_R2.fastq"

        rm -f "$R1_tmp" "$R2_tmp" "$listfile" 

    else
        echo "ATTENTION: fichier R2 manquant pour $base"
    fi
done

echo "Fastuniq termine"

#controle qualité à la fin 

echo "Lancement de FastQC"
fastqc "$SORTIE"/*.fastq --outdir "$QUALITE" --threads 4

echo "Lancement de MultiQC"
multiqc "$QUALITE" "$SORTIE" -o "$QUALITE"

echo "Controle qualite finalise"
