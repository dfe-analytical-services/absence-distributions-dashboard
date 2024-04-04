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
    # print(input$geography_choice)
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
    print(selectArea)
    return(selectArea)
  })


  reactiveTable <- reactive({
    selectArea <- selectAreaReactive()
    print(selectArea)
    print(input$selectYear)
    print(input$selectSchool_type)
    print(input$selectFSM)
    print(input$selectGender)
    print(input$selectSEN)

    req(input$selectYear, input$selectSchool_type, input$selectFSM, input$selectGender, input$selectSEN, selectArea)
    # print(input$selectYear,input$selectSchool_type,input$selectFSM,input$selectGender, input$selectSEN, input$selectArea)
    filtered_data <- df_absence %>%
      filter(
        area_name %in% selectArea,
        time_period == input$selectYear,
        school_type %in% input$selectSchool_type,
        FSM_eligible %in% input$selectFSM,
        SEN %in% input$selectSEN,
        Gender %in% input$selectGender
      ) %>%
      group_by(NCyearActual, Absence_band) %>%
      summarise(total = sum(TotalPupils, na.rm = TRUE)) %>%
      pivot_wider(names_from = NCyearActual, values_from = total) %>%
      rename_with(~ paste0("Year ", .), -1) %>%
      mutate(
        Absence_band = case_when(
          Absence_band %in% c("pct5_OARate") ~ "0-5%",
          Absence_band %in% c("pct10_OARate") ~ ">5-10%",
          Absence_band %in% c("pct15_OARate") ~ ">10-15%",
          Absence_band %in% c("pct20_OARate") ~ ">15-20%",
          Absence_band %in% c("pct25_OARate") ~ ">20-25%",
          Absence_band %in% c("pct30_OARate") ~ ">25-30%",
          Absence_band %in% c("pct35_OARate") ~ ">30-35%",
          Absence_band %in% c("pct40_OARate") ~ ">35-40%",
          Absence_band %in% c("pct45_OARate") ~ ">40-45%",
          Absence_band %in% c("pct50_OARate") ~ ">45-50%",
          Absence_band %in% c("pct50plus_OARate") ~ ">50%",
          TRUE ~ "Other" # Default case for any other values
        )
      )

    # make the bands appear in order
    filtered_data <- filtered_data %>%
      mutate(Absence_band_numeric = as.numeric(str_extract(Absence_band, "\\d+"))) %>% # Extract numeric part
      arrange(Absence_band_numeric) %>%
      select(-Absence_band_numeric)

    # turn into percentages
    filtered_data_perc <- filtered_data %>%
      mutate(across(starts_with("Year"), ~ . / sum(.), .names = "pct_{.col}")) %>%
      select(Absence_band, starts_with("pct_")) %>%
      rename_with(~ gsub("^pct_", "", .), starts_with("pct_"))
    return(list(filtered_data = filtered_data, filtered_data_perc = filtered_data_perc))
  })

  observe({
    reactiveTable()
  })

  output$tabDataNumber <- renderDataTable({
    data_to_display <- reactiveTable()[["filtered_data"]]

    datatable(data_to_display %>%
      select(Absence_band, starts_with("Year")))

    # Exclude specific columns
    excluded_columns <- c("Year 12", "Year 13", "Year 14", "Year X", "Year_N", "Year N2", "Year N1", "Year NA", "Year R")
    data_to_display <- data_to_display[, !names(data_to_display) %in% excluded_columns, drop = FALSE]

    # Order columns with mixedsort
    ordered_columns <- c("Absence Band" = "Absence_band", mixedsort(names(data_to_display)[-1]))

    # Conditionally format numeric columns
    datatable(
      data_to_display[, ordered_columns, drop = FALSE],
      options = list(
        scrollX = TRUE,
        paging = FALSE
      ),
      rownames = FALSE
    )
  })

  output$tabDataProportion <- renderDataTable({
    data_to_display <- reactiveTable()[["filtered_data_perc"]]

    datatable(data_to_display %>%
      select(Absence_band, starts_with("Year")))

    # Do not display columns for Years not in compulsory school age
    excluded_columns <- c("Year 12", "Year 13", "Year 14", "Year X", "Year_N", "Year N2", "Year NA", "Year N1", "Year R")
    data_to_display <- data_to_display[, !names(data_to_display) %in% excluded_columns, drop = FALSE]

    # Order columns with in numerical order
    ordered_columns <- c("Absence_band", mixedsort(names(data_to_display)[-1]))

    # Conditionally format numeric columns for display
    datatable(
      data_to_display[, ordered_columns, drop = FALSE],
      options = list(
        scrollX = TRUE,
        paging = FALSE
      ),
      rownames = FALSE
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
    filename = "data/absence_bands_distributions.zip",
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
