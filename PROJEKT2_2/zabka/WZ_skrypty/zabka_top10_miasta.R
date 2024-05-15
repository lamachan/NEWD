# Load required library
library(ggplot2)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
data <- na.omit(data)

# Count the number of shops in each city
city_counts <- data %>%
  group_by(city) %>%
  summarise(num_shops = n()) %>%
  ungroup()

# Select the top 10 cities with the most shops
top_10_cities <- city_counts %>%
  arrange(desc(num_shops)) %>%
  head(10)

# Create barplot
barplot <- ggplot(top_10_cities, aes(x = reorder(city, -num_shops), y = num_shops, fill = city)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Miasto", y = "Liczba Żabek", title = "Top 10 miast z największą liczbą Żabek") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the barplot
print(barplot)
