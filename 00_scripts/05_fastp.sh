#!/bin/bash
#SBATCH --job-name=05_fastp 
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/05_fastp.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/05_fastp.out"

ENTREE="/home/amartin3/04_clumpify"
SORTIE="/home/amartin3/05_fastp"
QUALITE="/home/amartin3/05_fastp/controle_qualite"


#création des dossiers de sortie s'ils n'existent pas déjà
mkdir -p "$SORTIE"
mkdir -p "$QUALITE"


#activer environnement conda
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

#pour chaque fichier R1
for R1 in "$ENTREE"/*_R1.fastq.gz
do
   #trouver le fichier R2 correspondant
   R2="${R1/_R1.fastq.gz/_R2.fastq.gz}" #prend le nom du fichier R1 et cherche le R2 correspondant
#permet de nettoyer les couples ensemble 

 
   # Nom de base pour les sorties
   base=$(basename "$R1" _R1.fastq.gz)



#fastp
  fastp \
        --in1 "$R1" --in2 "$R2" \ 
        --out1 "$OUT_R1" --out2 "$OUT_R2" \ 
        --merged_out "$MERGED" \ 
        --length_required 20 \ 
        --cut_front --cut_tail \
        --cut_window_size 4 \ 
        --cut_mean_quality 20 \
        --n_base_limit 5 \ 
        --unqualified_percent_limit 40 \
        --low_complexity_threshold 30 \
        --qualified_quality_phred 20 \
        --low_complexity_filter \ 
        --trim_poly_x \ 
        --poly_x_min_len 10 \ 
        --merge --correction \
        --overlap_len_require 30 \ 
        --overlap_diff_limit 5 \ 
        --overlap_diff_percent_limit 20 \ 
        --html "$HTML" \ 
        --json "$JSON" \
        --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \ 
        --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        --detect_adapter_for_pe \ 
        --thread 4 

   echo "Traitement de $base terminé"
done
echo "Tous les traitements sont terminés"

echo "Lancement de FastQC"
for fq_gz in "$SORTIE"/*.fastq.gz; do
    if [[ -f "$fq_gz" ]]; then
        echo "--> FastQC en cours sur : $(basename "$fq_gz")"
        fastqc "$fq_gz" --outdir "$QUALITE" --threads 4
    fi
done

echo "Lancement de MultiQC..."
# Déplacement dans le dossier pour empêcher MultiQC de scanner les gros fichiers de $SORTIE
cd "$QUALITE" || exit 1
multiqc . -o . --force

echo "Controle qualite finalise avec succes !"
  
