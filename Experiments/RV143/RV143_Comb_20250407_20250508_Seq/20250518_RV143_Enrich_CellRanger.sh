
#!/bin/bash
#BSUB -J cellranger
#BSUB -o cellranger.%J.out
#BSUB -e cellranger.%J.error
#BSUB -n 32
#BSUB -M 131072
#BSUB -R "span[hosts=1] rusage [mem=131072]"

module load cellranger/8.0.1
cd /project/shafferslab/Robert/RV143/RV143_Comb_20250407_20250508_Seq
cellranger count --id=20250518_RV143_Enrichment_counts_untransduced \
                 --libraries=/project/shafferslab/Robert/RV143/RV143_Comb_20250407_20250508_Seq/RV143_Enrichment_20250410_CellRanger.csv \
                 --transcriptome=/project/shafferslab/reference_sequences/refdata-gex-GRCh38-2024-A \
                 --r1-length=28 \
                 --jobmode=local \
                 --localcores=32 \
                 --localmem=128 \
                 --create-bam=true \
              --include-introns=true \






