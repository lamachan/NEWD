# Load required library
library(ggplot2)
library(gridExtra)

# Load the CSV data
data <- read.csv("../zabka_shops.csv")

# Filter out rows with missing values
data <- na.omit(data)

data$open_seconds <- data$closeTimeSeconds - data$openTimeSeconds
data$open_seconds <- ifelse(data$open_seconds < 0, 86400 + data$open_seconds, data$open_seconds)
data$open_hours <- data$open_seconds / 3600

histogram <- hist(data$open_hours,
     main = "Histogram - czas otwarcia",
     xlab = "Liczba godzin",
     ylab = "Liczba Żabek",
     breaks = 10,
     col = '#00692b',
     plot = FALSE)

boxplot <- ggplot(data, aes(y = open_hours)) +
  geom_boxplot(fill = "#00692b", color = "black") +
  labs(title = "Wykres pudełkowy - czas otwarcia", y = "Liczba godzin")

hist_gg <- ggplot(data.frame(x = histogram$mids, y = histogram$counts), aes(x, y)) +
  geom_bar(stat = "identity", fill = "#00692b") +
  theme_minimal() +
  labs(title = "Histogram - czas otwarcia", x = "Liczba godzin", y = "Liczba Żabek")

# Arrange the plots side by side
grid.arrange(hist_gg, boxplot, ncol = 2)