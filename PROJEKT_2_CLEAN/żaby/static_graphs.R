library(ggplot2)
library(dplyr)

dane <- read.csv("measurements_frogs.csv")

# ------------------------------------------------------------------------------
# ROZKŁAD SVL (SNOUT-VENT LENGTH)
# ------------------------------------------------------------------------------
histogram_SVL <- ggplot(dane, aes(x = SVL)) +
  geom_histogram(binwidth = 1, fill = "green", color = "black") +
  labs(title = "Rozkład pomiaru SVL", x = "SVL", y = "Liczba przypadków") +
  theme_minimal()

print(histogram_SVL)

# ------------------------------------------------------------------------------
# ZALEŻNOŚĆ ŚREDNIEJ WIELKOŚCI OCZU OD ŚREDNIEJ SVL
# ------------------------------------------------------------------------------
srednia_SVL <- dane %>%
  group_by(Species) %>%
  summarize(mean_SVL = mean(SVL, na.rm = TRUE))

srednia_oczy <- dane %>%
  group_by(Species) %>%
  summarize(mean_eye_length = mean(Eye.length, na.rm = TRUE))

dane_do_wykresu <- inner_join(srednia_SVL, srednia_oczy, by = "Species")

wykres_punktowy <- ggplot(dane_do_wykresu, aes(x = mean_SVL, y = mean_eye_length)) +
  geom_point(color = "lightgreen") +
  labs(title = "Zależność średniej wielkości oczu od średniej SVL",
       x = "Średnia SVL",
       y = "Średnia wielkość oczu") +
  theme_minimal()

print(wykres_punktowy)

# ------------------------------------------------------------------------------
# ROZKŁAD DŁUGOŚCI GŁOWY
# ------------------------------------------------------------------------------
histogram <- ggplot(dane, aes(x = Head.length)) +
  geom_histogram(binwidth = 1, fill = "darkgreen", color = "black") +
  labs(title = "Rozkład długości głowy", x = "Długość głowy", y = "Liczba obserwacji") +
  theme_minimal()

print(histogram)