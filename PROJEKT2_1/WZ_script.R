library(ggplot2)
library(reshape2)

setwd("D:/DOKUMENTY/STUDIA/SEMESTR 6/NEWD/PROJEKT/NEWD/PROJEKT2_1")
krzyzacy <- read.table("data/krzyzacy.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric"))
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

kosciuszko <- read.table("data/powstanie_kosciuszkowskie.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric", "numeric", "numeric"))
head(kosciuszko)

# Load the required libraries
library(plotly)
library(dplyr)
library(tidyr)

# Convert Miesiące column to factor
kosciuszko$Miesiące <- as.factor(kosciuszko$Miesiące)

# Melt the data frame to long format for plotting
kosciuszko_pivot <- pivot_longer(kosciuszko, cols = -Miesiące, names_to = "Type", values_to = "Count")

ggplot_obj <- ggplot(kosciuszko_pivot, aes(x = Miesiące, y = Count, fill = Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Monthly Military Personnel Counts",
       x = "Month",
       
       y = "Count",
       fill = "Type")

# Convert ggplot object to plotly
plotly_obj <- ggplotly(ggplot_obj)

# Show the plot
plotly_obj








library(plotly)

fig <-  plot_ly(x = c(0,1, 2), y = c(2, 1, 3), type = 'bar') %>%
  layout(title = 'A Figure Displaying Itself',
         plot_bgcolor='#e5ecf6', 
         xaxis = list( 
           zerolinecolor = '#ffff', 
           zerolinewidth = 2, 
           gridcolor = 'ffff'), 
         yaxis = list( 
           zerolinecolor = '#ffff', 
           zerolinewidth = 2, 
           gridcolor = 'ffff'))

fig
