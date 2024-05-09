library(ggplot2)

# Dane
dane <- data.frame(
  Rodzaj = c("Jazda chorągwi-husaria", "Jazda chorągwi-arkebuzerzya", "Jazda chorągwi-pancerni", 
             "Jazda chorągwi-lekka jazda", "Jazda chorągwi-kozacy", "Dragonia", 
             "Piechota", "Węgrzy i janczarzy", "Obsługa artylerii"),
  Liczba_jednostek = c(23, 3, 53, 26, 1, 7, 21, 3, 0),
  Liczba_żołnierzy = c(2670, 530, 5100, 1900, 150, 2800, 7150, 500, 150)
)

# Wykres
ggplot(dane, aes(x = Rodzaj, y = Liczba_żołnierzy, fill = Rodzaj)) +
  geom_bar(stat = "identity") +
  labs(title = "Liczba żołnierzy w różnych rodzajach jednostek",
       x = "Rodzaj",
       y = "Liczba żołnierzy") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")
