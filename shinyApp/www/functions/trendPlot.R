

# this function will draw a top10 trendPlot
# para: df, capital
trendPlot <- function(df,capital){
  if (is.null(df)) {
    return(NULL)  # Do not render any plot
  }
  # Aggregate data by country and sum the USD values
  df_top10 <- df %>% 
    group_by(Country.Name) %>% 
    summarize_at(capital,sum,rm.na=TRUE) %>%
    arrange(desc(.data[[capital]])) %>% 
    head(10)  # Get the top 10 countries
  
  # Filter data to get the top 10 countries
  top_countries <- df_top10$Country.Name
  
  # Filter the data to include only the top 10 countries
  trend_data <- df %>%
    filter(Country.Name %in% top_countries)
  
  # Generate the trend line plot
  p <- ggplot(trend_data, aes(x = Year, y = .data[[capital]], color = Country.Name)) +
    geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf),
              fill = "gray20", alpha = 0.3) + 
    geom_line(size = 1) +
    theme_minimal() +
    theme(plot.background = element_rect(fill = "gray20"),
          panel.background = element_rect(fill = "gray20"),
          axis.text.x = element_text(angle = 45, hjust = 1, size = 14, color = "white"),
          axis.text.y = element_text(size = 14, color = "white"),
          axis.title.x = element_text(size = 14, color = "white"),
          axis.title.y = element_text(size = 14, color = "white"),
          plot.title = element_text(size = 16, color = "white"),
          legend.text = element_text(size = 15, color = "white"),
          legend.title = element_text(size = 16, color = "white")) +
    labs(x = "Year", y = "Total USD", title = "Trend Analysis for Top 10 Countries")

  return(ggplotly(p))


}