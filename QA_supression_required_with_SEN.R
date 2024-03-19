shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(shiny))
shhh(library(gtools))
shhh(library(shinyjs))
shhh(library(tidyr))
shhh(library(tools))
shhh(library(testthat))
shhh(library(stringr))
shhh(library(shinydashboard))
shhh(library(shinyWidgets))
shhh(library(shinyGovstyle))
shhh(library(shinytitle))
shhh(library(dplyr))
shhh(library(ggplot2))
shhh(library(DT))
shhh(library(xfun))
shhh(library(metathis))
shhh(library(shinyalert))
shhh(library(shinytest2))
shhh(library(readr))
shhh(library(rstudioapi))
shhh(library(bslib))
shhh(library(dfeshiny))
shhh(library(ggiraph))

shhh(library(data.table))

# Read in the data
# 1 The distribution band data
df_absence <- read_absence_data(file = "data/absence_bands_distribution_withSEN.csv")
df_absence2 <- read_absence_data(file = "data/absence_bands_distributions.zip")

absence_col_names <- c("time_identifier", "time_period", "geographic_level", "country_code", "country_name", "region_code", "region_name", "old_la_code", "la_name", "school_type", "FSM_eligible","SEN", "Gender", "NCyearActual", "Absence_band", "TotalPupils")
colnames(df_absence) <- absence_col_names

df_absence2 <- read_absence_data(file = "data/absence_bands_distributions.zip")

absence_col_names2 <- c("time_identifier", "time_period", "geographic_level", "country_code", "country_name", "region_code", "region_name", "old_la_code", "la_name", "school_type", "FSM_eligible", "Gender", "NCyearActual", "Absence_band", "TotalPupils")
colnames(df_absence2) <- absence_col_names2


df_absence <- df_absence %>%
  mutate(
    time_period = ifelse(nchar(time_period) == 6, paste0("20", substr(time_period, 3, 4), "/", substr(time_period, 5, 6)), time_period),
    area_name = case_when(
      geographic_level == "National" ~ country_name,
      geographic_level == "Local authority" ~ la_name,
      TRUE ~ region_name # Default case if none of the above conditions are met
    )
  ) %>%
  filter(school_type != "Other") # removed the schools listed as Other and removed early years for now

df_absence2 <- df_absence2 %>%
  mutate(
    time_period = ifelse(nchar(time_period) == 6, paste0("20", substr(time_period, 3, 4), "/", substr(time_period, 5, 6)), time_period),
    area_name = case_when(
      geographic_level == "National" ~ country_name,
      geographic_level == "Local authority" ~ la_name,
      TRUE ~ region_name # Default case if none of the above conditions are met
    )
  ) %>%
  filter(school_type != "Other") # removed the schools listed as Other and removed early years for now


filtered_data <- df_absence %>%
  mutate(
    total = TotalPupils) 

filtered_data_summary<-filtered_data%>%
  summarize(
    how_many_cells_1 = sum(total %in% c(1), na.rm = TRUE),
    how_many_cells_1_or_2 = sum(total %in% c(1, 2), na.rm = TRUE),
    how_many_cells_1_to_4 = sum(total >= 1 & total <= 4, na.rm = TRUE),
    total_fields = n()
  ) 
 
  filtered_data_summary_totals<- filtered_data_summary %>%
  summarize(
    total_with_1 = sum(how_many_cells_1),
    total_with_1_or_2 = sum(how_many_cells_1_or_2),
    total_with_1_to_4 = sum(how_many_cells_1_to_4),
    total_fields = sum(total_fields)
  ) %>% 
  mutate(
    prop_missing_1 = total_with_1/total_fields,
    prop_missing_1_2= total_with_1_or_2/total_fields,
    prop_missing_1_to_4= total_with_1_to_4/total_fields
  )

filtered_data_NoSEN <- df_absence2 %>%
  mutate(
    total = TotalPupils) 
  
  filtered_data_NoSEN_summary<-filtered_data_NoSEN %>% 
  summarize(
    how_many_cells_1 = sum(total %in% c(1), na.rm = TRUE),
    how_many_cells_1_or_2 = sum(total %in% c(1, 2), na.rm = TRUE),
    how_many_cells_1_to_4 = sum(total >= 1 & total <= 4, na.rm = TRUE),
    total_fields = n()
  ) 
  
  filtered_data_NoSEN_summary_totals <-filtered_data_NoSEN_summary %>%
  summarize(
    total_with_1 = sum(how_many_cells_1),
    total_with_1_or_2 = sum(how_many_cells_1_or_2),
    total_with_1_to_4 = sum(how_many_cells_1_to_4),
    total_fields = sum(total_fields)
  ) %>% 
  mutate(
    prop_missing_1 = total_with_1/total_fields,
    prop_missing_1_2= total_with_1_or_2/total_fields,
    prop_missing_1_to_4= total_with_1_to_4/total_fields
  )

# Add a column at the beginning
filtered_data_block1 <- bind_cols(data.frame(Metric = "SEN Included"), filtered_data_summary_totals)
filtered_data_block2 <- bind_cols(data.frame(Metric = "SEN Not Included"),  filtered_data_NoSEN_summary_totals)

# Combine the outputs
combined_data <- bind_rows(filtered_data_block1, filtered_data_block2)

