library(tidyverse)
library(readxl)
library(lubridate)

# Load the Excel file
fda_raw <- read_excel("drug_recall.xlsx")

# Clean: rename columns and select relevant fields
fda_clean <- fda_raw %>%
  rename_with(~ gsub(" ", "_", .x)) %>%     # Replace spaces with underscores
  rename_with(tolower) %>%                  # Convert column names to lowercase
  rename(
    reason_for_recall = reason_for_recall,
    event_classification = event_classification,
    product_description = product_description,
    classification_date = center_classification_date
  ) %>%
  mutate(
    classification_date = ymd(classification_date),
    event_classification = as.factor(event_classification)
  ) %>%
  select(reason_for_recall, event_classification, product_description, classification_date) %>%
  filter(!is.na(reason_for_recall), !is.na(event_classification))

# Save cleaned version
write_csv(fda_clean, "fda_recalls_clean.csv")


fda <- read_csv("fda_recalls_clean.csv")

fda %>%
  count(event_classification) %>%
  mutate(prop = round(n / sum(n), 3)) %>%
  ggplot(aes(x = fct_infreq(event_classification), y = n)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = paste0(n, " (", prop * 100, "%)")), vjust = -0.5) +
  labs(title = "Distribution of Recall Classifications",
       x = "Classification", y = "Count")

fda %>%
  mutate(reason_length = str_count(reason_for_recall, "\\w+")) %>%
  ggplot(aes(x = reason_length)) +
  geom_histogram(binwidth = 5, fill = "darkorange", color = "white") +
  labs(title = "Length of Recall Reasons", x = "Word Count", y = "Frequency")

library(tidytext)
library(ggwordcloud)

fda_words <- fda %>%
  unnest_tokens(word, reason_for_recall) %>%
  anti_join(stop_words, by = "word") %>%
  count(event_classification, word, sort = TRUE) %>%
  group_by(event_classification) %>%
  slice_max(n, n = 100) %>%
  ungroup()

ggplot(fda_words, aes(label = word, size = n, color = event_classification)) +
  geom_text_wordcloud_area() +
  facet_wrap(~event_classification) +
  theme_minimal()

fda %>%
  count(year = lubridate::year(classification_date)) %>%
  ggplot(aes(x = year, y = n)) +
  geom_line(color = "darkgreen") +
  geom_point() +
  labs(title = "Recall Volume by Year", x = "Year", y = "Recall Count")
