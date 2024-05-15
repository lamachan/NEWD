# Load required library
library(ggplot2)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
data <- na.omit(data)

data$opening_hours <- paste(data$openTime, "-", data$closeTime, sep = "")

# Count the number of shops with each opening hours
opening_hours_counts <- data %>%
  group_by(opening_hours) %>%
  summarise(num_shops = n()) %>%
  ungroup()

# Select the top 3 most common opening hours
top_3_opening_hours <- opening_hours_counts %>%
  arrange(desc(num_shops)) %>%
  head(3)

# Create barplot
barplot <- ggplot(top_3_opening_hours, aes(x = reorder(opening_hours, -num_shops), y = num_shops, fill = opening_hours)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Godziny otwarca", y = "Liczba Żabek", title = "Top 3 najczęstsze godziny otwarcia Żabek") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the barplot
print(barplot)
