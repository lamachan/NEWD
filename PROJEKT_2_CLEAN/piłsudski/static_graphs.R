library(forcats)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(grid)
library(gridExtra)

dane_bitwa_warszawska <- read.csv("bitwa_warszawska.csv", check.names = F, stringsAsFactors = FALSE)

dane_siły <- dane_bitwa_warszawska %>%
  pivot_longer(
    cols = 1:4,
    names_to = "Kategorie",
    values_to = "Wartosci",
    values_drop_na = TRUE
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

# ------------------------------------------------------------------------------
# PORÓWNANIE SIŁ W BITWIE WARSZAWSKIEJ
# ------------------------------------------------------------------------------
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
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

# ------------------------------------------------------------------------------
# PORÓWNANIE STRAT W BITWIE WARSZAWSKIEJ
# ------------------------------------------------------------------------------
combined_data <- c(dane_armia_polska$Wartosci, dane_armia_rosyjska$Wartosci)
y_lim_max <- range(combined_data)[2] + 10000

g1 <- ggplot(dane_armia_polska, aes(x = Kategorie, y = Wartosci)) +
  geom_bar(stat = "identity", fill = "#0c7ea4", width = .4) +
  coord_flip() +
  geom_text(aes(label = Wartosci), position = position_dodge(width = 0.9), hjust = -0.1) +
  xlab("Armia polska") +
  ylab("Wartości") +
  ylim(0,y_lim_max) +
  theme_bw() +
  theme(
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

g2 <- ggplot(dane_armia_rosyjska, aes(x = Kategorie, y = Wartosci)) +
  geom_bar(stat = "identity", fill = "#c64f4a", width = .4) +
  coord_flip() +
  geom_text(aes(label = Wartosci), position = position_dodge(width = 0.9), hjust = -0.1) +
  xlab("Armia rosyjska") +
  ylab("Wartości") +
  ylim(0,y_lim_max) +
  theme_bw() +
  theme(
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14)
  )

title <- textGrob("Porównanie strat w Bitwie Warszawskiej", gp = gpar(fontsize = 20, fontface = "bold"))
grid.arrange(g1, g2, ncol = 2, top = title)