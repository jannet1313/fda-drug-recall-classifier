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
  
  # Extract and bake with the original recipe
  recipe <- model$pre$actions$recipe$recipe
  processed <- bake(recipe, new_data)
  
  pred <- predict(model, processed, type = "response")
  
  list(severity = pred[[1]])
}