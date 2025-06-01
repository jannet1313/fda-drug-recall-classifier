library(plumber)
library(tidymodels)

# Load the trained workflow
model <- readRDS("recall_model.rds")

#* Predict recall severity from reason
#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  # Match expected column name from blueprint
  new_data <- tibble(reason_for_recall = reason)
  
  # Make prediction
  pred <- predict(model, new_data, type = "class")
  
  # Return as JSON
  list(severity = pred[[1]])
}