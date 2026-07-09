#!/bin/bash
#SBATCH --job-name=11_mapdamage_k25
#SBATCH --ntasks=1
#SBATCH -p gdec
#SBATCH --time=10-00:00:00
#SBATCH --mem=400G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage_k25.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage_k25.out"

# Configuration des chemins pour k25
FASTQ_BASE_DIR="/home/amartin3/05_fastp"
KRAKENTOOLS_DIR="/home/amartin3/08_bracken/KrakenTools"
KRAKEN_DIR_SOURCE="/home/amartin3/07_kraken2_k25"
DAMAGEBASE="/home/amartin3/12_mapdamage_k25"

LOGFILE="${DAMAGEBASE}/mapdamage_k25_$(date +%Y%m%d_%H%M%S).txt"
MAPPING_INFO="${DAMAGEBASE}/mapping_bwa_k25_info.tsv"

mkdir -p "$DAMAGEBASE"

# Chargement de l'environnement
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

echo "Script MapDamage K25 started at $(date)" | tee -a "$LOGFILE"
echo -e "Sample\tSpecies\tType\tTotalReads\tMappedReads\tMappingRate" > "${MAPPING_INFO}"

#telechargement des genomes 
# cd /home/amartin3/genomes
# wget -O Stenella_coeruleoalba.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Stenella_coeruleoalba/latest_assembly_versions/GCF_023533275.1_mSteCoe1.p/GCF_023533275.1_mSteCoe1.p_genomic.fna.gz
# wget -O Tursiops_truncatus.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Tursiops_truncatus/latest_assembly_versions/GCF_011762595.1_mTurTru1.mat.Y/GCF_011762595.1_mTurTru1.mat.Y_genomic.fna.gz
# wget -O Orcinus_orca.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Orcinus_orca/latest_assembly_versions/GCF_000331955.2_Oorc_1.1/GCF_000331955.2_Oorc_1.1_genomic.fna.gz
# wget -O Benthosema_glaciale.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Benthosema_glaciale/latest_assembly_versions/GCF_900302495.1_fBenGla1.1/GCF_900302495.1_fBenGla1.1_genomic.fna.g
# wget -O Galium_boreale.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Galium_boreale/latest_assembly_versions/GCF_xxxxxxxxx.x/GCF_xxxxxxxxx.x_genomic.fna.gz

#gunzip *.fna.gz


declare -A TAXONS=(
    ["Benthosema_glaciale"]="125796:/home/amartin3/genomes/Benthosema_glaciale.fna"
    ["Galium_boreale"]="35896:/home/amartin3/genomes/Galium_boreale.fna"
    ["Conger_conger"]="82655:/home/amartin3/genomes/Conger_conger.fna"
    ["Melanogrammus_aeglefinus"]="8056:/home/amartin3/genomes/Melanogrammus_aeglefinus.fna"
    ["Stenella_coeruleoalba"]="9737:/home/amartin3/genomes/Stenella_coeruleoalba.fna"
    ["Mus_musculus"]="10090:/home/amartin3/genomes/Mus_musculus.fna"
    ["Vitis_vinifera"]="29760:/storage/groups/gdec/shared_paleo/genomes_REF/12Xv2_grapevine_genome_assembly.fa"
    ["Triticum_monococcum"]="4568:/storage/groups/gdec/shared/Logan/New_accessions/GCA_034509565.1_PI306540_Tmono_genomic.fna"
    ["Tursiops_truncatus"]="9739:/home/amartin3/genomes/Tursiops_truncatus.fna"
    ["Orcinus_orca"]="9733:/home/amartin3/genomes/Orcinus_orca.fna"
)

#indexation des genomes de reference

echo "Indexation BWA..." # A ne faire qu'une fois


bwa index /home/amartin3/genomes//home/amartin3/genomes/Benthosema_glaciale.fna
bwa index /home/amartin3/genomes//home/amartin3/genomes/Galium_boreale.fna
bwa index /home/amartin3/genomes//home/amartin3/genomes/Stenella_coeruleoalba.fna
bwa index /home/amartin3/genomes//home/amartin3/genomes/Tursiops_truncatus.fna
bwa index /home/amartin3/genomes//home/amartin3/genomes/Orcinus_orca.fna



SAMPLES=("sed6" "sed8")
shopt -s nullglob

for sample in "${SAMPLES[@]}"; do
  FASTQDIR="${FASTQ_BASE_DIR}"

  for KRAKENFILE in ${KRAKEN_DIR_SOURCE}/*${sample}*.kraken; do
    if [ ! -f "$KRAKENFILE" ]; then
      continue
    fi

    KRAKENBASENAME=$(basename "$KRAKENFILE" .kraken)
    echo ">>> Processing $KRAKENBASENAME ($sample)" | tee -a "${LOGFILE}"

    PREFIX=$(echo "$KRAKENBASENAME" | sed -E 's/(un)?merged$//')

    R1FILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_unmerged_R1.fastq.gz"
    R2FILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_unmerged_R2.fastq.gz"
    MERGEDFILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_merged.fastq.gz"

    for GROUP in "${!TAXONS[@]}"; do
      IFS=':' read -r TAXID REFFASTA <<< "${TAXONS[$GROUP]}"
      DAMAGEDIR="${DAMAGEBASE}/${sample}/${GROUP}"
      mkdir -p "${DAMAGEDIR}"

      OUTR1="${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R1.fastq"
      OUTR2="${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R2.fastq"
      OUTMERGED="${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.fastq"

      # Reads unmerged (paired-end)
      if [[ "$KRAKENBASENAME" == *"unmerged"* ]] && [ -f "$R1FILE" ] && [ -f "$R2FILE" ]; then
        echo "Extraction des reads unmerged pour $GROUP..." | tee -a "${LOGFILE}"

        python3 ${KRAKENTOOLS_DIR}/extract_kraken_reads.py \
          -k "$KRAKENFILE" \
          -s "$R1FILE" -s2 "$R2FILE" \
          -t "$TAXID" \
          -o "$OUTR1" -o2 "$OUTR2" \
          --fastq-output 2>>"${LOGFILE}"

        if [ -f "$OUTR1" ] && [ -f "$OUTR2" ]; then
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

          mapDamage -i "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam" \
            -r "$REFFASTA" \
            --folder "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_mapDamage_unmerged" \
            --no-stats 2>>"${LOGFILE}"
    
          total_reads=$(samtools view -c "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam")
          mapped_reads=$(samtools view -c -F 4 "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sorted.bam")
          mapping_rate=0
          if [[ $total_reads -gt 0 ]]; then
            mapping_rate=$(echo "scale=2; $mapped_reads * 100 / $total_reads" | bc)
          fi
          echo -e "${sample}\t${GROUP}\tunmerged\t${total_reads}\t${mapped_reads}\t${mapping_rate}" >> "$MAPPING_INFO"
    
          rm -f "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R1.sai" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_R2.sai" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.sam" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.bam"
        fi
      fi

      # Reads merged (single-end)
      if [[ "$KRAKENBASENAME" == *"merged"* ]] && [ -f "$MERGEDFILE" ] && [[ "$KRAKENBASENAME" != *"unmerged"* ]]; then
        echo "Extraction des reads merged pour $GROUP..." | tee -a "${LOGFILE}"
        
        python3 ${KRAKENTOOLS_DIR}/extract_kraken_reads.py \
          -k "$KRAKENFILE" \
          -s "$MERGEDFILE" \
          -t "$TAXID" \
          -o "$OUTMERGED" \
          --fastq-output 2>>"${LOGFILE}"
  
        if [ -f "$OUTMERGED" ]; then
          bwa aln -n 0.08 -l 24 -k 2 -q 20 -t 4 "$REFFASTA" "$OUTMERGED" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sai" 2>>"${LOGFILE}"

          bwa samse "$REFFASTA" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sai" "$OUTMERGED" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sam" 2>>"${LOGFILE}"
          samtools view -bS "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sam" > "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.bam" 2>>"${LOGFILE}"
          samtools sort -o "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.bam" 2>>"${LOGFILE}"
          samtools index "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sorted.bam" 2>>"${LOGFILE}"

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

          rm -f "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sai" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.sam" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}_merged.bam"
        fi
      fi
    done
  done
done

echo "MapDamage K25 terminé avec succès."
