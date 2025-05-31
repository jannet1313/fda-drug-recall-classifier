# model-api/plumber.R

library(plumber)
library(tibble)
library(jsonlite)

# Load the trained model
model <- readRDS("recall_model.rds")

#* @apiTitle FDA Recall Severity Prediction API

#* Predict recall classification from a reason
#* @post /predict
function(req) {
  body <- fromJSON(req$postBody)
  reason_input <- body$reason
  
  input_df <- tibble(reason_for_recall = reason_input)
  pred <- predict(model, input_df, type = "prob")
  
  return(pred)
}

