#!/bin/bash 
#SBATCH -J "PennCNV"
#SBATCH -N 1
#SBATCH -n 12

# Select which genome build to use - input argument 
Genome_Build=$1

# Select whether to run 3-step or 4-step PennCNV-Affy pipeline - input argument
Steps=$2

if [[ "${Genome_Build}" != Hg18 && "${Genome_Build}" != Hg19 && "${Genome_Build}" != Hg38 ]] || [[ "${Steps}" != 3Step && "${Steps}" != 4Step ]]
then 
	echo "Error: Genome Build must be one of Hg18/Hg19/Hg38 and Selected Steps must be one of 3Step or 4Step"
	exit 2
else 

# Specify directories - Should contain all files needed to run PennCNV Affy pipeline (see https://penncnv.openbioinformatics.org/en/latest/user-guide/affy/)
 
ref_dir="../ref/"
data_dir="../data/"
bin_dir="../bin/"

echo "PennCNV Workflow"
echo "Step 1: Generate the signal intensity data based on raw CEL files"
echo "Substep 1.1: Generate genotyping calls from CEL files" 

# Specify files needed for substep 1.1
CDF_File="${ref_dir}GenomeWideSNP_6.cdf"
Birdseed_File="${ref_dir}GenomeWideSNP_6.birdseed.models"
SpecialSNP_File="${ref_dir}GenomeWideSNP_6.specialSNPs"

# Move into directory that contains the raw CEL files 
cd "${data_dir}"

# Run substep 1.1
apt-probeset-genotype -c $CDF_File -a birdseed --read-models-birdseed $Birdseed_File --special-snps $SpecialSNP_File --out-dir ../apt_$1_$2 --cel-files "${ref_dir}listofCEL"

echo "Done Substep 1.1"

echo "Substep 1.2: Allele-specific signal extraction from CEL files" 

# Specify files needed for substep 1.2
Hapmap_File="${ref_dir}hapmap.quant-norm.normalization-target.txt"

# Run substep 1.2
apt-probeset-summarize --cdf-file $CDF_File --analysis quant-norm.sketch=50000,pm-only,med-polish,expr.genotype=true --target-sketch $Hapmap_File --out-dir ../apt_$1_$2 --cel-files "${ref_dir}listofCEL"

echo "Done Substep 1.2"

echo "Substep 1.3: Generate canonical genotype clustering file"

# Specify files needed for substep 1.3
Program_Geno_Cluster="${bin_dir}generate_affy_geno_cluster.pl"
Birdseed_Calls=../apt_$1_$2/birdseed.calls.txt
Birdseed_Conf=../apt_$1_$2/birdseed.confidences.txt
Quant_Norm=../apt_$1_$2/quant-norm.pm-only.med-polish.expr.summary.txt
	
if [ "${Genome_Build}" = Hg18 ] 
then
	echo "Using Hg18"
	AffyHg="${ref_dir}affygw6.hg18.pfb"
elif [ "${Genome_Build}" = Hg19 ]
then 
	echo "Using Hg19"
	AffyHg="${ref_dir}affygw6.hg19.pfb"
else 
	echo "Using Hg38"
	AffyHg="${ref_dir}affygw6.hg38.pfb"
fi

# Run substep 1.3 if 4-step procedure selected

if [ "${Steps}" = 4Step ]
then
	filesex="${ref_dir}File_Sex.txt"
	
	# Run substep 1.3
	$Program_Geno_Cluster $Birdseed_Calls $Birdseed_Conf $Quant_Norm -locfile $AffyHg -sexfile $filesex -out ../apt_$1_$2/gw6.genocluster

	echo "Done Substep 1.3"
else
	echo "Selected 3-step PennCNV-Affy pipeline: Skipping substep 1.3"
fi

echo "Substep 1.4: LRR and BAF calculation" 

# Specify files needed for substep 1.4
Normalize_Geno_Cluster="${bin_dir}normalize_affy_geno_cluster.pl"

if [ "${Steps}" = 4Step ]
then 
	echo "Using Cluster file generated in substep 1.3"
	GW6_Hg=../apt_$1_$2/gw6.genocluster
else 	
	echo "Using default Cluster file"
	GW6_Hg="${ref_dir}hapmap.genocluster"
fi

$Normalize_Geno_Cluster $GW6_Hg $Quant_Norm -locfile $AffyHg -out ../apt_$1_$2/PennCNV_Output_lrr_baf.txt

echo "Done Substep 1.4"

fi
