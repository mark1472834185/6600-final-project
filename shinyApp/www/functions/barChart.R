

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
    geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf),
              fill = "gray20", alpha = 0.3) + 
    geom_bar(stat = "identity", fill = "darkgrey") +
    theme_minimal() +
    theme(plot.background = element_rect(fill = "gray20"),
          panel.background = element_rect(fill = "gray20"),
          axis.text.x = element_text(angle = 45, hjust = 1, size = 14, color = "white"),
          axis.text.y = element_text(size = 14, color = "white"),
          axis.title.x = element_text(size = 16, color = "white"),
          axis.title.y = element_text(size = 16, color = "white"),
          plot.title = element_text(size = 18, color = "white")) +
    labs(x = "Country Name", y = "Total USD", title = "Top 10 Countries by Total USD value shown in Bar chart")
  
  return(p)
}
