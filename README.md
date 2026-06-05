# CapoSagro_Alexa

This project aims to study the marine ecosystems surrounding the Roman shipwreck Capo Sagro II using sedimentary DNA samples in order to reconstruct past marine biodiversity and understand the influence of the shipwreck and its cargo on the composition of these ecosystems, as part of the UMR GDEC (PaleoEvo Team) within the PaleoLab entity and in collaboration with DRASSM.

### Installing pipeline :

First, open your terminal. Then, run these two command lines :

    cd -place_in_your_local_computer
    git clone https://github.com/alexa923/CapoSagro_Alexa.git

### Update the pipeline in local by :

    git pull


### Step 1
Concatenated data: sed6 and sed8 samples for each run and replicat with the script 00_concatenated_files.sh

### Step 2
Quality check (fastqc and multiqc) on raw data and then concatenated data to check the sequences quality and look after similar patterns before and after the concatenation with the script 01_quality_check.sh

### Step 3

