# Zaimportowanie pakietu ggplot2 do tworzenia wykresów
library(ggplot2)

# Tworzenie histogramu dla pomiaru SVL
histogram_SVL <- ggplot(dane, aes(x = SVL)) +
  geom_histogram(binwidth = 1, fill = "green", color = "black") +
  labs(title = "Histogram pomiaru SVL", x = "SVL", y = "Liczba przypadków") +
  theme_minimal()

# Wyświetlenie histogramu
print(histogram_SVL)
