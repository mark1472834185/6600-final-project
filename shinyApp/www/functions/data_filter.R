# this function use to filter the dataset and return a filtered dataset
# para: df, yearRange,
data_filter <- function(df,year,continent,capital){
  
  # if continent selector is all
  if(continent == "All"){
    res <- df[df$Year >= year[1] &
                df$Year <= year[2],]
  }else{
    # same except continent
    res <- df[df$Year >= year[1] &
                df$Year <= year[2]&
                df$Continent == continent,]
  }
  
  # return filtered df
  return(res)
}
