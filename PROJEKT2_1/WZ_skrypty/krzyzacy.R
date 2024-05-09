library(ggplot2)
library(reshape2)

krzyzacy <- read.table("../data/krzyzacy.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric"))
head(krzyzacy)

melted_krzyzacy <- melt(krzyzacy, id.vars = "Kwartały", variable.name = "Rodzaj", value.name = "Liczba")
head(melted_krzyzacy)

ggplot(melted_krzyzacy, aes(x = Kwartały, y = Liczba, fill = Rodzaj)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(title = "Liczebność Armii Polskiej w wojnie z Krzyżakami w 1520 r. ",
       x = "Kwartał",
       y = "Liczba",
       fill = "Rodzaj") +
  theme_minimal()

