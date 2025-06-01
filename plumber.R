# plumber.R

library(plumber)

# Load model at the top-level only if not already loaded
if (!exists("model")) {
  model <- readRDS("/app/recall_model.rds")
}

#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  input <- data.frame(reason = reason)
  pred <- predict(model, input)  # REMOVE type = "response"
  list(severity = pred$.pred_class)  # Use tidymodels convention
}