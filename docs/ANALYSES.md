# Analysis order and figure map

The figure mapping below follows the manuscript's figure descriptions. It maps
analysis content to code, not a verified pixel-for-pixel reconstruction of the
final assembled figures. Panel labels, the chosen alternative plots, and
supplement numbering require confirmation against the submitted revision.
Schematics and final figure-layout source files are not included.

## Main-figure navigation

| Manuscript content | Notebook or script | Notes |
| --- | --- | --- |
| Figure 1D, reporter images | `Macro_Crop_RV124.ijm` | ImageJ macro; requires images and manual path configuration |
| Figure 1E, reporter flow distributions | `mScarlet3_Distribution.Rmd` | Requires exported FlowJo values and original gating information |
| Figure 2B-D, lineage diversity | `qd_diversity.Rmd`, `Diversity_Metrics.Rmd` | Contains alternative metrics and thresholding variants; confirm the final choices |
| Figure 2E, replicate abundance | `Scatter_Plot_Pools_Only.Rmd` | Pool-specific scatter plots and spike-in thresholds |
| Figure 2F, lineage abundance bubbles | `Bubble_Plot.Rmd` | Pool-specific bubble plots |
| Figure 3B, targeted-lineage recovery | `Plot_Percentage_of_Cells.Rmd` | Combines RNA cell fractions, gDNA read fractions, and target oligos |
| Figure 3C-D, cell-cycle-regressed UMAP | `Cell_Cycle_UMAPs.Rmd` | Regressed object and UMAPs; `Plot_UMAPs.Rmd` uses the original object |
| Figure 3E, DE contrast comparison | `Compare_Differential_Expression.Rmd` | Contains several `Volcanoish` plot variants |
| Figure 4A, targeted versus non-targeted DE | `Compare_Differential_Expression.Rmd` | Positive log fold change is higher in targeted cells within the enriched sample |
| Figure 4B-D, marker expression | `Plot_Gene_Expression.Rmd` | Per-gene expression PDFs including DCT, PMEL, TYR, CD44, CD59, MKI67 |
| Figure 4E, Hallmark analysis | `Gene_Set_Analysis.Rmd` | Uses `enricher()` over-representation, despite GSEA variable names; see outstanding definitions |
| Figure 4F-H, regulon activity | `Add_SCENIC_Data.Rmd` | Requires externally generated SCENIC outputs; heatmap is rendered in the notebook |

Supplementary analyses include the alternate gDNA pool, recovery-library
representation (`Check_Recovery_Library.Rmd`), barcode QC
(`Basic_Barcode_Metrics.Rmd`), original UMAPs (`Plot_UMAPs.Rmd`),
lineage-specific markers (`Enriched_Lineage_Comparison_Analysis.Rmd`), and
pseudobulk correlations (`Pseudobulk_Correlation.Rmd`). Final supplementary
panel numbers are not frozen in this map.

## Execution order

These are separate branches with shared inputs, not a single alphabetically
ordered pipeline. Start each notebook in a clean R session. See
[SETUP.md](SETUP.md) for path configuration, package checks, and render commands.

1. Run external gDNA barcode extraction/quantification with the archived sample
   configuration. Supply the resulting count table and `spike_in.csv`.
2. Run `Organize_Data.Rmd` to generate non-spike-in counts, calibration tables,
   threshold labels, and recovery oligos.
3. Run the gDNA plotting/summary notebooks below in any order after step 2.
4. Run Cell Ranger separately for both RNA samples and the single-cell barcode
   pipeline. Supply the per-UMI barcode table with matching cell identifiers.
5. Run `Create_Seurat_Objects.Rmd`, using the recovery oligos from step 2.
   `Basic_Barcode_Metrics.Rmd` reads the matrices and per-UMI table independently.
6. Run `Cell_Cycle_UMAPs.Rmd` for the cell-cycle-regressed branch. Other notebooks
   explicitly read the original object unless documented otherwise.
7. Run `Compare_Differential_Expression.Rmd`, then `Plot_Gene_Expression.Rmd`
   and, after resolving its missing definitions, `Gene_Set_Analysis.Rmd`.
8. Run the remaining Seurat-object analyses below independently after step 5.
   `Plot_Percentage_of_Cells.Rmd` also needs the gDNA tables from step 2.
9. For regulons, run `SaveLoom.Rmd`, the external SCENIC workflow, then
   `Add_SCENIC_Data.Rmd`. The external SCENIC workflow is not included.

RV124 reporter analysis and recovery-library sequencing analysis are independent
of RNA object creation. The library check still requires the recovery oligos.

## Complete notebook index

The following index covers every committed R Markdown notebook. Paths are links
to the source. Exact inputs, package imports, and literal output filenames are
also recorded in [notebooks.json](notebooks.json).

| Notebook | Prerequisite | Main products |
| --- | --- | --- |
| [mScarlet3_Distribution](../Experiments/RV124/Attempt_3/Scripts/mScarlet3_Distribution.Rmd) | FlowJo CSV exports | Reporter distributions and per-well PDFs |
| [Bubble_Plot](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Bubble_Plot.Rmd) | Organize_Data outputs | Pool-specific lineage abundance bubbles |
| [Compare_RV142_RV143_Barcodes](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Compare_RV142_RV143_Barcodes.Rmd) | RV143 organized counts and external RV142 counts | Barcode overlap checks in HTML |
| [Diversity_Metrics](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Diversity_Metrics.Rmd) | Organize_Data outputs | Thresholded pool diversity plots |
| [Odds_Ratios](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Odds_Ratios.Rmd) | Organize_Data outputs | Thresholded/unthresholded overlap and odds ratios in HTML |
| [Organize_Data](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Organize_Data.Rmd) | gDNA quantification and spike-in table | Organized counts, calibration, target oligos |
| [Scatter_Plot_Pools_Only](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Scatter_Plot_Pools_Only.Rmd) | Organize_Data outputs | Replicate abundance scatter plots |
| [qd_diversity](../Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/qd_diversity.Rmd) | Organize_Data outputs | Hill diversity and alternate diversity plots |
| [Check_Recovery_Library](../Experiments/RV143/2025_2_13_Recovery_Library_Sequencing/Scripts/Check_Recovery_Library.Rmd) | Recovery sequences and target oligos | Mini-library representation plot |
| [Add_SCENIC_Data](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Add_SCENIC_Data.Rmd) | Original Seurat object and external AUC/GRN/CTX | Regulon comparisons, heatmap in HTML, AUC boxplot PDFs |
| [Basic_Barcode_Metrics](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Basic_Barcode_Metrics.Rmd) | Both RNA matrices and barcode table | Barcode/UMI QC distributions |
| [Cell_Cycle_UMAPs](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Cell_Cycle_UMAPs.Rmd) | Original Seurat object | Cell-cycle scores, regressed object, UMAP PDFs |
| [Compare_Differential_Expression](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Compare_Differential_Expression.Rmd) | Original Seurat object | Two DE tables, volcano and contrast-comparison plots |
| [Compare_Lineages](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Compare_Lineages.Rmd) | Original Seurat object | Pairwise lineage DE volcano plots |
| [Create_Seurat_Objects](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Create_Seurat_Objects.Rmd) | Both RNA matrices, barcode table, target oligos | Strict-assignment Seurat object and gzipped count export |
| [Enriched_Lineage_Comparison_Analysis](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Enriched_Lineage_Comparison_Analysis.Rmd) | Original Seurat object | Lineage markers and selected expression plots |
| [Gene_Set_Analysis](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Gene_Set_Analysis.Rmd) | DE tables, gene sets, missing GO definition | Hallmark plots; full execution currently blocked |
| [Plot_Gene_Expression](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Plot_Gene_Expression.Rmd) | Original Seurat object and DE tables | Per-gene expression PDFs |
| [Plot_Percentage_of_Cells](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Plot_Percentage_of_Cells.Rmd) | Original Seurat object, gDNA counts, target oligos | Lineage recovery fraction plots |
| [Plot_UMAPs](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Plot_UMAPs.Rmd) | Original Seurat object | Protocol and lineage UMAPs without cell-cycle regression |
| [Pseudobulk_Correlation](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Pseudobulk_Correlation.Rmd) | Original Seurat object | Lineage and random pseudolineage correlation heatmaps |
| [SaveLoom](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/SaveLoom.Rmd) | Original Seurat object; SeuratDisk | Enriched-sample raw-count loom for external SCENIC |
| [Seurat_Object_Subset_Comparison](../Experiments/RV143/RV143_Comb_20250407_20250508_Seq/Post_Cluster_Analysis/Scripts/Seurat_Object_Subset_Comparison.Rmd) | Original Seurat object | Exploratory matched-size subsets and dimension reduction in HTML |
