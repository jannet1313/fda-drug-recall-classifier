# Dockerfile

FROM rstudio/plumber:latest

WORKDIR /app

COPY recall_model.rds /app/
COPY plumber.R /app/

EXPOSE 8000

CMD ["R", "-e", "pr <- plumber::plumb('/app/plumber.R'); pr$run(host='0.0.0.0', port=8000)"]

