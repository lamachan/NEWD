library(shiny)
library(ggplot2)
library(tidyr)

dane <- read.table("./data/powstanie_kosciuszkowskie.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric", "numeric", "numeric"))
head(dane)

wszystkie_kolumny <- colnames(dane[,-1])

ui <- fluidPage(
  titlePanel("Powstanie Kościuszkowskie"),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
    ),
    mainPanel(
      plotOutput("wykres", height = "700px")
    )
  )
)

server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    if (is.null(input$kolumny) || length(input$kolumny) == 0) {
      input$kolumny <- "Miesiące"
    }
    
    dane_do_wykresu <- dane_do_wykresu[, c("Miesiące", input$kolumny), drop = FALSE]
    dane_do_wykresu$Miesiące <- factor(dane_do_wykresu$Miesiące, levels = unique(dane$Miesiące))
    
    dane_long <- pivot_longer(dane_do_wykresu, cols = -Miesiące, names_to = "Kolumna", values_to = "Wartosc")
    dane_long$Kolumna <- gsub("\\.", " ", dane_long$Kolumna)
    
    ggplot(dane_long, aes(x = Miesiące, y = Wartosc, group = Kolumna, color = Kolumna)) +
      geom_line(linewidth = 1.5) +
      labs(title = "Liczba jednostek w poszczególnych miesiącach", x = "Miesiąc", y = "Liczba jednostek") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 22),
            legend.text = element_text(size = 12)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2))
  })
}

shinyApp(ui = ui, server = server)