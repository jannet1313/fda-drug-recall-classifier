# Use a working RStudio Plumber image
FROM rstudio/plumber:latest

# Create app directory
WORKDIR /app

# Copy model and API script into container
COPY plumber.R /app/
COPY recall_model.rds /app/

# Expose Plumber port
EXPOSE 8000

# Command to run the API
CMD R -e "pr <- plumber::plumb('/app/plumber.R'); pr$run(host='0.0.0.0', port=8000)"

