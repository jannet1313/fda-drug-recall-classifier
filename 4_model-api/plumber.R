# plumber.R

library(plumber)
library(tidymodels)
library(textrecipes)

# Load model
model <- readRDS("recall_model.rds")

# Create and start Plumber API
pr() %>%
  pr_post("/predict", function(reason) {
    tryCatch({
      new_data <- tibble(reason_for_recall = reason)
      prediction <- predict(model, new_data, type = "class")
      probabilities <- predict(model, new_data, type = "prob")
      list(
        severity = prediction[[1]],
        probabilities = as.list(probabilities[1, ])
      )
    }, error = function(e) {
      list(error = e$message)
    })
  }) %>%
  pr_run(host = "0.0.0.0", port = 8000)
