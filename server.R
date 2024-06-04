# ---------------------------------------------------------
# This is the server file.

server <- function(input, output, session) {
  # Loading screen -------------------------------------------------------------
  # Call initial loading screen

  hide(id = "loading-content", anim = TRUE, animType = "fade")
  show("app-content")

  # The template uses bookmarking to store input choices in the url. You can
  # exclude specific inputs (for example extra info created for a datatable
  # or plotly chart) using the list below, but it will need updating to match
  # any entries in your own dashboard's bookmarking url that you don't want
  # including.
  setBookmarkExclude(c(
    "cookies", "link_to_app_content_tab",
    "tabBenchmark_rows_current", "tabBenchmark_rows_all",
    "tabBenchmark_columns_selected", "tabBenchmark_cell_clicked",
    "tabBenchmark_cells_selected", "tabBenchmark_search",
    "tabBenchmark_rows_selected", "tabBenchmark_row_last_clicked",
    "tabBenchmark_state",
    "plotly_relayout-A",
    "plotly_click-A", "plotly_hover-A", "plotly_afterplot-A",
    ".clientValue-default-plotlyCrosstalkOpts"
  ))

  observe({
    # Trigger this observer every time an input changes
    reactiveValuesToList(input)
    session$doBookmark()
  })

  onBookmarked(function(url) {
    updateQueryString(url)
  })

  observe({
    if (input$navlistPanel == "dashboard") {
      change_window_title(
        session,
        paste0(
          site_title, " - "
        )
      )
    } else {
      change_window_title(
        session,
        paste0(
          site_title, " - ",
          input$navlistPanel
        )
      )
    }
  })

  observeEvent(input$cookies, {
    if (!is.null(input$cookies)) {
      if (!("dfe_analytics" %in% names(input$cookies))) {
        shinyjs::show(id = "cookieMain")
      } else {
        shinyjs::hide(id = "cookieMain")
        msg <- list(
          name = "dfe_analytics",
          value = input$cookies$dfe_analytics
        )
        session$sendCustomMessage("analytics-consent", msg)
        if ("cookies" %in% names(input)) {
          if ("dfe_analytics" %in% names(input$cookies)) {
            if (input$cookies$dfe_analytics == "denied") {
              ga_msg <- list(name = paste0("_ga_", google_analytics_key))
              session$sendCustomMessage("cookie-remove", ga_msg)
            }
          }
        }
      }
    } else {
      shinyjs::hide(id = "cookieMain")
    }
  })

  # Need these set of observeEvent to create a path through the cookie banner
  observeEvent(input$cookieAccept, {
    msg <- list(
      name = "dfe_analytics",
      value = "granted"
    )
    session$sendCustomMessage("cookie-set", msg)
    session$sendCustomMessage("analytics-consent", msg)
    shinyjs::show(id = "cookieAcceptDiv")
    shinyjs::hide(id = "cookieMain")
  })

  observeEvent(input$cookieReject, {
    msg <- list(
      name = "dfe_analytics",
      value = "denied"
    )
    session$sendCustomMessage("cookie-set", msg)
    session$sendCustomMessage("analytics-consent", msg)
    shinyjs::show(id = "cookieRejectDiv")
    shinyjs::hide(id = "cookieMain")
  })

  observeEvent(input$hideAccept, {
    shinyjs::toggle(id = "cookieDiv")
  })

  observeEvent(input$hideReject, {
    shinyjs::toggle(id = "cookieDiv")
  })

  observeEvent(input$remove, {
    shinyjs::toggle(id = "cookieMain")
    msg <- list(name = "dfe_analytics", value = "denied")
    session$sendCustomMessage("cookie-remove", msg)
    session$sendCustomMessage("analytics-consent", msg)
    print(input$cookies)
  })

  cookies_data <- reactive({
    input$cookies
  })

  output$cookie_status <- renderText({
    cookie_text_stem <- "To better understand the reach of our dashboard tools,
    this site uses cookies to identify numbers of unique users as part of Google
    Analytics. You have chosen to"
    cookie_text_tail <- "the use of cookies on this website."
    if ("cookies" %in% names(input)) {
      if ("dfe_analytics" %in% names(input$cookies)) {
        if (input$cookies$dfe_analytics == "granted") {
          paste(cookie_text_stem, "accept", cookie_text_tail)
        } else {
          paste(cookie_text_stem, "reject", cookie_text_tail)
        }
      }
    } else {
      "Cookies consent has not been confirmed."
    }
  })

  observeEvent(input$cookieLink, {
    # Need to link here to where further info is located.  You can
    # updateTabsetPanel to have a cookie page for instance
    updateTabsetPanel(session, "navlistPanel",
      selected = "Support and feedback"
    )
  })

  t <- list(
    family = "arial",
    size = 10,
    color = "grey"
  )
  #  output$cookie_status <- renderText(as.character(input$cookies))

  # Simple server stuff goes here ----------------------------------------------


  regionReactive <- reactive({
    list(input$geography_choice, input$selectArea)
  })

  laReactive <- reactive({
    list(input$geography_choice, input$selectArea)
  })

  selectAreaReactive <- reactive({
    selectArea <- switch(input$geography_choice,
      "National" = "England",
      "Regional" = {
        if (length(input$selectRegion) == 0) {
          # Handle the case when no Local Authorities are selected
          "England"
        } else {
          input$selectRegion
        }
      },
      "Local authority" = {
        if (length(input$selectLA) == 0) {
          # Handle the case when no Local Authorities are selected
          "England"
        } else {
          input$selectLA
        }
      }
    )
    return(selectArea)
  })


  reactiveTable <- reactive({
    df_absence <- df_absence %>%
      mutate(
        # time_period = paste0(substr(time_period, 1, 4), "/", substr(time_period, 5, 6)),
        area_name = case_when(
          geographic_level == "National" ~ country_name,
          geographic_level == "Local authority" ~ la_name,
          TRUE ~ region_name # Default case if none of the above conditions are met
        )
      )
    selectArea <- selectAreaReactive()

    req(input$selectYear, input$selectSchool_type, input$selectFSM, input$selectGender, input$selectSEN, selectArea)

    filtered_data <- df_absence %>%
      filter(
        time_period == input$selectYear,
        area_name %in% selectArea,
        school_type %in% input$selectSchool_type,
        fsm_eligible %in% input$selectFSM,
        sen_status %in% input$selectSEN,
        gender %in% input$selectGender
      ) %>%
      group_by(NCyearActual) %>%
      summarise(across(starts_with("pct"), sum, na.rm = TRUE)) %>% # add the numbers for all the filters together
      pivot_longer(cols = starts_with("pct"), names_to = "percent_band") %>%
      pivot_wider(names_from = NCyearActual, values_from = value) %>%
      rename_with(~ paste0("Year ", .), where(is.numeric)) %>%
      mutate(
        percent_band = case_when(
          percent_band %in% c("pct5_OARate") ~ "0-5%",
          percent_band %in% c("pct10_OARate") ~ ">5-10%",
          percent_band %in% c("pct15_OARate") ~ ">10-15%",
          percent_band %in% c("pct20_OARate") ~ ">15-20%",
          percent_band %in% c("pct25_OARate") ~ ">20-25%",
          percent_band %in% c("pct30_OARate") ~ ">25-30%",
          percent_band %in% c("pct35_OARate") ~ ">30-35%",
          percent_band %in% c("pct40_OARate") ~ ">35-40%",
          percent_band %in% c("pct45_OARate") ~ ">40-45%",
          percent_band %in% c("pct50_OARate") ~ ">45-50%",
          percent_band %in% c("pct50plus_OARate") ~ ">50%",
          TRUE ~ "Other" # Default case for any other values
        )
      )

    # add in a total column
    filtered_data <- filtered_data %>%
      mutate(Total = rowSums(across(starts_with("Year"))))


    # turn into percentages
    filtered_data_perc <- df_absence %>%
      filter(
        area_name %in% selectArea,
        time_period == input$selectYear,
        school_type %in% input$selectSchool_type,
        fsm_eligible %in% input$selectFSM,
        sen_status %in% input$selectSEN,
        gender %in% input$selectGender
      ) %>%
      group_by(NCyearActual) %>%
      summarise(across(starts_with("pct"), sum, na.rm = TRUE))

    # find the total number in each band and add it as a row at the bottom called Year 99
    totals <- filtered_data_perc %>%
      summarise(across(starts_with("pct"), sum, na.rm = TRUE)) %>%
      mutate(NCyearActual = 99) # call the total 99 for now and rename later as it is expecting a number

    # Bind the total row to the original data
    filtered_data_perc <- bind_rows(filtered_data_perc, totals) %>%
      mutate(total = rowSums(across(starts_with("pct")))) %>% # add the numbers for all the filters together
      mutate(across(starts_with("pct"), ~ . / total, .names = "percent_{.col}")) %>%
      select(-total) %>%
      select(-starts_with("pct")) %>%
      rename_with(~ gsub("^percent_", "", .), starts_with("percent_")) %>%
      pivot_longer(cols = starts_with("pct"), names_to = "percent_band") %>%
      pivot_wider(names_from = NCyearActual, values_from = value) %>%
      rename_with(~ paste0("Year ", .), where(is.numeric)) %>%
      mutate(
        percent_band = case_when(
          percent_band %in% c("pct5_OARate") ~ "0-5%",
          percent_band %in% c("pct10_OARate") ~ ">5-10%",
          percent_band %in% c("pct15_OARate") ~ ">10-15%",
          percent_band %in% c("pct20_OARate") ~ ">15-20%",
          percent_band %in% c("pct25_OARate") ~ ">20-25%",
          percent_band %in% c("pct30_OARate") ~ ">25-30%",
          percent_band %in% c("pct35_OARate") ~ ">30-35%",
          percent_band %in% c("pct40_OARate") ~ ">35-40%",
          percent_band %in% c("pct45_OARate") ~ ">40-45%",
          percent_band %in% c("pct50_OARate") ~ ">45-50%",
          percent_band %in% c("pct50plus_OARate") ~ ">50%",
          TRUE ~ "Other" # Default case for any other values
        )
      )
    list(filtered_data = filtered_data, filtered_data_perc = filtered_data_perc)
  })

  observe({
    reactiveTable()
  })

  output$tabDataNumber <- renderDataTable({
    data_to_display <- (reactiveTable()$filtered_data)
    datatable(data_to_display)

    col_names <- names(data_to_display)
    col_names[col_names == "percent_band"] <- "Overall Absence Band"

    # Conditionally format numeric columns
    datatable(
      data_to_display,
      options = list(
        scrollX = TRUE,
        paging = FALSE,
        initComplete = JS(
          "function(settings, json) {",
          "$('td:nth-child(1)').css('font-weight', 'bold');", # Bold the first column
          "$('td:nth-child(13)').css('font-weight', 'bold');", # Bold the 13th column
          "}"
        )
      ),
      rownames = FALSE,
      colnames = col_names
    ) %>% formatCurrency(
      columns = c(2:ncol(data_to_display)), # Apply to columns 2 to the end
      currency = "", # No currency symbol
      interval = 3, # Interval for comma separation
      digits = 0,
      mark = "," # Comma as the separator
    )
  })

  output$tabDataProportion <- renderDataTable({
    data_to_display <- (reactiveTable()$filtered_data_perc)
    datatable(data_to_display)

    # rename columns
    col_names <- names(data_to_display)
    col_names[col_names == "percent_band"] <- "Overall Absence Band"
    col_names[col_names == "Year 99"] <- "All Years"

    # Conditionally format numeric columns for display
    datatable(
      data_to_display,
      options = list(
        scrollX = TRUE,
        paging = FALSE,
        initComplete = JS(
          "function(settings, json) {",
          "$('td:nth-child(1)').css('font-weight', 'bold');", # Bold the first column
          "$('td:nth-child(13)').css('font-weight', 'bold');", # Bold the 13th column
          "}"
        )
      ),
      rownames = FALSE,
      colnames = col_names
    ) %>% formatPercentage(columns = 2:ncol(data_to_display), digits = 2)
  })


  observeEvent(input$go, {
    toggle(id = "div_a", anim = T)
  })


  observeEvent(input$link_to_app_content_tab, {
    updateTabsetPanel(session, "navlistPanel", selected = "dashboard")
  })

  # Download the underlying data button
  output$download_data <- downloadHandler(
    filename = "data/absence_bands_distributions.csv",
    content = function(file) {
      write.csv(df_absence, file)
    }
  )

  # Add input IDs here that are within the relevant drop down boxes to create
  # dynamic text
  output$dropdown_label <- renderText({
    selectArea <- selectAreaReactive()
    paste0(
      "Current selections: ", input$selectYear, ", ", input$selectArea, ", ", input$selectGender, ", ",
      input$selectSEN, ", ", input$selectFSM, ", ", input$selectschool_type
    )
  })

  # Dropdown expandable label ------------------------------------------------------------
  observeEvent(input$go, {
    toggle(id = "div_a", anim = T)
  })



  # Stop app -------------------------------------------------------------------

  session$onSessionEnded(function() {
    stopApp()
  })
}
