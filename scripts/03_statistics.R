############################################################
# 03_statistics.R — ANOVA & Post-hoc Analysis
############################################################

library(dplyr)
library(readr)

# ----------------------------------------------------------
# Load cleaned master dataset
# ----------------------------------------------------------

master_data <- read_csv("results/master_data_clean.csv")

# Convert treatment to factor
master_data$treatment <- as.factor(master_data$treatment)

############################################################
# STEP 1 — List of traits to analyze
############################################################

traits <- c(
  "plant_spread_cm",
  "total_flowers",
  "fruit_length_mm",
  "fruit_breadth_mm",
  "leaves",
  "crown_diameter_mm",
  "days_to_first_flowering",
  "days_to_first_harvest"
)

############################################################
# STEP 2 — Run ANOVA for ALL traits
############################################################

anova_results <- list()

for(trait in traits) {
  
  formula <- as.formula(paste(trait, "~ treatment"))
  
  model <- aov(formula, data = master_data)
  
  anova_results[[trait]] <- summary(model)
  
  cat("\n=====================================\n")
  cat("ANOVA for:", trait, "\n")
  cat("=====================================\n")
  print(summary(model))
}

############################################################
# STEP 3 — Tukey HSD post-hoc for ALL traits
############################################################

tukey_results <- list()

for(trait in traits) {
  
  formula <- as.formula(paste(trait, "~ treatment"))
  
  model <- aov(formula, data = master_data)
  
  tukey_results[[trait]] <- TukeyHSD(model)
  
  cat("\n=====================================\n")
  cat("Tukey HSD for:", trait, "\n")
  cat("=====================================\n")
  print(TukeyHSD(model))
}

############################################################
# END OF STATISTICAL ANALYSIS
############################################################