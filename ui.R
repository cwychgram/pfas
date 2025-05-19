ui <- page_sidebar(
  title = "Census tract PFAS concentrations",
  sidebar = sidebar(
    width = "20%",
    selectizeInput(
      inputId = "contaminant",
      label = "Contaminant",
      choices = c(
        # "PFBS", 
        # "PFDA", 
        # "PFHpA", 
        "PFHxS", 
        "PFNA", 
        "PFOA", 
        "PFOS"
        # "PFPeA"
      )
    ),
    selectizeInput(
      inputId = "type",
      label = "Concentration type",
      choices = c(
        "Population-weighted",
        "Area-weighted"
      )
    ),
    sliderInput(
      inputId = "year",
      label = "Year",
      min = 2013,
      max = 2024,
      value = 2024,
      ticks = FALSE,
      sep = ""
    ),
    div(
      span("Summary"),
      br(),
      span("Variable: ", textOutput("var", inline = TRUE)),
      br(),
      span("Min: ", textOutput("min", inline = TRUE), "ng/L"),
      br(),
      span("Q1: ", textOutput("q1", inline = TRUE), "ng/L"),
      br(),
      span("Median: ", textOutput("med", inline = TRUE), "ng/L"),
      br(),
      span("Mean: ", textOutput("mean", inline = TRUE), "ng/L"),
      br(),
      span("Q3: ", textOutput("q3", inline = TRUE), "ng/L"),
      br(),
      span("Max: ", textOutput("max", inline = TRUE), "ng/L"),
      br(),
      span("N Available: ", textOutput("n", inline = TRUE), "census tracts"),
      br(),
      span("N Missing: ", textOutput("na", inline = TRUE), "census tracts")
    )
  ),
    leafletOutput("map")
)