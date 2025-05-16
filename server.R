server <- function(input, output, session) {
  
  myvar <- reactive({
    paste0(
      str_to_lower(input$contaminant),
      "_avg",
      input$year,
      ifelse(input$type == "Population-weighted", "_p", "_a")
      )
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addResetMapButton() %>%
      fitBounds(-124.72584, 24.49813, -66.94989, 49.38436)
  })
  
  observeEvent(c(input$contaminant, input$type, input$year, input$map_zoom), {
    
    df <- df %>%
      dplyr::select(myvar(), x, y) %>%
      rename(myvar = 1) %>%
      # na.omit() %>%
      mutate(
        bins = cut(myvar, breaks = c(0, 1, 3, 5, 10, Inf)),
        cols = colour_values(bins, palette = "ylorbr", na_colour = "#E1E1E1")
        )

    leafletProxy("map") %>%
      addGlPoints(
        data = st_as_sf(df, coords = c("x", "y"), crs = 4326),
        popup = ~round(myvar, 1),
        fillColor = ~cols,
        fragmentShaderSource = "simpleCircle",
        radius = input$map_zoom
      ) 
  }, ignoreInit = TRUE)
  
  observeEvent(c(input$contaminant, input$type, input$year), {
    # myleg <- df %>%
    #   dplyr::select(myvar(), x, y) %>%
    #   rename(myvar = 1) %>%
    #   na.omit() %>%
    #   mutate(
    #     bins = cut(myvar, breaks = c(0, 1, 3, 5, 10, Inf)),
    #     cols = colour_values(bins, palette = "ylorbr", na_colour = "#E1E1E1")
    #   ) %>%
    #   arrange(bins) %>%
    #   summarise(bins = unique(bins),
    #             cols = unique(cols))
    # print(myleg)

    leafletProxy("map") %>%
      clearGlLayers() %>%
      clearControls() %>%
      addLegend(
        colors = c(
          "#FFFFE5FF",
          "#FEE391FF",
          "#FE9929FF",
          "#CC4C02FF",
          "#662506FF",
          "#E1E1E1"
          ),
        labels = c(
          "0 - 1", 
          "1 - 3", 
          "3 - 5",
          "5 - 10",
          "10+",
          "Not tested"
          ),
        opacity = 1,
        title = paste(myvar(), "(ng/L)"),
        position = "bottomright"
      )
  })
  
}