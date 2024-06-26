library(shiny)
library(ggplot2)
library(tidyr)

dane <- read.table('./data/korpus_oficerski_1945.txt', sep = ";", header = TRUE)

wszystkie_kolumny <- colnames(dane)

ui <- fluidPage(
  titlePanel("Korpus oficerski 1945 r."),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_rodzaje", "Filtruj rodzaje broni i służb:", choices = c("Wszystkie", unique(dane$Rodzaje_broni_i_sluzb)), selected = "Wszystkie", multiple = TRUE)
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
      input$kolumny <- "Rodzaje_broni_i_sluzb"
    }
    
    if (is.null(input$filtr_rodzaje) || length(input$filtr_rodzaje) == 0 || "Wszystkie" %in% input$filtr_rodzaje) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Rodzaje_broni_i_sluzb %in% input$filtr_rodzaje, ]
    }
    
    dane_do_wykresu <- dane_do_wykresu[, input$kolumny, drop = FALSE]

    dane_long <- pivot_longer(dane_do_wykresu, cols = -Rodzaje_broni_i_sluzb, names_to = "Armia", values_to = "Wartosc")
    
    ggplot(dane_long, aes(x = Rodzaje_broni_i_sluzb, y = Wartosc, fill = Armia)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Liczba oficerów w danej sekcji w 1945 r.", x = "Rodzaje broni i służb", y = "Liczba") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
            axis.text.y = element_text(size = 12),
            axis.title = element_text(size = 14),
            legend.text = element_text(size = 12)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2))
  })
}

shinyApp(ui = ui, server = server)