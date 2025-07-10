library(shinytest2)

test_that("{shinytest2} recording: Initial Check", {
  app <- AppDriver$new(
    name = "Initial Check",
    height = 933,
    width = 1379,
    load_timeout = 60 * 1000.,
    timeout = 20 * 1000.,
    wait = FALSE
  )
  app$expect_values()

  app$set_inputs(geography_choice = "Regional")
  app$expect_values()

  app$set_inputs(selectYear = "2017/18")
  app$expect_values()

  app$set_inputs(tabsetpanels = "Proportions of Year Group")
  app$expect_values()

  app$set_inputs(selectYear = "2022/23")
  app$expect_values()
})


test_that("{shinytest2} recording: absence-distributions-dashboard", {
  app <- AppDriver$new(
    name = "absence-distributions-dashboard",
    height = 933, width = 1379,
    load_timeout = 120 * 1000.,
    timeout = 60 * 1000.,
    wait = TRUE
  )
  app$set_inputs(left_nav = "user_guide")
  app$expect_values()

  app$set_inputs(left_nav = "technical_notes")
  app$expect_values()

  app$set_inputs(left_nav = "absence_distributions")
  app$expect_values()

  app$set_inputs(selectGender = "Female")
  app$expect_values()

  app$set_inputs(tabsetpanels = "Proportions of Year Group")
  app$expect_values()

  app$set_inputs(tabsetpanels = "Pupil Enrolments")
  app$expect_values()

  app$set_inputs(selectGender = character(0))
  app$expect_values()

  app$set_inputs(selectGender = "Male")
  app$expect_values()
})
