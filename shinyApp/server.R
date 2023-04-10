# server ----
library(shiny)
library(tidyverse)
library(leaflet)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinythemes)
library(bs4Dash)

# Define the Shiny app server
server1 <- function(input, output, session) {
  data <- read_csv("https://raw.githubusercontent.com/mark1472834185/6600-final-project/main/shinyApp/www/data/revised_data.csv")
  data$capitalType <- gsub(" \\(constant 2018 US\\$\\)","",data$capitalType)
  data_final <- read_csv("https://raw.githubusercontent.com/mark1472834185/6600-final-project/main/shinyApp/www/data/final_revised_data.csv")
    
  
  
    filtered_data <- reactiveVal()
    
    observeEvent(input$applyChanges, {
      req(input$yearRange, input$continent, input$capitalType)
      
      # Prepare the data for filtering
      df <- data

      # Convert the Total_USD column to numeric
      df$Total_USD <- as.numeric(as.character(df$Total_USD))

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
    
    aggregated_data <- reactive({
      req(filtered_data())
      
      df_filtered <- filtered_data()
      
      # Aggregate data by country and sum the USD values
      df_top10 <- df_filtered %>%
        group_by(Country.Name) %>%
        summarise(Total_USD = sum(Total_USD, na.rm = TRUE)) %>%
        arrange(desc(Total_USD)) %>%
        head(10)  # Get the top 10 countries
      
      df_top10
    })
    
    
    output$histogram <- renderPlot({
      req(aggregated_data())
      
      # Create a bar chart using ggplot2
      p <- ggplot(aggregated_data(), aes(x = reorder(Country.Name, Total_USD), y = Total_USD)) +
        geom_bar(stat = "identity", fill = "darkgrey") +
        theme(plot.background = element_rect(fill = "transparent"),
              panel.background = element_rect(fill = "transparent"),
              axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
              axis.text.y = element_text(size = 14),
              axis.title.x = element_text(size = 16),
              axis.title.y = element_text(size = 16),
              plot.title = element_text(size = 18)) +
        labs(x = "Country Name", y = "Total USD", title = "Top 10 Countries by Total USD value shown in Bar chart")
      
      print(p)
    
    })
    
    output$piechart <- renderPlot({
      req(aggregated_data())
      
      # Create a pie chart using ggplot2
      p <- ggplot(aggregated_data(), aes(x = "", y = Total_USD, fill = Country.Name)) +
        geom_bar(stat = "identity", width = 1) +
        coord_polar("y", start = 0) +
        theme_void() +
        theme(legend.position = "right", legend.text = element_text(size = 12),
              legend.title = element_text(size = 14),
              plot.title = element_text(size = 16, hjust = 0.5)) +
        labs(title = "Top 10 Countries by Total USD value shown in pie chart", fill = "Country")
      
      print(p)
    })
    
    output$trendPlot <- renderPlot({
      req(filtered_data())
      
      # Filter data to get the top 10 countries
      top_countries <- aggregated_data()$Country.Name
      
      # Filter the data to include only the top 10 countries
      trend_data <- filtered_data() %>%
        filter(Country.Name %in% top_countries)
      
      # Generate the trend line plot
      p <- ggplot(trend_data, aes(x = Year, y = Total_USD, color = Country.Name)) +
        geom_line(size = 1) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
              axis.text.y = element_text(size = 12),
              axis.title.x = element_text(size = 14),
              axis.title.y = element_text(size = 14),
              plot.title = element_text(size = 16)) +
        labs(x = "Year", y = "Total USD", title = "Trend Analysis for Top 10 Countries")
      
      print(p)
    })
    
    
  
    filtered_data_final <- reactive({
      req(input$yearRange, input$continent)
      
      # Prepare the data for filtering
      df1 <- data_final
      
      # Filter data based on selected year range
      df1 <- df1 %>%
        filter(Year >= input$yearRange[1] & Year <= input$yearRange[2])
      
      # Filter data based on selected regions
      if (input$continent != "All") {
        df1 <- df1 %>%
          filter(Continent == input$continent)
      }
      
      return(df1)
    })
    
    
    output$pca_cluster_plot <- renderPlotly({
      req(filtered_data_final())
      
      # Remove label columns
      df_numeric <- filtered_data_final() %>% select(5:56) %>% scale()
      
      # Identify and remove constant or near-constant columns
      non_constant_columns <- apply(df_numeric, 2, function(x) length(unique(x)) > 1)
      df_numeric <- df_numeric[, non_constant_columns]
      
      # Scale the remaining columns
      df_numeric <- scale(df_numeric)
      
      # Perform PCA
      pca_data <- prcomp(df_numeric, scale. = TRUE)
      
      # Transform the data using the selected principal components
      num_pcs <- 5
      pca_transformed_data <- predict(pca_data, newdata = df_numeric)[, 1:num_pcs]
      
      # Perform k-means clustering on the transformed data
      k <- 4
      kmeans_result <- kmeans(pca_transformed_data, centers = k)
      
      # Combine the original dataset with the PCA transformed data and cluster assignments
      data_pca_clustered <- cbind(filtered_data_final(), pca_transformed_data, cluster = kmeans_result$cluster)
      data_pca_clustered$cluster <- as.character(data_pca_clustered$cluster)
      
      # Create a Plotly PCA clustering plot
      fig <- plot_ly(data_pca_clustered, type = "scatter", mode = "markers",
                     x = ~PC1, y = ~PC2,
                     text = ~Country.Name, hoverinfo = "text",
                     marker = list(color = ~cluster, size = 10, showscale = FALSE),
                     showlegend = FALSE)
      
      return(fig)
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
