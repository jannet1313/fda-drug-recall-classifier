
# FDA Drug Recall Classifier

*A Machine Learning App for Predicting Recall Severity Based on Reason Text*

## Overview

This project presents a machine learning-powered web application that classifies FDA drug recall notices into severity levels (Class I, II, or III) based on the reason for recall. It combines data scraping, predictive modeling, and full-stack deployment into an interactive tool.

- A logistic regression model trained on FDA drug recall data
- A REST API deployed using Plumber (R)
- An interactive Shiny application for user input and prediction display
- Deployment using Amazon EC2 (API) and shinyapps.io (Shiny App)

## Problem Statement

FDA drug recalls are categorized by severity (Class I being the most urgent). However, classification is not always immediate. This project aims to accelerate response efforts by predicting recall class directly from the reason text using natural language processing and classification models.

## Data Acquisition

The data was obtained through the **FDA Enforcement Report API**, specifically from the drug recall dataset.

- API Endpoint: `https://api.fda.gov/drug/enforcement.json`
- Collected fields: `reason_for_recall`, `recalling_firm`, `classification`, `product_description`, `recall_initiation_date`
- Processed into a tabular format (CSV) for training and evaluation

## Exploratory Data Analysis (EDA)

- Number of observations: ~15,000 recalls
- Class distribution:
  - Class I: ~10%
  - Class II: ~60%
  - Class III: ~30%
- Word clouds and TF-IDF analysis highlighted common terms across classes
- Balanced dataset using stratified sampling for model training

## Modeling

- Text preprocessing with `tm` and `tidytext`
- Feature extraction using TF-IDF
- Logistic regression used for classification
- Evaluation metrics:
  - Accuracy: ~81%
  - Precision/Recall for each class shown in confusion matrix

## Application Design

### API

- Developed using **Plumber (R)**
- Endpoint: `/predict`
- Input: JSON with `reason` field
- Output: Predicted class with probability
- **Live API**: http://3.145.181.209:8000/predict

### Shiny App

- UI allows user to input a recall reason
- App connects to the API to fetch the prediction
- Result displayed with severity badge and description
- **Live App**: [https://jannetcastaneda.shinyapps.io/fda-recall-classifier/](https://jannetcastaneda.shinyapps.io/fda-recall-classifier/)

### Screenshot - Shiny App

![Shiny App Screenshot](./presentation/shiny_app_screenshot.png)

### Screenshot - API Response

![API Response Screenshot](./presentation/api_response.png)

## Deployment

- **Model API** hosted on **Amazon EC2** (Ubuntu)
  - Docker used to run the Plumber API
  - EC2 port 8000 opened via security group
- **Shiny App** hosted on **shinyapps.io**
  - Linked to GitHub repo for deployment

## Instructions for Use

### API Usage (via cURL)

```bash
curl -X POST http://3.145.181.209:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"reason": "possible contamination with bacteria"}'
```

###  Shiny App

Visit: [https://jannetcastaneda.shinyapps.io/fda-recall-classifier/](https://jannetcastaneda.shinyapps.io/fda-recall-classifier/)

## Directory Structure

```
fda-drug-recall-classifier/
├── README.md
├── data/                # Raw and processed data
├── model-api/           # Plumber API
├── app/                 # Shiny application
├── deploy/              # EC2 setup and Dockerfile
├── presentation/        # Final presentation slides and screenshots
└── report.md            # Full writeup (same as this file)
```

## Future Work

- Improve performance using ensemble models (e.g., random forest, XGBoost)
- Add NLP explainability with LIME or SHAP
- Allow batch prediction uploads in the Shiny app
- Collect more up-to-date recall data from FDA weekly

---

### License

[MIT License](LICENSE)

### Author

Jannet Castaneda Sanchez  

---
