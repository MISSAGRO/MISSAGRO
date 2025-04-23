library(shiny)

# Umbrales de eficiencia por cultivo (kg/mm)
umbrales <- list(
  "Maíz" = c(bajo = 15, alto = 25),
  "Trigo" = c(bajo = 10, alto = 18),
  "Soja" = c(bajo = 8, alto = 13),
  "Girasol" = c(bajo = 9, alto = 15),
  "Cebada" = c(bajo = 10, alto = 17),
  "Sorgo" = c(bajo = 12, alto = 20)
)

ui <- fluidPage(
  titlePanel("📊 Calculadora de eficiencia de uso del agua"),
  tags$p("Ingresá tu rendimiento y el agua acumulada durante el ciclo del cultivo. Esta herramienta te devuelve la eficiencia hídrica estimada en kg/mm."),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("cultivo", "Cultivo:",
                  choices = names(umbrales),
                  selected = "Maíz"),
      numericInput("rendimiento", "Rendimiento obtenido (kg/ha):", value = NA, min = 0),
      numericInput("agua", "Agua acumulada (mm):", value = NA, min = 1),
      actionButton("calcular", "Calcular")
    ),
    
    mainPanel(
      h3("Resultados"),
      verbatimTextOutput("resultado"),
      textOutput("interpretacion")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$calcular, {
    req(input$rendimiento, input$agua)
    
    eficiencia <- round(input$rendimiento / input$agua, 2)
    
    # Obtener umbrales según cultivo
    umbral <- umbrales[[input$cultivo]]
    interpretacion <- if (eficiencia < umbral["bajo"]) {
      "🔴 Baja eficiencia de uso del agua"
    } else if (eficiencia <= umbral["alto"]) {
      "🟡 Eficiencia media"
    } else {
      "🟢 Alta eficiencia de uso del agua"
    }
    
    output$resultado <- renderText({
      paste("Eficiencia de uso del agua:", eficiencia, "kg/mm")
    })
    
    output$interpretacion <- renderText({
      interpretacion
    })
  })
}

shinyApp(ui, server)
