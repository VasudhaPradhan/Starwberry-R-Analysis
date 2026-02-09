############################################################
# 02_eda.R — Exploratory Data Analysis (EDA)
############################################################

install.packages(c("ggplot2", "readr"))

library(dplyr)
library(ggplot2)
library(readr)


# ----------------------------------------------------------
# Load cleaned master dataset
# ----------------------------------------------------------

master_data <- read_csv("results/master_data_clean.csv")

# Inspect structure
str(master_data)

# Quick preview
head(master_data)

############################################################
# EDA STEP 2 — Overall summary statistics
############################################################

summary(master_data)

############################################################
# EDA STEP 3 — Treatment-wise mean performance
############################################################

treatment_means <- master_data %>%
  group_by(treatment) %>%
  summarise(
    plant_spread_cm = mean(plant_spread_cm, na.rm = TRUE),
    leaves = mean(leaves, na.rm = TRUE),
    crown_diameter_mm = mean(crown_diameter_mm, na.rm = TRUE),
    days_to_first_flowering = mean(days_to_first_flowering, na.rm = TRUE),
    primary_flowers = mean(primary_flowers, na.rm = TRUE),
    secondary_flowers = mean(secondary_flowers, na.rm = TRUE),
    tertiary_flowers = mean(tertiary_flowers, na.rm = TRUE),
    total_flowers = mean(total_flowers, na.rm = TRUE),
    days_to_first_harvest = mean(days_to_first_harvest, na.rm = TRUE),
    fruit_length_mm = mean(fruit_length_mm, na.rm = TRUE),
    fruit_breadth_mm = mean(fruit_breadth_mm, na.rm = TRUE)
  )

treatment_means

############################################################
# EDA STEP 4 — Treatment-wise SD and SE
############################################################

treatment_stats <- master_data %>%
  group_by(treatment) %>%
  summarise(
    
    # ---- Means ----
    mean_spread = mean(plant_spread_cm, na.rm = TRUE),
    mean_leaves = mean(leaves, na.rm = TRUE),
    mean_crown = mean(crown_diameter_mm, na.rm = TRUE),
    mean_flowering_days = mean(days_to_first_flowering, na.rm = TRUE),
    mean_primary = mean(primary_flowers, na.rm = TRUE),
    mean_secondary = mean(secondary_flowers, na.rm = TRUE),
    mean_tertiary = mean(tertiary_flowers, na.rm = TRUE),
    mean_total = mean(total_flowers, na.rm = TRUE),
    mean_harvest_days = mean(days_to_first_harvest, na.rm = TRUE),
    mean_length = mean(fruit_length_mm, na.rm = TRUE),
    mean_breadth = mean(fruit_breadth_mm, na.rm = TRUE),
    
    # ---- Standard Deviations ----
    sd_spread = sd(plant_spread_cm, na.rm = TRUE),
    sd_leaves = sd(leaves, na.rm = TRUE),
    sd_crown = sd(crown_diameter_mm, na.rm = TRUE),
    sd_flowering_days = sd(days_to_first_flowering, na.rm = TRUE),
    sd_primary = sd(primary_flowers, na.rm = TRUE),
    sd_secondary = sd(secondary_flowers, na.rm = TRUE),
    sd_tertiary = sd(tertiary_flowers, na.rm = TRUE),
    sd_total = sd(total_flowers, na.rm = TRUE),
    sd_harvest_days = sd(days_to_first_harvest, na.rm = TRUE),
    sd_length = sd(fruit_length_mm, na.rm = TRUE),
    sd_breadth = sd(fruit_breadth_mm, na.rm = TRUE),
    
    # ---- Sample size per treatment ----
    n = sum(!is.na(plant_spread_cm)),
    
    # ---- Standard Errors (SE = SD / sqrt(n)) ----
    se_spread = sd_spread / sqrt(n),
    se_leaves = sd_leaves / sqrt(n),
    se_crown = sd_crown / sqrt(n),
    se_flowering_days = sd_flowering_days / sqrt(n),
    se_primary = sd_primary / sqrt(n),
    se_secondary = sd_secondary / sqrt(n),
    se_tertiary = sd_tertiary / sqrt(n),
    se_total = sd_total / sqrt(n),
    se_harvest_days = sd_harvest_days / sqrt(n),
    se_length = sd_length / sqrt(n),
    se_breadth = sd_breadth / sqrt(n)
  )

# View results
treatment_stats

# Load these packages, if not loaded
library(ggplot2)
library(readr)
library(dplyr)

############################################################
# EDA STEP 5.1 — Plant spread by treatment
############################################################

# -----------------------------
# Boxplot: Plant spread
# -----------------------------

plot_spread_box <- ggplot(master_data, aes(x = treatment, y = plant_spread_cm)) +
  geom_boxplot(fill = "skyblue") +
  labs(
    title = "Plant spread across treatments",
    x = "Treatment",
    y = "Plant spread (cm)"
  ) +
  theme_minimal()

plot_spread_box

ggsave(
  filename = "results/figures/plant_spread_boxplot.png",
  plot = plot_spread_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Plant spread
# -----------------------------

plot_spread_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_spread)) +
  geom_col(fill = "steelblue") +
  geom_errorbar(
    aes(
      ymin = mean_spread - se_spread,
      ymax = mean_spread + se_spread
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean plant spread ± SE",
    x = "Treatment",
    y = "Plant spread (cm)"
  ) +
  theme_minimal()

plot_spread_mean

ggsave(
  filename = "results/figures/plant_spread_mean_SE.png",
  plot = plot_spread_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.2 — Total flowers (yield trait)
############################################################

# -----------------------------
# Boxplot: Total flowers
# -----------------------------

plot_total_box <- ggplot(master_data, aes(x = treatment, y = total_flowers)) +
  geom_boxplot(fill = "lightgreen") +
  labs(
    title = "Total flowers across treatments",
    x = "Treatment",
    y = "Total flowers per plant"
  ) +
  theme_minimal()

plot_total_box

ggsave(
  filename = "results/figures/total_flowers_boxplot.png",
  plot = plot_total_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Total flowers
# -----------------------------

plot_total_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_total)) +
  geom_col(fill = "darkgreen") +
  geom_errorbar(
    aes(
      ymin = mean_total - se_total,
      ymax = mean_total + se_total
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean total flowers ± SE",
    x = "Treatment",
    y = "Total flowers per plant"
  ) +
  theme_minimal()

plot_total_mean

ggsave(
  filename = "results/figures/total_flowers_mean_SE.png",
  plot = plot_total_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.3 — Fruit length (quality trait)
############################################################

# -----------------------------
# Boxplot: Fruit length
# -----------------------------

plot_length_box <- ggplot(master_data, aes(x = treatment, y = fruit_length_mm)) +
  geom_boxplot(fill = "orange") +
  labs(
    title = "Fruit length across treatments",
    x = "Treatment",
    y = "Fruit length (mm)"
  ) +
  theme_minimal()

plot_length_box

ggsave(
  filename = "results/figures/fruit_length_boxplot.png",
  plot = plot_length_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Fruit length
# -----------------------------

plot_length_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_length)) +
  geom_col(fill = "darkorange") +
  geom_errorbar(
    aes(
      ymin = mean_length - se_length,
      ymax = mean_length + se_length
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean fruit length ± SE",
    x = "Treatment",
    y = "Fruit length (mm)"
  ) +
  theme_minimal()

plot_length_mean

ggsave(
  filename = "results/figures/fruit_length_mean_SE.png",
  plot = plot_length_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.4 — Fruit breadth (quality trait)
############################################################

# -----------------------------
# Boxplot: Fruit breadth
# -----------------------------

plot_breadth_box <- ggplot(master_data, aes(x = treatment, y = fruit_breadth_mm)) +
  geom_boxplot(fill = "purple") +
  labs(
    title = "Fruit breadth across treatments",
    x = "Treatment",
    y = "Fruit breadth (mm)"
  ) +
  theme_minimal()

plot_breadth_box

ggsave(
  filename = "results/figures/fruit_breadth_boxplot.png",
  plot = plot_breadth_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Fruit breadth
# -----------------------------

plot_breadth_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_breadth)) +
  geom_col(fill = "mediumpurple") +
  geom_errorbar(
    aes(
      ymin = mean_breadth - se_breadth,
      ymax = mean_breadth + se_breadth
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean fruit breadth ± SE",
    x = "Treatment",
    y = "Fruit breadth (mm)"
  ) +
  theme_minimal()

plot_breadth_mean

ggsave(
  filename = "results/figures/fruit_breadth_mean_SE.png",
  plot = plot_breadth_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.5 — Number of leaves
############################################################

# -----------------------------
# Boxplot: Number of leaves
# -----------------------------

plot_leaves_box <- ggplot(master_data, aes(x = treatment, y = leaves)) +
  geom_boxplot(fill = "lightblue") +
  labs(
    title = "Number of leaves across treatments",
    x = "Treatment",
    y = "Number of leaves per plant"
  ) +
  theme_minimal()

plot_leaves_box

ggsave(
  filename = "results/figures/leaves_boxplot.png",
  plot = plot_leaves_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Number of leaves
# -----------------------------

plot_leaves_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_leaves)) +
  geom_col(fill = "dodgerblue") +
  geom_errorbar(
    aes(
      ymin = mean_leaves - se_leaves,
      ymax = mean_leaves + se_leaves
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean number of leaves ± SE",
    x = "Treatment",
    y = "Number of leaves per plant"
  ) +
  theme_minimal()

plot_leaves_mean

ggsave(
  filename = "results/figures/leaves_mean_SE.png",
  plot = plot_leaves_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.6 — Crown diameter
############################################################

# -----------------------------
# Boxplot: Crown diameter
# -----------------------------

plot_crown_box <- ggplot(master_data, aes(x = treatment, y = crown_diameter_mm)) +
  geom_boxplot(fill = "khaki") +
  labs(
    title = "Crown diameter across treatments",
    x = "Treatment",
    y = "Crown diameter (mm)"
  ) +
  theme_minimal()

plot_crown_box

ggsave(
  filename = "results/figures/crown_diameter_boxplot.png",
  plot = plot_crown_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Crown diameter
# -----------------------------

plot_crown_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_crown)) +
  geom_col(fill = "goldenrod") +
  geom_errorbar(
    aes(
      ymin = mean_crown - se_crown,
      ymax = mean_crown + se_crown
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean crown diameter ± SE",
    x = "Treatment",
    y = "Crown diameter (mm)"
  ) +
  theme_minimal()

plot_crown_mean

ggsave(
  filename = "results/figures/crown_diameter_mean_SE.png",
  plot = plot_crown_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.7 — Days to first flowering
############################################################

# -----------------------------
# Boxplot: Days to first flowering
# -----------------------------

plot_flowering_box <- ggplot(master_data, aes(x = treatment, y = days_to_first_flowering)) +
  geom_boxplot(fill = "pink") +
  labs(
    title = "Days to first flowering across treatments",
    x = "Treatment",
    y = "Days to first flowering"
  ) +
  theme_minimal()

plot_flowering_box

ggsave(
  filename = "results/figures/flowering_days_boxplot.png",
  plot = plot_flowering_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Days to first flowering
# -----------------------------

plot_flowering_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_flowering_days)) +
  geom_col(fill = "deeppink") +
  geom_errorbar(
    aes(
      ymin = mean_flowering_days - se_flowering_days,
      ymax = mean_flowering_days + se_flowering_days
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean days to first flowering ± SE",
    x = "Treatment",
    y = "Days to first flowering"
  ) +
  theme_minimal()

plot_flowering_mean

ggsave(
  filename = "results/figures/flowering_days_mean_SE.png",
  plot = plot_flowering_mean,
  width = 8,
  height = 5,
  dpi = 300
)

############################################################
# EDA STEP 5.8 — Days to first harvest
############################################################

# -----------------------------
# Boxplot: Days to first harvest
# -----------------------------

plot_harvest_box <- ggplot(master_data, aes(x = treatment, y = days_to_first_harvest)) +
  geom_boxplot(fill = "lightgray") +
  labs(
    title = "Days to first harvest across treatments",
    x = "Treatment",
    y = "Days to first harvest"
  ) +
  theme_minimal()

plot_harvest_box

ggsave(
  filename = "results/figures/harvest_days_boxplot.png",
  plot = plot_harvest_box,
  width = 8,
  height = 5,
  dpi = 300
)

# -----------------------------
# Mean ± SE plot: Days to first harvest
# -----------------------------

plot_harvest_mean <- ggplot(treatment_stats, aes(x = treatment, y = mean_harvest_days)) +
  geom_col(fill = "gray40") +
  geom_errorbar(
    aes(
      ymin = mean_harvest_days - se_harvest_days,
      ymax = mean_harvest_days + se_harvest_days
    ),
    width = 0.2
  ) +
  labs(
    title = "Mean days to first harvest ± SE",
    x = "Treatment",
    y = "Days to first harvest"
  ) +
  theme_minimal()

plot_harvest_mean

ggsave(
  filename = "results/figures/harvest_days_mean_SE.png",
  plot = plot_harvest_mean,
  width = 8,
  height = 5,
  dpi = 300
)