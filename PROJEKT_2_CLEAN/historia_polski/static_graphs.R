library(ggplot2)
library(reshape2)
library(tidyr)

# ------------------------------------------------------------------------------
# KRZYŻACY
# ------------------------------------------------------------------------------
df <- read.table("./data/krzyzacy.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric"))
head(df)

melted_df <- melt(df, id.vars = "Kwartały", variable.name = "Rodzaj", value.name = "Liczba")
head(melted_df)

ggplot(melted_df, aes(x = Kwartały, y = Liczba, fill = Rodzaj)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(title = "Liczebność Armii Polskiej w wojnie z Krzyżakami w 1520 r. ",
       x = "Kwartał",
       y = "Liczba",
       fill = "Rodzaj") +
  theme_minimal()

# ------------------------------------------------------------------------------
# WYPRAWA POŁOCKA
# ------------------------------------------------------------------------------
df <- read.table("./data/wyprawa_polocka.txt", header = TRUE, sep = ";", colClasses = c("character", "character", "numeric"))
head(df)

df <- df %>%
  fill("rodzaj.wojska") %>%
  spread(key = "rodzaj.oddziału", value = "liczba", fill = 0)

df <- tidyr::pivot_longer(df, cols = -rodzaj.wojska, names_to = "rodzaj_oddzialu", values_to = "liczba")
head(df)

ggplot(df, aes(x = rodzaj.wojska, y = liczba, fill = rodzaj_oddzialu)) +
  geom_bar(stat = "identity") +
  labs(title = "Siły główne Rzeczypospolitej uczestniczące w Wyprawie Połockiej",
       x = "Rodzaj wojska",
       y = "Liczba żołnierzy") +
  scale_fill_manual(values = c("jazda" = "blue", "piechota" = "red", "nieokreślony" = "gray")) +
  theme_minimal()

# ------------------------------------------------------------------------------
# ODSIECZ WIEDEŃSKA
# ------------------------------------------------------------------------------
df <- read.table("./data/odsiecz_wiednia.txt", header = TRUE, sep = ';', colClasses = c("character", "character", "numeric", "numeric"))
head(df)

df_long <- df %>%
  pivot_longer(cols = c("Liczba.jednostek", "Liczba.żołnierzy"), names_to = "Typ", values_to = "Liczba")

df_long$Typ <- gsub("\\.", " ", df_long$Typ)
head(df_long)

ggplot(df_long, aes(x = Rodzaj, y = Liczba, fill = Podrodzaj)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~Typ, scales = "free_y") +
  labs(title = "Liczebność armii polskiej idącej na odsiecz Wiednia",
       x = "Rodzaj",
       y = "Liczba") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()
