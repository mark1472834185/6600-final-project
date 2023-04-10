


# Define the Shiny app server
server <- function(input, output, session) {
  source("www/functions/data_filter.R")
  source("www/functions/barChart.R")
  source("www/functions/pie.R")
  source("www/functions/trendPlot.R")
  source("www/functions/km.R")
  
  # imported dataset
  data_final <- read_csv("https://raw.githubusercontent.com/mark1472834185/6600-final-project/main/shinyApp/www/data/final_revised_data.csv")
  
  
  
  # create reactive variables
  values <- reactiveValues(df = NULL,
                           year = NULL,
                           continent = NULL,
                           capital = NULL,
                           k = NULL)
  
  # observe Apply change button
  observeEvent(input$applyChanges, {
    # reassign the values
    values$year <- input$yearRange
    values$continent <- input$continent
    values$capital <- input$capitalType
    values$k <- input$k
    
    # Prepare the filtered data
    values$df <- data_filter(data_final,values$year,values$continent,values$capital)
  })
  
  
  observe({
    
    # update barChart when reactive values changed
    output$histogram <- renderPlot({ barChart(values$df,values$capital)})
    
    # update pie Chart when reactive values changed
    output$piechart <- renderPlot({ pie(values$df,values$capital) })
    
    # update trend Plot when reactive values changed
    output$trendPlot <- renderPlot({ trendPlot(values$df, values$capital) })
    
    # update kmeans clustering when reactive values changed
    output$pca_cluster_plot <- renderPlotly({ km(values$df,values$k) })
  })
  
  
  observeEvent(input$applyChanges, {
    output$planetImage_trend <- renderUI({
      if (input$applyChanges > 0 && input$capitalType == "Natural capital") {
        div(style = "display: flex; justify-content: center;",
            img(src = "https://raw.githubusercontent.com/mark1472834185/6600-final-project/main/shinyApp/www/figures/planet.png")
        )
      }
    })
  })
  
  observeEvent(input$applyChanges, {
    output$planetImage_pca <- renderUI({
      if (input$applyChanges > 0 && input$capitalType == "Natural capital") {
        div(style = "display: flex; justify-content: center;",
            img(src = "https://raw.githubusercontent.com/mark1472834185/6600-final-project/main/shinyApp/www/figures/planet.png")
        )
      }
    })
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