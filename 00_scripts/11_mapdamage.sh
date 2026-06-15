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
echo -e "Sample\tSpecies\tType\tTotalReads\tMappedReads\tMappingRate" > "${MAPPINGINFO}"

#telechargement des genomes 
 wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/latest_assembly_versions/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz
--2026-06-15 09:43:41--  https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/latest_assembly_versions/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz
