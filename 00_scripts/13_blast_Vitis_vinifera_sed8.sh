#!/bin/bash
#SBATCH --job-name=13_blast_Vitis_vinifera
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error=/home/amartin3/CapoSagro_Alexa/00_scripts/13_blast_Vitis_vinifera.err
#SBATCH --output=/home/amartin3/CapoSagro_Alexa/00_scripts/13_blast_Vitis_vinifera.out
#SBATCH --cpus-per-task=64

fichier_kraken_sed8="/home/amartin3/07_kraken2/clean_sed8_concat_dedup_merged.kraken"

fichier_fastq_sed8="/home/amartin3/05_fastp/clean_sed8_concat_dedup_fastp_merged.fastq.gz"

fichier_report_sed8="/home/amartin3/07_kraken2/clean_sed8_concat_dedup_merged.report"


module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

#############################SED 8##################################################################


cd /home/amartin3/07_kraken2

#1 extraire le taxid de la vigne
#python KrakenTools/extract_kraken_reads.py -k "$fichier_kraken_sed8" -s "$fichier_fastq_sed8" -o sortie_sed8.fastq -t 29760 -r "$fichier_report_sed8" --include-children

#2 convertir le fichier de sortie en fichier fasta
#seqkit fq2fa sortie_sed8.fastq -o sortie_sed8.fasta

#3 lancement du blast

blastn -num_threads 64 -query "/home/amartin3/07_kraken2/sortie_sed8.fasta" \
                -db /storage/biodatabanks/ncbi/NT/ncbi_blast_nt_2024-8-24/flat/nt -outfmt "6" \
                -evalue 1e-3 \
                -max_target_seqs 30 \
                -out vigne_sed8.blastn
                




