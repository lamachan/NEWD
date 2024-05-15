# Zaimportowanie pakietu dplyr
library(dplyr)

# Obliczenie średniej długości SVL dla każdego gatunku
srednia_SVL <- dane %>%
  group_by(Species) %>%
  summarize(mean_SVL = mean(SVL, na.rm = TRUE))

# Obliczenie średniej wielkości oczu dla każdego gatunku
srednia_oczy <- dane %>%
  group_by(Species) %>%
  summarize(mean_eye_length = mean(Eye.length, na.rm = TRUE))

# Połączenie danych
dane_do_wykresu <- inner_join(srednia_SVL, srednia_oczy, by = "Species")

# Tworzenie wykresu punktowego
# Tworzenie wykresu punktowego
wykres_punktowy <- ggplot(dane_do_wykresu, aes(x = mean_SVL, y = mean_eye_length)) +
  geom_point(color = "lightgreen") + # Zmiana koloru punktów na zielony
  labs(title = "Zależność średniej wielkości oczu od średniej SVL",
       x = "Średnia SVL",
       y = "Średnia wielkość oczu") +
  theme_minimal()

# Wyświetlenie wykresu
print(wykres_punktowy)



