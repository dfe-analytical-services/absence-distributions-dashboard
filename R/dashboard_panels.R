# message("Sourcing dashboard panels")
technical_panel <- function() {
  tabPanel(
    "Technical notes",
    gov_main_layout(
      gov_row(
        column(
          12,
          h3("Technical notes"),
          br(),
          p("The dashboard provides data on the distribution of overall absence for pupils in English schools at National, Regional and Local Authority geographic levels.
                    Data is available across state-funded primary, secondary and special schools and can also be broken
                    down by individual school type and pupil characteristics. Drop-down menus at the top of the page allow customisation of year and
                    breakdowns. "),
          br(),
          h3("Absence rates"),
          p("Absence rates are calculated by dividing the number of sessions coded as an absence by the total number of possible sessions, where possible sessions include on-site attendance, approved off-site educational activity (for example, work experience) and absence."),
          br(),
          h3("Suppression"),
          p("Data has been suppressed in the dashboard and underlying data where data for a single school is presented in a breakdown, for example, a single primary school in a specific local authority. Suppressed values have been replaced with a ‘c’.")
        )
      )
    )
  )
}

homepage_panel <- function() {
  tabPanel(
    "Homepage",
    gov_main_layout(
      gov_row(
        column(
          12,
          h1("DfE pupil absence distributions in schools in England"),
          br(),
          p("Data was last updated on 2024-03-21."),
          br()
        ),

        ## Left panel -------------------------------------------------------

        column(
          6,
          div(
            div(
              class = "panel panel-info",
              div(
                class = "panel-heading",
                style = "color: white;font-size: 18px;font-style: bold;
                background-color: #1d70b8;",
                h2("Contents")
              ),
              div(
                class = "panel-body",
                tags$div(
                  p("The dashboard provides data on the distribution of overall absence for pupils in English schools at National, Regional and Local Authority geographic levels.
                    Data is available across state-funded primary, secondary and special schools and can also be broken
                    down by individual school type and pupil characteristics. Drop-down menus at the top of the page allow customisation of year and
                    breakdowns. "),
                  br(),
                  p("Users can select a geographic level prior to selecting further options at
                  Region or Local Authority level."),
                  br(),
                  p("The Number and Percentage tabs shows information on the number and proportion of pupils in each Year
                    Group who fall into 5% bands for overall absence from 2017/18 to 2022/23."),
                  br(),
                  p("The distributions may be broken down to show numbers and proportions for pupils grouped by their Free School Meal status and by gender."),
                  br(),
                  p("Selection of multiple geographic areas or pupil characteristics will generate aggregate data of all pupils
                    matching the selection."),
                  br(),
                  p("During the 2020/21 and 2021/22 academic years, schools were advised to record where a pupil not attending in circumstances relating to coronavirus  as Code X. Where a pupil was not attending in these circumstances,
                    schools were expected to provide immediate access to remote education and they are not included in the absence rates reported
                    here. Throughout the pandemic, schools were advised to record pupils with a confirmed case of COVID-19 as absent due to
                    illness (Code I) which are included in the overall absence rates reported here."),
                  br(),
                  p("This release is derived from the pupil level school census from which further analysis such as school level absence rates can be produced.")
                ),
                br()
              )
            )
          )
        ),

        ## Right panel ------------------------------------------------------

        column(
          6,
          div(
            div(
              class = "panel panel-info",
              div(
                class = "panel-heading",
                style = "color: white;font-size: 18px;font-weight: bold;background-color: #1d70b8;",
                h2("Background Info")
              ),
              div(
                class = "panel-body",
                p("These figures are derived from census data submitted to the Department for Education (DfE)."),
                p("This dashboard has been developed as an accompaniment to DFE's termly National statistics on pupil absence. You can access these publications through the links below:"),
                br(),
                p(tags$a(href = "https://explore-education-statistics.service.gov.uk/find-statistics/pupil-absence-in-schools-in-england/2021-22", "Pupil absence in schools in England")),
                br(),
                p(tags$a(href = "https://explore-education-statistics.service.gov.uk/find-statistics/pupil-absence-in-schools-in-england/2022-23-autumn-and-spring-term", "Pupil absence in schools in England: autumn and spring terms")),
                br(),
                p(tags$a(href = "https://explore-education-statistics.service.gov.uk/find-statistics/pupil-absence-in-schools-in-england-autumn-term/2021-22-autumn-term", "Pupil absence in schools in England: autumn term")),
                br(),
                p(tags$a(href = "https://explore-education-statistics.service.gov.uk/find-statistics/pupil-attendance-in-schools", "Pupil attendance in schools in England: Pupil attendance and absence data including termly national statistics and fortnightly experimental statistics derived from DfE’s regular attendance data")),
              )
            )
          )
        )
      )
    )
  )
}


dashboard_panel <- function() {
  tabPanel(
    value = "dashboard",
    "Dashboard",

    # Sidebar with a slider input for number of bins
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          h1("DfE pupil absence distributions in schools in Englands")
        ),
        column(
          width = 12,
          expandable(
            inputId = "details", label = textOutput("dropdown_label"),
            contents =
              div(
                id = "div_a",
                # class = "well",
                # style = "min-height: 100%; height: 100%; overflow-y: visible",
                fluidRow(
                  column(
                    width = 3,
                    selectizeInput("selectYear",
                      "Select a Year:",
                      choices = choicesYear,
                      selected = "2021/22"
                    ),
                    selectizeInput(
                      inputId = "selectSchool_type",
                      label = "Select School Type:",
                      choices = choicesSchool_type,
                      multiple = "TRUE",
                      selected = c("Primary", "Secondary", "Special")
                    )
                  ),
                  column(
                    width = 3,
                    selectizeInput("selectFSM",
                      label = ("Select FSM status:"), multiple = TRUE,
                      choices = c("FSM Eligible" = "FSM eligible", "Not FSM Eligible" = "FSM Not eligible"),
                      selected = c("Not FSM Eligible", "FSM eligible")
                    ),
                    selectizeInput("selectGender",
                      label = ("Select gender:"), multiple = TRUE,
                      choices = c("Female" = "F", "Male" = "M"),
                      selected = c("F", "M")
                    )
                  ),
                  column(
                    width = 3,
                    selectizeInput(
                      inputId = "geography_choice",
                      label = "Choose geographic level:",
                      choices = c("National", "Regional", "Local authority"),
                      selected = "National",
                      width = "100%"
                    )
                  ),
                  column(
                    width = 3,
                    conditionalPanel(
                      condition = "input.geography_choice == 'Regional'",
                      selectizeInput(
                        inputId = "selectRegion",
                        label = "Choose region:",
                        choices = regions,
                        selected = regions[1],
                        width = "100%",
                        multiple = TRUE
                      )
                    ),
                    conditionalPanel(
                      condition = "input.geography_choice == 'Local authority'",
                      selectizeInput(
                        inputId = "selectLA",
                        label = "Choose local authority:",
                        choices = las,
                        selected = las[1],
                        width = "100%",
                        multiple = TRUE
                      )
                    )
                  )
                ),
                fluidRow(
                  column(
                    width = 12,
                    paste("Download the underlying data for this dashboard:"),
                    br(),
                    downloadButton(
                      outputId = "download_data",
                      label = "Download data",
                      icon = shiny::icon("download"),
                      class = "downloadButton"
                    )
                  )
                )
              )
          )
        ),
      ),
      column(
        width = 12,
        tabsetPanel(
          id = "tabsetpanels",
          tabPanel(
            "Pupil Numbers",
            fluidRow(
              column(
                width = 12,
                h2("Absence distributions by year group: Pupil Numbers"),
                fluidRow(
                  column(
                    width = 12,
                    dataTableOutput("tabDataNumber")
                  )
                )
              )
            )
          ),
          tabPanel(
            "Proportions",
            fluidRow(
              column(
                width = 12,
                h2("Absence distributions by year group: Proportions"),
                fluidRow(
                  column(
                    width = 12,
                    dataTableOutput("tabDataProportion")
                  )
                )
              )
            )
          )
        )
      )
    )
  )
}
