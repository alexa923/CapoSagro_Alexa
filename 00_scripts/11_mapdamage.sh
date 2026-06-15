#!/bin/bash
#SBATCH --job-name=11_mapdamage
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage.out"


BRACKEN_DIR="home/amartin3/08_bracken"
FASTQ_DIR="/home/amartin3/05_fastp"
DAMAGE_BASE="/home/amartin3/12_mapdamage"
KRACKENTOOLs_DIR="/home/amartin3/08_bracken/KrakenTools"


LOGFILE="${DAMAGE_BASE}/mapdamage_$(date +%Y%m%d_%H%M%S).txt"
MAPPING_INFO="${DAMAGE_BASE}/mapping_bwa_info.tsv"

mkdir -p "$DAMAGE_BASE"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

##installer mapdamage_py39

echo "Script MapDamage started at $(date)" | tee -a "$LOGFILE"

# Initialiser le fichier de mapping info
echo -e "Sample\tSpecies\tType\tTotalReads\tMappedReads\tMappingRate" > "${MAPPING_INFO}"

#telechargement des genomes

cd /home/amartin3/genomes

wget -O Homo_sapiens.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/latest_assembly_versions/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz
wget -O Canis_lupus.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Canis_lupus_familiaris/latest_assembly_versions/GCF_014441545.1_ROS_Cfam_1.0/GCF_014441545.1_ROS_Cfam_1.0_genomic.fna.gz
wget -O Mus_musculus.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Mus_musculus/latest_assembly_versions/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz
wget -O Ovis_aries.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Ovis_aries/latest_assembly_versions/GCF_016772045.2_ARS-UI_Ramb_v3.0/GCF_016772045.2_ARS-UI_Ramb_v3.0_genomic.fna.gz
wget -O Bos_taurus.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Bos_taurus/latest_assembly_versions/GCF_002263795.3_ARS-UCD2.0/GCF_002263795.3_ARS-UCD2.0_genomic.fna.gz



wget -O Conger_conger.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Conger_conger/latest_assembly_versions/GCF_963514075.1_fConCon1.1/GCF_963514075.1_fConCon1.1_genomic.fna.gz
#Diplodus_sargus.fna.gz sur genome ref ncbi
wget -O Engraulis_encrasicolus.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Engraulis_encrasicolus/latest_assembly_versions/GCF_034702125.1_IST_EnEncr_1.0/GCF_034702125.1_IST_EnEncr_1.0_genomic.fna.gz
#Merluccius_merluccius sur genome ref ncbi
#Gobiusculus_flavescens sur European Nucleotide Archive

#vigne deja telecharge
#Triticum_monococcum deja telecharge
#Triticum_aestivum deja telecharge
wget -O Oryza_sativa.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Oryza_sativa/latest_assembly_versions/GCF_034140825.1_ASM3414082v1/GCF_034140825.1_ASM3414082v1_genomic.fna.gz
#Quercus_variabilis sur genome ref ncbi
wget -O Hordeum_vulgare.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plants/Hordeum_vulgare/latest_assembly_versions/GCF_904849725.1_MorexV3_pseudomolecules_assembly/GCF_904849725.1_MorexV3_pseudomolecules_assembly_genomic.fna.gz
wget -O Cannabis_sativa.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Cannabis_sativa/latest_assembly_versions/GCF_029168945.1_ASM2916894v1/GCF_029168945.1_ASM2916894v1_genomic.fna.gz

gunzip *.fna.gz



declare -A TAXONS=(
    
    ["Homo_sapiens"]="9606:/home/amartin3/genomes/Homo_sapiens.fna"
    ["Canis_lupus"]="9612:/home/amartin3/genomes/Canis_lupus.fna"
    ["Mus_musculus"]="10090:/home/amartin3/genomes/Mus_musculus.fna"
    ["Ovis_aries"]="9940:/home/amartin3/genomes/Ovis_aries.fna"
    ["Bos_taurus"]="9913:/home/amartin3/genomes/Bos_taurus.fna"

    
    ["Conger_conger"]="82655:/home/amartin3/genomes/Conger_conger.fna"
    ["Diplodus_sargus"]="38941:/home/amartin3/genomes/Diplodus_sargus.fna"
    ["Engraulis_encrasicolus"]="184585:/home/amartin3/genomes/Engraulis_encrasicolus.fna"
    ["Merluccius_merluccius"]="8063:/home/amartin3/genomes/Merluccius_merluccius.fna"
    ["Gobiusculus_flavescens"]="257540:/home/amartin3/genomes/Gobiusculus_flavescens.fasta"

    
    ["Vitis_vinifera"]="29760:/storage/groups/gdec/shared_paleo/genomes_REF/12Xv2_grapevine_genome_assembly.fa"
    ["Triticum_monococcum"]="4568:/storage/groups/gdec/shared/Logan/New_accessions/GCA_034509565.1_PI306540_Tmono_genomic.fna"
    ["Triticum_aestivum"]="4565:/storage/groups/gdec/shared/Logan/Accessions/GCF_018294505.1_IWGSC_CS_RefSeq_v2.1_genomic.fna"
    ["Oryza_sativa"]="4530:/home/amartin3/genomes/Oryza_sativa.fna"
    ["Quercus_variabilis"]="103481:/home/amartin3/genomes/Quercus_variabilis.fna"
    ["Hordeum_vulgare"]="4513:/home/amartin3/genomes/Hordeum_vulgare.fna"
    ["Cannabis_sativa"]="3483:/home/amartin3/genomes/Cannabis_sativa.fna"
)



# INDEXATION BWA DES GÉNOMES DE RÉFÉRENCE

echo "Indexation BWA..." # A ne faire qu'une fois !

bwa index /home/amartin3/genomes/Homo_sapiens.fna
bwa index /home/amartin3/genomes/Canis_lupus.fna
bwa index /home/amartin3/genomes/Mus_musculus.fna
bwa index /home/amartin3/genomes/Ovis_aries.fna
bwa index /home/amartin3/genomes/Bos_taurus.fna

bwa index /home/amartin3/genomes/Conger_conger.fna
bwa index /home/amartin3/genomes/Diplodus_sargus.fna
bwa index /home/amartin3/genomes/Engraulis_encrasicolus.fna
bwa index /home/amartin3/genomes/Merluccius_merluccius.fna
bwa index /home/amartin3/genomes/Gobiusculus_flavescens.fasta

bwa index /storage/groups/gdec/shared_paleo/genomes_REF/12Xv2_grapevine_genome_assembly.fa
bwa index /storage/groups/gdec/shared/Logan/New_accessions/GCA_034509565.1_PI306540_Tmono_genomic.fna
bwa index /storage/groups/gdec/shared/Logan/Accessions/GCF_018294505.1_IWGSC_CS_RefSeq_v2.1_genomic.fna
bwa index /home/amartin3/genomes/Oryza_sativa.fna
bwa index /home/amartin3/genomes/Quercus_variabilis.fna
bwa index /home/amartin3/genomes/Hordeum_vulgare.fna
bwa index /home/amartin3/genomes/Cannabis_sativa.fna


#calcul du taux de mapping 
calculate_mapping_rate() {
    local bam_file="$1"
    local sample_name="$2"
    local species="$3"
    local type="$4"
    
    if [[ -f "$bam_file" ]]; then
        local total_reads=$(samtools view -c "$bam_file")
        local mapped_reads=$(samtools view -c -F 4 "$bam_file")
        local mapping_rate=0
        if [[ $total_reads -gt 0 ]]; then
            mapping_rate=$(echo "scale=2; $mapped_reads * 100 / $total_reads" | bc)
        fi
        echo -e "${sample_name}\t${species}\t${type}\t${total_reads}\t${mapped_reads}\t${mapping_rate}" >> "$MAPPING_INFO"
        echo "✓ Stats for ${sample_name}_${species}_${type}: ${mapped_reads}/${total_reads} (${mapping_rate}%)" | tee -a "$LOGFILE"
    fi
}


#boucle de traitement des echantillons
SAMPLES=("sed6" "sed8")
shopt -s nullglob


for sample in "${SAMPLES[@]}"; do
  echo ""
  echo "======================================================================"
  echo "Traitement de l'échantillon: $sample"
  echo "======================================================================"

BRACKEN_DIR="${BRACKENBASE}/${sample}"
FASTQDIR="${FASTQBASE}/${sample}"

  if [ ! -d "$BRACKEN_DIR" ]; then
    echo "ATTENTION: Répertoire Bracken absent pour $sample" | tee -a "${LOGFILE}"
    continue
  fi

   # Boucle sur les fichiers Bracken (merged et unmerged)
  for BRACKENFILE in ${BRACKEN_DIR}/*.bracken; do
    if [ ! -f "$BRACKENFILE" ]; then
      continue
    fi


    BRACKENBASENAME=$(basename "$BRACKENFILE" .bracken)
    echo ""
    echo ">>> Processing $BRACKENBASENAME ($sample)" | tee -a "${LOGFILE}"


    # Extraire le préfixe de base
    PREFIX=$(echo "$BRACKENBASENAME" | sed -E 's/(un)?merged$//')
    echo "Prefix: $PREFIX" | tee -a "${LOGFILE}"

    KRAKEN="/home/amartin3/07_kraken2"

    # Chercher les fichiers FASTQ correspondants (Ajustés avec TES vrais noms de fichiers)
    R1FILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_unmerged_R1.fastq.gz"
    R2FILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_unmerged_R2.fastq.gz"
    MERGEDFILE="${FASTQDIR}/clean_${sample}_concat_dedup_fastp_merged.fastq.gz"

    #Boucle sur les espèces (17 taxons) 
    for GROUP in "${!TAXONS[@]}"; do
      IFS=':' read -r TAXID REFFASTA <<< "${TAXONS[$GROUP]}"
      DAMAGEDIR="${DAMAGEBASE}/${sample}/${GROUP}"
      mkdir -p "${DAMAGEDIR}"

      echo ""
      echo "--- Espèce: $GROUP (TaxID: $TAXID) ---"

      OUTR1="${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R1.fastq"
      OUTR2="${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R2.fastq"
      OUTMERGED="${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_merged.fastq"

      #Traitement des reads unmerged (paired-end) 
      if [[ "$KRAKENBASENAME" == *"unmerged"* ]] && [ -f "$R1FILE" ] && [ -f "$R2FILE" ]; then
        echo "Extraction des reads unmerged pour $GROUP..." | tee -a "${LOGFILE}"

        python3 ${KRAKENTOOLS_DIR}/extract_kraken_reads.py \
          -k "$KRAKENFILE" \  #attention fichiers kraken ne sont pas dans le même dossier
          -r "$BRACKENFILE" \
          -s "$R1FILE" -s2 "$R2FILE" \
          -t "$TAXID" \
          -o "$OUTR1" -o2 "$OUTR2" \
          --fastq-output 2>>"${LOGFILE}"

        if [ -f "$OUTR1" ] && [ -f "$OUTR2" ]; then
          echo "Mapping BWA paired-end pour $GROUP..." | tee -a "${LOGFILE}"

          #BWA aln
          bwa aln -n 0.08 -l 24 -k 2 -q 20 -t 4 "$REFFASTA" "$OUTR1" > "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R1.sai" 2>>"${LOGFILE}"
          bwa aln -n 0.08 -l 24 -k 2 -q 20 -t 4 "$REFFASTA" "$OUTR2" > "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R2.sai" 2>>"${LOGFILE}"

          #BWA sampe
          bwa sampe "$REFFASTA" \
            "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R1.sai" \
            "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R2.sai" \
            "$OUTR1" "$OUTR2" \
            > "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sam" 2>>"${LOGFILE}

          #conversion de SAM à BAM
          samtools view -bS "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sam" > "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.bam" 2>>"${LOGFILE}"

          #tri et indexation
          samtools sort -o "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sorted.bam" "${DAMAGEDIR}/${KRAKENBASENAME}_${GROUP}.bam" 2>>"${LOGFILE}"
          samtools index "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sorted.bam" 2>>"${LOGFILE}

          #MapDamage
          echo "MapDamage unmerged pour $GROUP..." | tee -a "${LOGFILE}"
          mapDamage -i "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sorted.bam" \
            -r "$REFFASTA" \
            --folder "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_mapDamage_unmerged" \
            --no-stats 2>>"${LOGFILE}"
    
          calculate_mapping_rate "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sorted.bam" "$sample" "$GROUP" "unmerged"
    
          rm -f "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R1.sai" \
                "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}_R2.sai" \
                "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.sam" \
                "${DAMAGEDIR}/${BRACKENBASENAME}_${GROUP}.bam" 2>>"${LOGFILE}"
        fi
      fi

      #Traitement des reads merged (single-end)
      if [[ "$BRACKENBASENAME" == *"merged"* ]] && [ -f "$MERGEDFILE" ]; then
        echo "Extraction des reads merged pour $GROUP..." | tee -a "${LOGFILE}"
        
        python3 ${KRAKENTOOLS_DIR}/extract_kraken_reads.py \
          -k "$KRAKENFILE" \
          -r "$BRACKENFILE" \
          -s "$MERGEDFILE" \
          -t "$TAXID" \
          -o "$OUTMERGED" \
          --fastq-output 2>>"${LOGFILE}"
  
        if [ -f "$OUTMERGED" ]; then
          echo "Mapping BWA single-end pour $GROUP..." | tee -a "${LOGFILE}"

