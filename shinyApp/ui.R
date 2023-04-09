# UI ----
library(DT)
library(shiny)
library(tidyverse)
library(leaflet)

# Define the Shiny app UI
ui1 <- fluidPage(
  # App title
  titlePanel("General Wealth Analysis by Country Across the World --- Seattle OG"),
  
  # Add custom CSS for the slider input
  tags$head(
    tags$style(HTML("
      .irs-bar {
        background-color: grey !important;
        border: 1px solid lightgrey !important;
      }
      .irs-slider {
        border: 1px solid grey !important;
      }
      .irs-from, .irs-to {
        background-color: grey !important;
        border: 1px solid grey !important;
      }
    "))
  ),
  
  
  
  # Sidebar layout
  sidebarLayout(
    # Sidebar panel
    sidebarPanel(
      # Slider input for selecting year range
      sliderInput("yearRange", "Select Year Range:",
                  min = 1995, max = 2018, value = c(1995, 2018),
                  step = 1, animate = TRUE),
      
      # Checkboxes for selecting regions
      #Revise1 add South America
      #Revise2 change to the radio button
       radioButtons("continent", "Select continent:",
               choices = c("All", "Europe", "North America", "Asia", "Oceania", "South America", "Africa")),
       leafletOutput("map"),
      
      # Select input for selecting capital type
      selectInput("capitalType", "Select Capital Type:",
                  choices = c("Human capital", "Human capital per capita", "Human capital per capita, female", 
                              "Human capital per capita, male", "Human capital, female", "Human capital, male", "Natural capital", 
                              "Natural capital, agricultural land", "Natural capital, fisheries", "Natural capital, forests: ecosystem services", 
                              "Natural capital, forests: timber", "Natural capital, fossil fuels", "Natural capital, nonrenewable assets: coal", 
                              "Natural capital, nonrenewable assets: gas", "Natural capital, nonrenewable assets: minerals", "Natural capital, nonrenewable assets: oil", 
                              "Natural capital, renewable")),
      
      # Action button to apply changes
      actionButton("applyChanges", "Apply Changes")
    ),
    
    # Main panel
    mainPanel(
      # Output for displaying the histogram
      plotOutput("histogram")
    )
  )
)

