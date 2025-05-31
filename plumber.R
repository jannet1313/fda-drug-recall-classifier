# plumber.R

library(plumber)

model <- readRDS("/app/recall_model.rds")

#* Predict recall severity
#* @post /predict
#* @param reason The reason for recall
#* @serializer unboxedJSON
predict_recall <- function(reason) {
  pred <- predict(model, data.frame(reason = reason), type = "response")
  list(severity = pred)
}