library(shinytest2)

test_that("{shinytest2} recording: Initial Check", {
  app <- AppDriver$new(
    variant = platform_variant(), name = "Initial Check", height = 933,
    width = 1379
  )
  app$set_inputs(navlistPanel = "dashboard")
  app$set_inputs(
    tabDataNumber_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataNumber_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabDataNumber_state = c(
    1715261015209, 0, 10, "", TRUE, FALSE, TRUE,
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(geography_choice = "Regional")
  app$set_inputs(
    tabDataNumber_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataNumber_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabDataNumber_state = c(
    1715261025530, 0, 10, "", TRUE, FALSE, TRUE,
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(selectYear = "2017/18")
  app$set_inputs(
    tabDataNumber_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataNumber_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabDataNumber_state = c(
    1715261030569, 0, 10, "", TRUE, FALSE, TRUE,
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabsetpanels = "Proportions of Year Group")
  app$set_inputs(tabDataProportion_rows_current = c(
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(
    tabDataProportion_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataProportion_state = c(
    1715261041426, 0, 10, "", TRUE, FALSE,
    TRUE, c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE,
      "", TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE,
      FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(selectYear = "2022/23")
  app$set_inputs(tabDataProportion_rows_current = c(
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(
    tabDataProportion_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataProportion_state = c(
    1715261046323, 0, 10, "", TRUE, FALSE,
    TRUE, c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE,
      "", TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE,
      FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$expect_screenshot()
})


test_that("{shinytest2} recording: absence-distributions-dashboard", {
  app <- AppDriver$new(
    variant = platform_variant(), name = "absence-distributions-dashboard",
    height = 933, width = 1379
  )
  app$set_inputs(
    cookies = c("granted", "GA1.1.1899314467.1715259664", "GS1.1.1715259663.1.1.1715261064.0.0.0"),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(navlistPanel = "dashboard")
  app$set_inputs(
    tabDataNumber_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataNumber_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabDataNumber_state = c(
    1715261258167, 0, 10, "", TRUE, FALSE, TRUE,
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(selectGender = "Female")
  app$set_inputs(
    tabDataNumber_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataNumber_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabDataNumber_state = c(
    1715261269268, 0, 10, "", TRUE, FALSE, TRUE,
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabsetpanels = "Proportions of Year Group")
  app$set_inputs(tabDataProportion_rows_current = c(
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11
  ), allow_no_input_binding_ = TRUE)
  app$set_inputs(
    tabDataProportion_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataProportion_state = c(
    1715261270452, 0, 10, "", TRUE, FALSE,
    TRUE, c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE,
      "", TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE,
      FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    )
  ), allow_no_input_binding_ = TRUE)
  app$expect_screenshot()
  app$set_inputs(tabsetpanels = "Pupil Enrolments")
  app$set_inputs(selectGender = character(0))
  app$set_inputs(selectGender = "Male")
  app$set_inputs(
    tabDataNumber_rows_current = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
    allow_no_input_binding_ = TRUE
  )
  app$set_inputs(tabDataNumber_rows_all = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), allow_no_input_binding_ = TRUE)
  app$set_inputs(tabDataNumber_state = c(
    1715261285998, 0, 10, "", TRUE, FALSE, TRUE,
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE),
    c(TRUE, "", TRUE, FALSE, TRUE), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "",
      TRUE, FALSE, TRUE
    ), c(TRUE, "", TRUE, FALSE, TRUE), c(
      TRUE, "", TRUE, FALSE,
      TRUE
    )
  ), allow_no_input_binding_ = TRUE)
})
