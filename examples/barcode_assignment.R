# Synthetic illustration of the three filters in Create_Seurat_Objects.Rmd.
# This example starts from unique-UMI counts per lineage and cell, after RNA QC.
# It does not implement FASTQ processing, barcode clustering, or RNA analysis.
counts <- rbind(
  lineage_A = c(3, 5, 3, 3, 2, 0),
  lineage_B = c(0, 2, 2, 3, 0, 0)
)
colnames(counts) <- c("single", "clear_leader", "small_gap", "multiple", "low_count", "empty")
threshold <- 3
above_threshold <- colSums(counts >= threshold)
gap <- apply(counts, 2, function(x) {
  ranked <- sort(x, decreasing = TRUE)
  ranked[1] - ranked[2]
})
keep <- above_threshold == 1 & gap >= threshold
assignment <- apply(counts, 2, function(x) rownames(counts)[which.max(x)])
assignment[!keep] <- NA_character_
result <- data.frame(cell = colnames(counts), barcodes_at_threshold = above_threshold,
                     top_minus_second = gap, retained = keep, lineage = assignment,
                     row.names = NULL)
print(result, row.names = FALSE)
stopifnot(identical(unname(keep), c(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE)))
stopifnot(identical(unname(assignment[keep]), c("lineage_A", "lineage_A")))
cat("PASS: two cells assigned; ambiguous, low-count, and empty cells excluded.\n")
