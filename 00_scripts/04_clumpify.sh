#!/bin/bash
#SBATCH --job-name=04_clumpify
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/04_clumpify.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/04_clumpify.out"


ENTREE="/home/amartin3/03_fastuniq"
SORTIE="/home/amartin3/04_clumpify"
QUALITE="/home/amartin3/04_clumpify/controle_qualite"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

CLUMPIFY=clumpify.sh

mkdir -p "$SORTIE"
mkdir -p "$QUALITE"


for R1 in "$ENTREE"/*_R1.fastq; do
    R2="${R1/_R1.fastq/_R2.fastq}"
    if [[ -f "$R2" ]]; then 
        base=$(basename "$R1" _R1.fastq)
        $CLUMPIFY \
            in="$R1" in2="$R2" \
            out="$SORTIE/${base}_clumpify_R1.fastq.gz" \
            out2="$SORTIE/${base}_clumpify_R2.fastq.gz" \
            dedupe=t
        echo "Clumpify terminé pour $base
    else
        echo "Fichier R2 manquant pour $R1, ignore"
    fi
done    

echo "Analyse Clumpify terminee "

#faire controle qualité 

echo "ANALYSE DE LA QUALITE"


echo "Lancement de FastQC"
fastqc "$SORTIE"/*.fastq.gz --outdir "$QUALITE" --threads 4

echo "Lancement de MultiQC"
multiqc "$QUALITE" "$SORTIE" -o "$QUALITE"

echo "Analyse finalisee"
