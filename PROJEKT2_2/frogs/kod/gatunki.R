# Zaimportowanie pakietu ggplot2 do tworzenia wykresów
library(ggplot2)

# Zaimportowanie pakietu dplyr
library(dplyr)

# Wybieranie tylko kolumn numerycznych
dane_num <- dane %>%
  select_if(is.numeric)

# Obliczenie średnich wartości dla każdego gatunku
srednie <- sapply(dane_num, function(x) if(is.numeric(x)) mean(x, na.rm = TRUE) else NA)

# Konwersja wyników na data frame
srednie_df <- as.data.frame(t(srednie))

# Dodanie nazw kolumn
colnames(srednie_df) <- c("Head.length", "Head.width")

# Dodanie kolumny z nazwami gatunków
srednie_df$Species <- rownames(srednie_df)

# Tworzenie interaktywnego wykresu ggplot2
wykres <- ggplot(srednie_df, aes(x = Head.length, y = Head.width, text = Species)) +
  geom_point(color = "darkgreen") +
  labs(title = "Średnia długość i szerokość głowy dla każdego gatunku",
       x = "Średnia długość głowy", y = "Średnia szerokość głowy") +
  theme_minimal()

# Konwersja na wykres interaktywny
wykres_interaktywny <- ggplotly(wykres)

# Wyświetlenie wykresu interaktywnego
print(wykres_interaktywny)
