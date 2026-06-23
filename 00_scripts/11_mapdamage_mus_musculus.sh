#!/bin/bash
#SBATCH --job-name=11_mapdamage_murinae
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage_murinae.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage_murinae.out"

# Configuration des chemins
FASTQ_BASE_DIR="/home/amartin3/05_fastp"
DAMAGEBASE="/home/amartin3/12_mapdamage_murinae"
KRAKENTOOLS_DIR="/home/amartin3/08_bracken/KrakenTools"
KRAKEN_DIR_SOURCE="/home/amartin3/07_kraken2"

LOGFILE="${DAMAGEBASE}/mapdamage_murinae_$(date +%Y%m%d_%H%M%S).txt"
MAPPING_INFO="${DAMAGEBASE}/mapping_bwa_info.tsv"

mkdir -p "$DAMAGEBASE"

# Chargement de l'environnement
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

echo "Script MapDamage (Tests Murinae) started at $(date)" | tee -a "$LOGFILE"

# Initialiser le fichier de mapping info
echo -e "Sample\tSpecies\tType\tTotalReads\tMappedReads\tMappingRate" > "${MAPPING_INFO}"


# On extrait TOUJOURS avec le TaxID 39107 (Murinae), mais on change la référence de mapping.
declare -A TAXONS=(
    ["Mus_musculus"]="39107:/home/amartin3/genomes/Mus_musculus.fna"
    ["Rattus_norvegicus"]="39107:/home/amartin3/genomes/Rattus_norvegicus.fna"
    ["Oryctolagus_cuniculus"]="39107:/home/amartin3/genomes/Oryctolagus_cuniculus.fna"
)

# Boucle de traitement des échantillons
SAMPLES=("sed6" "sed8")
shopt -s nullglob

for sample in "${SAMPLES[@]}"; do
  echo ""
  echo "======================================================================"
  echo "Traitement de l'échantillon: $sample"
  echo "======================================================================"

  FASTQDIR="${FASTQ_BASE_DIR}"

  for KRAKENFILE in ${KRAKEN_DIR_SOURCE}/*${sample}*.kraken; do
    if [ ! -f "$KRAKENFILE" ]; then
      continue
    fi

    # Extraction du nom de base depuis le fichier .kraken
    KRAKENBASENAME=$(basename "$KRAKENFILE" .kraken)
    echo ""
    echo ">>> Processing $KRAKENBASENAME ($sample)" | tee -a "${LOGFILE}"

    # Extraire le prefixe de base
    PREFIX=$(echo "$KRAKENBASENAME" | sed -E 's/(un)?merged$//')
    echo "Prefix: $PREFIX" | tee -a "${LOGFILE}"

    # Correspondance avec fichiers fastq
    R1FILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_unmerged_R1.fastq.gz"
    R2FILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_unmerged_R2.fastq.gz"
    MERGEDFILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_merged.fastq.gz"

    # Boucle sur les stratégies de test
    for GROUP in "${!TAXONS[@]}"; do
      IFS=':' read -r TAXID REFFASTA <<< "${TAXONS[$GROUP]}"
      DAMAGEDIR="${DAMAGEBASE}/${sample}/${GROUP}"
      mkdir -p "${DAMAGEDIR}"

      echo ""
      echo "--- Test: $GROUP (Extraction TaxID: $TAXID via Référence: $REFFASTA) ---"

      OUTR1="${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R1.fastq"
      OUTR2="${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R2.fastq"
      OUTMERGED="${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.fastq"

      # Traitement des reads unmerged (paired-end)
      if [[ "$KRAKENBASENAME" == *"unmerged"* ]] && [ -f "$R1FILE" ] && [ -f "$R2FILE" ]; then
        echo "Extraction des reads unmerged pour $GROUP..." | tee -a "${LOGFILE}"

        python3 ${KRAKENTOOLS_DIR}/extract_kraken_reads.py \
          -k "$KRAKENFILE" \
          -s "$R1FILE" -s2 "$R2FILE" \
          -t "$TAXID" \
          -o "$OUTR1" -o2 "$OUTR2" \
          --fastq-output 2>>"${LOGFILE}"

        if [ -f "$OUTR1" ] && [ -f "$OUTR2" ]; then
          echo "Mapping BWA paired-end pour $GROUP..." | tee -a "${LOGFILE}"

          bwa aln -n 0.08 -l 24 -k 2 -q 20 -t 4 "$REFFASTA" "$OUTR1" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R1.sai" 2>>"${LOGFILE}"
          bwa aln -n 0.08 -l 24 -k 2 -q 20 -t 4 "$REFFASTA" "$OUTR2" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R2.sai" 2>>"${LOGFILE}"

          bwa sampe "$REFFASTA" \
            "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R1.sai" \
            "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R2.sai" \
            "$OUTR1" "$OUTR2" \
            > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sam" 2>>"${LOGFILE}"

          samtools view -bS "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sam" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.bam" 2>>"${LOGFILE}"
          samtools sort -o "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.bam" 2>>"${LOGFILE}"
          samtools index "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam" 2>>"${LOGFILE}"

          echo "MapDamage unmerged pour $GROUP..." | tee -a "${LOGFILE}"
          mapDamage -i "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam" \
            -r "$REFFASTA" \
            --folder "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_mapDamage_unmerged" \
            --no-stats 2>>"${LOGFILE}"
          
          # Calcul du taux de mapping
          total_reads=$(samtools view -c "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam")
          mapped_reads=$(samtools view -c -F 4 "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam")
          mapping_rate=0
          if [[ $total_reads -gt 0 ]]; then
            mapping_rate=$(echo "scale=2; $mapped_reads * 100 / $total_reads" | bc)
          fi
        
          echo -e "${sample}\t${GROUP}\tunmerged\t${total_reads}\t${mapped_reads}\t${mapping_rate}" >> "$MAPPING_INFO"
          echo "Stats for ${sample}_${GROUP}_unmerged: ${mapped_reads}/${total_reads} (${mapping_rate}%)" | tee -a "$LOGFILE"
        
          rm -f "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R1.sai" \
                "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R2.sai" \
                "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sam" \
                "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.bam" 2>>"${LOGFILE}"
        fi
      fi

      # Traitement des reads merged (single-end)
      if [[ "$KRAKENBASENAME" == *"merged"* ]] && [ -f "$MERGEDFILE" ] && [[ "$KRAKENBASENAME" != *"unmerged"* ]]; then
        echo "Extraction des reads merged pour $GROUP..." | tee -a "${LOGFILE}"
        
        python3 ${KRAKENTOOLS_DIR}/extract_kraken_reads.py \
          -k "$KRAKENFILE" \
          -s "$MERGEDFILE" \
          -t "$TAXID" \
          -o "$OUTMERGED" \
          --fastq-output 2>>"${LOGFILE}"
  
        if [ -f "$OUTMERGED" ]; then
          echo "Mapping BWA single-end pour $GROUP..." | tee -a "${LOGFILE}"

          bwa aln -n 0.08 -l 24 -k 2 -q 20 -t 4 "$REFFASTA" "$OUTMERGED" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sai" 2>>"${LOGFILE}"

          bwa samse "$REFFASTA" \
            "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sai" \
            "$OUTMERGED" \
            > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sam" 2>>"${LOGFILE}"

          samtools view -bS "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sam" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.bam" 2>>"${LOGFILE}"
          samtools sort -o "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.bam" 2>>"${LOGFILE}"
          samtools index "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam" 2>>"${LOGFILE}"

          echo "MapDamage merged pour $GROUP..." | tee -a "${LOGFILE}"
          mapDamage -i "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam" \
            -r "$REFFASTA" \
            --folder "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_mapDamage_merged" \
            --no-stats 2>>"${LOGFILE}"
       
          total_reads=$(samtools view -c "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam")
          mapped_reads=$(samtools view -c -F 4 "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam")
          mapping_rate=0
          if [[ $total_reads -gt 0 ]]; then
            mapping_rate=$(echo "scale=2; $mapped_reads * 100 / $total_reads" | bc)
          fi

          echo -e "${sample}\t${GROUP}\tmerged\t${total_reads}\t${mapped_reads}\t${mapping_rate}" >> "$MAPPING_INFO"
          echo "Stats for ${sample}_${GROUP}_merged: ${mapped_reads}/${total_reads} (${mapping_rate}%)" | tee -a "$LOGFILE"

          rm -f "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sai" \
                "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sam" \
                "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.bam" 2>>"${LOGFILE}"
        fi
      fi

    done  # Fin boucle sur les strategies
  done  # Fin boucle sur les fichiers Kraken
done  # Fin boucle sur les echantillons

echo "Analyses comparatives Murinae terminees avec succes."
