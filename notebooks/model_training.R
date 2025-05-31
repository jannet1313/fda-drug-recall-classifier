# notebooks/model_training.R

library(tidymodels)
library(readr)
library(dplyr)

# Load the data
df <- read_csv("data/fda_recall_raw.csv") %>%
  filter(!is.na(classification), !is.na(reason_for_recall)) %>%
  filter(classification %in% c("Class I", "Class II", "Class III"))

# Convert classification to a factor
df <- df %>%
  mutate(classification = factor(classification, levels = c("Class I", "Class II", "Class III")))

# Split into training and test sets
set.seed(123)
recall_split <- initial_split(df, prop = 0.8, strata = classification)
recall_train <- training(recall_split)
recall_test <- testing(recall_split)

# Recipe: process text using tokenization and TF-IDF
recall_recipe <- recipe(classification ~ reason_for_recall, data = recall_train) %>%
  step_tokenize(reason_for_recall) %>%
  step_stopwords(reason_for_recall) %>%
  step_tokenfilter(reason_for_recall, max_tokens = 300) %>%
  step_tfidf(reason_for_recall)

# Define logistic regression model
recall_model <- multinom_reg() %>%
  set_engine("nnet") %>%
  set_mode("classification")

# Combine recipe + model into a workflow
recall_wf <- workflow() %>%
  add_recipe(recall_recipe) %>%
  add_model(recall_model)

# Train the model
recall_fit <- fit(recall_wf, data = recall_train)

# Save the model for later use in API
saveRDS(recall_fit, "model-api/recall_model.rds")

# Optional: evaluate performance
recall_preds <- predict(recall_fit, recall_test) %>%
  bind_cols(recall_test)

metrics(recall_preds, truth = classification, estimate = .pred_class)