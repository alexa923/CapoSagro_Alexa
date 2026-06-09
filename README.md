# CapoSagro_Alexa

This project aims to study the marine ecosystems surrounding the Roman shipwreck Capo Sagro II using sedimentary DNA samples in order to reconstruct past marine biodiversity and understand the influence of the shipwreck and its cargo on the composition of these ecosystems, as part of the UMR GDEC (PaleoEvo Team) within the PaleoLab entity and in collaboration with DRASSM.

### Installing pipeline :

First, open your terminal. Then, run these two command lines :

    cd -place_in_your_local_computer
    git clone https://github.com/alexa923/CapoSagro_Alexa.git

### Update the pipeline in local by :

    git pull


### Step 1
Data concatenation of sed6 and sed8 samples for each run and replicat with the script 00_concatenated_files.sh

### Step 2
Quality check (fastqc and multiqc) on raw data and then concatenated data to check the sequences quality and look after similar patterns before and after the concatenation with the script 01_quality_check.sh

### Step 3
At first, we used bbdduk to start cleaning the data which remove Phix sequences used for diversity in sequencing using the 02_bbduk2.sh script

* 02_bbduk.sh was a test with trimming parameters but removed too much reads
* 02_bbduk3.sh was a test with trimming parameters including a smaller minimum length of 20bp for the reads but also removed too much reads
* 02_bbduk2.sh was the best option knowing that trimming parameters will be included in the seventh step (fastp).

### Step 4
Fastuniq allowed us to deduplicate the reads (due to PCR) to only keep real biological information using the 03_fastuniq2.sh script.

* 03_fastuniq.sh was a test using bbduk.sh output files

### Step 5
Repair.sh script was used before the next step to correct the different number of read in the paired input files.

--> This script was used in local:

conda activate your_environnement

repair.sh \ 
    in1=/home/amartin3/03_fastuniq2/clean_sed6_concat_dedup_R1.fastq \
    in2=/home/amartin3/03_fastuniq2/clean_sed6_concat_dedup_R2.fastq \
    out1=/home/amartin3/03_fastuniq2/clean_sed6_concat_dedup_R1_fixed.fastq \
    out2=/home/amartin3/03_fastuniq2/clean_sed6_concat_dedup_R2_fixed.fastq \
    outs=/home/amartin3/03_fastuniq2/clean_sed6_singles.fastq


repair.sh \ 
    in1=/home/amartin3/03_fastuniq2/clean_sed8_concat_dedup_R1.fastq \
    in2=/home/amartin3/03_fastuniq2/clean_sed8_concat_dedup_R2.fastq \
    out1=/home/amartin3/03_fastuniq2/clean_sed8_concat_dedup_R1_fixed.fastq \
    out2=/home/amartin3/03_fastuniq2/clean_sed8_concat_dedup_R2_fixed.fastq \
    outs=/home/amartin3/03_fastuniq2/clean_sed8_singles.fastq

### Step 6
We used Clumpify to deduplicate the reads a second time which is more efficient to find reads that share k-mers and detect sequencing errors using 04_clumpify.sh script.

### Step 7
To end data cleaning, we used fastp tool to merge R1 (forward) and R2 (reverse), observe the quality, do bases correction and trimming parameters including adaptater removal.

### Step 8
Then, we used kraken2 to do the taxonomic assignment using k-mer matches with the 07_kraken2.sh scirpt 

*the script 06_kraken_db.sh was a test for the creation of the kraken database but here it was already created so not necessary 
We made a korna graph to visualize the results before the next step

### Step 9 

We used bracken to correct kraken2 results with the 08_bracken.sh script. 
We also did a krona visualization after this correction. 

### References 
https://github.com/ZimmermannHH/BeringSea_shotgun_sequencing/

