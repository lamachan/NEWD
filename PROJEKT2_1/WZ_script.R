library(ggplot2)
library(reshape2)

setwd("D:/DOKUMENTY/STUDIA/SEMESTR 6/NEWD/PROJEKT/NEWD/PROJEKT2_1")
data <- read.table("data/krzyzacy.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric"))
head(data)

data_long <- melt(data, id.vars = "Kwartały", variable.name = "Rodzaj", value.name = "Liczba")
head(data_long)

ggplot(data_long, aes(x = Kwartały, y = Liczba, fill = Rodzaj)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(title = "Liczebność Armii Polskiej w wojnie z Krzyżakami w 1520 r. ",
       x = "Kwartał",
       y = "Liczba",
       fill = "Rodzaj") +
  theme_minimal()