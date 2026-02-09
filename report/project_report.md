# Analysis of Treatment Effects on Growth, Yield and Quality Traits of Strawberry Using R

---

## 1. Problem Statement

Strawberry cultivation involves multiple agronomic treatments that influence plant growth, flowering behavior, yield and fruit quality.  
In experimental horticulture, large datasets are often collected across replications and plants, but:

- Data are commonly stored in complex, multi-sheet Excel workbooks  
- Manual or spreadsheet-based analysis increases the risk of errors  
- Identifying the best-performing treatment across multiple traits is difficult  
- Reproducible and transparent statistical workflows are often lacking  

### Research Problem

**How can experimental strawberry data be transformed into a reproducible, statistically sound analysis pipeline that objectively identifies the best treatments for growth, yield and quality traits?**

---

## 2. Objectives of the Project

The objectives of this project were:

1. To convert raw experimental Excel data into a clean and analyzable format  
2. To explore treatment-wise variability using exploratory data analysis (EDA)  
3. To test treatment effects statistically using ANOVA  
4. To identify significant differences using post-hoc testing  
5. To summarize results in an automated and objective manner  
6. To demonstrate strong R programming and statistical skills suitable for PhD-level research  

---

## 3. Experimental Data Description

- **Crop:** Strawberry (*Fragaria × ananassa*)  
- **Experimental design:** One-factor experiment (Treatment)  
- **Number of treatments:** 9 (T1–T9)  
- **Replications:** Up to 4  
- **Observations:** Plant-level measurements  

### Traits analyzed

- Plant spread (cm)  
- Number of leaves  
- Crown diameter (mm)  
- Days to first flowering  
- Total flowers per plant  
- Days to first harvest  
- Fruit length (mm)  
- Fruit breadth (mm)  

Missing observations were present for some replications and were handled using `NA`-aware statistical methods rather than data deletion.

---

## 4. Methodology

### 4.1 Data Cleaning and Structuring

- Raw Excel worksheets were merged into a single tidy dataset  
- Each row represents one plant within one replication and treatment  
- Missing values were retained as `NA`  
- The cleaned dataset was exported as `master_data_clean.csv`  

This ensured transparency, reproducibility, and traceability of all analyses.

---

### 4.2 Exploratory Data Analysis (EDA)

EDA was conducted to understand:

- Distribution of traits across treatments  
- Biological variability among plants  
- Presence of outliers  
- Overall treatment-wise trends  

For each trait, the following visualizations were created:

- **Boxplots** to examine distribution, variability, and outliers  
- **Mean ± Standard Error (SE) bar plots** to compare treatments  

Mean ± SE plots were used as they are standard in agronomy and horticulture research for treatment comparison.

---

### 4.3 Statistical Analysis

#### Analysis of Variance (ANOVA)

- One-way ANOVA was performed for each trait using treatment as the factor  
- Statistical significance was tested at α = 0.05  

#### Post-hoc Testing

- Tukey’s Honest Significant Difference (HSD) test was applied  
- Pairwise treatment comparisons were conducted while controlling family-wise error  

---

### 4.4 Automated Results Summarization

To avoid subjective interpretation:

- An automated R script was developed to  
  - Identify traits with significant treatment effects  
  - Select the best-performing treatment for each trait  
  - Apply biological logic (e.g., lower days indicate earlier flowering or harvest)  

This step transformed statistical output into clear, reproducible scientific conclusions.

---

## 5. Results

### 5.1 Summary of Treatment Performance

| Trait | Best Treatment | Significant |
|-----|---------------|------------|
| Total flowers | T8 | Yes |
| Fruit length | T3 | Yes |
| Fruit breadth | T3 | Yes |
| Leaves | T1 | Yes |
| Days to first flowering | T5 | Yes |
| Days to first harvest | T5 | Yes |
| Plant spread | — | No |
| Crown diameter | — | No |

---

### 5.2 Interpretation of Results

- **T8** showed superior performance for yield-related traits  
- **T3** produced fruits with superior size and quality  
- **T5** resulted in the earliest flowering and harvesting  
- **T1** promoted vegetative growth as indicated by leaf number  
- Plant spread and crown diameter were relatively stable across treatments  

---

## 6. Discussion

The results indicate that no single treatment was optimal for all traits.  
Distinct trade-offs were observed between:

- Vegetative growth  
- Yield potential  
- Fruit quality  
- Earliness  

This highlights the importance of trait-specific treatment selection in strawberry cultivation.

---

## 7. Conclusion

This project demonstrates how:

- Raw experimental horticultural data can be transformed into a clean, analyzable format  
- Exploratory and inferential statistics can be combined in a reproducible workflow  
- R can be used as a complete tool for experimental data analysis and interpretation  

The analytical framework developed in this study can be applied to other agricultural and horticultural experiments.

---

## 8. Tools and Technologies Used

- R  
- tidyverse packages (`dplyr`, `ggplot2`, `readr`)  
- Statistical methods: ANOVA, Tukey HSD  
- Version control: GitHub  

---
