library(ggplot2)
library(tidyr)

# Your data
df <- read.table("../data/odsiecz_wiednia.txt", header = TRUE, sep = ';', colClasses = c("character", "character", "numeric", "numeric"))

# Reshape the data for plotting
df_long <- df %>%
  pivot_longer(cols = c("Liczba.jednostek", "Liczba.żołnierzy"), names_to = "Typ", values_to = "Liczba")

df_long$Typ <- gsub("\\.", " ", df_long$Typ)  # Replace "." with space

# Plot
ggplot(df_long, aes(x = Rodzaj, y = Liczba, fill = Podrodzaj)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~Typ, scales = "free_y") +
  labs(title = "Liczebność armii polskiej idącej na odsiecz Wiednia",
       x = "Rodzaj",
       y = "Liczba") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()

