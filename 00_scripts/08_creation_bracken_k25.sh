#!/bin/bash
#SBATCH -p gdec
#SBATCH --mem=300G
#SBATCH -J K25_brack
#SBATCH -o K25_brack.out
#SBATCH -e K25_brack.err
#SBATCH --cpus-per-task=64


DB_DIR="/storage/groups/gdec/shared/Kraken_database/core_nt_k25"
bracken-build -d $DB_DIR -t 64 -k 25 -l 50
