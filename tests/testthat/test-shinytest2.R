library(shinytest2)

inputs <- c(
  "absence_distributions",
  "accessibility_statement",
  "cookies_statement",
  "geography_choice",
  "left_nav",
  "pages",
  "selectFSM",
  "selectGender",
  "selectLA",
  "selectRegion",
  "selectSEN",
  "selectSchool_type",
  "selectYear",
  "support",
  "tabDataNumber_rows_all",
  "tabsetpanels",
  "technical_notes",
  "user_guide"
)

outputs <- c(
  "tabDataNumber",
  "tabDataProportion",
  "dropdown_label"
)

wait_time <- 200

test_that("Absence dashboard tests", {
  app <- AppDriver$new(
    name = "Initial Check",
    height = 933,
    width = 1379,
    load_timeout = 60 * 1000.,
    timeout = 20 * 1000.,
    wait = TRUE
  )
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(geography_choice = "Regional")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(selectYear = "2017/18")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(tabsetpanels = "Proportions of Year Group")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(selectYear = "2022/23")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(left_nav = "user_guide")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(left_nav = "technical_notes")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(left_nav = "absence_distributions")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(selectGender = "Female")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(tabsetpanels = "Proportions of Year Group")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(tabsetpanels = "Pupil Enrolments")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(selectGender = character(0))
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)

  app$set_inputs(selectGender = "Male")
  app$wait_for_idle(wait_time)
  app$expect_values(input = inputs, output = outputs)
})
