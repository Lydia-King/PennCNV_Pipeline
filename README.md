### PennCNV Affy Pipeline 

This repo contains scripts, ref files and programs needed to run the PennCNV Affy Pipeline (Affymetrix SNP Array 6.0). The pipeline is used to preprocess raw CEL files to produce Log R Ratio (LRR) and B Allele Frequency (BAF) that will be used as inputs for ASCAT, see [PennCNV User Guide](http://penncnv.openbioinformatics.org/en/latest/user-guide/affy/) for PennCNV Affy user guide. 

#### **Scripts**
The scripts folder contains the PennCNV_Script.sh script used to run the PennCNV Affy pipeline for the Affymetrix SNP Array 6.0. The PennCNV Affy pipeline contains 2 steps but we are only interested in Step 1. Generate the signal intensity data based on raw CEL files. Step 1 has 4 substeps (1.1 - 1.4) and the script allows users to input arguments to run the 3-step or 4-step pipeline using Hg18/Hg19/Hg38. When only a limited number of CEL files are available it is recommended to only use steps 1.1, 1.2 and 1.4. 

An example of how the script is run to preprocess the data using the 4 step procedure and Hg19 is: `sbatch PennCNV_Script.sh Hg19 4`

#### **Bin**
The bin folder contains the programs used to generate canonical genotype clusters (substep 1.3 - generate_affy_geno_cluster.pl) and calculate the Log R Ratio (LRR) values and the B Allele Frequency (BAF) values for each marker in each individual (substep 1.4 - normalize_affy_geno_cluster.pl). These programs can also be obtained from [PennCNV User Guide]( PennCNV-Affy programs and library files ).

#### **Ref**
The ref folder contains the ref files needed to run substeps 1.1 - 1.4 of the PennCNV Affy pipeline. Note that the zipped files should be unzipped before use. These files can also be obtained from the [PennCNV User Guide](http://penncnv.openbioinformatics.org/en/latest/user-guide/affy/). Ref files for PennCNV Affy SNP6 pipeline are shown below.

**Substep 1.1 Generate genotyping calls from CEL files:**

- GenomeWideSNP_6.cdf
- GenomeWideSNP_6.birdseed.models
- GenomeWideSNP_6.specialSNPs
- listofCEL 

Note that the listofCEL file is created by you and is a list of raw filenames that should match names of CEL files provided in data folder (example of structure provided).

**Subsetp 1.2 Allele-specific signal extraction from CEL files:**

- hapmap.quant-norm.normalization-target.txt
- listofCEL 

Note that the listofCEL file is created by you and is a list of raw filenames that should match names of CEL files provided in data folder (example of structure provided).

**Substep 1.3 Generate canonical genotype clustering file:**

- affygw6.hg18.pfb
- affygw6.hg19.pfb
- affygw6.hg38.pfb 
- File_Sex.txt 

Note that only one .pfb is used depending on which genome build is going to be used. Also note that the File_Sex.txt file is created by you and is a list of raw filenames and sex info for each that should match names of CEL files provided in data folder (example of structure provided).

**Substep 1.4 LRR and BAF calculation:**

- hapmap.genocluster (if you have omitted substep 1.3, otherwise use cluster file created by that step)
- affygw6.hg18.pfb
- affygw6.hg19.pfb
- affygw6.hg38.pfb 

Note that only one .pfb is used depending on which genome build is going to be used.

For more information see the [PennCNV User Guide](http://penncnv.openbioinformatics.org/en/latest/user-guide/affy/).

#### **Data**
Store raw CEL files in this directory.
