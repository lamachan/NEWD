library(forcats)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(grid)
library(gridExtra)

# setwd("C:/Users/alaoc/OneDrive/Dokumenty/Semestr 6/Wizualizacja Danych/Projekt 2. R")
dane_bitwa_warszawska <- read.csv("Bitwa Warszawska.csv", check.names = F, stringsAsFactors = FALSE)

dane_siły <- dane_bitwa_warszawska %>%
  pivot_longer(
    cols = 1:4,
    names_to = "Kategorie",
    values_to = "Wartosci",
    values_drop_na = TRUE # Opcjonalnie można usunąć NA
  ) %>%
  mutate(
    Strona = rep(c("Armia polska", "Armia rosyjska"), each = 4)
  )


dane_armia_polska <- dane_bitwa_warszawska[5:8] %>%
  pivot_longer(
    cols = 1:4, 
    names_to = "Kategorie", 
    values_to = "Wartosci"
  ) %>%
  slice(1:4)

dane_armia_polska <- na.omit(dane_armia_polska)

dane_armia_rosyjska <- dane_bitwa_warszawska[2,5:8] %>%
  pivot_longer(
    cols = 1:4, 
    names_to = "Kategorie", 
    values_to = "Wartosci"
  ) %>%
  slice(1:4)

dane_armia_rosyjska <- na.omit(dane_armia_rosyjska)

# Wykres słupkowy porównujący siły armii
ggplot(dane_siły, aes(x = Kategorie, y = Wartosci, fill = Strona)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.4) +
  coord_flip() +
  geom_text(aes(label = Wartosci), position = position_dodge(width = 0.9), hjust = -0.1) +
  xlab("") +
  ylab("Wartości") +
  ggtitle("Porównanie sił w Bitwie Warszawskiej") +
  scale_fill_manual(values = c("Armia polska" = "#0c7ea4", "Armia rosyjska" = "#c64f4a")) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5), # Ustawienia tytułu
    axis.text = element_text(size = 12),  # Zmiana rozmiaru tekstu na osiach
    axis.title = element_text(size = 14)  # Zmiana rozmiaru tytułów osi
  )

combined_data <- c(dane_armia_polska$Wartosci, dane_armia_rosyjska$Wartosci)
y_lim_max <- range(combined_data)[2] + 10000

# Wykres słupkowy strat armii polskiej
g1 <- ggplot(dane_armia_polska, aes(x = Kategorie, y = Wartosci)) +
  geom_bar(stat = "identity", fill = "#0c7ea4", width = .4) +
  coord_flip() +
  geom_text(aes(label = Wartosci), position = position_dodge(width = 0.9), hjust = -0.1) +
  xlab("Armia polska") +
  ylab("Wartości") +
  ylim(0,y_lim_max) +
  theme_bw() +
  theme(
    axis.text = element_text(size = 12),  # Zmiana rozmiaru tekstu na osiach
    axis.title = element_text(size = 14)  # Zmiana rozmiaru tytułów osi
  )

# Wykres słupkowy strat armiim rosyjskiej
g2 <- ggplot(dane_armia_rosyjska, aes(x = Kategorie, y = Wartosci)) +
  geom_bar(stat = "identity", fill = "#c64f4a", width = .4) +
  coord_flip() +
  geom_text(aes(label = Wartosci), position = position_dodge(width = 0.9), hjust = -0.1) +
  xlab("Armia rosyjska") +
  ylab("Wartości") +
  ylim(0,y_lim_max) +
  theme_bw() +
  theme(
    axis.text = element_text(size = 12),  # Zmiana rozmiaru tekstu na osiach
    axis.title = element_text(size = 14)  # Zmiana rozmiaru tytułów osi
  )

title <- textGrob("Porównanie strat w Bitwie Warszawskiej", gp = gpar(fontsize = 20, fontface = "bold"))
grid.arrange(g1, g2, ncol = 2, top = title)

dane <- data.frame(
  Kategoria = c("Produkt A", "Produkt A", "Produkt B", "Produkt B", "Produkt C", "Produkt C"),
  Kwartał = c("Q1", "Q2", "Q1", "Q2", "Q1", "Q2"),
  Sprzedaż = c(200, 150, 100, 120, 180, 160)
)

ggplot(dane, aes(x = Kwartał, y = Sprzedaż, fill = Kategoria)) +
  geom_bar(stat = "identity", position = "stack") +
  coord_flip() +
  ggtitle("Skumulowany wykres paskowy sprzedaży po kwartałach") +
  xlab("Kwartał") +
  ylab("Sprzedaż") +
  theme_minimal()

