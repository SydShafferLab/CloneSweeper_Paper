# Current manuscript analyses

This guide covers the analysis content described in main Figures 1 through 4
and the existing Supplementary Figures 1 through 3, together with its required
processing steps. Proposed revision panels and new analyses are excluded.

The links identify the relevant notebooks and sections. Some original notebooks
also contain alternative plots or exploratory sections. Their presence does not
make those additional outputs manuscript results. Exact output-file choices and
panel numbering must be reconciled again when the final figures are assembled.
The guide does not establish a successful full rerun.

## Figure-to-code index

| Notebook | Use in the existing manuscript |
| --- | --- |
| [mScarlet3_Distribution](../Experiments/RV124/Attempt_3/Scripts/mScarlet3_Distribution.Rmd) | Figure 1E reporter distributions |
| [Bubble_Plot](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Bubble_Plot.Rmd) | Figure 2F and Supplementary Figure 1E lineage-abundance bubbles |
| [Diversity_Metrics](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Diversity_Metrics.Rmd) | Figure 2B-D and Supplementary Figure 1A-C diversity metrics |
| [Organize_Data](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Organize_Data.Rmd) | Required gDNA count organization, calibration, and target-oligo preparation |
| [Scatter_Plot_Pools_Only](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Scatter_Plot_Pools_Only.Rmd) | Figure 2E and Supplementary Figure 1D replicate abundance |
| [qd_diversity](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/qd_diversity.Rmd) | Number-of-barcodes, Shannon, and Simpson sections for Figure 2B-D and Supplementary Figure 1A-C |
| [Check_Recovery_Library](../Experiments/RV143/2025_2_13_Recovery_Library_Sequencing/Scripts/Check_Recovery_Library.Rmd) | Supplementary Figure 2B recovery-library representation |
| [Add_SCENIC_Data](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Add_SCENIC_Data.Rmd) | Figure 4F-H regulon activity |
| [Basic_Barcode_Metrics](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Basic_Barcode_Metrics.Rmd) | Supplementary Figure 2C-E barcode QC |
| [Cell_Cycle_UMAPs](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Cell_Cycle_UMAPs.Rmd) | Figure 3C-D cell-cycle-regressed UMAPs |
| [Compare_Differential_Expression](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Compare_Differential_Expression.Rmd) | Figure 3E, Figure 4A, and Supplementary Figure 3D expression contrasts |
| [Create_Seurat_Objects](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Create_Seurat_Objects.Rmd) | Required RNA processing and lineage assignment |
| [Enriched_Lineage_Comparison_Analysis](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Enriched_Lineage_Comparison_Analysis.Rmd) | Supplementary Figure 3C lineage-specific marker expression |
| [Gene_Set_Analysis](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Gene_Set_Analysis.Rmd) | Figure 4E Hallmark analysis |
| [Plot_Gene_Expression](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Plot_Gene_Expression.Rmd) | Figure 4B-D expression of DCT, PMEL, TYR, CD44, CD59, and MKI67 |
| [Plot_Percentage_of_Cells](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Plot_Percentage_of_Cells.Rmd) | Figure 3B targeted-lineage recovery fractions |
| [Plot_UMAPs](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Plot_UMAPs.Rmd) | Supplementary Figure 3A-B UMAPs without cell-cycle regression |
| [Pseudobulk_Correlation](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Pseudobulk_Correlation.Rmd) | Supplementary Figure 3E lineage and random-pseudolineage correlations |
| [SaveLoom](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/SaveLoom.Rmd) | Required enriched-sample count export for external SCENIC processing |

Figure 1D image processing uses
[Macro_Crop_RV124.ijm](../Experiments/RV124/Attempt_3/Incucyte_Images/4x/2025-09-17_Processing/Macro_Crop_RV124.ijm).
The original image data, figure schematics, sorting-gate source material, and
final figure-layout files are not included in this checkout.

## Required analysis order

1. Process gDNA reads with the separate barcode pipeline and archived sample
   configuration. Supply its count table and `spike_in.csv`, then run
   `Organize_Data.Rmd`.
2. Use the organized gDNA tables for the diversity, replicate-abundance, and
   bubble-plot sections listed above. The two diversity notebooks contain
   different thresholding variants; verify the variant used for each panel.
3. Run Cell Ranger for both RNA samples and the single-cell barcode pipeline.
   Supply RNA matrices and the per-UMI barcode table with matching cell IDs.
4. Run `Create_Seurat_Objects.Rmd`, using the target oligos from the gDNA branch.
   `Basic_Barcode_Metrics.Rmd` independently reads both matrices and the barcode
   table for the supplementary QC plots.
5. Run `Cell_Cycle_UMAPs.Rmd` for Figure 3C-D. Use `Plot_UMAPs.Rmd` for the
   non-regressed supplementary UMAPs. `Plot_Percentage_of_Cells.Rmd` also requires
   the organized gDNA counts and target oligos.
6. Run `Compare_Differential_Expression.Rmd`, then the manuscript marker sections
   of `Plot_Gene_Expression.Rmd` and the Hallmark analysis in
   `Gene_Set_Analysis.Rmd`. Positive fold change in the targeted-cell contrast
   means higher expression in targeted cells within the enriched sample.
7. Run `Enriched_Lineage_Comparison_Analysis.Rmd` and
   `Pseudobulk_Correlation.Rmd` from the original Seurat object for the existing
   supplementary lineage comparisons.
8. For Figure 4F-H, run `SaveLoom.Rmd`, the external SCENIC workflow, and then
   `Add_SCENIC_Data.Rmd`. The SCENIC execution workflow and databases are not
   included here.

The RV124 flow/image analyses are independent of these RNA and gDNA branches.
The recovery-library check requires its sequence list and the target oligos.

See [SETUP.md](SETUP.md) for commands, [DATA.md](DATA.md) for file formats and
identities, and [REPRODUCIBILITY.md](REPRODUCIBILITY.md) for execution limitations.
The notebook list used by the checks is [manuscript_notebooks.txt](manuscript_notebooks.txt).
The input/output manifest [notebooks.json](notebooks.json) covers those same 19
notebooks. It records literal paths needed for running the legacy notebooks,
including output directories shared with their additional plotting sections.
