import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import LabelEncoder
import pickle

# Load your data
df = pd.read_excel("../2_data/drug_recall.xlsx")

# Prepare data (correct column names and rename them for consistency)
df = df[["Reason for Recall", "Event Classification"]].dropna()
df = df.rename(columns={"Reason for Recall": "reason_for_recall", "Event Classification": "classification"})

X = df["reason_for_recall"]
y = df["classification"]

# Encode the labels
le = LabelEncoder()
y_encoded = le.fit_transform(y)

# Optional: Print label classes for reference
print("Classes:", le.classes_)

# Build model
model = Pipeline([
    ("tfidf", TfidfVectorizer()),
    ("clf", LogisticRegression(max_iter=1000))
])

# Train model
model.fit(X, y_encoded)

# Save model and label encoder
with open("recall_model_sklearn.pkl", "wb") as f:
    pickle.dump(model, f)

with open("label_encoder.pkl", "wb") as f:
    pickle.dump(le, f)

print("Model and label encoder saved successfully.")