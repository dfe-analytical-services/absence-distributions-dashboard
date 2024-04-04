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

source("R/read_data.R")

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
    pupils = TotalPupils) 

filtered_data_summary<-filtered_data%>%
  summarize(
    how_many_cells_1 = sum(pupils %in% c(1), na.rm = TRUE),
    how_many_cells_1_or_2 = sum(pupils %in% c(1, 2), na.rm = TRUE),
    how_many_cells_1_to_4 = sum(pupils >= 1 & pupils <= 4, na.rm = TRUE),
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
    pupils = TotalPupils) 
  
  filtered_data_NoSEN_summary<-filtered_data_NoSEN %>% 
  summarize(
    how_many_cells_1 = sum(pupils %in% c(1), na.rm = TRUE),
    how_many_cells_1_or_2 = sum(pupils %in% c(1, 2), na.rm = TRUE),
    how_many_cells_1_to_4 = sum(pupils >= 1 & total <= 4, na.rm = TRUE),
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

#Second strategy: Only suppress when all the pupils in a column for a particular set of filters are in the same band
#becasue this means if we know there are 27 female pupils in City of London in 2020 and they are all in <5% then we
#have shown the absence of those pupils.

#Find these cases by grouping at:
#1. LA and Year - unlikely
#2. LA and Gender Male/Female(FSM both)
#3. LA and FSM Eligible /Not eligible(Gender Both)
#4. LA and Gender and FSM 



#1. LA and Year - find the max in a column and check if it is smaller than the total
# seond method look for cases where there is only one which isnt 0
#157LAs x 11NCyears x 4 years = 6908 choices if all are there
Supression_LAYear<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, NCyearActual)%>%
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 6706 rows which fits (not all need be there)
  filter(max_of_pupils==total_of_pupils)        ##gives 0 cases

#2. LA and Gender Male/Female(FSM both)
#157LAs x 11NCyears x 4 years x 2 genders = 13816 choices if all are there
Supression_LAYearGender<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, Gender, NCyearActual)%>% #
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 13408 rows which fits (not all need be there)
  filter(max_of_pupils==total_of_pupils)        #gives 3 cases

#######################################
###############FSM and GENDER ONLY CASE
#######################################

#3. LA and Gender Male/Female(FSM both)
#157LAs x 11NCyears x 4 years x 2 FSM states = 13816 choices if all are there
Supression_LAYearFSM_NoSEN<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, FSM_eligible, NCyearActual)%>% #
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 13344 rows which fits (not all need be there)
  filter(max_of_pupils==total_of_pupils)       #gives 15 cases
  
#4. LA and Gender Male/Female and FSM elgible and not eligible
#157LAs x 11NCyears x 4 years x 2 FSM states x 2 genders= 27632 choices if all are there
Supression_LAYearFSMGender_NoSEN<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, FSM_eligible, Gender, NCyearActual)%>% #
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 26658 rows which fits (not all need be there)
  filter(max_of_pupils==total_of_pupils)  #gives 43 cases

#######################################
###############SEN and GENDER ONLY CASE
#######################################


#5. LA and Gender Male/Female(FSM both)
#157LAs x 11NCyears x 4 years x 2 SEN states = 13816 choices if all are there
Supression_LAYearSEN_NoFSM<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, SEN, NCyearActual)%>% #
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 13409 rows which fits (not all need be there)
  filter(max_of_pupils==total_of_pupils)       #gives 13 cases

#6. LA and Gender Male/Female and SEN and not SEN
#157LAs x 11NCyears x 4 years x 2 SEN states x 2 genders= 27632 choices if all are there
Supression_LAYearSENGender_NoFSM<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, SEN, Gender, NCyearActual)%>% #
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 26786 rows which fits (not all need be there)
  filter(max_of_pupils==total_of_pupils)  #gives 71 cases

#######################################
###############SEN and FSM together
#######################################

#7. LA and Gender Male/Female and SEN and not SEN
#157LAs x 11NCyears x 4 years x 2 SEN states x 2 genders x 2 FSM= 55264 choices if all are there
Supression_LAYearSENFSMGender<-filtered_data %>% 
  filter(geographic_level == "Local authority") %>%
  group_by (time_period, la_name, SEN, FSM_eligible, Gender, NCyearActual)%>% #
  summarise (
    total_of_pupils = sum(pupils),
    max_of_pupils=max(pupils)
  ) %>%                                          #gives 53235 rows which fits (why are there more...)
  filter(max_of_pupils==total_of_pupils)  #gives 171 cases