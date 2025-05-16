ui <- page_sidebar(
  title = "Census tract PFAS concentrations",
  sidebar = sidebar(
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
    )
  ),
    leafletOutput("map")
)