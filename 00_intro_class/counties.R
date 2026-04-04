rm(list=ls())
cat("\014") # clear console
setwd("~/social_networks/00_intro_class")

# Load the data as 
counties = read.delim("../data/County_Profiles.txt",sep="|", header=TRUE, stringsAsFactors = FALSE)

# Get a quick overview of the dataframe structure and variable names
str(counties)
# Another overview — shows variable names, types, and first few values
summary(counties)
# See all variable names explicitly
names(counties)
# Count of rows and columns
dim(counties)
# ── For numeric variables: valid entries, max, min, mean, sd ──────────────
# summary() handles most of this — shows min, max, mean, and count of NAs
# (valid entries = nrow(counties) minus NA count)
summary(counties[, sapply(counties, is.numeric)])
# SD for each numeric variable (na.rm=TRUE skips missing values)
sapply(counties[, sapply(counties, is.numeric)], sd, na.rm = TRUE)
# Count of valid (non-NA) entries for each numeric variable
sapply(counties[, sapply(counties, is.numeric)], function(x) sum(!is.na(x)))
# ── For string/character variables: mode and count of unique values ───────
# Count of unique values for each string variable
sapply(counties[, sapply(counties, is.character)], function(x) length(unique(x)))
# Mode (most frequent value) for each string variable
# R has no built-in mode() for this, so we define a helper function first
find_mode <- function(x) {
  names(sort(table(x), decreasing = TRUE))[1]
}
sapply(counties[, sapply(counties, is.character)], find_mode)



# ── 1. Sanity-check the raw variables before any analysis ─────────────────

# Check that percent_poor is actually bounded between 0 and 1
if (any(counties$percent_poor < 0 | counties$percent_poor > 1, na.rm = TRUE)) {
  warning("SUSPICIOUS DATA: percent_poor contains values outside 0–1. Check for transcription errors.")
}

# Check that household size is plausible (US county averages typically 2.0 – 4.5)
if (any(counties$average_household_size < 1 | counties$average_household_size > 10, na.rm = TRUE)) {
  warning("SUSPICIOUS DATA: average_household_size contains implausible values (below 1 or above 10).")
}

# Check for duplicate county identifiers — each state+county combo should be unique
duplicate_count <- sum(duplicated(paste(counties$state, counties$county)))
if (duplicate_count > 0) {
  warning(paste("SUSPICIOUS DATA:", duplicate_count, 
                "duplicate state/county combinations found. Rows may have been entered twice."))
}

# Report how many rows are lost to missing values
n_missing <- sum(is.na(counties$percent_poor) | is.na(counties$average_household_size))
cat("Note:", n_missing, "rows dropped due to missing values.\n")

# ── 2. Choose the right test ───────────────────────────────────────────────

# percent_poor is a proportion (0–1), which is often skewed.
# A Pearson correlation assumes both variables are roughly normally distributed.
# We use Spearman rank correlation instead — it makes no distributional assumptions
# and is robust to outliers and skewed data, which are common in county-level poverty data.

# ── 3. Run the Spearman correlation ───────────────────────────────────────

# cor.test() gives us the estimate, confidence interval, and p-value in one call
result <- cor.test(
  counties$average_household_size,
  counties$percent_poor,
  method   = "spearman",   # rank-based, robust to skew and outliers
  exact    = FALSE          # required for large samples; uses normal approximation
)

# ── 4. Print the key outputs cleanly ──────────────────────────────────────

cat("\n── Spearman Correlation: Household Size vs. Poverty Rate ──\n")

# Point estimate — the correlation coefficient (rho), ranges from -1 to +1
cat("Point estimate (rho):", round(result$estimate, 3), "\n")

# P-value — probability of seeing this result if there were truly no relationship
cat("P-value:", format.pval(result$p.value, digits = 3), "\n")

# Plain-English interpretation
if (result$p.value < 0.05) {
  cat("Conclusion: There IS a statistically significant relationship",
      "(p < 0.05) between household size and poverty rate.\n")
} else {
  cat("Conclusion: There is NO statistically significant relationship",
      "(p >= 0.05) between household size and poverty rate.\n")
}

# ── 5. Post-hoc reasonableness checks on the result itself ────────────────

# A correlation above 0.95 in observational county data is almost certainly an error
if (abs(result$estimate) > 0.95) {
  warning("SUSPICIOUS RESULT: Correlation is extremely high (|rho| > 0.95). 
  This is unusual for observational county-level data — check for data entry errors 
  or duplicate rows inflating the relationship.")
}

# A p-value of exactly 0 usually signals a computational problem, not a true result
if (result$p.value == 0) {
  warning("SUSPICIOUS RESULT: P-value is exactly 0, which is mathematically impossible. 
  This may indicate duplicate rows or a corrupted variable.")
}

# If fewer than 50 counties remain after removing NAs, results may be unreliable
n_valid <- sum(!is.na(counties$percent_poor) & !is.na(counties$average_household_size))
if (n_valid < 50) {
  warning(paste("SUSPICIOUS RESULT: Only", n_valid, 
                "valid observations were used. Results may be unstable 
  with so few counties — check for widespread missing data."))
}