# Setup and execution

## Requirements

The notebooks use R Markdown and the packages listed below. The source uses
Seurat v5 interfaces such as `JoinLayers()` and `layer =`; it is not a Seurat v4
workflow. The exact original R and package versions are not recorded in this
checkout. Installing current packages is a starting point, not a recreation of
the original environment.

| Component | Requirement or evidence |
| --- | --- |
| R | R with Seurat v5-compatible packages; original version unrecorded |
| Rendering | `knitr`, `rmarkdown`, and Pandoc; RStudio is optional |
| Python | Python 3.9 or newer for the standard-library preflight tool |
| RNA preprocessing | Cell Ranger **8.0.1**, GRCh38 **2024-A**, as specified in the committed job |
| Barcode extraction | Separate gDNA and v2.1_10X repositories, with exact revisions still to be supplied |
| Image processing | Fiji/ImageJ; original version unrecorded |
| Flow preprocessing | FlowJo exports; original version and gating workspace absent |
| Graphics | Cairo support and fonts used by the notebooks, including Helvetica Neue |
| External analysis | SCENIC outputs and databases; original commands, versions, and checksums absent |

The Cell Ranger job requests 32 cores and 128 GB of memory. That is its recorded
cluster allocation, not a measured minimum for these R notebooks. RNA objects
and dense intermediate barcode matrices may require substantial RAM. Runtime
and peak memory have not been benchmarked from this checkout.

### Install R dependencies

Run these commands in a separate R library for this project. They install
available versions and do **not** produce a verified historical environment.
The package checker inventories every notebook, including optional analyses.
Install only the packages for a chosen notebook if the full set is unnecessary.

```r
install.packages(c(
  "knitr", "rmarkdown", "Seurat", "tidyverse", "Matrix", "ggplot2", "dplyr",
  "stringr", "stringi", "pheatmap", "egg", "ggbreak", "scattermore", "ggh4x",
  "Polychrome", "ggrepel", "ggrastr", "ggforce", "reshape2", "tidyplots",
  "Cairo", "broom", "extrafont", "vegan", "msigdbr", "BiocManager"
))
BiocManager::install(c("ComplexHeatmap", "GSEABase", "enrichplot",
                       "org.Hs.eg.db", "clusterProfiler"))
```

`SaveLoom.Rmd` also requires `SeuratDisk`. Follow its
[upstream installation guide](https://github.com/mojaveazure/seurat-disk), record
the installed revision, and verify compatibility with the Seurat object before
export. `msigdbr` APIs and gene-set releases vary across versions. The current
notebook uses `source_gene`, so verify the table schema as well as the release.

Check the environment and retain the output alongside a run:

```sh
mkdir -p validation-local
Rscript scripts/check_environment.R > validation-local/environment.txt
```

An exit code of 1 reports missing packages. This check does not install packages.
After a successful full rerun, archive `sessionInfo()`, database versions, and a
lockfile from that tested environment. Do not label a newly generated lockfile as
the original environment.

## Configure paths

`CLONESWEEPER_EXPERIMENTS` must be an **absolute path** to the data directory
containing `RV124` and `RV143`. It can be an external data mirror or this
checkout's `Experiments` directory. Preserve the relative structure in
[DATA.md](DATA.md). Use a working copy of the inputs because notebooks write
outputs into this tree and can overwrite existing results.

From the repository root, for data placed in this checkout:

```sh
export CLONESWEEPER_EXPERIMENTS="$PWD/Experiments"
python3 scripts/preflight.py Create_Seurat_Objects.Rmd
```

Or configure an external data mirror:

```sh
export CLONESWEEPER_EXPERIMENTS="/absolute/path/to/Experiments"
```

In RStudio, set the variable before using **Knit**:

```r
Sys.setenv(CLONESWEEPER_EXPERIMENTS = "/absolute/path/to/Experiments")
```

All 23 notebooks use this variable in their setup chunk. Most then work from
`RV143`; the flow notebook uses `RV124`; the RV142/RV143 comparison uses the
parent `Experiments` directory. Knitr applies the working directory to subsequent
chunks. Executing isolated code directly in the R console does not apply that
setting; knit the notebook or explicitly set the corresponding working directory.

## Run a notebook

Follow the [dependency order](ANALYSES.md). For example, once gDNA counts and
`RV143/spike_in.csv` have been supplied:

```sh
python3 scripts/preflight.py Organize_Data.Rmd --prepare-output-dirs
mkdir -p rendered
Rscript -e 'rmarkdown::render("Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm/Post_Cluster_Analysis/Scripts/2024_10_23_gDNA_Sequencing/Organize_Data.Rmd", output_dir = "rendered")'
```

Only continue to rendering if preflight exits successfully. The optional
`--prepare-output-dirs` flag creates documented output parent directories after
all listed inputs exist. Without that flag, preflight is read-only. It checks
paths, not data schemas, scientific validity, or package compatibility. An input
produced earlier within the same notebook is not required at preflight.

HTML goes to `rendered/`. Tables, RDS objects, and exported figures go to the
notebook's `Organized_Data` or `Plots` directories under the configured data
root. Some exploratory plots are displayed in the HTML without a separate export.
The flow notebook also exports one PDF per well. See [notebooks.json](notebooks.json) for exact literal
input and output paths. The manifest is maintained with the source and excludes
unresolved runtime variables and upstream FASTQ dependencies.

## Separate upstream steps

- The committed Cell Ranger shell script is an **LSF cluster job template**.
  Configure its working directory, libraries CSV, transcriptome path, and sample
  ID. Despite its filename, its recorded `--id` is the **untransduced** sample.
  A second enriched-sample run is required by `Create_Seurat_Objects.Rmd`.
- The two `paths_and_variables.json` files contain comments, and the gDNA file
  also contains a trailing comma. They are historical pipeline configurations,
  not strict JSON. Use the matching upstream parser and configure its paths.
  Do not silently remove comments or change scientific settings without
  checking that pipeline's requirements.
- `SaveLoom.Rmd` exports input for SCENIC. It does not run SCENIC. Supply the
  AUC, GRN, and CTX outputs before `Add_SCENIC_Data.Rmd`.
- Configure both input and output paths in `Macro_Crop_RV124.ijm` before running
  it in Fiji. Verify image order, channel mapping, crop dimensions, and scale
  against the original image metadata.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| `Set CLONESWEEPER_EXPERIMENTS...` | Set the variable in the same shell/R session that renders the notebook |
| Missing input file | Use the exact filename in DATA.md and run its upstream stage first |
| Cannot open output file | Run preflight with `--prepare-output-dirs` and check write permissions |
| Missing `Well_1` or `mCherry` | Verify FlowJo filenames and exported column names |
| `JoinLayers` or `layer` errors | Check Seurat v5 compatibility and object structure |
| Missing SCENIC cells | Check cell IDs against the enriched Seurat object; do not join by row order |
| Font/Cairo errors | Install the requested font/graphics support or record an explicit font substitution |
| Missing `go_bp_sets` | The committed gene-set notebook does not define it; see the recorded execution gaps |

Do not change thresholds, gene universes, or lineage identities to make a failed
run complete. Resolve input or version differences and record the decision.
