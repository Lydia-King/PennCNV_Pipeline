## PennCNV-Affy Pipeline 

This repository contains scripts, ref files and programs needed to run the PennCNV-Affy pipeline for the Affymetrix SNP Array 6.0. The pipeline is used to preprocess raw CEL files to produce Log R Ratio (LRR) and B Allele Frequency (BAF) values that will be used as inputs for ASCAT. See the [PennCNV-Affy user guide](http://penncnv.openbioinformatics.org/en/latest/user-guide/affy/) for more information, including a full step-by-step guide for running the entire pipeline. Below is a brief guide to what each directory (bin, data, ref and scripts) contains. 

-----

### **Bin**
The directory contains the programs used to carry out substep 1.3 and substep 1.4 of the PennCNV-Affy pipeline i.e. to generate canonical genotype clusters and to calculate the LRR values and the BAF values for each marker in each individual, respectively. Substep 1.3 uses generate_affy_geno_cluster.pl and substep 1.4 uses normalize_affy_geno_cluster.pl. These programs can also be obtained from the user guide, link provided above. 

**Important:** Substeps 1.1 and 1.2 use programs from the Affymetrix Power Tools (APT) software to generate genotyping calls from the raw CEL files and to extract allele-specific signal values from the raw CEL files. These programs are apt-probeset-genotype and apt-probeset-summarize, respectively, and instructions on how to download the APT software package can be found in the user guide, link provided above. 

-----

### **Data**
Store the raw (Affymetrix SNP 6.0) CEL files in this directory. 

-----

### **Ref**
The ref directory contains the ref files needed to run substeps 1.1 - 1.4 of the PennCNV-Affy pipeline. Note that the zipped files should be unzipped before use. These files can also be obtained from the user guide, link provided above. Ref files needed to run PennCNV-Affy SNP6 pipeline are listed below. Note that at each substep output files are created and stored in a directory with a name of your choosing, these files are not included below.

#### **Substep 1.1 Generate genotyping calls from CEL files:**

- GenomeWideSNP_6.cdf
- GenomeWideSNP_6.birdseed.models
- GenomeWideSNP_6.specialSNPs
- listofCEL 

Note that the listofCEL file is created by you and is a list of the raw CEL filenames that should match the names of the CEL files provided in the data directory, an example of how this file should be structured is provided.

#### **Subsetp 1.2 Allele-specific signal extraction from CEL files:**

- GenomeWideSNP_6.cdf
- hapmap.quant-norm.normalization-target.txt
- listofCEL 

Note that the listofCEL file is created by you and is a list of the raw CEL filenames that should match the names of the CEL files provided in the data directory, an example of how this file should be structured is provided.

#### **Substep 1.3 Generate canonical genotype clustering file:**

- affygw6.hg18.pfb
- affygw6.hg19.pfb
- affygw6.hg38.pfb 
- File_Sex.txt 

Note that only one .pfb file is used depending on which genome build is selected. Also note that the File_Sex.txt file is created by you and is a list of the raw CEL filenames and sex information for each individual and should match the names of the CEL files provided in the data directory, an example of how this file should be structured is provided. 

**Important:** If the user has only a few dozen CEL files, then it is unlikely that a clustering file can be generated successfully and accurately. In that case, it is advised that this substep is skipped and the default clustering file provided in the PennCNV-Affy package is used in substep 1.4. 

#### **Substep 1.4 LRR and BAF calculation:**

- hapmap.genocluster (use this file if substep 1.3 was omitted, otherwise use cluster file created by that step)
- affygw6.hg18.pfb
- affygw6.hg19.pfb
- affygw6.hg38.pfb 

Note that only one .pfb file is used depending on which genome build is selected.

For more information about each step, see the PennCNV-Affy user guide.

-----

### **Scripts**
The scripts directory contains the PennCNV_Script.sh script used to run the PennCNV-Affy pipeline for the Affymetrix SNP Array 6.0. The PennCNV-Affy pipeline contains 2 steps, however we are only interested in Step 1: Generate the signal intensity data based on raw CEL files. Step 1 has 4 substeps (substeps 1.1 - 1.4) and the script allows users to input arguments to run the 3-step or 4-step pipeline using Hg18, Hg19 or Hg38. When only a limited number of CEL files are available it is recommended to only use substeps 1.1, 1.2 and 1.4.  

An example of how the script is run to preprocess the data using the 4-step procedure and Hg19 is: `sbatch PennCNV_Script.sh Hg19 4Step`  

**Important:** Accepted arguments for argument 1 include `Hg18`, `Hg19` or `Hg38` and accepted arguments for argument 2 include `3Step` or `4Step`. If anything else is inputted an error will be produced. 

-----

### **To run this pipeline on your own data**

**1.** Clone this repository and navigate into it:

```bash
git clone https://github.com/Lydia-King/PennCNV_Pipeline
cd PennCNV_Pipeline
```

**2.** Set up data directory by downloading/moving raw CEL files into it:

```bash
# I had data already downloaded in CEL directory
mv ../CEL/* data/ 
```

**3.** Create listofCEL and File_Sex.txt files:

```bash
cd data/
ls *.CEL >> ../ref/listofCEL_temp
sed 1i'cel_files' ../ref/listofCEL_temp > ../ref/listofCEL

ls *.CEL >> ../ref/File_Sex_temp.txt
sed 's/$/\tfemale/' ../ref/File_Sex_temp.txt > ../ref/File_Sex.txt

rm ../ref/listofCEL_temp ../ref/File_Sex_temp.txt
```

**4.** Unzip files in ref folder:

```bash
cd ../ref/
gunzip *.gz
```

**5.** Submit script with input arguments:

```bash
cd ../scripts
sbatch PennCNV_Script.sh Hg38 4Step
```
