# RNAseq Workflow: Mapping, Assembly, and Differential Gene Expression Analysis

## Overview

This project uses an RNAseq workflow pipeline to generate count data and identify differentially expressed genes from sequencing reads. The reads are mapped using a reference genome.
The workflow consists of the following steps:

1. **Fastq files downloaded using SRA-Toolkit**
2. **Quality Assessment with FASTQC**
3. **High Quality Read Filtering using FastP**
4. **Reference Genome Mapping using HiSAT2**
5. **Assembly using StringTie**
6. **Counts data generated using Cufflinks**
7. **Differentially Expressed Genes calculated using CuffDiff**

<br></br>

![Flowchart of the workflow followed in my project](https://github.com/groverkaushal/RNAseq-Workflow-Mapping-Assembly-and-Differential-Gene-Expression-Analysis/blob/main/Flowchart.png)

Fig: Flowchart of the workflow followed in my project

## Datasets
This project involves transcriptomic analysis to compare the salinity stress response in salinity-tolerant genotypes of chickpea. 
The analysis was conducted on a salinity-tolerant chickpea genotype under both control and saline environments. 
The dataset includes RNAseq sequencing reads from two control group samples and two saline group samples.
 
 

- **BioProject:** [PRJNA842022](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA842022&o=acc_s%3Aa)
- **SRA Study:** SRP376874
<br></br>
- **Run ID:** SRR19383303 (Control Sample 1)
- **Run ID:** SRR19383302 (Control Sample 2)
- **Run ID:** SRR19383301 (Saline Sample 1)
- **Run ID:** SRR19383300 (Saline Sample 2)
<br></br>
- **Year of Experiment:** 2022
- **Instrument:** Illumina NextSeq 500
- **Layout:** Single
- **Organism:** Cicer arietinum (Chickpea)
- **Total Bases per Sample:** ~510 Mb (Million Bases)
- **No. of reads per Sample:** ~10.4 Million reads
- **Estimated Genome Size:** 500 Mb
- **Estimated Transcriptome Size:** 77 Mb
- **Estimated Transcriptome Coverage per Sample:** 510/77 = 6.6X




## System Requirements

- Python 3
- Conda

## Installing Dependencies

1. Create a conda environment and activate it:

   ```bash
   conda create -n grover
   conda activate grover
   ```

2. Install FastQC:

   ```bash
   sudo apt -y install fastqc
   ```

3. Install Fastp:

   ```bash
   conda install -c bioconda fastp
   ```

4. Install ncbi_datasets:

   ```
   conda install -c conda-forge ncbi-datasets-cli
   ```

5. Install HiSAT2:

   ```
   git clone https://github.com/DaehwanKimLab/hisat2.git
   cd hisat2
   make
   echo 'export PATH=$(pwd):$PATH' >> ~/.bashrc
   source ~/.bashrc
   cd ..
   ```

6. Install SamTools:

   ```
   wget https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2
   tar -xf samtools-1.20.tar.bz2 
   rm samtools-1.20.tar.bz2
   sudo apt-get install zlib1g-dev libncurses5-dev libncursesw5-dev liblzma-dev libbz2-dev libcurl4-openssl-dev
   cd samtools-1.20/
   make
   echo 'export PATH=$(pwd):$PATH' >> ~/.bashrc
   source ~/.bashrc
   cd ..
   ```

7. Install StringTie:

   ```
   git clone https://github.com/gpertea/stringtie
   cd stringtie
   make release
   echo 'export PATH=$(pwd):$PATH' >> ~/.bashrc
   source ~/.bashrc
   cd ..
   ```

8. Install CuffLinks:

   ```
   wget http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz
   tar -xf cufflinks-2.2.1.Linux_x86_64.tar.gz
   rm cufflinks-2.2.1.Linux_x86_64.tar.gz
   cd cufflinks-2.2.1.Linux_x86_64
   echo 'export PATH=$(pwd):$PATH' >> ~/.bashrc
   source ~/.bashrc
   cd ..
   ```



## Workflow
### Quality Assessment

The first step involves evaluating the quality of the sample using FASTQC. Summary statistics obtained from FASTQC provide insights into various quality metrics, allowing us to identify any potential issues in the sequencing data.
Fastp tool was used to remove duplicated reads, trim the low quality ends, remove the low quality reads, trim adapter sequences, remove low complexity sequences, trim poly G tail. After filtering the HQ reads, Again the FastQC reports were generated.

```
chmod +x Fastp_and_FastQC.sh
./Fastp_and_FastQC.sh
```

### Mapping

Following the quality assessment, we perform mapping of the reads on a reference genome using HiSAT2. First the reference genome fasta file, gtf file and gff file was downloaded. Then HiSAT2 tool was used to generate 4 mapping sam files
 from the 4 SRR Fastq files. 
```
chmod +x mapping.sh
./mapping.sh
```

### Assembly

Now, first the 4 sam files were sorted and compressed to 4 bam (binary) files using SamTools. Next the 4 bam files were assembled individually using StringTie. The reference gff file was given as input
 to generate 4 assembled gtf files. These 4 gtf files were further merged into 1 "merged.gtf" file.
```
chmod +x assembly.sh
./assembly.sh
```

### Differentially Expressed Genes

Now, finally the differentially expressed genes were calculated between the 2 conditions - control and stress, each with 2 samples. For this we use the 4 bam files generated by HiSAT2, and the merged.gtf file generated by StringTie. 
We use the CuffDiff tool from Cufflinks package to calculate the DEG's. The results were stored in "gene_exp.diff" file.
```
chmod +x deg.sh
./deg.sh
```

---

### Contact

For any questions or further information, please contact Kaushal Grover at kausha87_sit@jnu.ac.in.

---

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
