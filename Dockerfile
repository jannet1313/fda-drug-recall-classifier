FROM rstudio/plumber:latest

# Install required R packages
RUN R -e "install.packages(c('tidymodels', 'textrecipes', 'themis', 'hardhat', 'jsonlite'), repos='http://cran.rstudio.com/')"

# Set working directory in the container
WORKDIR /app

# Copy the files into the container
COPY plumber.R /app/plumber.R
COPY app/entrypoint.R /app/entrypoint.R
COPY app/recall_model.rds /app/recall_model.rds

# Expose the port Plumber runs on
EXPOSE 8000

# Start the API
CMD ["Rscript", "/app/entrypoint.R"]

