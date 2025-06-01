# entrypoint.R
library(plumber)

model <- readRDS("/app/recall_model.rds")
pr <- plumber::plumb("/app/plumber.R")
pr$run(host = "0.0.0.0", port = 8000)
