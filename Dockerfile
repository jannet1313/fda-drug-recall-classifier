FROM rstudio/plumber:latest

WORKDIR /app

COPY recall_model.rds plumber.R entrypoint.R /app/

EXPOSE 8000

CMD ["Rscript", "entrypoint.R"]

