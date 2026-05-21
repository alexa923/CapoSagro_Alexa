#!/bin/bash

#SBATCH --job-name=00_concatenated_files
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/alexa923/CapoSagro_Alexa/00_scripts/00_concatenated_files.err"
#SBATCH --output="/home/alexa923/CapoSagro_Alexa/00_scripts/00_concatenated_files.out"

RUN1="/storage/groups/gdec/shared_paleo/Illumina/01_raw_data"
RUN2="/storage/groups/gdec/shared_paleo/E1531_final/run1_20250320_AV241601_E1531_Ps5Lane1_Ps6Lane2"
RUN3="/storage/groups/gdec/shared_paleo/E1531_final/run2_20250414_AV241601_E1531_Ps5_Ps6_11022026_CORRECTED"
RUN4="/storage/groups/gdec/shared_paleo/E1531_final/run3_20251008_AV241601_E1531_Ps7_Ps8"
RUN5="/storage/groups/gdec/shared_paleo/E1531_final/run4_20251104_AV241601_E1531_Ps7_Ps8_04112025"
RUN6="/storage/groups/gdec/shared_paleo/E1672"
Home="/home/amartin3"

#echo "Concaténation des fichiers sed6"
## sed6 R1

#cat \
#  ${RUN1}/1120_sed6_rep3_R1.fastq.gz \
#  ${RUN1}/1129_sed6_rep1_R1.fastq.gz \
#  ${RUN1}/1130_sed6_rep2_R1.fastq.gz \
#  ${RUN2}/1120_sed6_rep3/1120_sed6_rep3_R1.fastq.gz \
#  ${RUN2}/1129_sed6_rep1/1129_sed6_rep1_R1.fastq.gz \
#  ${RUN2}/1130_sed6_rep2/1130_sed6_rep2_R1.fastq.gz \
#  ${RUN3}/1129_sed6_rep1/1129_sed6_rep1_R1.fastq.gz \
#  ${RUN3}/1130_sed6_rep2/1130_sed6_rep2_R1.fastq.gz \
#  ${RUN3}/1120_sed6_rep3/1120_sed6_rep3_R1.fastq.gz \
#  ${RUN4}/1129_sed6_rep1/1129_sed6_rep1_R1.fastq.gz \
#  ${RUN4}/1130_sed6_rep2/1130_sed6_rep2_R1.fastq.gz \
#  ${RUN5}/1129_sed6_rep1/1129_sed6_rep1_R1.fastq.gz \
#  ${RUN5}/1130_sed6_rep2/1130_sed6_rep2_R1.fastq.gz \
#  ${RUN6}/1129_sed6-rep1/1129_sed6-rep1_R1.fastq.gz \
#  ${RUN6}/1130_sed6-rep2/1130_sed6-rep2_R1.fastq.gz \
#  > "${Home}/sed6/sed6_concat_R1.fastq.gz"

##sed6 R2

#cat \
#  ${RUN1}/1120_sed6_rep3_R2.fastq.gz \
#  ${RUN1}/1129_sed6_rep1_R2.fastq.gz \
#  ${RUN1}/1130_sed6_rep2_R2.fastq.gz \
#  ${RUN2}/1120_sed6_rep3/1120_sed6_rep3_R2.fastq.gz \
#  ${RUN2}/1129_sed6_rep1/1129_sed6_rep1_R2.fastq.gz \
#  ${RUN2}/1130_sed6_rep2/1130_sed6_rep2_R2.fastq.gz \
#  ${RUN3}/1129_sed6_rep1/1129_sed6_rep1_R2.fastq.gz \
#  ${RUN3}/1130_sed6_rep2/1130_sed6_rep2_R2.fastq.gz \
#  ${RUN3}/1120_sed6_rep3/1120_sed6_rep3_R2.fastq.gz \
#  ${RUN4}/1129_sed6_rep1/1129_sed6_rep1_R2.fastq.gz \
#  ${RUN4}/1130_sed6_rep2/1130_sed6_rep2_R2.fastq.gz \
#  ${RUN5}/1129_sed6_rep1/1129_sed6_rep1_R2.fastq.gz \
#  ${RUN5}/1130_sed6_rep2/1130_sed6_rep2_R2.fastq.gz \
#  ${RUN6}/1129_sed6-rep1/1129_sed6-rep1_R2.fastq.gz \
#  ${RUN6}/1130_sed6-rep2/1130_sed6-rep2_R2.fastq.gz \
#  > "${Home}/sed6/sed6_concat_R2.fastq.gz"

#echo "Concaténation sed6 terminée."

#echo "Concaténation des fichiers sed8"
## sed 8 R1

#cat \
#  ${RUN1}/1121_sed8_rep1_R1.fastq.gz \
#  ${RUN1}/1122_sed8_rep2_R1.fastq.gz \
#  ${RUN1}/1131_sed8_rep3_R1.fastq.gz \
#  ${RUN2}/1121_sed8_rep1/1121_sed8_rep1_R1.fastq.gz \
#  ${RUN2}/1122_sed8_rep2/1122_sed8_rep2_R1.fastq.gz \
#  ${RUN2}/1131_sed8_rep3/1131_sed8_rep3_R1.fastq.gz \
#  ${RUN3}/1121_sed8_rep1/1121_sed8_rep1_R1.fastq.gz \
#  ${RUN3}/1122_sed8_rep2/1122_sed8_rep2_R1.fastq.gz \
#  ${RUN3}/1131_sed8_rep3/1131_sed8_rep3_R1.fastq.gz \
#  ${RUN4}/1121_sed8_rep1/1121_sed8_rep1_R1.fastq.gz \
#  ${RUN4}/1122_sed8_rep2/1122_sed8_rep2_R1.fastq.gz \
#  ${RUN5}/1121_sed8_rep1/1121_sed8_rep1_R1.fastq.gz \
#  ${RUN5}/1122_sed8_rep2/1122_sed8_rep2_R1.fastq.gz \
#  ${RUN6}/1121_sed8-rep1/1121_sed68-rep1_R1.fastq.gz \
#  ${RUN6}/1122_sed8-rep2/1122_sed8-rep2_R1.fastq.gz \
#  > "${Home}/sed8/sed8_concat_R1.fastq.gz"



## sed 8 R2

#cat \
#  ${RUN1}/1121_sed8_rep1_R2.fastq.gz \
#  ${RUN1}/1122_sed8_rep2_R2.fastq.gz \
#  ${RUN1}/1131_sed8_rep3_R2.fastq.gz \
#  ${RUN2}/1121_sed8_rep1/1121_sed8_rep1_R2.fastq.gz \
#  ${RUN2}/1122_sed8_rep2/1122_sed8_rep2_R2.fastq.gz \
#  ${RUN2}/1131_sed8_rep3/1131_sed8_rep3_R2.fastq.gz \
#  ${RUN3}/1121_sed8_rep1/1121_sed8_rep1_R2.fastq.gz \
#  ${RUN3}/1122_sed8_rep2/1122_sed8_rep2_R2.fastq.gz \
#  ${RUN3}/1131_sed8_rep3/1131_sed8_rep3_R2.fastq.gz \
#  ${RUN4}/1121_sed8_rep1/1121_sed8_rep1_R2.fastq.gz \
#  ${RUN4}/1122_sed8_rep2/1122_sed8_rep2_R2.fastq.gz \
#  ${RUN5}/1121_sed8_rep1/1121_sed8_rep1_R2.fastq.gz \
#  ${RUN5}/1122_sed8_rep2/1122_sed8_rep2_R2.fastq.gz \
#  ${RUN6}/1121_sed8-rep1/1121_sed8-rep1_R2.fastq.gz \
#  ${RUN6}/1122_sed8-rep2/1122_sed8-rep2_R2.fastq.gz \
#  > "${Home}/sed8/sed8_concat_R2.fastq.gz"

#echo "Concaténation sed8 terminée."
#echo "Concaténation terminée pour tous les échantillons."
