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

# Création des dossiers de sortie s'ils n'existent pas déjà
mkdir -p "$SORTIE"
mkdir -p "$QUALITE"

# Activer l'environnement conda
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

# Pour chaque fichier R1 issu de Clumpify
for R1 in "$ENTREE"/*_clumpify_R1.fastq.gz
do
    # Trouver le fichier R2 correspondant
    R2="${R1/_R1.fastq.gz/_R2.fastq.gz}"
 
    if [[ -f "$R2" ]]; then
        # Nom de base propre pour cet échantillon
        base=$(basename "$R1" _clumpify_R1.fastq.gz)
        echo "--> Traitement fastp pour : $base"

        # DÉFINITION DES VARIABLES DE SORTIE (Indispensable pour que fastp fonctionne !)
        OUT_R1="$SORTIE/${base}_fastp_unmerged_R1.fastq.gz"
        OUT_R2="$SORTIE/${base}_fastp_unmerged_R2.fastq.gz"
        MERGED="$SORTIE/${base}_fastp_merged.fastq.gz"
        HTML="$SORTIE/${base}_fastp_report.html"
        JSON="$SORTIE/${base}_fastp_report.json"

        # Exécution de fastp
        fastp \
            --in1 "$R1" --in2 "$R2" \
            --out1 "$OUT_R1" --out2 "$OUT_R2" \
            --merged_out "$MERGED" \
            --length_required 20 \
            --cut_front --cut_tail \
            --cut_window_size 4 \
            --cut_mean_quality 10 \
            --n_base_limit 5 \
            --unqualified_percent_limit 40 \
            --low_complexity_threshold 30 \
            --qualified_quality_phred 20 \
            --low_complexity_filter \
            --trim_poly_x \
            --poly_x_min_len 10 \
            --merge --correction \
            --overlap_len_require 10 \
            --overlap_diff_limit 5 \
            --overlap_diff_percent_limit 20 \
            --html "$HTML" \
            --json "$JSON" \
            --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
            --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
            --detect_adapter_for_pe \
            --thread 4

        echo "Traitement de $base terminé"
        echo "--------------------------------------"
    else
        echo "Fichier R2 manquant pour $R1, échantillon ignoré."
    fi
done

echo "Tous les traitements fastp sont terminés."

# ==================================================
# CONTRÔLE QUALITÉ SÉCURISÉ (Fichier par fichier)
# ==================================================
echo "ANALYSE DE LA QUALITE"

echo "Lancement de FastQC..."
for fq_gz in "$SORTIE"/*.fastq.gz; do
    if [[ -f "$fq_gz" ]]; then
        echo "--> FastQC sur : $(basename "$fq_gz")"
        fastqc "$fq_gz" --outdir "$QUALITE" --threads 4
    fi
done

echo "Lancement de MultiQC..."
cd "$QUALITE" || exit 1
multiqc . -o . --force

echo "Analyse finalisee avec succes !"
