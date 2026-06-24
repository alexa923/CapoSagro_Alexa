#!/bin/bash
#SBATCH --job-name=11_mapdamage_vitis_vinifera
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage_vitis_vinifera.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/11_mapdamage_vitis_vinifera.out"


VITIS_DIR="/home/amartin3/12_mapdamage/sed6/Vitis_vinifera"

REF_FASTA="/storage/groups/gdec/shared_paleo/genomes_REF/12Xv2_grapevine_genome_assembly.fa"

OUT_DIR="/home/amartin3/12_mapdamage_vitis_vinifera"
MAPPING_INFO="${OUT_DIR}/mapping_vigne_combined_info.tsv"

mkdir -p "$OUT_DIR"

# Chargement de l'environnement
module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

echo "Début du traitement de la vigne (sed6) à $(date)"
echo -e "Sample\tSpecies\tType\tTotalReads\tMappedReads\tMappingRate" > "${MAPPING_INFO}"

#recuperation des fichiers bam
BAM_UNMERGED=$(ls ${VITIS_DIR}/*unmerged*.sorted.bam)
BAM_MERGED=$(ls ${VITIS_DIR}/*merged*.sorted.bam | grep -v "unmerged")

echo "Fichier Unmerged trouvé : $BAM_UNMERGED"
echo "Fichier Merged trouvé : $BAM_MERGED"


#concatenation des fichiers
echo "Conversion des BAMs en SAM"
samtools view -h "$BAM_UNMERGED" > "${OUT_DIR}/unmerged.sam"
samtools view "$BAM_MERGED" > "${OUT_DIR}/merged_no_header.sam"

echo "Concaténation des fichiers SAM..."
cat "${OUT_DIR}/unmerged.sam" "${OUT_DIR}/merged_no_header.sam" > "${OUT_DIR}/sed6_Vitis_vinifera_combined.sam"

echo "Conversion du SAM combiné en BAM trie"
BAM_COMBINED_SORTED="${OUT_DIR}/sed6_Vitis_vinifera_combined.sorted.bam"
samtools sort -o "${OUT_DIR}/sed6_Vitis_vinifera_combined.sorted.bam" "${OUT_DIR}/sed6_Vitis_vinifera_combined.sam"
samtools index "${OUT_DIR}/sed6_Vitis_vinifera_combined.sorted.bam"

#suppression des fichiers temporaires 
rm -f "${OUT_DIR}/unmerged.sam" "${OUT_DIR}/merged_no_header.sam" "${OUT_DIR}/sed6_Vitis_vinifera_combined.sam"

#calcul du mapping rate
total_reads=$(samtools view -c "$BAM_COMBINED_SORTED")
mapped_reads=$(samtools view -c -F 4 "$BAM_COMBINED_SORTED")
mapping_rate=0

if [[ $total_reads -gt 0 ]]; then
  mapping_rate=$(echo "scale=2; $mapped_reads * 100 / $total_reads" | bc)
fi

echo -e "sed6\tVitis_vinifera\tcombined\t${total_reads}\t${mapped_reads}\t${mapping_rate}" >> "$MAPPING_INFO"
echo "Stats for sed6_Vitis_vinifera_combined: ${mapped_reads}/${total_reads} (${mapping_rate}%)"

#lancement de mapdamage
echo "Lancement de mapDamage..."
mapDamage -i "$BAM_COMBINED_SORTED" \
  -r "$REF_FASTA" \
  --folder "${OUT_DIR}/mapDamage_combined_results" \
  --no-stats

echo "Fin du script avec succès à $(date)"
