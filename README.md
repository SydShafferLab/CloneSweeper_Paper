# CloneSweeper paper analysis

Analysis notebooks for the CloneSweeper lineage tracking and recovery study from
the Shaffer Lab. The repository covers reporter validation (RV124), longitudinal
lineage abundance, recovery-library sequencing, and single-cell RNA analysis (RV143).

## Start here

1. Read the [setup and execution guide](docs/SETUP.md).
2. Find the relevant notebook in the [analysis order and figure map](docs/ANALYSES.md).
3. Obtain the inputs described in the [data guide](docs/DATA.md).
4. Check the [reproduction status and remaining requirements](docs/REPRODUCIBILITY.md).

```sh
git clone https://github.com/SydShafferLab/CloneSweeper_Paper.git
cd CloneSweeper_Paper
python3 scripts/preflight.py --list
Rscript examples/barcode_assignment.R
```

The small example uses synthetic barcode counts and base R. It demonstrates the
lineage-assignment rule and checks expected outcomes. It does not reproduce a
paper figure or validate the full pipeline.

## What is included

| Location | Contents |
| --- | --- |
| [RV124](Experiments/RV124/Attempt_3) | Flow cytometry notebook and ImageJ image-processing macro |
| [RV143 gDNA](Experiments/RV143/2024_10_23_gDNA_Sequencing/Step3_40bp_Scaffold_90Match_3mm) | Barcode pipeline configuration, abundance and diversity notebooks |
| [Recovery library](Experiments/RV143/2025_2_13_Recovery_Library_Sequencing) | Library representation notebook and one previously exported plot |
| [RV143 single-cell](Experiments/RV143/RV143_Comb_20250407_20250508_Seq) | Cell Ranger job, barcode configuration, Seurat and downstream notebooks |
| [docs](docs) | Inputs, dependencies, execution order, figure mapping, and validation status |
| [scripts](scripts) | Input preflight, package/version check, and notebook syntax check |

## Reproduction status

This is an analysis source repository. The current checkout does **not** include
the sequencing matrices, FlowJo exports, microscope images, most intermediate
objects, or a pinned original R environment. Full figure reproduction has not
been verified from a clean checkout. See the [specific outstanding requirements](docs/REPRODUCIBILITY.md).

Notebook working directories are configured through `CLONESWEEPER_EXPERIMENTS`,
so they no longer depend on an author's personal Drive path. Scientific analysis
steps and thresholds are retained. The historical cluster configurations and
ImageJ macro still need their platform-specific paths configured separately.

FASTQ barcode processing is maintained in separate repositories:

- [BarcodeAnalysis_v2_gDNA](https://github.com/SydShafferLab/BarcodeAnalysis_v2_gDNA)
- [BarcodeAnalysis_v2.1_10X](https://github.com/SydShafferLab/BarcodeAnalysis_v2.1_10X)

The committed RV143 single-cell configuration names the `v2.1_10X` pipeline.
Its exact analysis commit must be recorded before reproducing the study. These
links are not version pins.

## Questions and reuse

Use this repository's GitHub Issues to report missing inputs or execution problems.
Include the notebook name, repository commit, and `sessionInfo()` output, with
private paths removed if necessary. A license and final paper citation have not
yet been supplied in this checkout.
