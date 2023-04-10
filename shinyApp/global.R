# global settings ----
library(shiny)
library(tidyverse)
library(leaflet)
library(plotly)


source("ui.R")
source("server.R")

shinyApp(ui = ui1, server = server1)