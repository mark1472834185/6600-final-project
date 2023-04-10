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
    coord_polar("y", start = 0) +
    theme_void() +
    theme(legend.position = "right", legend.text = element_text(size = 15),
          legend.title = element_text(size = 18),
          plot.title = element_text(size = 16, hjust = 0.5)) +
    labs(title = "Top 10 Countries by Total USD value shown in pie chart", fill = "Country")
  
  return(p)
}
