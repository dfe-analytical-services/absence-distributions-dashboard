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
          p("The dashboard provides data on the distribution of overall absence for pupils in English schools at national, regional and local authority geographic levels.
                    Data is available across state-funded primary, secondary and special schools and can also be broken
                    down by individual school type and pupil characteristics. Drop-down menus at the top of the page allow customisation of year and
                    breakdowns. "),
          br(),
          h3("Absence rates"),
          p("Absence rates are calculated by dividing the number of sessions coded as an absence by the total number of possible sessions, where possible sessions include on-site attendance, approved off-site educational activity (for example, work experience) and absence. The banding rates are as follows:"),
          p(" 0-5% = Pupils whose overall absence was in the range 0.00-4.99%,"),
          p(" 5-10% = Pupils whose overall absence was in the range 5.00-9.99%,"),
          p(" 10-15% = Pupils whose overall absence was in the range 10.00-14.99%,"),
          p(" 15-20% = Pupils whose overall absence was in the range 15.00-19.99%,"),
          p(" 20-25% = Pupils whose overall absence was in the range 20.00-24.99%,"),
          p(" 25-30% = Pupils whose overall absence was in the range 25.00-29.99%,"),
          p(" 30-25% = Pupils whose overall absence was in the range 30.00-34.99%,"),
          p(" 35-40% = Pupils whose overall absence was in the range 35.00-39.99%,"),
          p(" 40-45% = Pupils whose overall absence was in the range 40.00-44.99%,"),
          p(" 45-50% = Pupils whose overall absence was in the range 45.00-49.99%,"),
          p(" 50%+ = Pupils whose overall absence was in the range 50.00-100%,"),
          br(),
          h3("Special Educational Needs"),
          p("A SEN status of 'Any special educational need' includes pupils who have either an EHC Plan or SEN Support status."),
          p("A pupil has an EHC plan when a formal assessment has been made. A document is in place that sets out the child’s need and the extra help they should receive. EHC plans were introduced in September 2014 replacing Statements of SEN, with these being phased out by April 2018. This category therefore includes Statements of SEN for the years up to 2018."),
          p("From 2015, the School Action and School Action Plus categories were combined to form one category of SEN support. Extra or different help is given from that provided as part of the school’s usual curriculum. The class teacher and special educational needs co-ordinator (SENCO) may receive advice or support from outside specialists. The criteria required for SEN Support varies in Local Authorities."),
          br(),
          h3("Suppression"),
          p("The underlying data has not been supressed but pupils who are unclassified for SEN status or FSM status are not displayed in the app which may result in different headcounts to other published absence publications."),
          br(),
          h3("See the source code"),
          p(
            "The source code for this dashboard is available in our ",
            a(href = "https://github.com/dfe-analytical-services/absence-distributions-dashboard", "GitHub repository", .noWS = c("after")),
            "."
          )
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
          h1("Pupil absence distributions in schools in England"),
          br(),
          p("Data was last updated on 10 May 2024."),
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
                  p("The dashboard provides data on the distribution of overall absence for pupils in English schools at national, regional and local authority geographic levels.
                    Data is available across state-funded primary, secondary and special schools and can also be broken
                    down by individual school type and pupil characteristics. Drop-down menus at the top of the page allow customisation of year and
                    breakdowns. "),
                  br(),
                  p("Users can select a geographic level prior to selecting further options at
                  regional or local authority level."),
                  br(),
                  p("The Pupil Enrolments and Proportions by Year Group tabs shows information on the number and proportion of pupil enrolments in each year
                    group who fall into 5% bands for overall absence from 2016/17 to 2022/23."),
                  br(),
                  p("The distributions may be broken down to show numbers and proportions for pupil enrolments grouped by their Free School Meal status, Special Educational Need status and by sex. A SEN status of 'Any special educational need' includes pupils who have either an EHC Plan or SEN Support status."),
                  br(),
                  p("Selection of multiple geographic areas or pupil characteristics will generate aggregate data of all pupils
                    matching the selection. To remove a characteristic delete it from the selection box."),
                  br(),
                  p("During the 2020/21 and 2021/22 academic years, schools were advised to record where a pupil not attending in circumstances relating to COVID-19  as Code X. Where a pupil was not attending in these circumstances,
                    schools were expected to provide immediate access to remote education and they are not included in the absence rates reported
                    here. Throughout the pandemic, schools were advised to record pupils with a confirmed case of COVID-19 as absent due to
                    illness (Code I) which are included in the overall absence rates reported here."),
                  br(),
                  p("This release is derived from the pupil level school census from which further analysis such as school level absence rates can be produced."),
                  p("Pupils who are unclassified for SEN status or FSM status are not displayed in the app which may result in different headcounts to other published absence publications.")
                )
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
                p("This dashboard has been developed as an accompaniment to DfE's national statistics on pupil absence. You can access these publications through the links below:"),
                br(),
                p(tags$a(href = "https://explore-education-statistics.service.gov.uk/find-statistics/pupil-absence-in-schools-in-england", "Pupil absence in schools in England")),
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
          h1("Pupil absence distributions in schools in England")
        ),
        column(
          width = 12,
          fluidRow(
            column(
              width = 3,
              selectizeInput("selectYear",
                "Select year:",
                choices = choicesYear,
                selected = "2022/23"
              ),
              selectizeInput(
                inputId = "selectSchool_type",
                label = "Select school type:",
                choices = choicesSchool_type,
                multiple = "TRUE",
                selected = c("State-funded primary", "State-funded secondary", "Special")
              )
            ), # end of col
            column(
              width = 3,
              selectizeInput("selectFSM",
                label = ("Select FSM status:"), multiple = TRUE,
                choices = c("Eligible" = "Eligible", "Not Eligible" = "Not Eligible"),
                selected = c("Not Eligible", "Eligible")
              ),
              selectizeInput("selectSEN",
                label = ("Select SEN status:"), multiple = TRUE,
                choices = c("Any special educational need", "No identified special educational need"),
                selected = c("Any special educational need", "No identified special educational need")
              ),
              selectizeInput("selectGender",
                label = ("Select sex:"), multiple = TRUE,
                choices = c("Female", "Male"),
                selected = c("Female", "Male")
              )
            ), # end of col
            column(
              width = 3,
              selectizeInput(
                inputId = "geography_choice",
                label = "Select geographic level:",
                choices = c("National", "Regional", "Local authority"),
                selected = "National",
                width = "100%"
              )
            ), # end of col
            column(
              width = 3,
              conditionalPanel(
                condition = "input.geography_choice == 'Regional'",
                selectizeInput(
                  inputId = "selectRegion",
                  label = "Select region:",
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
                  label = "Select local authority:",
                  choices = las,
                  selected = las[1],
                  width = "100%",
                  multiple = TRUE
                )
              )
            ) # end of col
          ), # end of row with all the selections in
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
            ) # end of col
          ) # end of row with download in
        ), # end of col with selectors in
        column(
          width = 12,
          tabsetPanel(
            id = "tabsetpanels",
            tabPanel(
              "Pupil Enrolments",
              fluidRow(
                column(
                  width = 12,
                  # h2("Absence distributions by year group: Pupil Enrolments"),
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
              "Proportions of Year Group",
              fluidRow(
                column(
                  width = 12,
                  # h2("Absence distributions by year group: Proportions"),
                  fluidRow(
                    column(
                      width = 12,
                      dataTableOutput("tabDataProportion")
                    )
                  ) # end of row
                ) # end of col
              )
            ) # end of tabpanel
          ) # end of tabset
        ) # end of col with panel in
      ) # end of gov
    ) # end of gov layout
  ) # tabpanel dashboard
}
