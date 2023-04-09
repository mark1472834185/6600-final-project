# server ----
library(shiny)
library(tidyverse)
library(leaflet)
library(dplyr)
library(ggplot2)


data <- read.csv()

# Define the Shiny app server
server1 <- function(input, output) {
  
  # Create a reactive expression to filter data based on user inputs
  filtered_data <- reactive({
    df <- data
    
    # Filter data based on selected year range
    df <- df %>%
      filter(Year >= input$yearRange[1] & Year <= input$yearRange[2])
    
    # Filter data based on selected regions
    if (!"Global" %in% input$Continent) {
      df <- df %>%
        filter(Region %in% input$Continent)
    }
    
    # Filter data based on selected capital type
    df <- df %>%
      filter(`Capital type option` == input$capitalType)
    
    df
  })
  
  # Create a histogram or bar chart based on the filtered data
  output$histogram <- renderPlot({
    # Wait for the user to click the "Apply Changes" button
    input$applyChanges
    
    # Get the filtered data
    df <- filtered_data()
    
    # Aggregate data by country and sum the USD values
    aggregated_data <- df %>%
      group_by(`Country Name`) %>%
      summarise(Total_USD = sum(`USD value`, na.rm = TRUE)) %>%
      arrange(desc(Total_USD)) %>%
      head(10)  # Get the top 10 countries
    
    # Create a bar chart using ggplot2
    p <- ggplot(aggregated_data, aes(x = reorder(`Country Name`, Total_USD), y = Total_USD)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(x = "Country Name", y = "Total USD", title = "Top 10 Countries by Total USD")
    
    print(p)
  })


  
  #Revise1 add interactive map into
  cities <- data.frame(
    continent = c("North America", "Europe", "Asia", "Oceania", "South America", "Africa")
  )
  
  # Filter the data based on the user input
  filtered_cities <- reactive({
    if (input$continent == "All") {
      cities
    } else {
      cities[cities$continent == input$continent, ]
    }
  })
  
  output$map <- renderLeaflet({
    if (input$continent == "Europe") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -10, lat1 = 34, lng2 = 30, lat2 = 60)
    } else if (input$continent == "North America") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -128, lat1 = 24, lng2 = -56, lat2 = 50)
    } else if (input$continent == "Asia") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = 80, lat1 = -10, lng2 = 150, lat2 = 45)
    } else if (input$continent == "Oceania") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = 112, lat1 = -47, lng2 = 180, lat2 = -10)
    } else if (input$continent == "South America") {
      leaflet(data = filtered_cities()) %>%
        addTiles() %>%
        fitBounds(lng1 = -75, lat1 = -45, lng2 = -50, lat2 = 5)
    } else if (input$continent == "Africa") {
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

