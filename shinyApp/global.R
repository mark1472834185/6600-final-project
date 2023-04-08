# global settings ----
library(shiny)
library(tidyverse)


source("ui.R")
source("server.R")

shinyApp(ui = ui1, server = server1)