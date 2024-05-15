# Load required library
library(ggplot2)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
data <- na.omit(data)

# Count the number of shops in each county
county_counts <- data %>%
  group_by(county) %>%
  summarise(num_shops = n()) %>%
  ungroup()

# Filter counties with lowercase first character
county_counts <- county_counts[substr(county_counts$county, 1, 1) == tolower(substr(county_counts$county, 1, 1)), ]

# Select the top 10 counties with the most shops
top_10_counties <- county_counts %>%
  arrange(desc(num_shops)) %>%
  head(10)

# Create barplot
barplot <- ggplot(top_10_counties, aes(x = reorder(county, -num_shops), y = num_shops, fill = county)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Powiat", y = "Liczba Żabek", title = "Top 10 powiatów (bez miast na prawach powiatu) z największą liczbą Żabek") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the barplot
print(barplot)
