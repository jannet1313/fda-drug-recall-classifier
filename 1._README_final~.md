
# FDA Drug Recall Classifier

This project leverages FDA enforcement report data (2012–2024) to build a predictive model that classifies the **severity of drug recalls** based on the **reason for recall**. The application includes data cleaning, model training, and deployment via both a Shiny interface and a REST API.

---

## 🔍 Exploratory Data Analysis (EDA)

The dataset contains ~15,000 drug recall events. Key observations:

### Class Distribution

| Classification | Count | Description                                      |
|----------------|--------|--------------------------------------------------|
| Class I        | ~10%   | Life-threatening or serious health issues       |
| Class II       | ~60%   | Temporary or reversible health problems         |
| Class III      | ~30%   | Less likely to cause harm                       |

- Bar charts confirmed class imbalance.  
- **Stratified sampling** was used to split training and test sets.

### Text Features (`reason_for_recall`)

- **Median Length**: ~10–15 words per reason.
- **TF-IDF Highlights**:
  - *Class I*: `contamination`, `sterility`, `life-threatening`
  - *Class II*: `mislabeling`, `adverse`, `subpotent`
  - *Class III*: `labeling`, `packaging`, `noncompliance`

Visual tools like word clouds and token frequency plots guided feature engineering.

---

## 🧠 Modeling Approach

- **Model**: Multinomial Logistic Regression (`nnet::multinom`)
- **Text Features**: TF-IDF of `reason_for_recall`
- **Split**: 80% training, 20% testing (stratified)
- **Metrics**:
  - **Accuracy**: 86.1%
  - **Cohen’s Kappa**: 0.608
  - **Confusion Matrix**: Strong separation across classes

The `multinom_reg()` approach improved precision, especially for borderline Class II/III cases.

---

## 🚀 Deployment

The application is deployed in two environments:

- **🌐 Shiny App (User Interface)**  
  [FDA Recall Classifier App](https://jannetcastaneda.shinyapps.io/fda-drug-recall-classifier/)

- **🔗 RESTful API (via EC2)**  
  `http://3.145.181.209:8000/predict`

**API Example Usage**:
```bash
curl -X POST http://3.145.181.209:8000/predict \
  -d "reason=product contaminated with foreign material"
```

---

## 📁 Project Structure

```
fda-drug-recall-classifier/
├── 1_README.md
├── 2_data/
│   ├── drug_recall.xlsx
│   └── fda_recalls_clean.csv
├── 3_notebooks/
│   └── eda_modeling.Rmd
├── 4_model-api/
│   ├── recall_model.rds
│   ├── plumber.R
│   └── entrypoint.R (optional)
├── 5_shiny-app/
│   ├── app.R
│   └── FDA Drug Recall Classifier - Modeling Report.html
└── presentation/
    └── final_slides.pdf
```

---

## 👩‍💻 Author

**Jannet Castaneda Sanchez**  
UCLA Master of Applied Statistics and Data Science  
Deployed June 2025 | [GitHub Repo (Private/Class Submission)](#)

---

## ✅ Summary

This project demonstrates how **natural language processing (NLP)** and **logistic regression** can classify recall risk from real-world regulatory data. The full pipeline from data acquisition to cloud deployment is reproducible and live.
