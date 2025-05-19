server <- function(input, output, session) {
  
  myvar <- reactive({
    paste0(
      str_to_lower(input$contaminant),
      "_avg",
      input$year,
      ifelse(input$type == "Population-weighted", "_p", "_a")
    )
  })
  
  output$var <- renderText({
    myvar()
  })
  
  output$map <- renderLeaflet({
    leaflet(
      options = leafletOptions(zoomSnap = 0.25, zoomDelta = 0.25)
    ) %>%
      addMapPane(name = "labels", zIndex = 420) %>%
      addProviderTiles(
        providers$CartoDB.PositronNoLabels
      ) %>%
      addProviderTiles(
        providers$CartoDB.PositronOnlyLabels,
        group = "Show Labels",
        options = leafletOptions(pane = "labels")
      ) %>%
      addResetMapButton() %>%
      setView(-97.000, 38.000, zoom = 4.25) %>%
      addLayersControl(
        baseGroups = c(
          "Hide Labels",
          "Show Labels"
        ),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      htmlwidgets::onRender("
    function() {
        $('.leaflet-control-layers-list').prepend('Basemap');
    }
")
    
  })
  
  observeEvent(c(input$contaminant, input$type, input$year), {
    
    df <- df %>%
      dplyr::select(myvar(), x, y) %>%
      rename(myvar = 1) %>%
      # na.omit() %>%
      mutate(
        # bins = cut(myvar, breaks = c(0, 1, 3, 5, 10, Inf)),
        # cols = colour_values(bins, palette = "ylorbr", na_colour = "#E1E1E1")
        cols = case_when(
          # between(round(myvar, 1), 0, .9) ~ "#F7FBFFFF",
          between(round(myvar, 1), 0, .9) ~ "#E7F0FA",
          between(round(myvar, 1), 1, 2.9) ~ "#C6DBEFFF",
          between(round(myvar, 1), 3, 4.9) ~ "#6BAED6FF",
          between(round(myvar, 1), 5, 9.9) ~ "#2171B5FF",
          between(round(myvar, 1), 10, Inf) ~ "#08306BFF",
          TRUE ~ "#E1E1E1"
        )
      )
    
    # print(summary(df$myvar[df$cols == "#FFFFE5FF"]))
    # print(summary(df$myvar[df$cols == "#FEE391FF"]))
    # print(summary(df$myvar[df$cols == "#FE9929FF"]))
    # print(summary(df$myvar[df$cols == "#CC4C02FF"]))
    # print(summary(df$myvar[df$cols == "#662506FF"]))
    # print(summary(df$myvar[df$cols == "#E1E1E1"]))
    
    leafletProxy("map") %>%
      clearGlLayers() %>%
      clearControls() %>%
      addGlPoints(
        data = st_as_sf(df, coords = c("x", "y"), crs = 4326),
        popup = ~round(myvar, 1),
        fillColor = ~cols,
        fragmentShaderSource = "simpleCircle",
        radius = 5
      ) %>%
      addLegend(
        colors = c(
          # "#F7FBFFFF",
          "#E7F0FA",
          "#C6DBEFFF",
          "#6BAED6FF",
          "#2171B5FF",
          "#08306BFF",
          "#E1E1E1"
        ),
        labels = c(
          "0.0 - 0.9", 
          "1.0 - 2.9", 
          "3.0 - 4.9",
          "5.0 - 9.9",
          "10.0+",
          "Not tested"
        ),
        opacity = 1,
        title = paste(myvar(), "(ng/L)"),
        position = "bottomright"
      )
    
    output$min <- renderText({
      round(summary(df$myvar)[1], 1)
    })
    output$q1 <- renderText({
      round(summary(df$myvar)[2], 1)
    })
    output$med <- renderText({
      round(summary(df$myvar)[3], 1)
    })
    output$mean <- renderText({
      round(summary(df$myvar)[4], 1)
    })
    output$q3 <- renderText({
      round(summary(df$myvar)[5], 1)
    })
    output$max <- renderText({
      round(summary(df$myvar)[6], 1)
    })
    output$n <- renderText({
      comma(sum(!is.na(df$myvar)))
    })
    output$na <- renderText({
      comma(as.vector(summary(df$myvar)[7]))
    })
  })
  
}