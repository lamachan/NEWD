library(shiny)
library(ggplot2)
library(tidyr)

# Wczytanie danych
dane <- read.table(text = "Stopien;Armia_austro-wegierska;Armia_rosyjska;Armia_niemiecka;Armia_J_Hallera;Oficerowie_z_legionow
Generałowie_broni;1;1;0;1;1
Generałowie_dywizji;10;11;1;0;4
Generałowie_brygady;49;54;2;3;7
Pułkownicy;175;197;12;9;52
Podpułkownicy;350;232;43;23;114
Majorowie;665;487;112;54;272
Kapitanowie;2164;1456;345;151;832
Porucznicy;4117;3648;1252;1597;3072
Podporucznicy;1945;1865;829;431;3459", header = TRUE, sep = ";")

# Nazwy wszystkich kolumn
wszystkie_kolumny <- colnames(dane)

# UI
ui <- fluidPage(
  titlePanel("Interaktywna wizualizacja danych"),
  sidebarLayout(
    sidebarPanel(
      selectInput("kolumny", "Wybierz kolumny:", choices = wszystkie_kolumny, selected = wszystkie_kolumny, multiple = TRUE),
      selectInput("filtr_stopien", "Filtruj stopnie:", choices = c("Wszystkie", unique(dane$Stopien)), selected = "Wszystkie", multiple = TRUE) # zaznaczone "Wszystkie" domyślnie
    ),
    mainPanel(
      plotOutput("wykres", height = "500px") # powiększenie wykresu
    )
  )
)

# Server
server <- function(input, output) {
  output$wykres <- renderPlot({
    dane_do_wykresu <- dane
    
    # Jeśli żadna kolumna nie jest wybrana, automatycznie zaznaczamy kolumnę Stopien
    if (is.null(input$kolumny) || length(input$kolumny) == 0) {
      input$kolumny <- "Stopien"
    }
    
    # Jeśli nie wybrano żadnych stopni, wyświetlamy wszystkie
    if (is.null(input$filtr_stopien) || length(input$filtr_stopien) == 0 || "Wszystkie" %in% input$filtr_stopien) {
      dane_do_wykresu <- dane_do_wykresu
    } else {
      dane_do_wykresu <- dane_do_wykresu[dane_do_wykresu$Stopien %in% input$filtr_stopien, ]
    }
    
    # Filtruj dane według wyboru użytkownika
    dane_do_wykresu <- dane_do_wykresu[, input$kolumny, drop = FALSE]
    
    # Przekształcenie danych do długiego formatu
    dane_long <- pivot_longer(dane_do_wykresu, cols = -Stopien, names_to = "Kolumna", values_to = "Wartosc")
    
    # Wykres countplot
    ggplot(dane_long, aes(x = Stopien, y = Wartosc, fill = Kolumna)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Countplot dla wybranych kolumn", x = "Stopień", y = "Wartość") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      coord_cartesian(ylim = c(0, max(dane_long$Wartosc) * 1.2)) # powiększenie osi y
  })
}

# Uruchomienie aplikacji
shinyApp(ui = ui, server = server)

