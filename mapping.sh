#!/bin/bash

### Downloading Reference Chickpea Genome
mkdir 3_mapping
cd 3_mapping
datasets download genome accession GCF_000331145.1 --include-gtf
unzip ncbi_dataset.zip
mv ncbi_dataset/data/GCF_000331145.1/genomic.gff ./
mv ncbi_dataset/data/GCF_000331145.1/genomic.gtf ./
mv ncbi_dataset/data/GCF_000331145.1/GCF_000331145.1_ASM33114v1_genomic.fna ./
rm ncbi_dataset.zip README.md ncbi_dataset -r
cd ..



### Mapping
hisat2-build -p 20 ./3_mapping/GCF_000331145.1_ASM33114v1_genomic.fna ./3_mapping/chickpea
hisat2_extract_splice_sites.py ./3_mapping/genomic.gtf > ./3_mapping/splicesites.txt

hisat2 -q --n-ceil L,0,0.15 --mp 6,2 --no-softclip --np 1 --rdg 5,3 --score-min L,0,-0.2 --known-splicesite-infile ./3_mapping/splicesites.txt -k 2 --all -p 20 -t -x ./3_mapping/chickpea -U ./2_HQ_filtered/SRR19383303_out.fastq -S ./3_mapping/hisat_control1_scoremin-0.2.sam > ./3_mapping/hisat_control1_scoremin-0.2.summary
hisat2 -q --n-ceil L,0,0.15 --mp 6,2 --no-softclip --np 1 --rdg 5,3 --score-min L,0,-0.2 --known-splicesite-infile ./3_mapping/splicesites.txt -k 2 --all -p 20 -t -x ./3_mapping/chickpea -U ./2_HQ_filtered/SRR19383302_out.fastq -S ./3_mapping/hisat_control2_scoremin-0.2.sam > ./3_mapping/hisat_control2_scoremin-0.2.summary
hisat2 -q --n-ceil L,0,0.15 --mp 6,2 --no-softclip --np 1 --rdg 5,3 --score-min L,0,-0.2 --known-splicesite-infile ./3_mapping/splicesites.txt -k 2 --all -p 20 -t -x ./3_mapping/chickpea -U ./2_HQ_filtered/SRR19383301_out.fastq -S ./3_mapping/hisat_stress1_scoremin-0.2.sam > ./3_mapping/hisat_stress1_scoremin-0.2.summary
hisat2 -q --n-ceil L,0,0.15 --mp 6,2 --no-softclip --np 1 --rdg 5,3 --score-min L,0,-0.2 --known-splicesite-infile ./3_mapping/splicesites.txt -k 2 --all -p 20 -t -x ./3_mapping/chickpea -U ./2_HQ_filtered/SRR19383300_out.fastq -S ./3_mapping/hisat_stress2_scoremin-0.2.sam > ./3_mapping/hisat_stress2_scoremin-0.2.summary

# This command actually maps the sra read file to the genome. It takes as input the reads file, the reference genome index files, splicesites file. This outputs the alignment SAM file. Here:
# –n-ceil L,0,0.15 = to allow max N’s in a read. A linear function f(x) = 0 + 0.15*(read_length).
# –mp 6,2 = Sets the maximum (MX) and minimum (MN) mismatch penalties
# –no-softclip = disable softclip. By default, HISAT2 may soft-clip reads near their 5’ and 3’ ends.
# –score-min L,0,-0.2 = Sets a function governing the minimum alignment score needed for an alignment to be considered “valid”.











