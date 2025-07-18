<h1 align="center">
  <br>
DfE Pupil absence distributions in schools in England
  <br>
</h1>

---

<p align="center">
  <a href="#introduction">Introduction</a> |
  <a href="#requirements">Requirements</a> |
  <a href="#how-to-use">How to use</a> |
  <a href="#how-to-contribute">How to contribute</a> |
  <a href="#contact">Contact</a>
</p>

---

## Introduction 

The dashboard provides users with an opportunity to investigate pupil absence at national, regional and local authority geographic levels in 5% bandings for overall absence. Data is available across state-funded primary, secondary and special schools and can also be broken down by individual school type, and pupils year group, Special Educational Needs status, Free school Meal status and sex.

Live version of the dashboard can be accessed at https://department-for-education.shinyapps.io/absence-distributions-dashboard/

The dashboard is split across multiple tabs:

- <b>Pupil Enrolments</b> shows the number of pupil enrolments in each year group and 5% overall absence band for the selections chosen. 
- <b>Proportions</b> shows the proportion of enrolments in each year group falling in each banding 5% overall absence band for the selections chosen

The dashboard also includes further information on the data itself on the technical notes tab, alongside accessibility and information on where to find further support. 

 
---

## Requirements


### i. Software requirements (for running locally)

- Installation of R Studio 1.2.5033 or higher

- Installation of R 3.6.2 or higher

- Installation of RTools40 or higher

### ii. Programming skills required (for editing or troubleshooting)

- R at an intermediate level, [DfE R training guide](https://dfe-analytical-services.github.io/r-training-course/)

- Particularly [R Shiny](https://shiny.rstudio.com/)


  
---

## How to use

### Running the app locally

1. Clone or download the repo. 

2. Open the R project in R Studio.

3. Run `renv::restore()` to install dependencies.

4. Run `shiny::runApp()` to run the app locally.


### Packages

Package control is handled using renv. As in the steps above, you will need to run `renv::restore()` if this is your first time using the project.

### Tests

UI tests have been created using shinytest2 that test the app loads. More should be added over time as extra features are added.

GitHub Actions provide CI by running the automated tests and checks for code styling. The yaml files for these workflows can be found in the .github/workflows folder.

The function run_tests_locally() is created in the Rprofile script and is available in the RStudio console at all times to run both the unit and ui tests.

### Deployment

- The app is deployed to the department's shinyapps.io subscription using GitHub actions. The yaml file for this can be found in the .github/workflows folder.

### Navigation

In general all .r files will have a usable outline, so make use of that for navigation if in RStudio: `Ctrl-Shift-O`.

### Code styling 

The function tidy_code() is created in the Rprofile script and therefore is always available in the RStudio console to tidy code according to tidyverse styling using the styler package. This function also helps to test the running of the code and for basic syntax errors such as missing commas and brackets.


---

### Flagging issues

If you spot any issues with the application, please flag it in the "Issues" tab of this repository, and label as a bug.

### Merging pull requests

Only members of the Statistics Development team can merge pull requests. Add cjrace as requested reviewers, and the team will review before merging.

---

## Contact


If you have any questions about the dashboard please contact [schools.statistics@education.gov.uk](mailto:schools.statistics@education.gov.uk).
