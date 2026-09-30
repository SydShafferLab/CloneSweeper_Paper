# Parse R chunks without executing them or requiring scientific packages/data.
# Also works with only base R installed. Run from the repository root.
files <- list.files("Experiments", pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
if (!length(files)) stop("Run from the CloneSweeper_Paper repository root.")
failed <- character()
for (file in files) {
  lines <- readLines(file, warn = FALSE)
  in_chunk <- FALSE
  code <- character()
  for (line in lines) {
    if (grepl("^```\\{r[ ,}]", line)) {
      in_chunk <- TRUE
    } else if (in_chunk && grepl("^```\\s*$", line)) {
      in_chunk <- FALSE
      code <- c(code, "")
    } else if (in_chunk) {
      code <- c(code, line)
    }
  }
  error <- tryCatch({parse(text = code); NULL}, error = function(e) conditionMessage(e))
  if (!is.null(error) || in_chunk) {
    failed <- c(failed, file)
    cat("FAIL", file, "\n", error, "\n")
  } else {
    cat("PASS", basename(file), "\n")
  }
}
if (length(failed)) quit(status = 1)
cat("Parsed", length(files), "notebooks. This does not verify runtime behavior or results.\n")
