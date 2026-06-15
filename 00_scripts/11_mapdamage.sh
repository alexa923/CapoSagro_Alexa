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
wget -O Canis_lupus.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Canis_lupus_familiaris/latest_assembly_versions/GCF_014441545.1_ROS_Cfam_1.0/GCF_014441545.1_ROS_Cfam_1.0_genomic.fna.gz
wget -O Mus_musculus.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Mus_musculus/latest_assembly_versions/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz
wget -O Ovis_aries.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Ovis_aries/latest_assembly_versions/GCF_016772045.1_ARS-UI_Ramb_v3.0/GCF_016772045.1_ARS-UI_Ramb_v3.0_genomic.fna.gz
wget -O Bos_taurus.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/Bos_taurus/latest_assembly_versions/GCF_002263795.3_ARS-UCD1.3/GCF_002263795.3_ARS-UCD1.3_genomic.fna.gz

wget -O Conger_conger.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Conger_conger/latest_assembly_versions/GCF_963691635.1_fConCon1.1/GCF_963691635.1_fConCon1.1_genomic.fna.gz
wget -O Diplodus_sargus.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Diplodus_sargus/latest_assembly_versions/GCF_949127535.1_fDipSar1.1/GCF_949127535.1_fDipSar1.1_genomic.fna.gz
wget -O Engraulis_encrasicolus.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Engraulis_encrasicolus/latest_assembly_versions/GCF_947565395.1_fEngEnc1.1/GCF_947565395.1_fEngEnc1.1_genomic.fna.gz
wget -O Merluccius_merluccius.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Merluccius_merluccius/latest_assembly_versions/GCF_944039175.1_fMerMer1.2/GCF_944039175.1_fMerMer1.2_genomic.fna.gz
wget -O Gobiusculus_flavescens.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/Gobiusculus_flavescens/latest_assembly_versions/GCF_963870625.1_fGobFla1.1/GCF_963870625.1_fGobFla1.1_genomic.fna.gz

wget -O Vitis_vinifera.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Vitis_vinifera/latest_assembly_versions/GCF_000003745.3_12X/GCF_000003745.3_12X_genomic.fna.gz
wget -O Triticum_monococcum.fa https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/947/556/615/GCA_947556615.1_TAES_TA2067/GCA_947556615.1_TAES_TA2067_genomic.fna.gz
wget -O Triticum_aestivum.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Triticum_aestivum/latest_assembly_versions/GCF_003473745.1_IWGSC_RefSeq_v1.0/GCF_003473745.1_IWGSC_RefSeq_v1.0_genomic.fna.gz
wget -O Oryza_sativa.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Oryza_sativa/latest_assembly_versions/GCF_000005425.2_IRGSP-1.0/GCF_000005425.2_IRGSP-1.0_genomic.fna.gz
wget -O Quercus_variabilis.fa https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/027/915/715/GCA_027915715.1_ASM2791571v1/GCA_027915715.1_ASM2791571v1_genomic.fna.gz
wget -O Hordeum_vulgare.fa https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/902/500/625/GCA_902500625.2_Morex_V3/GCA_902500625.2_Morex_V3_genomic.fna.gz
wget -O Cannabis_sativa.fa https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Cannabis_sativa/latest_assembly_versions/GCF_029168945.1_cs10_v3/GCF_029168945.1_cs10_v3_genomic.fna.gz

