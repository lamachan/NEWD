# Load required library
library(ggplot2)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
data <- na.omit(data)

# Count the number of shops in each voidodeship
voivodeship_counts <- data %>%
  group_by(voivodeship) %>%
  summarise(num_shops = n()) %>%
  ungroup()

# Create barplot
barplot <- ggplot(voivodeship_counts, aes(x = reorder(voivodeship, -num_shops), y = num_shops, fill = voivodeship)) +
  geom_bar(stat = "identity", fill='#00692b') +
  labs(x = "Województwo", y = "Liczba Żabek", title = "Liczba Żabek w poszczególnych województwach") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the barplot
print(barplot)
