library(httr)
library(jsonlite)
library(tidyverse)

collect_recalls <- function(skip = 0, limit = 100) {
  url <- paste0("https://api.fda.gov/drug/enforcement.json?limit=", limit, "&skip=", skip)
  res <- GET(url)
  json <- fromJSON(content(res, "text"), flatten = TRUE)
  return(json$results)
}

# Collect first 1000 records
recall_list <- lapply(seq(0, 900, 100), function(i) collect_recalls(i))
recall_df <- bind_rows(recall_list)

# Only keep relevant columns
recall_df <- recall_df %>%
  select(recall_number, classification, reason_for_recall, product_description, report_date)

# Save to CSV
write_csv(recall_df, "data/fda_recall_raw.csv")
