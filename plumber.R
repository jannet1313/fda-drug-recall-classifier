# plumber.R

library(plumber)
library(tidymodels)

model <- readRDS("/app/recall_model.rds")

#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
function(reason) {
  input <- data.frame(reason = reason)
  pred <- predict(model, input)
  list(severity = pred$.pred_class[1])
}
