library(ggplot2)
library(tidyr)

# Your data
df <- read.table("../data/wyprawa_polocka.txt", header = TRUE, sep = ";", colClasses = c("character", "character", "numeric"))

# Reshape data for plotting
df <- df %>%
  fill("rodzaj.wojska") %>%
  spread(key = "rodzaj.oddziału", value = "liczba", fill = 0)

df <- tidyr::pivot_longer(df, cols = -rodzaj.wojska, names_to = "rodzaj_oddzialu", values_to = "liczba")


# Plot
ggplot(df, aes(x = rodzaj.wojska, y = liczba, fill = rodzaj_oddzialu)) +
  geom_bar(stat = "identity") +
  labs(title = "Siły główne Rzeczypospolitej uczestniczące w Wyprawie Połockiej",
       x = "Rodzaj wojska",
       y = "Liczba żołnierzy") +
  scale_fill_manual(values = c("jazda" = "blue", "piechota" = "red", "nieokreślony" = "gray")) +  # Colors for each rodzaj oddzialu
  theme_minimal()
