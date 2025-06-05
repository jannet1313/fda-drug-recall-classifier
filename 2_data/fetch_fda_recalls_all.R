# fetch_fda_recalls_all.R

library(httr)
library(jsonlite)
library(dplyr)

# Base API URL
base_url <- "https://api.fda.gov/drug/enforcement.json"

# Set your query parameters
date_range <- "report_date:[20120101+TO+20241231]"
limit <- 1000  # FDA's max per page
skip <- 0
all_data <- list()

repeat {
  cat("Fetching records", skip + 1, "to", skip + limit, "...\n")

  query <- list(
    search = date_range,
    limit = limit,
    skip = skip
  )

  res <- GET(base_url, query = query)

  if (status_code(res) != 200) {
    stop("❌ Request failed at skip=", skip, ". HTTP ", status_code(res))
  }

  parsed <- fromJSON(content(res, "text", encoding = "UTF-8"))

  # Break if no more results
  if (length(parsed$results) == 0) {
    break
  }

  all_data[[length(all_data) + 1]] <- parsed$results
  skip <- skip + limit
}

# Combine all results
recalls_df <- bind_rows(all_data)

# Optional: Keep important columns
recalls_clean <- recalls_df %>%
  select(
    recall_number,
    classification,
    reason_for_recall,
    product_description,
    report_date,
    recalling_firm,
    state,
    country
  )

# Save to file
dir.create("data", showWarnings = FALSE)
write.csv(recalls_clean, "data/fda_recalls_2012_2024.csv", row.names = FALSE)

cat("✅ Saved", nrow(recalls_clean), "recall records to data/fda_recalls_2012_2024.csv\n")
