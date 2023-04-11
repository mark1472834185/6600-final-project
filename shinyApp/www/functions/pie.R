library(plotly)
# this function will draw a top10 pie Chart
# para: df, capital
pie <- function(df,capital){
  if (is.null(df)) {
    return(NULL)  # Do not render any plot
  }
  # Aggregate data by country and sum the USD values
  df_top10 <- df %>% 
    group_by(Country.Name) %>% 
    summarize_at(capital,sum,na.rm=TRUE) %>%
    arrange(desc(.data[[capital]])) %>% 
    head(10)  # Get the top 10 countries
  
  # draw a top10 pie chart
  # Create a pie chart using ggplot2
  p <- ggplot(df_top10, aes(x = "", y = .data[[capital]], fill = Country.Name)) +
    geom_bar(stat = "identity", width = 1) +
    theme_minimal() +
    coord_polar("y", start = 0) +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "gray20"),
      panel.background = element_rect(fill = "gray20"),
      axis.ticks = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank(),
      legend.position = "right",
      legend.text = element_text(size = 15, color = "white"),
      legend.title = element_text(size = 18, color = "white"),
      plot.title = element_text(size = 16, color = "white")
    ) +
    labs(title = "Top 10 Countries by Total USD value shown in pie chart", fill = "Country")
  
  return(p)
}
