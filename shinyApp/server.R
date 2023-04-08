# server ----
library(shiny)
library(tidyverse)
library(leaflet)

server1 <- function(input, output) {
  # Reactive values ----
  values <- reactiveValues(tbl = NULL,
                           obsList = NULL,
                           plot.df = NULL,
                           # For feature BIN ----
                           bins = NULL)
  
  # Observe any updates from the dataset selection ----
  observeEvent(input$dbList1, {
    # Function IF will prevent to show error/warning messages on the blank screen ----
    if (!NA %in% match(input$dbList1, c("mpg", "diamonds", "msleep"))) {
      # Make selected dataset data.frame ---- 
      values$tbl <- as.data.frame(get(input$dbList1))
      # Save column names to obsList ----
      values$obsList <- colnames(values$tbl)
      # UI output for 1st observation ----
      output$obs1 <- renderUI({
        selectInput(
          inputId = "observationInput1",
          label = "1st observation",
          choices =  values$obsList
        )
      })
    }
  })
  
  #Revise1 add interactive map into
  cities <- data.frame(
    region = c("North America", "Europe", "Asia", "Oceania", "South America", "Africa")
  )
  
  # Filter the data based on the user input
  filtered_cities <- reactive({
    if (input$region == "All") {
      cities
    } else {
      cities[cities$region == input$region, ]
    }
  })
  
  output$map <- renderLeaflet({
    if (input$region == "Europe") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -10, lat1 = 34, lng2 = 30, lat2 = 60)
    } else if (input$region == "North America") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -128, lat1 = 24, lng2 = -56, lat2 = 50)
    } else if (input$region == "Asia") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = 80, lat1 = -10, lng2 = 150, lat2 = 45)
    } else if (input$region == "Oceania") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = 112, lat1 = -47, lng2 = 180, lat2 = -10)
    } else if (input$region == "South America") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -75, lat1 = -45, lng2 = -50, lat2 = 5)
    } else if (input$region == "Africa") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -20, lat1 = -35, lng2 = 45, lat2 = 30)
    } else {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -180, lat1 = -90, lng2 = 180, lat2 = 90)
    }
  })
  
  # Observe the updates of the selected columns ----
  observeEvent(input$observationInput1, {
    # Save the selected column/s to values$plot.df ----
    values$plot.df <-
      as.data.frame(values$tbl[, input$observationInput1])
    # Save column names ----
    colnames(values$plot.df) <- input$observationInput1
    
    # TODO 
    # Problem 3: You may insert an if else statement to control 
    # if the BIN widget should be appeared
    ## your code here ##
    # P3 modify
    if (is.numeric(values$plot.df[[1]])) {
      output$binInput <- renderUI({
        sliderInput(
          inputId = "bins",
          label = "Bins",
          value = 10,
          min = 1,
          max = 50
        )
      })
    } else {
      output$binInput <- NULL
    }
    
    # Render output data table ----
    output$dataSet <- DT::renderDataTable({
      values$tbl
    },
    # Default settings for DT::renderDataTable{()} ----
    extensions = c('Scroller', 'FixedColumns'),
    options = list(
      deferRender = TRUE,
      scrollX = TRUE,
      scrollY = 200,
      scroller = TRUE,
      dom = 'Bfrtip',
      fixedColumns = TRUE
    ))
    
    
    
    
    
  })
  
  # Output chart types using created function switch_chart()
  observe({
    # TODO 
    # Problem 3: Store input$bins to reactive value
    # You may ignore this for Problem 2
    ## your code here ##
    if (!is.null(input$bins)) {
      values$bins <- input$bins
    }
    
    # TODO 
    # Problem 2: Complete the output settings with switch_chart() here
    # hint: values$plot.df is the data frame should be processed in switch_chart()
    output$plotChart <- renderPlot({
      
      if (is.null(values$plot.df)) {
        return(NULL)
      }
      
      if (is.numeric(values$plot.df[[1]]) && !is.null(input$bins)) {
        hist(values$plot.df[, 1], breaks = input$bins, main = "", xlab = colnames(values$plot.df), col = "darkgrey", border = "black")
      } else {
        switch_chart(values$plot.df, input$observationInput1, values$bins)
      }
      
    })
  })
  
  
  # Widget RESET ----
  # hint: set widget to NULL, then widget will disappear ----
  observeEvent(input$reset, {
    values$tbl <- NULL
    output$obs1 <- NULL
  })
  
  # Widget for DEBUG any specific values, default is the obs1 ----
  # You may comment it up ----
  output$aaa <- renderPrint({
    values$obs1
  })
}

