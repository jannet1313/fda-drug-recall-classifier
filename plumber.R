# plumber.R

library(plumber)
library(tidymodels)

model <- readRDS("recall_model.rds")

#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  # Wrap input in a tibble as expected by tidymodels workflows
  input <- tibble(reason = reason)
  
  # Predict using the workflow
  pred <- predict(model, input)  # returns a tibble
  list(severity = pred$.pred_class)
}