#!/bin/bash
#SBATCH --job-name=01_quality_check
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/01_quality_check.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/01_quality_check.out"

#activer environnement conda
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

#créer des dossiers de sortie QC (avant et après concaténation)
Home="/home/amartin3"
mkdir -p "${Home}/02_QC_raw_data"
mkdir -p "${Home}/02_QC_concatenated_data"

#QC des fichiers bruts avant concaténation 
cd ${Home}/02_QC_raw_data
echo "Début de l'analyse FastQC"

fastqc \
  /storage/groups/gdec/shared_paleo/Illumina/01_raw_data/*.fastq.gz \
  /storage/groups/gdec/shared_paleo/E1531_final/run1_20250320_AV241601_E1531_Ps5Lane1_Ps6Lane2/*/*.fastq.gz \
  /storage/groups/gdec/shared_paleo/E1531_final/run2_20250414_AV241601_E1531_Ps5_Ps6_11022026_CORRECTED/*/*.fastq.gz \
  /storage/groups/gdec/shared_paleo/E1531_final/run3_20251008_AV241601_E1531_Ps7_Ps8/*/*.fastq.gz \
  /storage/groups/gdec/shared_paleo/E1531_final/run4_20251104_AV241601_E1531_Ps7_Ps8_04112025/*/*.fastq.gz \
  /storage/groups/gdec/shared_paleo/E1672/*/*.fastq.gz \
  --outdir .
#agrégation des rapports fastQC avant cat
echo "Agrégation avec MultiQC"
multiqc . -o .
echo "Fin du contrôle qualité"

#QC des fichiers concaténés 
cd ${Home}/02_QC_concatenated_data
echo "Début de l'analyse FastQC après concaténation"

fastqc \
  /home/amartin3/01_concatenated_data/sed6_concat_R1.fastq.gz \
  /home/amartin3/01_concatenated_data/sed6_concat_R2.fastq.gz \
  /home/amartin3/01_concatenated_data/sed8_concat_R1.fastq.gz \
  /home/amartin3/01_concatenated_data/sed8_concat_R2.fastq.gz \
  --outdir .

# Agrégation des rapports FastQC (après cat)
echo "Agrégation avec MultiQC après concaténation"
multiqc . -o .
echo "Fin des contrôles qualité"
