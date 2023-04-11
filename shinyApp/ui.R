# UI ----
library(DT)
library(shiny)
library(tidyverse)
library(leaflet)
library(plotly)
library(shinythemes)
library(bs4Dash)

# Define the Shiny app UI
ui1 <- fluidPage(
  # add a theme
  theme = shinytheme("darkly"),
  # App title
  titlePanel("General Wealth Analysis by Country Across the World --- Seattle OG"),
  
  # add a theme
  tags$head(
    tags$style(HTML("
    .irs-bar {
      ...
    }
    /* Add your custom CSS styles here */
    .sidebar {
      background-color: #f8f9fa;
      border-right: 1px solid #dee2e6;
      padding: 15px;
    }
    .sidebar h3 {
      color: #0c5460;
    }
    .sidebar .form-group {
      margin-bottom: 15px;
    }
    .sidebar .btn {
      background-color: #0c5460;
      color: #ffffff;
      font-weight: bold;
    }
    .sidebar .btn:hover {
      background-color: #0c5460;
      color: #ffffff;
      opacity: 0.9;
    }
  "))
  ),
  
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
      img(src="https://raw.githubusercontent.com/mark1472834185/6600-final-project/main/shinyApp/www/figures/earth.png", align = "right", width = "120px", height = "90px"),
      
      tabsetPanel(
        tabPanel("Relation Analysis",
                 conditionalPanel(
                   condition = "input.applyChanges > 0",
                   p("The generated barchart and piechart regarding the information on the side panel. Showing detailed relationship between
                    countries in the capital type and year range selected", style = "margin-top: 20px; margin-bottom: 20px;"),
                   div(style = "width: 100%; display: block;",
                       plotOutput("histogram")),
                   div(style = "width: 100%; height: 2px; background-color: gray; display: block; margin-top: 20px; margin-bottom: 20px;"),
                   div(style = "width: 100%; display: block;",
                 ),
                       plotOutput("piechart"))
        ),
        
        tabPanel("Trend Analysis",
                 conditionalPanel(
                   condition = "input.applyChanges > 0",
                   p("The generated Time-Series plot regarding the information on the side panel. Showing in detailed about the trend of each
                     country in the capital type selected and year range selected", style = "margin-top: 20px; margin-bottom: 20px;"),
                   plotlyOutput("trendPlot")
                 ),
                 
                 uiOutput("planetImage_trend")
                 
        ),
              
        tabPanel("PCA Cluster Analysis",
                 conditionalPanel(
                   condition = "input.applyChanges > 0",
                    p("The automatically generated PCA Cluster plot only respond to the change in year and continent information. Showing the relationship between
                      PC1 and PC2. In this case, the first 5 principal components have been chose for further analysis, since they are representing the 5 linear 
                      combinations of the original features that capture the most variation in the original Capital dataset. These components are uncorrelated with each other,
                      so that they are suitable for further analysis without redundancy. In the PCA plot, the x-axis (PC1) and the y-axis (PC2) are chosen because they are the first two principal components 
                      that capture the maximum amount of variation from the previous mentioned 5 principle components. By plotting the data points in this lower-dimensional space,  
                      visualization of the relationships and patterns in the data become clearer, that might not be apparent in the original higher-dimensional space 
                      ", style = "margin-top: 20px; margin-bottom: 20px;"),
                    plotlyOutput("pca_cluster_plot"),
                       sliderInput("k",
                                "Select k:",
                                min = 2,
                                max = 7,
                                value = 3),
                 ),
                 
                 uiOutput("planetImage_pca")
        )
      )
    )
  )
)
