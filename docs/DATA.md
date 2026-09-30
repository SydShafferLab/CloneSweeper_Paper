# Input data and identities

Paths below are relative to `CLONESWEEPER_EXPERIMENTS`. The required inputs are
not included in the public checkout. No data accession or download URL is
recorded here. A complete public reproduction requires a stable data deposit,
file checksums, and the sample metadata described below.

For exact per-notebook paths and outputs, see [notebooks.json](notebooks.json)
or run `python3 scripts/preflight.py NOTEBOOK.Rmd`.

## RV124 reporter validation

- `RV124/Attempt_3/Flow/27JUN2024_Jazz/FlowJo_2025_11_12/Scale_Values/*.csv`
  contains FlowJo exports. The notebook creates object names from the first six
  filename characters and expects `Well_1` through `Well_4`. Each has a numeric
  `mCherry` column. The plotted threshold is 175 in the exported scale. Preserve
  the gating and transformation used for these exports; CSVs alone do not
  document those steps.
- `RV124/Attempt_3/Incucyte_Images/4x/Raw_Uncalibrated/` contains image sequences
  selected by the macro's `Grayscale`, `Green`, and `Red` filename filters. The
  microscope data and calibration metadata are absent.

## RV143 genomic barcode analysis

The shared prefix for this section is
`RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/`.

| Input | Format and role |
| --- | --- |
| `barcode_quantify/FeatureReference_filtered_group1_counts.csv` | Upstream barcode counts. `Organize_Data.Rmd` takes column 6 as row names, discards six remaining metadata columns, and renames six count columns positionally to `1A`, `1B`, `2A`, `2B`, `Pre1`, `Pre2`. Verify this order against the original sample sheet. |
| `RV143/spike_in.csv` (outside the shared prefix) | CSV requiring `sequence` and `spike_med`. It identifies spike-in barcodes and their cell-number calibration. |
| `Post_Cluster_Analysis/Organized_Data/counts_without_spike_ins.csv` | Generated barcode-by-sample counts with spike-ins removed. |
| `Post_Cluster_Analysis/Organized_Data/spike_in_counts.csv` | Generated spike-in counts and `Cell_Numbers` calibration. |
| `Post_Cluster_Analysis/Organized_Data/threshold_type_dataframe.csv` | Generated labels for spike-in-calibrated barcode abundance thresholds. |
| `Post_Cluster_Analysis/Organized_Data/Gibson_Assembly_Sequences_20241212.csv` | Generated recovery oligos. Downstream code extracts barcode bases 50 through 69. Despite the suffix, this is written with `write.table` and read as whitespace-delimited by the Seurat notebook. |

`Compare_RV142_RV143_Barcodes.Rmd` additionally requires
`RV142/2024_08_14_RV142_RV90_gDNA_BCs/Step_3_All_RevCom_23bp_Promoter_3mm_100Match/Organized_Data/all_data_without_spike_ins.csv`.
The RV142 data and producing workflow are not included here.

The historical gDNA configuration sets `spike_in_added` to `no`, whereas the
post-processing notebooks use `spike_in.csv`. Preserve the recorded files and
reconcile this upstream/downstream distinction with the original run before
claiming raw-data reproducibility.

## Recovery-library sequencing

`RV143/2025_2_13_Recovery_Library_Sequencing/Data/sequences_37_56.txt` is a
whitespace-delimited, headerless sequence list. `Check_Recovery_Library.Rmd`
compares it to the recovery oligos above. The producing extraction command is
not included. One exported `Barplot.pdf` is present, but its presence is not a
substitute for the input data.

## RV143 single-cell RNA and barcode assignments

The shared prefix is `RV143/RV143_Comb_20250407_20250508_Seq/`.

| Input | Format and identity requirements |
| --- | --- |
| `20250518_RV143_Enrichment_counts_untransduced/outs/raw_feature_bc_matrix/` | Cell Ranger raw RNA matrix directory accepted by `Read10X`, including matrix, features, and cell barcodes. |
| `20250518_RV143_Enrichment_counts_enriched/outs/raw_feature_bc_matrix/` | Corresponding enriched-protocol RNA matrix. |
| `20250520_Unmapped/EB_output_modified.txt` | Headerless whitespace-delimited table, five columns in order: `Cell_Barcode`, `UMI`, `Lineage_Barcode`, `StartSeq_Type`, `Sample`. |
| Recovery oligos from the gDNA workflow | Full mini-library used to identify targeted lineage barcodes. |

The barcode table's `Sample` values are matched literally to
`untransduced_step1_unmapped.txt` and `enriched_step1_unmapped.txt`. The notebooks
count **distinct UMIs** for each cell-barcode/lineage-barcode pair. Cell barcode
strings must match the corresponding RNA matrix, including any `-1` suffix.
Do not substitute a count-only table for this per-UMI table.

`Create_Seurat_Objects.Rmd` adds `Untransduced_` and `Enriched_` prefixes when
merging the two RNA objects. It saves an RDS object **without a `.rds` extension** at
`Post_Cluster_Analysis/Organized_Data/Create_Seurat_Objects/seurat_strict_barcode_requirements`.
The object includes RNA and `Lineage_Assay` assays plus these metadata fields:

- `orig.ident` for the protocol/sample label.
- `Lineage_Barcode_w_Max_Count` for the assigned barcode sequence.
- `has_targeted_lineage_barcode` for mini-library membership.
- `Mini_Library_Assignment` for the targeted barcode or `Non-Enriched`.

`Cell_Cycle_UMAPs.Rmd` produces the sibling object
`seurat_strict_barcode_requirements_cell_cycle_regression`.
Do not interchange these objects when reproducing a UMAP.

### Recorded processing rules

The source creates each RNA object with `min.cells = 3` and `min.features = 200`,
then retains cells with `nFeature_RNA > 200`, `nFeature_RNA < 9000`,
`nCount_RNA > 10000`, and mitochondrial percentage `< 10` using `^MT-` genes.
Barcode assignment then requires exactly one lineage with at least 3 unique
UMIs and a top-minus-second UMI difference of at least 3. These are separate
filters. A cell with barcode counts 3 and 2 fails even though only one barcode
reaches 3. The [synthetic example](../examples/barcode_assignment.R) illustrates this.

RNA uses `LogNormalize` with scale factor 10,000, followed by scaling, variable
gene selection, PCA, neighbors and UMAP over PCs 1 through 10, and clustering at
resolution 0.5. The source sets seed 1 in the object-creation notebook. Other
package defaults and stochastic steps must be captured in the tested environment.

The DE notebook compares targeted versus non-targeted cells **within `Enriched`**.
Positive fold change means higher in targeted cells. Its separate protocol
contrast excludes targeted cells and uses `Enriched` as `ident.1` and
`Untransduced` as `ident.2`. The filename `markers_untranduced_vs_transduced.csv`
contains a historical typo and does not specify the sign of the comparison.

### SCENIC branch

`Add_SCENIC_Data.Rmd` requires these files beneath
`Post_Cluster_Analysis/Organized_Data/SCENIC_20251027/Output_Data/`:
`AUC_output.csv`, `GRN_output.tsv`, and `CTX_output.csv`. Cell identifiers must
match the enriched RNA object. Supply the SCENIC commands, motif/ranking
resources, database versions, and original cell-identifier transformation with
these outputs. `SaveLoom.Rmd` is only the input export step.

## Sample history and figure interpretation

The manuscript describes recovery from thawed **pretreatment** cells, with
reporter transduction and sorting after target lineages were identified in
separate drug-treated cultures. `Enriched` is a recovery-protocol label and
should not be read as direct drug exposure of the RNA-profiled cells.
`Untransduced` is the paired protocol comparison in these notebooks.

Barcode sequences are the stable lineage identifiers. Plot order and temporary
numeric labels are not a validated manuscript lineage key. A release must
include the final barcode-to-lineage key, sample sheet, collection dates,
treatment/transduction/sorting history, and deposited data identifiers.
