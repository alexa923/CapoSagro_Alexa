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


mkdir -p "$SORTIE"
mkdir -p "$QUALITE"


module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic


for R1 in "$ENTREE"/*_clumpify_R1.fastq.gz
do
    
    R2="${R1%_R1.fastq.gz}_R2.fastq.gz"
 
    if [[ -f "$R2" ]]; then
        
        base=$(basename "$R1" _clumpify_R1.fastq.gz)
        echo " Traitement fastp pour : $base"

        
        OUT_R1="$SORTIE/${base}_fastp_unmerged_R1.fastq.gz"
        OUT_R2="$SORTIE/${base}_fastp_unmerged_R2.fastq.gz"
        MERGED="$SORTIE/${base}_fastp_merged.fastq.gz"
        HTML="$SORTIE/${base}_fastp_report.html"
        JSON="$SORTIE/${base}_fastp_report.json"

        
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

        echo "Traitement de $base termine"
       
    else
        echo "Fichier R2 manquant pour $R1, échantillon ignore."
    fi
done

echo "Tous les traitements fastp sont termines."


# controle qualite

echo "Lancement de FastQC"
fastqc "$SORTIE"/*_merged.fastq.gz --outdir "$QUALITE" --threads 4

echo "Lancement de MultiQC"
multiqc "$QUALITE" -o "$QUALITE"

echo "Analyse finalisee"
