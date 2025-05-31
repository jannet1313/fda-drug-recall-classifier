FROM rstudio/plumber:latest

WORKDIR /app

COPY plumber.R /app/
COPY recall_model.rds /app/
COPY entrypoint.R /app/

EXPOSE 8000

CMD ["Rscript", "/app/entrypoint.R"]
