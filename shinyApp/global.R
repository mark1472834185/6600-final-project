# global settings ----
library(shiny)
library(tidyverse)
library(leaflet)
library(plotly)
library(shinythemes)
library(bs4Dash)

source("ui.R")
source("server.R")
shinyApp(ui = ui1, server = server)