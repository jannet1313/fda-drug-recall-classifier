# plumber.R

library(plumber)
library(tidymodels)

# Load trained workflow
model <- readRDS("recall_model.rds")

#* Predict recall severity from reason
#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  new_data <- tibble(reason_for_recall = reason)
  
  # Use hardhat to preprocess input with model's blueprint
  processed <- hardhat::forge(new_data, blueprint = model$pre$mold$blueprint)
  
  pred <- predict(model, processed$predictors, type = "response")
  
  list(severity = pred[[1]])
}