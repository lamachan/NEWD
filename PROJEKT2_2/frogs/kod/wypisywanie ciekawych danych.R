# Zaimportowanie pakietu dplyr
library(dplyr)

# Obliczenie średniej wielkości oczu dla każdego gatunku
srednia_oczy <- dane %>%
  group_by(Species) %>%
  summarize(mean_eye_length = mean(Eye.length, na.rm = TRUE))

# Obliczenie średniej długości ciała (SVL) dla każdego gatunku
srednia_SVL <- dane %>%
  group_by(Species) %>%
  summarize(mean_SVL = mean(SVL, na.rm = TRUE))

# Połączenie danych
dane_do_sortowania <- inner_join(srednia_oczy, srednia_SVL, by = "Species")

# Obliczenie stosunku oczy do długości ciała (SVL)
dane_do_sortowania <- dane_do_sortowania %>%
  mutate(oczy_do_SVL = mean_eye_length / mean_SVL) %>%
  arrange(oczy_do_SVL) # Sortowanie rosnąco według stosunku oczy do długości ciała

# Obliczenie maksymalnego stosunku oczy do długości ciała
najwiekszy_stosunek_oczy_do_SVL <- dane_do_sortowania %>%
  arrange(desc(oczy_do_SVL)) # Sortowanie malejąco według stosunku oczy do długości ciała

# Wyświetlenie wyników
print("Gatunki według największej średniej długości SVL:")
print(head(srednia_SVL, n = 5))

print("Gatunki według najmniejszej średniej długości SVL:")
print(head(srednia_SVL %>% arrange(mean_SVL), n = 5))

print("Gatunki według najmniejszego stosunku oczy do reszty ciała:")
print(head(dane_do_sortowania, n = 5))

print("Gatunki według największego stosunku oczy do reszty ciała:")
print(head(najwiekszy_stosunek_oczy_do_SVL, n = 5))
