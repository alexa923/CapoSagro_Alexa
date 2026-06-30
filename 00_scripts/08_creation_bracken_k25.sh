#!/bin/bash
#SBATCH -p gdec
#SBATCH --mem=300G
#SBATCH -J 08_creation_bracken_k25
#SBATCH -o 08_creation_bracken_k25.out
#SBATCH -e 08_creation_bracken_k25.err
#SBATCH --cpus-per-task=64



DB_DIR="/storage/groups/gdec/shared/Kraken_database/core_nt_k25"
bracken-build -d $DB_DIR -t 64 -k 25 -l 50
