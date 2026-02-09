--------------------------------
# Strawberry Data Analysis in R
# 01_import_clean.R
--------------------------------
  
############################################################
# Step 1: Importing & Cleaning Plant Spread Data
############################################################

# ------------------------------------------------
# Install required packages once if not installed
# ------------------------------------------------

install.packages(c("readxl", "dplyr", "tidyr", "stringr"))

# -----------------------------
# Load libraries
# -----------------------------

library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

# Check session info (for reproducibility)
sessionInfo()

# -----------------------------
# Define Excel file path
# -----------------------------

file_path <- "data/Data for R.xlsx"

# View all worksheet names
sheet_names <- excel_sheets(file_path)
sheet_names


############################################################
# STEP 1.1 — Import raw Plant Spread sheet
############################################################

plant_spread_raw <- read_excel(
  file_path,
  sheet = "Plant spread (cm)",
  col_names = FALSE
)

# View raw messy data
plant_spread_raw


############################################################
# STEP 1.2 — Convert everything to numeric where possible
############################################################

plant_spread_clean <- plant_spread_raw %>%
  mutate(across(everything(), as.numeric))

# View cleaned numeric matrix
plant_spread_clean


############################################################
# STEP 1.3 — Convert wide data to long (tidy) format
############################################################

plant_spread_long <- plant_spread_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
plant_spread_long


############################################################
# STEP 1.4 — Extract numeric column index
############################################################

plant_spread_long <- plant_spread_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
plant_spread_long


############################################################
# STEP 1.5 — Assign treatment labels
############################################################

plant_spread_long <- plant_spread_long %>%
  mutate(
    treatment_block = floor((row_id - 4) / 9) + 1,
    treatment = paste0("T", treatment_block)
  )

# Quick check of treatment mapping
plant_spread_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


############################################################
# STEP 1.6 — Decode NS, EW, and Excel average columns
############################################################

plant_spread_long <- plant_spread_long %>%
  mutate(
    direction = case_when(
      col_num %% 3 == 1 ~ "NS",
      col_num %% 3 == 2 ~ "EW",
      col_num %% 3 == 0 ~ "Av"
    )
  )

# Check direction pattern
plant_spread_long %>% 
  select(col_num, direction) %>% 
  head(15)


############################################################
# STEP 1.7 — Remove Excel average columns (Av)
############################################################

plant_spread_noav <- plant_spread_long %>%
  filter(direction != "Av")

# View NS & EW only
plant_spread_noav %>% 
  select(col_num, direction, value) %>% 
  head(20)


############################################################
# STEP 1.8 — Remove Excel average rows (keep only 5 plants)
############################################################

plant_spread_noav <- plant_spread_noav %>%
  group_by(treatment) %>%
  filter(row_id %in% sort(unique(row_id))[1:5]) %>%
  ungroup()

# Confirm 5 plant rows per treatment
plant_spread_noav %>% 
  distinct(row_id, treatment) %>% 
  print(n = 60)


############################################################
# STEP 1.9 — Decode replication (R1–R4)
############################################################

plant_spread_noav <- plant_spread_noav %>%
  mutate(
    replication = paste0("R", ceiling(col_num / 3))
  )

# Check replication mapping
plant_spread_noav %>% 
  select(col_num, replication, direction, value) %>% 
  head(20)


############################################################
# STEP 1.10 — Calculate average plant spread (NS & EW mean)
############################################################

plant_spread_avg <- plant_spread_noav %>%
  group_by(treatment, replication, row_id) %>%
  summarise(
    plant_spread_cm = mean(value),
    .groups = "drop"
  )

# Final cleaned analytical dataset
plant_spread_avg %>% print(n = 60)


############################################################
# END OF STEP 1 — Plant Spread Data Cleaned Successfully
############################################################


############################################################
# STEP 2 — Import & Clean "No. of leaves" Data
############################################################


# ----------------------------------------------------------
# STEP 2.1 — Import raw "No. of leaves" worksheet
# ----------------------------------------------------------

leaves_raw <- read_excel(
  file_path,
  sheet = "No. of leaves",
  col_names = FALSE
)

# View raw messy data
leaves_raw


# ----------------------------------------------------------
# STEP 2.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

leaves_clean <- leaves_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
leaves_clean


# ----------------------------------------------------------
# STEP 2.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

leaves_long <- leaves_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
leaves_long


# ----------------------------------------------------------
# STEP 2.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

leaves_long <- leaves_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
leaves_long


# ----------------------------------------------------------
# STEP 2.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

leaves_long <- leaves_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
leaves_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 2.6 — Remove Excel average rows (keep only 5 plants)
# ----------------------------------------------------------

leaves_noavg <- leaves_long %>%
  group_by(treatment) %>%
  filter(row_id %in% sort(unique(row_id))[1:5]) %>%
  ungroup()

# Confirm 5 plant rows per treatment
leaves_noavg %>% 
  distinct(row_id, treatment) %>% 
  print(n = 60)


# ----------------------------------------------------------
# STEP 2.7 — Decode replication labels (R1–R4)
# ----------------------------------------------------------

leaves_noavg <- leaves_noavg %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
leaves_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 2.8 — Final tidy dataset for number of leaves
# ----------------------------------------------------------

leaves_avg <- leaves_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    leaves = value
  )

# Final cleaned analytical dataset
leaves_avg %>% print(n = 60)


############################################################
# END OF STEP 2 — "No. of leaves" Data Cleaned Successfully
############################################################


############################################################
# STEP 3 — Import & Clean "Crown diameter (mm)" Data
############################################################


# ----------------------------------------------------------
# STEP 3.1 — Import raw Crown Diameter worksheet
# ----------------------------------------------------------

crown_raw <- read_excel(
  file_path,
  sheet = "Crown diameter (mm)",
  col_names = FALSE
)

# View raw messy data
crown_raw


# ----------------------------------------------------------
# STEP 3.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

crown_clean <- crown_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
crown_clean


# ----------------------------------------------------------
# STEP 3.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

crown_long <- crown_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
crown_long


# ----------------------------------------------------------
# STEP 3.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

crown_long <- crown_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
crown_long


# ----------------------------------------------------------
# STEP 3.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

crown_long <- crown_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
crown_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 3.6 — Remove Excel average rows (keep only 5 plants)
# ----------------------------------------------------------

crown_noavg <- crown_long %>%
  group_by(treatment) %>%
  filter(row_id %in% sort(unique(row_id))[1:5]) %>%
  ungroup()

# Confirm 5 plant rows per treatment
crown_noavg %>% 
  distinct(row_id, treatment) %>% 
  print(n = 60)


# ----------------------------------------------------------
# STEP 3.7 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

crown_noavg <- crown_noavg %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
crown_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 3.8 — Final tidy dataset for crown diameter
# ----------------------------------------------------------

crown_avg <- crown_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    crown_diameter_mm = value
  )

# Final cleaned analytical dataset
crown_avg %>% print(n = 60)


############################################################
# END OF STEP 3 — Crown Diameter Data Cleaned Successfully
############################################################


############################################################
# STEP 4 — Import & Clean "Days to first flowering" Data
############################################################


# ----------------------------------------------------------
# STEP 4.1 — Import raw Days to First Flowering worksheet
# ----------------------------------------------------------

flowering_raw <- read_excel(
  file_path,
  sheet = "Days to first flowering",
  col_names = FALSE
)

# View raw messy data
flowering_raw


# ----------------------------------------------------------
# STEP 4.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

flowering_clean <- flowering_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
flowering_clean


# ----------------------------------------------------------
# STEP 4.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

flowering_long <- flowering_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
flowering_long


# ----------------------------------------------------------
# STEP 4.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

flowering_long <- flowering_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
flowering_long


# ----------------------------------------------------------
# STEP 4.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

flowering_long <- flowering_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
flowering_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 4.6 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

flowering_noavg <- flowering_long %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
flowering_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 4.7 — Final tidy dataset for days to first flowering
# ----------------------------------------------------------

flowering_avg <- flowering_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    days_to_first_flowering = value
  )

# Final cleaned analytical dataset
flowering_avg %>% print(n = 60)


############################################################
# END OF STEP 4 — Days to First Flowering Data Cleaned Successfully
############################################################


############################################################
# STEP 5 — Import & Clean "no. of primary flowers" Data
############################################################


# ----------------------------------------------------------
# STEP 5.1 — Import raw Primary Flowers worksheet
# ----------------------------------------------------------

primary_raw <- read_excel(
  file_path,
  sheet = "no. of primary flowers",
  col_names = FALSE
)

# View raw messy data
primary_raw


# ----------------------------------------------------------
# STEP 5.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

primary_clean <- primary_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
primary_clean


# ----------------------------------------------------------
# STEP 5.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

primary_long <- primary_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
primary_long


# ----------------------------------------------------------
# STEP 5.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

primary_long <- primary_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
primary_long


# ----------------------------------------------------------
# STEP 5.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

primary_long <- primary_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
primary_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 5.6 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

primary_noavg <- primary_long %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
primary_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 5.7 — Final tidy dataset for primary flower count
# ----------------------------------------------------------

primary_avg <- primary_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    primary_flowers = value
  )

# Final cleaned analytical dataset
primary_avg %>% print(n = 60)


############################################################
# END OF STEP 5 — Primary Flowers Data Cleaned Successfully
############################################################


############################################################
# STEP 6 — Import & Clean "no. of secondary flowers" Data
############################################################


# ----------------------------------------------------------
# STEP 6.1 — Import raw Secondary Flowers worksheet
# ----------------------------------------------------------

secondary_raw <- read_excel(
  file_path,
  sheet = "no. of secondary flowers",
  col_names = FALSE
)

# View raw messy data
secondary_raw


# ----------------------------------------------------------
# STEP 6.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

secondary_clean <- secondary_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
secondary_clean


# ----------------------------------------------------------
# STEP 6.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

secondary_long <- secondary_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
secondary_long


# ----------------------------------------------------------
# STEP 6.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

secondary_long <- secondary_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
secondary_long


# ----------------------------------------------------------
# STEP 6.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

secondary_long <- secondary_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
secondary_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 6.6 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

secondary_noavg <- secondary_long %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
secondary_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 6.7 — Final tidy dataset for secondary flower count
# ----------------------------------------------------------

secondary_avg <- secondary_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    secondary_flowers = value
  )

# Final cleaned analytical dataset
secondary_avg %>% print(n = 60)


############################################################
# END OF STEP 6 — Secondary Flowers Data Cleaned Successfully
############################################################


############################################################
# STEP 7 — Import & Clean "no. of tertiary flowers" Data
############################################################


# ----------------------------------------------------------
# STEP 7.1 — Import raw Tertiary Flowers worksheet
# ----------------------------------------------------------

tertiary_raw <- read_excel(
  file_path,
  sheet = "no. of tertiary flowers",
  col_names = FALSE
)

# View raw messy data
tertiary_raw


# ----------------------------------------------------------
# STEP 7.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

tertiary_clean <- tertiary_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
tertiary_clean


# ----------------------------------------------------------
# STEP 7.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

tertiary_long <- tertiary_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
tertiary_long


# ----------------------------------------------------------
# STEP 7.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

tertiary_long <- tertiary_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
tertiary_long


# ----------------------------------------------------------
# STEP 7.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

tertiary_long <- tertiary_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
tertiary_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 7.6 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

tertiary_noavg <- tertiary_long %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
tertiary_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 7.7 — Final tidy dataset for tertiary flower count
# ----------------------------------------------------------

tertiary_avg <- tertiary_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    tertiary_flowers = value
  )

# Final cleaned analytical dataset
tertiary_avg %>% print(n = 60)


############################################################
# END OF STEP 7 — Tertiary Flowers Data Cleaned Successfully
############################################################


############################################################
# STEP 8 — Import & Clean "Total no. of flowers" Data
############################################################


# ----------------------------------------------------------
# STEP 8.1 — Import raw Total Flowers worksheet
# ----------------------------------------------------------

total_raw <- read_excel(
  file_path,
  sheet = "Total no. of flowers",
  col_names = FALSE
)

# View raw messy data
total_raw


# ----------------------------------------------------------
# STEP 8.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

total_clean <- total_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
total_clean


# ----------------------------------------------------------
# STEP 8.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

total_long <- total_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
total_long


# ----------------------------------------------------------
# STEP 8.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

total_long <- total_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
total_long


# ----------------------------------------------------------
# STEP 8.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

total_long <- total_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
total_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 8.6 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

total_noavg <- total_long %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
total_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 8.7 — Final tidy dataset for total flower count
# ----------------------------------------------------------

total_avg <- total_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    total_flowers = value
  )

# Final cleaned analytical dataset
total_avg %>% print(n = 60)


############################################################
# END OF STEP 8 — Total Flowers Data Cleaned Successfully
############################################################


############################################################
# STEP 9 — Import & Clean "Days to first harvest (DAP)" Data
############################################################


# ----------------------------------------------------------
# STEP 9.1 — Import raw Days to First Harvest worksheet
# ----------------------------------------------------------

harvest_raw <- read_excel(
  file_path,
  sheet = "Days to first harvest (DAP)",
  col_names = FALSE
)

# View raw messy data
harvest_raw


# ----------------------------------------------------------
# STEP 9.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

harvest_clean <- harvest_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
harvest_clean


# ----------------------------------------------------------
# STEP 9.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

harvest_long <- harvest_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data
harvest_long


# ----------------------------------------------------------
# STEP 9.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

harvest_long <- harvest_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
harvest_long


# ----------------------------------------------------------
# STEP 9.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

harvest_long <- harvest_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
harvest_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 9.6 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

harvest_noavg <- harvest_long %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
harvest_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 9.7 — Final tidy dataset for days to first harvest
# ----------------------------------------------------------

harvest_avg <- harvest_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    days_to_first_harvest = value
  )

# Final cleaned analytical dataset
harvest_avg %>% print(n = 60)


############################################################
# END OF STEP 9 — Days to First Harvest Data Cleaned Successfully
############################################################


############################################################
# STEP 10 — Import & Clean "Fruit length (mm)" Data
############################################################


# ----------------------------------------------------------
# STEP 10.1 — Import raw Fruit Length worksheet
# ----------------------------------------------------------

length_raw <- read_excel(
  file_path,
  sheet = "Fruit length (mm)",
  col_names = FALSE
)

# View raw messy data
length_raw


# ----------------------------------------------------------
# STEP 10.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

length_clean <- length_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
length_clean


# ----------------------------------------------------------
# STEP 10.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

length_long <- length_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data (includes Excel average rows)
length_long


# ----------------------------------------------------------
# STEP 10.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

length_long <- length_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
length_long


# ----------------------------------------------------------
# STEP 10.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

length_long <- length_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
length_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 10.6 — Remove Excel average rows (keep only plant values)
# ----------------------------------------------------------

length_noavg <- length_long %>%
  group_by(treatment) %>%
  filter(row_id %in% sort(unique(row_id))[1:5]) %>%
  ungroup()

# Confirm only 5 plant rows per treatment remain
length_noavg %>% 
  distinct(row_id, treatment) %>% 
  print(n = 60)


# ----------------------------------------------------------
# STEP 10.7 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

length_noavg <- length_noavg %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
length_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 10.8 — Final tidy dataset for fruit length
# ----------------------------------------------------------

length_avg <- length_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    fruit_length_mm = value
  )

# Final cleaned analytical dataset
length_avg %>% print(n = 60)


############################################################
# END OF STEP 10 — Fruit Length Data Cleaned Successfully
############################################################


############################################################
# STEP 11 — Import & Clean "Fruit breadth (mm)" Data
############################################################


# ----------------------------------------------------------
# STEP 11.1 — Import raw Fruit Breadth worksheet
# ----------------------------------------------------------

breadth_raw <- read_excel(
  file_path,
  sheet = "fruit breadth (mm)",
  col_names = FALSE
)

# View raw messy data
breadth_raw


# ----------------------------------------------------------
# STEP 11.2 — Convert all values to numeric where possible
# ----------------------------------------------------------

breadth_clean <- breadth_raw %>%
  mutate(across(everything(), as.numeric))

# View numeric-cleaned matrix
breadth_clean


# ----------------------------------------------------------
# STEP 11.3 — Convert wide data to long (tidy) format
# ----------------------------------------------------------

breadth_long <- breadth_clean %>%
  mutate(row_id = row_number()) %>%
  pivot_longer(
    cols = -row_id,
    names_to = "col_id",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

# View long-format data (includes Excel average rows)
breadth_long


# ----------------------------------------------------------
# STEP 11.4 — Extract numeric column index (replication number)
# ----------------------------------------------------------

breadth_long <- breadth_long %>%
  mutate(
    col_num = as.numeric(str_remove(col_id, "\\.\\.\\."))
  )

# View updated data
breadth_long


# ----------------------------------------------------------
# STEP 11.5 — Assign treatment labels based on row blocks
# ----------------------------------------------------------

breadth_long <- breadth_long %>%
  mutate(
    treatment_block = floor((row_id - 3) / 8) + 1,
    treatment = paste0("T", treatment_block)
  )

# Check treatment mapping
breadth_long %>% 
  distinct(row_id, treatment) %>% 
  print(n = 40)


# ----------------------------------------------------------
# STEP 11.6 — Remove Excel average rows (keep only plant values)
# ----------------------------------------------------------

breadth_noavg <- breadth_long %>%
  group_by(treatment) %>%
  filter(row_id %in% sort(unique(row_id))[1:5]) %>%
  ungroup()

# Confirm only 5 plant rows per treatment remain
breadth_noavg %>% 
  distinct(row_id, treatment) %>% 
  print(n = 60)


# ----------------------------------------------------------
# STEP 11.7 — Decode replication labels (R1–R3)
# ----------------------------------------------------------

breadth_noavg <- breadth_noavg %>%
  mutate(
    replication = paste0("R", col_num)
  )

# Check replication mapping
breadth_noavg %>% 
  select(col_num, replication, value) %>% 
  head(20)


# ----------------------------------------------------------
# STEP 11.8 — Final tidy dataset for fruit breadth
# ----------------------------------------------------------

breadth_avg <- breadth_noavg %>%
  select(
    treatment,
    replication,
    row_id,
    fruit_breadth_mm = value
  )

# Final cleaned analytical dataset
breadth_avg %>% print(n = 60)


############################################################
# END OF STEP 11 — Fruit Breadth Data Cleaned Successfully
############################################################


############################################################
# STEP 12 — Build Master Dataset (All Traits Combined)
############################################################


# ----------------------------------------------------------
# STEP 12.1 — Start with plant spread dataset (base table)
# ----------------------------------------------------------

master_data <- plant_spread_avg

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.2 — Add number of leaves
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    leaves_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.3 — Add crown diameter
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    crown_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.4 — Add days to first flowering
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    flowering_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.5 — Add primary flowers
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    primary_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.6 — Add secondary flowers
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    secondary_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.7 — Add tertiary flowers
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    tertiary_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.8 — Add total flowers
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    total_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.9 — Add days to first harvest (DAP)
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    harvest_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.10 — Add fruit length
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    length_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)


# ----------------------------------------------------------
# STEP 12.11 — Add fruit breadth
# ----------------------------------------------------------

master_data <- master_data %>%
  left_join(
    breadth_avg,
    by = c("treatment", "replication", "plant_no")
  )

master_data %>% print(n = 20)

# ----------------------------------------------------------
# STEP 12.12 — Reorder columns for clean structure
# ----------------------------------------------------------

master_data <- master_data %>%
  select(
    treatment,
    replication,
    plant_no,
    everything()
  )

master_data %>% print(n = 10)

# ----------------------------------------------------------
# Save cleaned master dataset
# ----------------------------------------------------------

write.csv(
  master_data,
  "results/master_data_clean.csv",
  row.names = FALSE
)


