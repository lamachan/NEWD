# Zaimportowanie pakietu ggplot2 do tworzenia wykresów
library(ggplot2)

# Zaimportowanie pakietu dplyr do manipulacji danymi
library(dplyr)

# Zaimportowanie pakietu tidyr do manipulacji danymi
library(tidyr)

# Wybieranie tylko kolumn numerycznych
dane_num <- dane %>%
  select_if(is.numeric)

# Przekształcenie danych na format długi
dane_long <- dane_num %>%
  gather(key = "measurement", value = "value")

# Tworzenie histogramu dla każdej zmiennej numerycznej
# Tworzenie histogramu dla każdej zmiennej numerycznej
wykresy_histogram <- ggplot(dane_long, aes(x = value, fill = measurement)) +
  geom_histogram(binwidth = 2, color = "black") +
  facet_wrap(~ measurement, scales = "free") +
  labs(title = "Histogramy pomiarów", x = "Wartość", y = "Liczba przypadków") +
  theme_minimal() +
  theme(axis.text = element_text(color = "black"),
        axis.title = element_text(color = "black"),
        legend.title = element_text(color = "black"),
        legend.text = element_text(color = "black")) +
  scale_fill_manual(values = c("Head.width" = "green", "Head.length" = "green", "Internarial" = "green", "Interorbital" = "green",
                               "Eye.length" = "green", "Eye.naris" = "green", "Naris.snout" = "green", 
                               "Antebrachial.length" = "green", "Femur.length" = "green", "Tibio.fibula" = "green"))

# Wyświetlenie histogramów
print(wykresy_histogram)
