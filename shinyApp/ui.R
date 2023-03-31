# UI ----
# test test

library(DT)
library(shiny)
library(tidyverse)


ui <- fluidPage(titlePanel("hw5 - IE6600 by Shucheng Zhang"),
                sidebarLayout(
                  sidebarPanel(
                    width = 2,
                    selectInput(
                      width = "100%",
                      inputId = "dbList1",
                      label = "Default Dataset List",
                      choices = c(choose = "List of data frame...",
                                  "mpg", "diamonds", "msleep"),
                      selectize = FALSE
                    ),
                    uiOutput("obs1"),
                    
                    # TODO Problem 3: Add one widget for BIN feature:
                    ## your code here ##
                    uiOutput("binInput"),
                    
                    
                    actionButton(
                      inputId = "reset",
                      label = "Reset Data",
                      icon = icon("refresh"),
                      width = "100%"
                    ),
                    verbatimTextOutput("aaa")
                  ),
                  mainPanel(fluidPage(fluidRow(
                    column(6,
                           DT::dataTableOutput("dataSet")),
                    column(6,
                           plotOutput(
                             "plotChart",
                             width = "100%",
                             height = "300px"
                           ))
                  )))
                ))