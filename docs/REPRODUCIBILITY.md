# Reproduction status

This documentation covers the existing manuscript analyses listed in
[ANALYSES.md](ANALYSES.md). It adds no study results or proposed revision analyses.

## Available checks

Run from the repository root:

```sh
Rscript scripts/check_notebooks.R
python3 scripts/preflight.py --list
Rscript scripts/check_environment.R
```

The checks use the 19 notebooks in [manuscript_notebooks.txt](manuscript_notebooks.txt).
They check R syntax, documented input paths, and installed package versions.
They do not verify scientific results or reproduce the figures.

## Requirements for execution

The public checkout lacks the RNA matrices, barcode tables, FlowJo exports,
original images, and most intermediate objects. See [DATA.md](DATA.md) for the
expected paths and schemas. Original R/package versions and upstream barcode
pipeline revisions are also unrecorded. The Cell Ranger job specifies version
8.0.1 and GRCh38 2024-A, but both samples' libraries files and complete run
records are needed.

The SCENIC branch requires the external AUC, GRN, and CTX outputs and the
software/database versions that generated them. The Hallmark notebook calls
`enricher()` and has no explicit measured-gene background; its separate GO
section references an undefined `go_bp_sets`. The original definitions are
needed before a complete clean-session run can be claimed. Configuring paths
alone does not resolve these execution gaps.

## Verification of this update

Source baseline: `8303369cefb39abb6e8e551bed9b5c535682e7b4`.
The manuscript notebooks use a configurable working directory. A stray `x`
that prevented the existing pseudobulk notebook from parsing was removed.
Other analysis code, thresholds, and results are unchanged. The four notebooks
outside the documented manuscript workflow retain their original source.

All 19 documented notebooks passed syntax checks. Documentation links and the
manifest were checked, and the RNA preflight correctly reported its four
missing input paths. Full study execution and figure reproduction have not
been performed from this checkout.

After the manuscript analyses and figures are finalized, update the mapping and
record the tested environment, input versions, and reproducible outputs before
making a final release.
