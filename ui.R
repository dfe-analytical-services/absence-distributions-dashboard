# ---------------------------------------------------------
# This is the ui file.
# Use it to call elements created in your server file into the app, and define
# where they are placed. Also use this file to define inputs.
#
# Every UI file should contain:
# - A title for the app
# - A call to a CSS file to define the styling
# - An accessibility statement
# - Contact information
#
# Other elements like charts, navigation bars etc. are completely up to you to
# decide what goes in. However, every element should meet accessibility
# requirements and user needs.
#
# This file uses a slider input, but other inputs are available like date
# selections, multiple choice dropdowns etc. Use the shiny cheatsheet to explore
# more options: https://shiny.rstudio.com/images/shiny-cheatsheet.pdf
#
# Likewise, this template uses the navbar layout.
# We have used this as it meets accessibility requirements, but you are free to
# use another layout if it does too.
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# ---------------------------------------------------------

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# The documentation for this GOVUK components can be found at:
#
#    https://github.com/moj-analytical-services/shinyGovstyle
#


#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# The documentation for this GOVUK components can be found at:
#
#    https://github.com/moj-analytical-services/shinyGovstyle
#

ui <- function(input, output, session) {
  page_fluid(
    # Metadata for app ========================================================
    tags$html(lang = "en"),
    tags$head(HTML(paste0("<title>", site_title, "</title>"))), # set in global.R
    tags$head(tags$link(rel = "shortcut icon", href = "dfefavicon.png")),
    # Add meta description for search engines
    meta() %>%
      meta_general(
        application_name = "Pupil absence distributions in schools in England: data dashboard",
        description = "Pupil absence distributions in schools in England: data dashboard",
        robots = "index,follow",
        generator = "R-Shiny",
        subject = "stats development",
        rating = "General",
        referrer = "no-referrer"
      ),
    shinyjs::useShinyjs(),
    # Required to make the title update based on tab changes
    shinytitle::use_shiny_title(),

    ## Custom CSS -------------------------------------------------------------
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "dfe_shiny_gov_style.css"
      )
    ),
    dfeshiny::custom_disconnect_message(
      links = site_primary,
      publication_name = ees_pub_name,
      publication_link = ees_pub_url
    ),
    tags$head(includeHTML(("google-analytics.html"))),
    dfe_cookies_script(),
    dfeshiny::cookies_banner_ui(
      name = site_title
    ),
    dfeshiny::header(
      header = site_title,
      logo_alt_text = "The logo for the Department for Education",
      main_alt_text = "Link to the Department for education home page"
    ),
    shinyGovstyle::banner(
      "beta banner",
      "beta",
      paste0(
        "This Dashboard is in beta phase and we are still reviewing performance
        and reliability. "
      )
    ),
    # Page navigation =========================================================
    # This switches between the supporting pages in the footer and the main dashboard
    gov_main_layout(
      bslib::navset_hidden(
        id = "pages",
        nav_panel(
          "dashboard",
          ## Main dashboard ---------------------------------------------------
          layout_columns(
            # Override default wrapping breakpoints to avoid text overlap
            col_widths = breakpoints(sm = c(4, 8), md = c(3, 9), lg = c(2, 9)),
            ## Left navigation ------------------------------------------------
            dfe_contents_links(
              links_list = c(
                "Absence distributions",
                "User guide",
                "Technical notes"
              )
            ),
            ## Dashboard panels -----------------------------------------------
            bslib::navset_hidden(
              id = "left_nav",
              nav_panel(
                "absence_distributions", dashboard_panel()
              ),
              nav_panel(
                "user_guide", homepage_panel()
              ),
              nav_panel(
                "technical_notes", technical_panel()
              )
            )
          )
        ),
        ## Footer pages -------------------------------------------------------
        nav_panel(
          "support",
          layout_columns(
            col_widths = c(-2, 8, -2),

            # Add backlink
            actionLink(
              class = "govuk-back-link",
              style = "margin: 0",
              "support_to_dashboard",
              "Back to dashboard"
            ),
            dfeshiny::support_panel(
              team_email = "schools.statistics@education.gov.uk",
              repo_name = "https://github.com/dfe-analytical-services/absence-distributions-dashboard",
              publication_name = ees_pub_name,
              publication_slug = ees_pub_url
            )
          )
        ),
        nav_panel(
          "accessibility_statement",
          layout_columns(
            col_widths = c(-2, 8, -2),

            # Add backlink
            actionLink(
              class = "govuk-back-link",
              style = "margin: 0",
              "a11y_to_dashboard",
              "Back to dashboard"
            ),
            a11y_panel()
          )
        ),
        nav_panel(
          "cookies_statement",
          layout_columns(
            col_widths = c(-2, 8, -2),

            # Add backlink
            actionLink(
              class = "govuk-back-link",
              style = "margin: 0",
              "cookies_to_dashboard",
              "Back to dashboard"
            ),
            cookies_panel_ui(google_analytics_key = google_analytics_key)
          )
        )
      )
    ),

    # Footer ==================================================================
    shinyGovstyle::footer(
      full = TRUE,
      links = c(
        "Support",
        "Accessibility statement",
        "Cookies statement"
      )
    )
  )
}
