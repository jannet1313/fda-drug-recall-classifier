fda <- read_csv("2_data/fda_recalls_clean.csv")

fda %>%
  filter(event_classification == "Class II", str_detect(tolower(reason_for_recall), "death")) %>%
  select(reason_for_recall, event_classification)