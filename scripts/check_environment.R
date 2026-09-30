# Run from the repository root. Read-only; no packages are installed.
cat(R.version.string, "\n")
files <- readLines("docs/manuscript_notebooks.txt", warn = FALSE)
if (any(!file.exists(files))) stop("A listed manuscript notebook is missing.")
if (!length(files)) stop("Run this script from the CloneSweeper_Paper repository root.")
text <- unlist(lapply(files, readLines, warn = FALSE))
hits <- regmatches(text, gregexpr("library\\([A-Za-z][A-Za-z0-9.]*\\)", text))
packages <- sort(unique(c("knitr", "rmarkdown", sub("library\\((.*)\\)", "\\1", unlist(hits)))))
available <- vapply(packages, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))
versions <- vapply(packages, function(p) {
  if (available[[p]]) as.character(packageVersion(p)) else "MISSING"
}, character(1))
print(data.frame(package = packages, version = unname(versions)), row.names = FALSE)
cat("\nCairo graphics:", capabilities("cairo"), "\n")
if (available[["rmarkdown"]]) cat("Pandoc:", rmarkdown::pandoc_available(), "\n")
cat("\nSession information for this check (not the original analysis environment):\n")
print(sessionInfo())
if (any(!available)) quit(status = 1)
