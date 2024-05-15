dane <- read.csv("../measurements_frogs.csv")

library(ggplot2)

histogram <- ggplot(dane, aes(x = Head.length)) +
  geom_histogram(binwidth = 1, fill = "darkgreen", color = "black") +
  labs(title = "Rozkład długości głowy", x = "Długość głowy", y = "Liczba obserwacji") +
  theme_minimal()

print(histogram)