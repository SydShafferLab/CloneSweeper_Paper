# Reproduction status

## Scope of this documentation update

Source audited from commit `8303369cefb39abb6e8e551bed9b5c535682e7b4`.
The update adds setup, data and figure guides, a notebook input/output inventory,
a read-only preflight, package/version reporting, and a synthetic assignment
example. All 23 notebook working directories now use a configured data root.
A stray `x` after `table(seurat_large_lineages$Pseudolineage)` was removed because
it prevented the pseudobulk notebook from parsing.

No DE thresholds, lineage definitions, normalization settings, or scientific
results were changed. Source parsing and example execution do not establish
that the paper figures can be regenerated.

## Validation that can run without the study data

From the repository root:

```sh
Rscript scripts/check_notebooks.R
Rscript examples/barcode_assignment.R
python3 scripts/preflight.py --list
Rscript scripts/check_environment.R
```

The first three commands require only base R and Python. The environment check
reports missing dependencies and exits nonzero when any are absent. On a fresh
source-only checkout, a scientific notebook preflight should report missing
inputs rather than suggest that the analysis is ready to run.

## Requirements for a complete reproducible release

| Requirement | Current evidence | Needed to close it |
| --- | --- | --- |
| Study inputs | Not included; paths documented in DATA.md | Public accession/downloads, checksums, sample sheet, target oligos and lineage key |
| Original R environment | Package names only | Original session/version record, then tested environment and lockfile |
| Raw barcode processing | Two historical configurations, external repositories | Exact pipeline commits, preprocessing commands, sample sheet, logs |
| Both RNA samples | One Cell Ranger job with untransduced `--id` | Both libraries CSVs and complete commands/logs |
| SCENIC | Loom export and downstream plotting notebook | Full run commands, versions, ranking/motif databases, AUC/GRN/CTX files |
| Figure mapping | Mapping by manuscript content and script outputs | Final panel-to-output choices and figure assembly source |
| Successful rerun | No full run from this checkout | Clean-session execution, retained logs, QC totals and output comparisons |
| Release metadata | No license, final citation, or archived release in checkout | Author-selected license, citation, release tag and archival identifier |

### Specific execution and interpretation gaps found in the source

- `Gene_Set_Analysis.Rmd` references `go_bp_sets` without defining or loading it.
  Its Hallmark calls use `enricher()`, an over-representation test, and omit an
  explicit measured-gene universe. A final GO source, gene-set release, and
  intended background must be confirmed before changing this analysis. The
  figure legend should match the method actually used.
- `Organize_Data.Rmd` plots `df_spike_in_counts$Cell_Numbers` before assigning
  that column. This section needs execution with the original input schema and
  correction/verification before claiming a clean-session run.
- `Create_Seurat_Objects.Rmd` and `Basic_Barcode_Metrics.Rmd` initialize completed
  barcode matrices only when some RNA cells lack barcode records. A dataset with
  no missing barcode columns follows an undefined-object path. This should be
  repaired and exercised with representative data before broader reuse.
- The source count-table column ordering is positional. Renaming an arbitrary
  table to the expected filename does not establish the correct sample mapping.
- The historical ImageJ and cluster scripts retain platform-specific paths.
  They are documented as templates rather than verified portable launchers.
- The gDNA configuration and post-processing use different spike-in handling
  conventions. The relationship needs confirmation against the original run.
- Stochastic exploratory notebooks do not consistently record seeds. A release
  should archive the original seeds when available, or explicitly label new
  seeded reruns and compare their results.

These findings identify concrete limits of the current code archive. They are
not an exhaustive scientific code review. Resolving data/version gaps may reveal
additional execution issues. Separate revision analyses should be integrated
only after their inputs, provenance, and final figure choices are settled.

## Suggested verification record for a full run

Record the repository commit, R session, upstream software/database versions,
input checksums, sample mapping, barcode orientation, QC cell counts, assigned
lineage counts, DE contrast direction and gene universe, and output checksums.
Verify cell IDs before every merge. Save each notebook's rendered report and
error/output log. Compare recreated tables and plots with the final submitted
figure sources before marking reproduction complete.

## Validation of this update, 2026-09-30

| Check | Result |
| --- | --- |
| Parse all R notebook chunks with base R 4.6.1 | 23 of 23 passed after the syntax correction |
| Execute synthetic barcode example | Passed all six expected cases |
| Preflight behavior with temporary fixtures | Missing-input failure creates no outputs; supplied paths permit output-directory creation |
| Manifest and documentation links | All 23 notebooks covered; local links resolve |
| Comparison against source commit | Analysis text outside setup chunks unchanged except the documented stray `x` removal |
| RNA notebook preflight on source-only checkout | Correctly reports four missing input paths |
| Environment inventory | Missing analysis/rendering packages reported; this machine is not a complete analysis environment |
| Full study analysis and figure reproduction | Not run |
