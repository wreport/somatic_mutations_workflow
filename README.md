# Somatic mutation workflow

GATK-derived somatic mutation dectection workflow for healthy human somatic cells.

This workflow is being tested on human somatic cells Illumina Hiseq data.

Designed for Cromwell engine.

The order of launching:
 
1. trimming
2. mapping
3. sam-to-bam-conversion
4. readgroups
5. validate
6. indexing
7. mark-duplicates
8. recalibrate-bq-scores
7. variant-calling