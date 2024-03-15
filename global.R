# ---------------------------------------------------------
# This is the global file.
# Use it to store functions, library calls, source files etc.
# Moving these out of the server file and into here improves performance
# The global file is run only once when the app launches and stays consistent
# across users whereas the server and UI files are constantly interacting and
# responsive to user input.
#
# ---------------------------------------------------------
# message("Sourcing global")


# Library calls ----------------------------------------------------------------
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
# shhh(library(shinya11y))

# Functions --------------------------------------------------------------------

# Here's an example function for simplifying the code needed to commas separate
# numbers:

# This line enables bookmarking such that input choices are shown in the url.
enableBookmarking("url")

# cs_num -----------------------------------------------------------------------
# Comma separating function



cs_num <- function(value) {
  format(value, big.mark = ",", trim = TRUE)
}

# Source scripts ---------------------------------------------------------------

# Source any scripts here. Scripts may be needed to process data before it gets
# to the server file.
# It's best to do this here instead of the server file, to improve performance.

# source("R/filename.r")


# appLoadingCSS ----------------------------------------------------------------
# Set up loading screen

appLoadingCSS <- "
#loading-content {
  position: absolute;
  background: #000000;
  opacity: 0.9;
  z-index: 100;
  left: 0;
  right: 0;
  height: 100%;
  text-align: center;
  color: #FFFFFF;
}
"

site_title <- "Absence Distribution in Schools"
site_primary <- "https://department-for-education.shinyapps.io/dfe-shiny-template/"
site_overflow <- "https://department-for-education.shinyapps.io/dfe-shiny-template-overflow/"
# We can add further mirrors where necessary. Each one can generally handle
# about 2,500 users simultaneously
sites_list <- c(site_primary, site_overflow)
# Update this with your parent
# publication name (e.g. the EES publication)
ees_pub_name <- "Statistical publication"
# Update with parent publication link
ees_publication <- "https://explore-education-statistics.service.gov.uk/find-statistics/"
google_analytics_key <- "Z967JJVQQX"


source("R/read_data.R")

# Read in the data

# 1 The distribution band data
df_absence <- read_absence_data(file = "data/absence_bands_distributions.zip")
absence_col_names <- c("time_identifier", "time_period", "geographic_level", "country_code", "country_name", "region_code", "region_name", "old_la_code", "la_name", "school_type", "FSM_eligible", "Gender", "NCyearActual", "Absence_band", "TotalPupils")
colnames(df_absence) <- absence_col_names


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

# Get geographical levels from data
# Add geog lookup
geog_lookup <- df_absence %>%
  dplyr::select(geographic_level, region_name, la_name) %>%
  unique() %>%
  arrange(region_name, la_name) %>%
  mutate(la_name = case_when(
    geographic_level == "Region" ~ "All",
    geographic_level != "Region" ~ la_name
  ))

geog_levels <- geog_lookup %>%
  dplyr::select(geographic_level) %>%
  unique() %>%
  as.data.table()

regions <- geog_lookup %>%
  filter(geographic_level == "Region", !is.na(region_name), region_name != "NULL") %>%
  arrange(region_name) %>%
  pull(region_name) %>%
  unique()

las <- geog_lookup %>%
  filter(geographic_level == "Local authority", !is.na(la_name)) %>%
  arrange(region_name, la_name) %>%
  pull(la_name) %>%
  unique()

choicesYear <- sort(unique(df_absence$time_period))

choicesSchool_type <- unique(df_absence$school_type)

# choicesFSM <- c("FSM Eligible", "Not FSM Eligible")

# choicesGender <- c("Female", "Male")

expandable <- function(inputId, label, contents) {
  govDetails <- shiny::tags$details(
    class = "govuk-details", id = inputId,
    shiny::tags$summary(
      class = "govuk-details__summary",
      shiny::tags$span(
        class = "govuk-details__summary-text",
        label
      )
    ),
    shiny::tags$div(contents)
  )
}

## Custom rounding function ################################################

roundFiveUp <- function(value, dp) {
  if (!is.numeric(value) && !is.numeric(dp)) stop("both inputs must be numeric")
  if (!is.numeric(value)) stop("the value to be rounded must be numeric")
  if (!is.numeric(dp)) stop("the decimal places value must be numeric")

  z <- abs(value) * 10^dp
  z <- z + 0.5 + sqrt(.Machine$double.eps)
  z <- trunc(z)
  z <- z / 10^dp
  return(z * sign(value))
}
