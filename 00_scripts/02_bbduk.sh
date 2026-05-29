#!/bin/bash
#SBATCH --job-name=02_bbduk
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/02_bbduk.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/02_bbduk.out"



ENTREE="/home/amartin3/01_concatenated_data" 
SORTIE="/home/amartin3/02_bbduk" 
QUALITE="/home/amartin3/02_bbduk/controle_qualite" 

mkdir -p "$SORTIE"
mkdir -p "${SORTIE}/controle_qualite"


module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

PHIX=/home/amartin3/bbmap/resources/phix174_ill.ref.fa.gz
BBDUK=bbduk.sh


#boucle sur tous les fichiers R1 
for r1_file in /home/amartin3/01_concatenated_data/*_R1.fastq.gz; do

    # Déduire le nom du fichier R2 
    r2_file="${r1_file/_R1.fastq.gz/_R2.fastq.gz}"
    
    #vérifie que le R2 existe
    [[ ! -f "$r2_file" ]] && { echo "ERREUR: Fichier R2 manquant pour $r1_file" >&2; continue; }
    
    # Extraire le nom de base propre du fichier
    base_name="${r1_file%%_R1.fastq.gz}"

 
    $BBDUK \
       in1="$r1_file" \ 
       in2="$r2_file" \ 
       out1="$SORTIE/clean_${r1_file}" \
       out2="$SORTIE/clean_${r2_file}" \
       ref=$PHIX \ 
       ktrim=rl \ 
       k=23 \ 
       mink=11 \ 
       hdist=1 \ 
       tpe=t \ 
       tbo=t \  
       minlen=25 \ 
       qtrim=r \ 
       trimq=20 \
       stats="$SORTIE/${base_name}_bbduk_stats.txt" 

done



echo "Analyse BBduk terminée"

# à la fin lancer un fastqc / multi qc pour checker la qualité à chaque étape

echo "Analyse de la qualité"
fastqc "$SORTIE"/*.fastq.gz --outdir "$QUALITE"
multiqc "$QUALITE" -o "$QUALITE" 
echo "Analyse de la qualité terminée"
