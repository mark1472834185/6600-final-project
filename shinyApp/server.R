# server ----
library(shiny)
library(tidyverse)
library(leaflet)
library(dplyr)
library(ggplot2)


# Define the Shiny app server
server1 <- function(input, output, session) {
  data <- read_csv("~/GitHub/IE-6600-final-project/shinyApp/www/data/revised_data.csv")
  data$capitalType <- gsub(" \\(constant 2018 US\\$\\)","",data$capitalType)
    
    filtered_data <- reactiveVal()
    
    observeEvent(input$applyChanges, {
      req(input$yearRange, input$continent, input$capitalType)
      
      # Prepare the data for filtering
      df <- data
      
      # Remove non-numeric characters from the Total_USD column
      df$Total_USD <- gsub("[^0-9.]", "", df$Total_USD)
      
      # Convert the Total_USD column to numeric
      df$Total_USD <- as.numeric(as.character(df$Total_USD))
      
      # Replace NAs with 0 in the Total_USD column
      df$Total_USD[is.na(df$Total_USD)] <- 0
      
      # Filter data based on selected year range
      df <- df %>%
        filter(Year >= input$yearRange[1] & Year <= input$yearRange[2])
      
      # Filter data based on selected regions
      if (input$continent != "All") {
        df <- df %>%
          filter(Continent == input$continent)
      }
      
      # Filter data based on selected capital type
      df <- df %>%
        filter(capitalType == input$capitalType)
      
      filtered_data(df)
    })
    
    output$histogram <- renderPlot({
      req(filtered_data())
      
      # Aggregate data by country and sum the USD values
      aggregated_data <- filtered_data() %>%
        group_by(Country.Name) %>%
        summarise(Total_USD = sum(Total_USD, na.rm = TRUE)) %>%
        arrange(desc(Total_USD)) %>%
        head(10)  # Get the top 10 countries
      
      # Create a bar chart using ggplot2
      p <- ggplot(aggregated_data, aes(x = reorder(Country.Name, Total_USD), y = Total_USD)) +
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

}

