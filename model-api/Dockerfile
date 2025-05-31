FROM rocker/plumber

# Copy API files into container
COPY plumber.R /plumber.R
COPY recall_model.rds /recall_model.rds

# Expose the port that the API will listen on
EXPOSE 8000

# Start the Plumber API
CMD ["R", "-e", "pr <- plumber::plumb('/plumber.R'); pr$run(host='0.0.0.0', port=8000)"]
