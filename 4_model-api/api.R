# api.R

library(plumber)
library(tidymodels)
library(textrecipes)

# Load the model
model <- readRDS("recall_model.rds")

#* Predict recall severity and probabilities from reason
#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  tryCatch({
    new_data <- tibble(reason_for_recall = reason)
    
    prediction <- predict(model, new_data, type = "class")
    probabilities <- predict(model, new_data, type = "prob")
    
    list(
      severity = prediction[[1]],
      probabilities = probabilities[1, ] |> as.list()
    )
  }, error = function(e) {
    list(error = e$message)
  })
}
