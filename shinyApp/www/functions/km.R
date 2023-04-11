

# this function apply kemans with df, n-clusters 
# return a scatter plot with clusters label

km <- function(df,k){
  if (is.null(df)) {
    return(NULL)  # Do not render any plot
  }
  set.seed(11)
  
  library(dplyr)
  
  # Aggregate data by country and sum the USD values
  df <- df %>% 
    group_by(Country.Name) %>%
    summarise(across(where(is.numeric), sum))
  
  # Remove columns with zero variance
  df_numeric <- df[,3:ncol(df)] %>% select(where(function(x) var(x) != 0))
  print(df_numeric)
  # dimensionality reduction (PCA)
  df_pca <- prcomp(df_numeric, scale. = TRUE)
  
  # Transform the data using the selected principal components
  num_pcs <- 3
  pca_transformed_data <- predict(df_pca, newdata = df_numeric)[, 1:num_pcs]
  
  # Perform k-means clustering on the transformed data
  kmeans_result <- kmeans(pca_transformed_data, centers = min(k, nrow(pca_transformed_data)))
  
  # Combine original df and cluster label
  df_clustered <- cbind(df, cluster = kmeans_result$cluster)
  
  # Combine the original dataset with the PCA transformed data and cluster assignments
  data_pca_clustered <- cbind(df, pca_transformed_data, cluster = kmeans_result$cluster)
  data_pca_clustered$cluster <- as.factor(data_pca_clustered$cluster)
  
  # Create a Plotly PCA clustering plot
  fig <- plot_ly(data_pca_clustered, type = "scatter", mode = "markers",
                 x = ~PC1, y = ~PC2,
                 text = ~Country.Name,
                 marker = list(symbol = ~cluster, color = ~cluster, size = 10, showscale = FALSE),
                 hovertemplate = "Country: %{text}<br>Cluster: %{marker.symbol}",
                 showlegend = F) %>%
    layout(
      plot_bgcolor = "rgba(0,0,0,0)",
      paper_bgcolor = "rgba(0,0,0,0)",
      xaxis = list(
        title = "PC1",
        zerolinecolor = "white",
        tickfont = list(color = "white"),
        showgrid = FALSE,
        gridcolor = "gray20",
        linecolor = "gray20",
        titlefont = list(color = "white")
      ),
      yaxis = list(
        title = "PC2",
        zerolinecolor = "white",
        tickfont = list(color = "white"),
        showgrid = FALSE,
        gridcolor = "gray20",
        linecolor = "gray20",
        titlefont = list(color = "white")
      ),
      title = list(
        text = "PCA Cluster Analysis",
        font = list(color = "white")
      ),
      legend = list(
        font = list(color = "white")
      ),
      margin = list(l = 50, r = 50, b = 50, t = 50, pad = 0)
    )
  
  return(fig)
}




