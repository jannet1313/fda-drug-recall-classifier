library(plumber)

# Load model
model <- readRDS("recall_model.rds")

# Define API
#* @post /predict
function(req, res) {
  input <- req$body$reason
  pred <- predict(model, data.frame(reason = input), type = "response")
  return(list(prediction = pred))
}

# Launch API only if run directly
if (interactive() || identical(Sys.getenv("RUN_PLUMBER"), "TRUE")) {
  pr <- plumb("plumber.R")
  pr$run(host = "0.0.0.0", port = 8000)
}
