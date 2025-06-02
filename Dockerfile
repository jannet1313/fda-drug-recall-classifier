FROM rstudio/plumber:latest

# Install system dependencies (needed for text processing)
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('tidymodels', 'textrecipes', 'themis', 'text2vec', 'stopwords'), repos='http://cran.rstudio.com/')"

# Set working directory
WORKDIR /app

# Copy files into container
COPY plumber.R /app/plumber.R
COPY app/entrypoint.R /app/entrypoint.R
COPY app/recall_model.rds /app/recall_model.rds

# Expose the Plumber port
EXPOSE 8000

# Run the API
CMD ["Rscript", "/app/entrypoint.R"]


