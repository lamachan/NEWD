library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

dane <- read.table("./data/sily_zbrojne_przed_ww2.txt", header = TRUE, sep = ';', colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric"))

ui <- fluidPage(
  titlePanel("Stan liczebny polskich sił zbrojnych przed II wojną światową"),
  sidebarLayout(
    sidebarPanel(
      selectInput("group_type", "Wybierz Rodzaj Grupowania:", choices = c("Żołnierze", "Ogółem pracownicy")),
      conditionalPanel(
        condition = "input.group_type == 'Żołnierze'",
        selectInput("rodzaj_filter", "Filtruj Rodzaj:", choices = c("Wszyscy żołnierze", "Żołnierze służby czynnej", "Żołnierze rezerwy")),
        uiOutput("stopien_filter"),
      ),
      br()
    ),
    mainPanel(
      plotOutput("wykres")
    )
  )
)

server <- function(input, output, session) {
  
  output$stopien_filter <- renderUI({
    rodzaj <- input$rodzaj_filter
    if (rodzaj == "Wszyscy żołnierze") {
      stopien_choices <- unique(dane$Stopień)
    } else {
      stopien_choices <- unique(dane[dane$Rodzaj == rodzaj, "Stopień"])
    }
    selectInput("stopien_filter", "Filtruj Stopień:", choices = c("", stopien_choices), multiple = TRUE)
  })
  
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    if (input$group_type == "Żołnierze") {
      if (input$rodzaj_filter %in% c("Wszyscy żołnierze", "Żołnierze służby czynnej", "Żołnierze rezerwy")) {
        if (!is.null(input$stopien_filter)) {
          dane_do_wykresu <- dane_do_wykresu %>%
            filter(Stopień %in% input$stopien_filter)
        }
        if (input$rodzaj_filter != "Wszyscy żołnierze") {
          dane_do_wykresu <- dane_do_wykresu %>%
            filter(Rodzaj == input$rodzaj_filter)
        }
        
        dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Stopień != "", ]

        dane_long <- pivot_longer(dane_do_wykresu, cols = -c(Rodzaj, Stopień), names_to = "Data", values_to = "Stan")
        dane_long$Data <- gsub("Stan.", "", dane_long$Data)
        dane_long$Data <- factor(dane_long$Data, levels = c("01.02.1936", "01.01.1938", "01.01.1939", "01.06.1939"))
        
        ggplot(dane_long, aes(x = Data, y = Stan, fill = Stopień)) +
          geom_bar(stat = "identity", position = "dodge") +
          labs(title = "Stan w poszczególnych okresach",
               x = "Data", y = "Liczba", fill = "Stopień") +
          theme_minimal() +
          theme(legend.position = "bottom",
                axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
                axis.text.y = element_text(size = 12),
                axis.title = element_text(size = 14),
                plot.title = element_text(size = 22),
                legend.text = element_text(size = 12)) +
          scale_fill_brewer(palette = "Set1")
      }
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Rodzaj %in% c("Ogółem żołnierze", "Pracownicy cywilni", "Konie"), ]
      
      dane_long <- pivot_longer(dane_do_wykresu, cols = -c(Rodzaj, Stopień), names_to = "Data", values_to = "Stan")
      dane_long$Data <- gsub("Stan.", "", dane_long$Data)
      dane_long$Data <- factor(dane_long$Data, levels = c("01.02.1936", "01.01.1938", "01.01.1939", "01.06.1939"))
      
      ggplot(dane_long, aes(x = Data, y = Stan, fill = Rodzaj)) +
        geom_bar(stat = "identity", position = "dodge") +
        labs(title = "Stan w poszczególnych okresach",
             x = "Data", y = "Liczba", fill = "Rodzaj") +
        theme_minimal() +
        theme(legend.position = "bottom",
              axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
              axis.text.y = element_text(size = 12),
              axis.title = element_text(size = 14),
              plot.title = element_text(size = 22),
              legend.text = element_text(size = 12)) +
        scale_fill_brewer(palette = "Dark2")
    }
  })
}

shinyApp(ui = ui, server = server)