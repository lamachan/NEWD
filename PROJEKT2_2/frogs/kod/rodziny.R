dane <- read.csv("../measurements_frogs.csv")

library(ggplot2)

wykres_slupkowy <- ggplot(dane, aes(x = Family)) +
  geom_bar(fill = "lightgreen") +
  labs(title = "Liczba obserwacji dla każdej rodziny", x = "Rodzina", y = "Liczba obserwacji") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(wykres_slupkowy)
