library(shiny)
library(ggplot2)
library(tidyr)

dane <- read.table('./data/armia_krajowa_1944.txt', sep = ";", header = TRUE)

wszystkie_kolumny <- colnames(dane)

ui <- fluidPage(
  titlePanel("Armia Krajowa 1944 r."),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_okreg", "Filtruj okregi:", choices = c("Wszystkie", unique(dane$Okreg)), selected = "Wszystkie", multiple = TRUE)
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
      input$kolumny <- "Okreg"
    }

    if (is.null(input$filtr_okreg) || length(input$filtr_okreg) == 0 || "Wszystkie" %in% input$filtr_okreg) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Okreg %in% input$filtr_okreg, ]
    }
    
    dane_do_wykresu <- dane_do_wykresu[, input$kolumny, drop = FALSE]
    
    dane_long <- pivot_longer(dane_do_wykresu, cols = -Okreg, names_to = "Rodzaj", values_to = "Wartosc")
    
    ggplot(dane_long, aes(x = Okreg, y = Wartosc, fill = Rodzaj)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Liczba jednostek i oficerów w poszczególnych okręgach", x = "Okręg", y = "Liczba") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title = element_text(size = 14),
            legend.text = element_text(size = 12)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2))
  })
}

shinyApp(ui = ui, server = server)