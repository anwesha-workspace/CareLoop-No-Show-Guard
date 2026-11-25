# CareLoop Clinics — No-Show Guard

**GitHub Repository:** [Add your public GitHub repository link here]

## Project Summary

- **Part 1 — Data Cleaning:** Processed 1,020 appointment records and retained 990 clean records for analysis.
- **Part 2 — SQL Analysis:** Gomti Nagar Care Point had the highest clinic-level no-show rate at 33.3%.
- **Part 3 — Machine Learning:** Logistic Regression was selected, with cross-validation ROC-AUC of 0.7737 and a classification threshold of 0.35.
- **Part 4 — GenAI:** Analysed 9 nonblank call-centre notes out of 10 selected notes and classified the reasons using Gemini with Pydantic validation.

## Business Recommendation

CareLoop Clinics should prioritize early intervention for appointments with higher predicted no-show risk. The overall no-show rate was approximately 22.02%, while Gomti Nagar Care Point had a substantially higher rate of 33.3%. Appointments booked 31 or more days in advance had a 60.5% no-show rate, suggesting that these patients may benefit from additional reminders and confirmation calls. The selected Logistic Regression model achieved a test ROC-AUC of 0.7889 using a threshold of 0.35, with a recall of 57.14%. The GenAI analysis identified reminder problems, transport difficulties, fees, illness and work schedules among the recorded reasons. Clinics should use these insights to improve reminders, offer easier rescheduling and investigate transport and scheduling barriers.

## Machine Learning Model Selection

Logistic Regression was selected because it achieved the highest cross-validation ROC-AUC of 0.7737 among the models compared. A threshold of 0.35 was chosen based on the highest out-of-fold F1 score. On the test set, the model achieved:

- ROC-AUC: 0.7889
- Precision: 0.5714
- Recall: 0.5714
- F1-score: 0.5714

## GenAI Prompt Comparison

The CRAFT prompt was used to classify the notes with a defined set of allowed root causes and instructions not to guess when evidence was unclear.

The simple-prompt versus CRAFT-prompt comparison for N007 and N009 is pending because the Gemini API free-tier quota was reached. This section should be updated after completing that comparison.

## Limitations

1. Only 10 call-centre notes were selected, so they cannot establish the true distribution of reasons across all clinics.
2. The dataset is observational. Associations identified by the model do not prove that a particular factor causes missed appointments.
3. The train/test split was random rather than chronological, so the evaluation does not fully represent prediction on future appointments.

## Submission Files

- `01_ingest_clean.ipynb`
- `rejected_rows.json`
- `appointments_clean.csv`
- `clinics_enriched.csv`
- `load_data.sql`
- `02_queries.sql`
- `03_model.ipynb`
- `test_risk_scores.csv`
- `04_genai.ipynb`
- `notes_analysed.csv`
- `README.md`
- `data/` — Original input files

