# plumber.R

library(plumber)
library(tidymodels)
library(textrecipes)  # Needed for tokenization

# Load trained workflow
model <- readRDS("recall_model.rds")

#* Predict recall severity from reason
#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  new_data <- tibble(reason_for_recall = reason)
  
  # Use predict directly — workflow handles preprocessing
  prediction <- predict(model, new_data, type = "class")  # or use "prob" if you prefer
  
  list(severity = prediction[[1]])
}