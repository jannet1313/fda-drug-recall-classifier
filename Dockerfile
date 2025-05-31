# Use Plumber base image
FROM rstudio/plumber:latest

# Set the working directory inside the container
WORKDIR /app

# Copy files into the container
COPY plumber.R /app/
COPY recall_model.rds /app/

# Expose the port
EXPOSE 8000

# Correctly run Plumber
CMD ["Rscript", "plumber.R"]
