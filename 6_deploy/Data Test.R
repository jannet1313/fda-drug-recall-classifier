# check_class_balance.R

# Load training data
training_data <- read.csv("~/Desktop/fda-drug-recall-classifier/data/fda_recall_raw.csv")

# View class counts and proportions
print(table(training_data$recall_class))
print(prop.table(table(training_data$recall_class)))

training_data <- read.csv("~/Desktop/fda-drug-recall-classifier/data/fda_recall_raw.csv")
str(training_data)

names(training_data)

library(themis)

recipe(...) %>%
  step_downsample(classification)  # or step_upsample(classification)
