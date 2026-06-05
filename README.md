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
BBduk remove Phix sequences used for diversity while sequencing using the 02_bbduk2.sh script

* 02_bbduk.sh was a test with trimming parameters but removed too much reads
* 02_bbduk3.sh was a test with trimming parameters including a minimum length of 20bp for the reads but also removed too much reads
* 02_bbduk2.sh was the best option knowing that trimming parameters will be included in the seventh step (fastp).

### Step 4
Fastuniq allowed us to deduplicate the reads (due to PCR) to only keep real biological information using the 03_fastuniq2.sh script.

* 03_fastuniq.sh was a test using bbduk.sh output files

### Step 5

