#!/bin/bash

mkdir 1_fastq_reads
mkdir -p 2_HQ_filtered/before_fastp 2_HQ_filtered/after_fastp


### SRR IDs
SRR_IDS=("SRR19383303" "SRR19383302" "SRR19383301" "SRR19383300")


### Go Through each SRR Id and download it, convert it to fastq, generate fastqc report, filter HQ reads using Fastp tool, again generate fastQC report.
for SRR_ID in "${SRR_IDS[@]}"
do

    ### Download SRA files and convert them to FASTQ
    prefetch "$SRR_ID" --progress --output-directory ./1_fastq_reads/
    vdb-validate ./1_fastq_reads/"$SRR_ID"
    fasterq-dump --split-files ./1_fastq_reads/"$SRR_ID"/"$SRR_ID".sra -F fastq --outdir 1_fastq_reads/

    ## generate fastqc reports and filter HQ reads by Fastp
    fastqc ./1_fastq_reads/"$SRR_ID".fastq --threads 12 --outdir ./2_HQ_filtered/before_fastp/

    fastp -i ./1_fastq_reads/"$SRR_ID".fastq -o ./2_HQ_filtered/"$SRR_ID"_out.fastq --json ./2_HQ_filtered/after_fastp/"$SRR_ID"_fastp_report.json --html ./2_HQ_filtered/after_fastp/"$SRR_ID"_fastp_report.html --qualified_quality_phred 30 --unqualified_percent_limit 40 -y --complexity_threshold 20 --cut_front --cut_front_window_size 4 --cut_front_mean_quality 30 --cut_tail --cut_tail_window_size 4 --cut_tail_mean_quality 30 --trim_poly_g --poly_g_min_len 6 --trim_poly_x --poly_x_min_len 6 --dedup

    fastqc ./2_HQ_filtered/"$SRR_ID"_out.fastq --threads 12 --outdir ./2_HQ_filtered/after_fastp/

done


find ./2_HQ_filtered/before_fastp -type f -name '*.zip' -delete
find ./2_HQ_filtered/after_fastp -type f -name '*.zip' -delete
