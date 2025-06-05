# entrypoint.R

library(plumber)

# Plumb and run the API
pr("api.R") |> 
  pr_run(host = "0.0.0.0", port = 8000)