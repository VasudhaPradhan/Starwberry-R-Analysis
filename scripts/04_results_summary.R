############################################################
# 04_results_summary.R — Results summarization
############################################################

library(dplyr)
library(readr)

# Load cleaned data
master_data <- read_csv("results/master_data_clean.csv")

# Traits to summarize
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

summarize_trait <- function(trait) {
  
  # Mean per treatment
  means <- master_data %>%
    group_by(treatment) %>%
    summarise(
      mean_value = mean(.data[[trait]], na.rm = TRUE),
      .groups = "drop"
    )
  
  # ANOVA
  model <- aov(as.formula(paste(trait, "~ treatment")), data = master_data)
  p_value <- summary(model)[[1]][["Pr(>F)"]][1]
  
  # Is trait significant?
  significant <- ifelse(p_value < 0.05, "Yes", "No")
  
  # Identify best treatment
  if (significant == "Yes") {
    
    if (trait %in% c("days_to_first_flowering", "days_to_first_harvest")) {
      # lower is better
      best <- means %>% arrange(mean_value) %>% slice(1)
    } else {
      # higher is better
      best <- means %>% arrange(desc(mean_value)) %>% slice(1)
    }
    
  } else {
    best <- tibble(
      treatment = NA,
      mean_value = NA
    )
  }
  
  # Final row
  tibble(
    trait = trait,
    best_treatment = best$treatment,
    best_mean = round(best$mean_value, 2),
    anova_p_value = signif(p_value, 3),
    significant = significant
  )
}

results_summary <- bind_rows(
  lapply(traits, summarize_trait)
)

write_csv(
  results_summary,
  "results/results_summary.csv"
)

results_summary
