library(shiny)
library(ggplot2)
library(tidyr)

dane <- read.table("./data/korpus_oficerski_1921.txt", header = TRUE, sep = ";", colClasses = c("character", "numeric", "numeric", "numeric", "numeric", "numeric"))

wszystkie_kolumny <- colnames(dane)

ui <- fluidPage(
  titlePanel("Korpus oficerski 1921 r."),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_stopien", "Filtruj stopnie:", choices = c("Wszystkie", unique(dane$Stopien)), selected = "Wszystkie", multiple = TRUE) # zaznaczone "Wszystkie" domyślnie
    ),
    mainPanel(
      plotOutput("wykres", height = "500px")
    )
  )
)

server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    if (is.null(input$kolumny) || length(input$kolumny) == 0) {
      input$kolumny <- "Stopien"
    }

    if (is.null(input$filtr_stopien) || length(input$filtr_stopien) == 0 || "Wszystkie" %in% input$filtr_stopien) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Stopien %in% input$filtr_stopien, ]
    }
    
    dane_do_wykresu <- dane_do_wykresu[, input$kolumny, drop = FALSE]

    dane_long <- pivot_longer(dane_do_wykresu, cols = -Stopien, names_to = "Armia", values_to = "Wartosc")

    ggplot(dane_long, aes(x = Stopien, y = Wartosc, fill = Armia)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Liczba oficerów w 1921 r.", x = "Stopień", y = "Liczba") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title = element_text(size = 14),
            legend.text = element_text(size = 12)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2))
  })
}

shinyApp(ui = ui, server = server)