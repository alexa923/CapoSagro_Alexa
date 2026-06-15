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
#Gobiusculus_flavescens sur genome ref ncbi

#vigne deja telecharge
#Triticum_monococcum deja telecharge
#Triticum_aestivum deja telecharge
wget -O Oryza_sativa.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Oryza_sativa/latest_assembly_versions/GCF_034140825.1_ASM3414082v1/GCF_034140825.1_ASM3414082v1_genomic.fna.gz
#Quercus_variabilis sur genome ref ncbi
wget -O Hordeum_vulgare.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plants/Hordeum_vulgare/latest_assembly_versions/GCF_904849725.1_MorexV3_pseudomolecules_assembly/GCF_904849725.1_MorexV3_pseudomolecules_assembly_genomic.fna.gz
wget -O Cannabis_sativa.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Cannabis_sativa/latest_assembly_versions/GCF_029168945.1_ASM2916894v1/GCF_029168945.1_ASM2916894v1_genomic.fna.gz

gunzip *.fna.gz



declare -A TAXONS=(
    --
    ["Homo_sapiens"]="9606:/home/amartin3/genomes/Homo_sapiens.fna"
    ["Canis_lupus"]="9612:/home/amartin3/genomes/Canis_lupus.fna"
    ["Mus_musculus"]="10090:/home/amartin3/genomes/Mus_musculus.fna"
    ["Ovis_aries"]="9940:/home/amartin3/genomes/Ovis_aries.fna"
    ["Bos_taurus"]="9913:/home/amartin3/genomes/Bos_taurus.fna"

    
    ["Conger_conger"]="82655:/home/amartin3/genomes/Conger_conger.fna"
    ["Diplodus_sargus"]="38941:/home/amartin3/genomes/Diplodus_sargus.fna"
    ["Engraulis_encrasicolus"]="184585:/home/amartin3/genomes/Engraulis_encrasicolus.fna"
    ["Merluccius_merluccius"]="8063:/home/amartin3/genomes/Merluccius_merluccius.fna"
    

    
    ["Vitis_vinifera"]="29760:/storage/groups/gdec/shared_paleo/genomes_REF/12Xv2_grapevine_genome_assembly.fa"
    ["Triticum_monococcum"]="4568:/storage/groups/gdec/shared/Logan/New_accessions/GCA_034509565.1_PI306540_Tmono_genomic.fna"
    ["Triticum_aestivum"]="4565:/storage/groups/gdec/shared/Logan/Accessions/GCF_018294505.1_IWGSC_CS_RefSeq_v2.1_genomic.fna"
    ["Oryza_sativa"]="4530:/home/amartin3/genomes/Oryza_sativa.fa"
    ["Quercus_variabilis"]="103481:/home/amartin3/genomes/Quercus_variabilis.fa"
    ["Hordeum_vulgare"]="4513:/home/amartin3/genomes/Hordeum_vulgare.fa"
    ["Cannabis_sativa"]="3483:/home/amartin3/genomes/Cannabis_sativa.fa"
)
