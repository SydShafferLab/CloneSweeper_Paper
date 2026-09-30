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
```

This guide covers the analyses described in the existing main Figures 1 through 4
and Supplementary Figures 1 through 3, plus their required processing steps.
It does not include proposed revision analyses. Older exploratory files remain
in the repository but are outside the documented manuscript workflow.

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
been verified from a clean checkout. See the [reproduction status](docs/REPRODUCIBILITY.md).

The 19 notebooks listed in the manuscript guide have working directories configured through `CLONESWEEPER_EXPERIMENTS`,
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
