#!/bin/bash
#SBATCH --job-name=02_bbduk2
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error=/home/amartin3/CapoSagro_Alexa/00_scripts/02_bbduk2.err
#SBATCH --output=/home/amartin3/CapoSagro_Alexa/00_scripts/02_bbduk2.out

ENTREE="/home/amartin3/01_concatenated_data"
SORTIE="/home/amartin3/02_bbduk2"
QUALITE="/home/amartin3/02_bbduk2/controle_qualite"

mkdir -p "$SORTIE"
mkdir -p "$QUALITE"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

PHIX="phix"
BBDUK="bbduk.sh"

echo "DÉBUT DU TRAITEMENT BBDUK"


for r1_file in "$ENTREE"/*_R1.fastq.gz; do

    r2_file="${r1_file/_R1.fastq.gz/_R2.fastq.gz}"
    
    if [[ ! -f "$r2_file" ]]; then
        echo "ERREUR: Fichier R2 manquant pour $r1_file" >&2
        continue
    fi
    
    file_name=$(basename "$r1_file" _R1.fastq.gz)

    echo "Traitement de l'échantillon : $file_name"
 
    $BBDUK \
       in1="$r1_file" \
       in2="$r2_file" \
       out1="$SORTIE/clean_${file_name}_R1.fastq.gz" \
       out2="$SORTIE/clean_${file_name}_R2.fastq.gz" \
       ref="$PHIX" \
       ktrim=rl \
       k=23 \
       mink=11 \
       hdist=1 \
       stats="$SORTIE/${file_name}_bbduk_stats.txt"

    echo "Echantillon $file_name traite"
   
done

echo "Analyse BBDuk terminee "


echo "ANALYSE DE LA QUALITE"


echo "Lancement de FastQC"
fastqc "$SORTIE"/*.fastq.gz --outdir "$QUALITE" --threads 4

echo "Lancement de MultiQC"
multiqc "$QUALITE" "$SORTIE" -o "$QUALITE"

echo "Analyse finalisee"
