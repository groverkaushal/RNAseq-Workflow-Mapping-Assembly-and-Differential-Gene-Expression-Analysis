#!/bin/bash

mkdir 4_assembly

### Converting Sam file to Binary (BAM) file with SamTools
samtools sort -o ./4_assembly/control1.bam --output-fmt BAM --threads 20 ./3_mapping/hisat_control1_scoremin-0.2.sam
samtools sort -o ./4_assembly/control2.bam --output-fmt BAM --threads 20 ./3_mapping/hisat_control2_scoremin-0.2.sam
samtools sort -o ./4_assembly/stress1.bam --output-fmt BAM --threads 20 ./3_mapping/hisat_stress1_scoremin-0.2.sam
samtools sort -o ./4_assembly/stress2.bam --output-fmt BAM --threads 20 ./3_mapping/hisat_stress2_scoremin-0.2.sam


### Assemble using reference gff file with StringTie
stringtie -p 20 -e -G ./3_mapping/genomic.gff -o ./4_assembly/control1.gtf -A ./4_assembly/control1_counts.tab ./4_assembly/control1.bam
stringtie -p 20 -e -G ./3_mapping/genomic.gff -o ./4_assembly/control2.gtf -A ./4_assembly/control2_counts.tab ./4_assembly/control2.bam
stringtie -p 20 -e -G ./3_mapping/genomic.gff -o ./4_assembly/stress1.gtf -A ./4_assembly/stress1_counts.tab ./4_assembly/stress1.bam
stringtie -p 20 -e -G ./3_mapping/genomic.gff -o ./4_assembly/stress2.gtf -A ./4_assembly/stress2_counts.tab ./4_assembly/stress2.bam


cat <<EOL > ./4_assembly/list_gtf
./4_assembly/control1.gtf
./4_assembly/control2.gtf
./4_assembly/stress1.gtf
./4_assembly/stress2.gtf
EOL

### we merge the 4 gtf files using stringtiemerge to create a merged.gtf file.
stringtie --merge -G ./3_mapping/genomic.gff -o ./4_assembly/merged.gtf ./4_assembly/list_gtf

