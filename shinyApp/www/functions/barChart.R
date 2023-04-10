

# this function will draw a top10 barChart
# para: df, capital
barChart <- function(df,capital){
  if (is.null(df)) {
    return(NULL)  # Do not render any plot
  }
  # Aggregate data by country and sum the USD values
  df_top10 <- df %>% 
    group_by(Country.Name) %>% 
    summarize_at(capital,sum,na.rm=TRUE) %>%
    arrange(desc(.data[[capital]])) %>% 
    head(10)  # Get the top 10 countries
  
  # draw a top10 bar
  p <- ggplot(df_top10, aes(x = reorder(Country.Name, .data[[capital]]), y = .data[[capital]] ) )  +
    geom_bar(stat = "identity", fill = "darkgrey") +
    theme(plot.background = element_rect(fill = "transparent"),
          panel.background = element_rect(fill = "transparent"),
          axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
          axis.text.y = element_text(size = 14),
          axis.title.x = element_text(size = 16),
          axis.title.y = element_text(size = 16),
          plot.title = element_text(size = 18)) +
    labs(x = "Country Name", y = "Total USD", title = "Top 10 Countries by Total USD value shown in Bar chart")
  
  return(p)
}
