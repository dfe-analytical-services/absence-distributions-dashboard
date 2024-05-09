#script to generate dummy data
source("R/read_data.R")

# Read in the data

# 1 The distribution band data
df_absence <- read_absence_data(file = "data/absence_bands_distributions.csv")


absence_col_names <- c("time_identifier", "time_period", "geographic_level", "country_code", "country_name",  "region_name", "region_code","old_la_code", "new_la_code","la_name", "school_type", "fsm_eligible", "sen_status", "gender", "NCyearActual", "pct5_OARate", "pct10_OARate","pct15_OARate","pct20_OARate","pct25_OARate","pct30_OARate","pct35_OARate","pct40_OARate","pct45_OARate","pct50_OARate","pct50plus_OARate")
colnames(df_absence) <- absence_col_names

df_absence[, grepl("^pct", colnames(df_absence))] <- lapply(df_absence[, grepl("^pct", colnames(df_absence))], function(x) sample(0:2000, length(x), replace = TRUE))

write.csv(df_absence, file = "data/absence_bands_distributions.csv", row.names = FALSE)