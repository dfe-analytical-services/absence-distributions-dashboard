library(dplyr)
library(readr)
source("R/read_data.R")

# Read in the absence bands data
df_absence <- read_absence_data(file = "data/la_distribution.csv")
absence_col_names <- c("time_identifier", "time_period", "geographic_level", "country_code", "country_name", "region_code", "old_la_code", "la_name", "school_type", "FSM_eligible", "SEN_provision", "Gender", "NCyearActual", "Absence_band", "TotalPupils")
colnames(df_absence) <- absence_col_names
# Read in the LA Names

la_region_names <- c("la_code", "la_name", "GOR_code", "region_name")
df_la_region_names <- read_absence_data(file = "data/laregioncodes.csv")
colnames(df_la_region_names) <- la_region_names
regions <- df_la_region_names %>%
  select(GOR_code, region_name) %>%
  distinct()
df_absence2 <- df_absence %>%
  select(-la_name) %>%
  left_join(df_la_region_names %>% select(la_code, la_name), by = c("old_la_code" = "la_code"))
df_absence3 <- df_absence2 %>% left_join(regions, by = c("region_code" = "GOR_code"))
# Add a column which is called geographical_level and make all the LA data to be Local authority
# df_absence <- df_absence %>% mutate(geographic_level = "Local authority")


# group them at national level
# national <- df_absence %>%
#   group_by(AcademicYear, Absence_band, Phase, FSMeligible, SEN, Gender,  NCyearActual) %>%
#   summarise(Count=sum(Count)) %>%
#   mutate(geographic_level = "National",
#          la_code=NA,
#          la_name=NA,
#          region_name=NA,
#          )

# national_noSEN <- df_absence %>%
#   group_by(AcademicYear, Absence_band, FSMeligible, Gender, NCyearActual) %>%
#   summarise(Count=sum(Count)) %>%
#   mutate(geographical_level = "National")

# getting rid of the SEN
# local<- df_absence %>%
#   group_by(la_name, la_code, region_name, AcademicYear, Absence_band, FSMeligible, Gender, NCyearActual) %>%
#   summarise(Count=sum(Count)) %>%
#   mutate(geographic_level = "Local authority")


# group them at regional level
# regional <- df_absence %>%
#   group_by(region_name, AcademicYear, Absence_band, Gender, NCyearActual) %>%
#   summarise(Count=sum(Count)) %>%
#   mutate(geographic_level = "Regional",
#          la_code=NA,
#          la_name=NA
#          )

# Bind the rows on the bottom and save out for the app.
# df_absence_all<-local %>%
#   rbind(regional, national)

# Check
# LA level is 10428369, regional is 520485 and national is 63378 so total should be 11,012,232

# write out the data
# Get rid of everything before 18/19
df_absence4 <- df_absence3 %>% filter(time_period %in% c("201718", "201819", "201920", "202021", "202122"))
write.csv(df_absence4, "data/absence_bands_distributions.csv")


# 2 The school level FSM and PA data
df_school <- read_absence_data(file = "data/absence_fsm_school.csv")

# bit to make the data right for now - prob wont be needed when it comes from PDR
df_school <- df_school %>%
  mutate(
    FSM_perc = FSM / Headcount_SPC,
    geographic_level = "Local authority",
    Phase = case_when(
      Phase == "State-funded primary" ~ "Primary",
      Phase == "State-funded secondary" ~ "Secondary",
      Phase == "Special" ~ "Special"
    )
  ) %>%
  rename(
    region_name = Region,
    la_name = LA,
    AcademicYear = Year
  )

write.csv(df_school, "data/absence_school_fsm.csv")
