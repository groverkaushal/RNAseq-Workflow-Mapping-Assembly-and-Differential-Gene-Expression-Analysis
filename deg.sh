#!/bin/bash

mkdir 5_deg
cd 5_deg


cuffdiff -L control,stress -p 20 ./4_assembly/merged.gtf ./4_assembly/control1.bam,./4_assembly/control2.bam ./4_assembly/stress1.bam,./4_assembly/stress2.bam





