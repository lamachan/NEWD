library(highcharter)
library(htmlwidgets)

dane <- read.csv("measurements_frogs.csv")

unikalne_rodziny <- length(unique(dane$Family))
print(unikalne_rodziny)

dane_treemap <- aggregate(x = list(Freq = dane$Family), by = list(Family = dane$Family), FUN = length)
dane_hier <- data_to_hierarchical(dane_treemap, c("Family", "Freq"))

hc <- hchart(dane_hier, type = "treemap", allowDrillToNode = TRUE, layoutAlgorithm = "squarified",
             dataLabels = list(enabled = TRUE, format = '{point.name}'),
             levelIsConstant = FALSE, name = "Podział zbioru według rodziny"
    		 ) %>%
  hc_title(
    text = "Podział zbioru według rodziny",
    style = list(fontSize = "20px", color = "#000000")
  )

saveWidget(hc, "./dynamic_graphs/frogs_treemap.html")
