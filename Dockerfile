FROM rstudio/plumber:latest

# Install required R packages
RUN R -e "install.packages(c('tidymodels', 'textrecipes', 'themis'), repos='http://cran.rstudio.com/')"

# Set working directory
WORKDIR /app

# Copy files into container
COPY plumber.R /app/
COPY recall_model.rds /app/
COPY entrypoint.R /app/

# Expose the Plumber port
EXPOSE 8000

# Run the API
CMD ["Rscript", "/app/entrypoint.R"]

