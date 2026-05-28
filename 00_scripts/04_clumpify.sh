#!/bin/bash
#SBATCH --job-name=04_clumpify
#SBATCH --ntasks=1
#SBATCH -p smp
#SBATCH --mem=1000G
#SBATCH --mail-user=alexa.martin@inrae.fr
#SBATCH --mail-type=ALL 
#SBATCH --error="/home/amartin3/CapoSagro_Alexa/00_scripts/04_clumpify.err"
#SBATCH --output="/home/amartin3/CapoSagro_Alexa/00_scripts/04_clumpify.out"


ENTREE="/home/amartin3/03_fastuniq"
SORTIE="/home/amartin3/04_clumpify"

module load conda/4.12.0
source ~/.bashrc
conda activate bioinformatic

CLUMPIFY=/home/amartin3/bbmap/clumpify.sh

#crée le dossier s'il n'existe pas
mkdir -p "$SORTIE"

#pour tous les fichiers R1 
for R1 in "$ENTREE"/*_R1.fastq; do
    # Déduire le nom du fichier R2 correspondant
    R2="${R1/_R1.fastq/_R2.fastq}"
    # Vérifier que le fichier R2 existe
    if [[ -f "$R2" ]]; then
        # Extraire le nom de base pour l'output 
        base=$(basename "$R1" _R1.fastq) #pourquoi ?

        #Lancement de Clumpify pour chaque paire de reads
        $CLUMPIFY \
            in="$R1" in2="$R2" \
            out="$SORTIE/${base}_clumpify_R1.fastq.gz" \
            out2="SORTIE/${base}_clumpify_R2.fastq.gz" \
            dedupe=t #Remove duplicate reads.  For pairs, both must match pourquoi=t
        echo "Clumpify terminé pour $base
    else
        echo "Fichier R2 manquant pour $R1, ignoré" #comment ça ignoré
    fi #pourquoi
done    

#faire controle qualité 
