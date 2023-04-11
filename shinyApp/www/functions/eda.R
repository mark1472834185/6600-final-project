testdata <- read.csv("C:/Data/revised_data.csv")
head(testdata)
unique_countries <- unique(testdata$Country.Name)
print(unique_countries)
summary(c_name)

continent_count <- c_name %>%
  group_by(Continent) %>%
  summarize(count = n())

# Create a pie chart
ggplot(data = continent_count, aes(x = "", y = count, fill = Continent)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("#9999CC", "#66CC99", "skyblue", "yellow", "purple", "grey")) +
  labs(title = "Number of Countries by Continent") +
  theme_void() +
  geom_text(aes(label = count), position = position_stack(vjust = 0.5), size = 5) +
  theme(legend.text = element_text(size = 18))

continent_country <- c_name %>%
  group_by(Continent) %>%
  slice_head(n = 5) %>%
  summarize(Country.Name = paste(Country.Name, collapse = ", "))

# Print the resulting summary dataset
print(continent_country)

colSums(is.na(merged_df))
na_rows <- which(apply(is.na(clean_data), 1, any))

# Print the row indices
print(na_rows)

clean_data <- merged_df[complete.cases(merged_df), ]

# Print the resulting dataset
print(clean_data)

unique_series <- unique(merged_df$Series.Name)
summary_df <- data.frame(Series_Name = unique_series)

# Print the resulting summary dataframe
print(summary_df)

names(merged_df)[6] <- "Total_USD"
names(merged_df)[3] <- "capitalType"
merged_df <- merged_df[, -c(2, 4)]
summary(merged_df)

subset_data <- subset(merged_df, Country.Name %in% c("United States", "China") & Year == 2018 & capitalType == "Natural capital (constant 2018 US$)")

# Create the ggplot with the subset data
ggplot(subset_data, aes(x = Country.Name, y = Total_USD)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Comparison of Natural Capital between US and China in 2018",
       x = "Country", y = "Natural Capital (constant 2018 US$)") +
  theme_minimal()

subset_data_2 <- subset(merged_df, Country.Name %in% c("United States", "Russia") & capitalType == "Natural capital per capita, fossil fuels (constant 2018 US$)" & Year >= 2000 & Year <= 2010)

# Create the ggplot with the subset data
ggplot(subset_data_2, aes(x = Year, y = Total_USD, color = Country.Name, group = Country.Name)) +
  geom_line(size = 1.5) +
  labs(title = "Comparison of Natural Capital per Capita, Fossil Fuels between US and Russia (2000-2010)",
       x = "Year", y = "Natural Capital per Capita, Fossil Fuels (constant 2018 US$)") +
  theme_minimal()