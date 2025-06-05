library(tidymodels)
library(textrecipes)
library(readr)

# Load cleaned data
fda <- read_csv("fda_recalls_clean.csv")

# Ensure classification is a factor
fda <- fda %>%
  mutate(event_classification = as.factor(event_classification))

# Split into training and testing sets
set.seed(123)
split <- initial_split(fda, prop = 0.8)
train_data <- training(split)
test_data  <- testing(split)

# Create text preprocessing recipe
recall_recipe <- recipe(event_classification ~ reason_for_recall, data = train_data) %>%
  step_tokenize(reason_for_recall) %>%
  step_stopwords(reason_for_recall) %>%
  step_tokenfilter(reason_for_recall, max_tokens = 100) %>%
  step_tfidf(reason_for_recall)

library(nnet)

# Replace logistic_reg with multinom_reg
lr_spec <- multinom_reg() %>%
  set_engine("nnet") %>%
  set_mode("classification")

# Combine into a workflow
recall_wf <- workflow() %>%
  add_recipe(recall_recipe) %>%
  add_model(lr_spec)

# Fit the model to training data
recall_fit <- recall_wf %>%
  fit(data = train_data)

# Evaluate on the test set
test_predictions <- predict(recall_fit, test_data, type = "prob") %>%
  bind_cols(predict(recall_fit, test_data)) %>%
  bind_cols(test_data)

# Confusion matrix
conf_mat(test_predictions, truth = event_classification, estimate = .pred_class)

# Accuracy and other metrics
metrics(test_predictions, truth = event_classification, estimate = .pred_class)

dir.create("4_model-api", showWarnings = FALSE)
saveRDS(recall_fit, "4_model-api/recall_model.rds")


