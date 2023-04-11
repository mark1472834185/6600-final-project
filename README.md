## General Wealth Analysis by Country Across the World

This is a R Shiny App Project to discover the Total value of USD by different or combination of continents, year, and capital type.

## Dataset

This a public dataset named wealth account from the World Bank. 
https://databank.worldbank.org/source/wealth-accounts#

## Introduction

We design a slider input for users to drag and adjust the year range, a interactive map to allow users to zoom in and select specific continent and a select box input to decide the capital type on the UI. On the right side of the UI, there are three types of analysis such as relation analysis, trend analysis, and PCA cluster analysis. In the server part the function will generate pie chart, histogram, line chart and scatter plot for the corresponding analysis and display on the UI. The top 10 countries of selected continents will be shown in the plot.

Required R packages: 

shiny, tidyverse, leaflet, plotly, shinythemes, bs4Dash, ggplot2, dplyr, and DT.

Deployed R shiny link: 
