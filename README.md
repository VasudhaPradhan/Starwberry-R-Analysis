# Strawberry Treatment Data Analysis in R

## Project Overview
This project demonstrates a complete, reproducible data analysis workflow in **R** using real experimental data from a strawberry field trial.  
The analysis covers data cleaning, exploratory data analysis (EDA), statistical testing and result summarization.

The project was designed to showcase **practical R skills for agricultural and biological research** with a focus on clarity, reproducibility and statistical rigor.

---

## Experimental Background
- **Crop:** Strawberry  
- **Design:** One-factor experiment  
- **Treatments:** 9 nutrient and biostimulant treatments  
- **Observations:** Plant-level measurements across replications  
- **Traits analyzed:**  
  - Plant spread  
  - Number of leaves  
  - Crown diameter  
  - Days to first flowering  
  - Total flowers  
  - Days to first harvest  
  - Fruit length  
  - Fruit breadth  

Missing observations were retained and handled statistically to reflect real-world experimental conditions.

---

## Project Structure
```text
├── data/
│   └── Data for R.xlsx
├── report/
│   └── project_report.md
├── results/
│   ├── master_data_clean.csv
│   ├── results_summary.csv
│   └── figures/
├── scripts/
│   ├── 01_import_clean.R
│   ├── 02_eda.R
│   ├── 03_statistics.R
│   └── 04_results_summary.R
└── README.md
```

---

## Analysis Workflow
1. **Data Import & Cleaning**
   - Converted multi-sheet Excel data into a single tidy dataset
   - Standardized structure and preserved missing values

2. **Exploratory Data Analysis**
   - Boxplots to visualize biological variability
   - Mean ± SE plots for treatment comparison

3. **Statistical Analysis**
   - One-way ANOVA for all traits
   - Tukey HSD post-hoc tests for significant traits

4. **Results Summary**
   - Identification of best treatments per trait
   - Exported concise results table

---

## Key Outcomes
- Significant treatment effects were observed for most yield and quality traits.
- Different treatments optimized different traits, highlighting trade-offs between growth, yield, quality, and earliness.
- The workflow is fully reproducible and easily extensible to more complex experimental designs.

---

## Tools and Technologies Used
- R  
- tidyverse packages (`dplyr`, `ggplot2`, `readr`)  
- Statistical methods: ANOVA, Tukey HSD  
- Version control: GitHub

---

## Detailed Documentation
For full methodology, statistical interpretation, and results discussion, see **[Project Report](report/project_report.md)**

---

## Purpose
This project serves as a **portfolio-quality example** of applied data analysis in R for plant science, horticulture, and agricultural research, suitable for PhD applications and research interviews.
