a11y_panel <- function() {
  tabPanel(
    "Accessibility",
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          h1("Accessibility statement"),
          br("This accessibility statement applies to the Pupil absence in schools in England distribution dashboard.
            This application is run by the Department for Education. We want as
            many people as possible to be able to use this application, and have
            actively developed this application with accessibilty in mind."),
          h2("WCAG 2.1 compliance"),
          br(
            "We follow the reccomendations of the ",
            a(
              href = "https://www.w3.org/TR/WCAG21/",
              "WCAG 2.1 requirements. ",
              onclick = "ga('send', 'event', 'click', 'link', 'IKnow', 1)"
            ),
            "This means that this application:"
          ),
          tags$div(tags$ul(
            tags$li("uses colours that have sufficient contrast"),
            tags$li("allows you to zoom in up to 300% without the text spilling
                    off the screen"),
            tags$li("has its performance regularly monitored, with a team
                    working on any feedback to improve accessibility for all
                    users.")
          )),
          h2("Limitations"),
          br("We recognise that there are still potential issues with
          accessibility in this application, but we will continue to review
          updates to technology available to us to keep improving accessibility
          for all of our users."),
          h2("Feedback"),
          br(
            "If you have any feedback on how we could further improve the
            accessibility of this application, please contact us at",
            a(href = "mailto:schools.statistics@education.gov.uk", "schools.statistics@education.gov.uk")
          )
        )
      )
    )
  )
}
