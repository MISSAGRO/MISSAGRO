library(shiny)

ui <- fluidPage(
  titlePanel("Análisis de Sensibilidad del Margen Bruto"),
  sidebarLayout(
    sidebarPanel(
      selectInput("cultivo", "Cultivo:",
                  choices = c("Trigo", "Cebada", "Arveja")),
      numericInput("rendimiento", "Rendimiento esperado (kg/ha):", value = 4000, min = 0),
      numericInput("precio", "Precio base (US$/ton):", value = 215, min = 0),
      numericInput("costo", "Costo total estimado (US$/ha):", value = 662, min = 0)
    ),
    mainPanel(
      h3("Resultados del Análisis de Sensibilidad"),
      tableOutput("tabla_resultados"),
      plotOutput("grafico_resultados")
    )
  )
)

server <- function(input, output) {
  output$tabla_resultados <- renderTable({
    precios <- c(input$precio * 0.95, input$precio, input$precio * 1.05)
    ingresos <- precios * input$rendimiento / 1000
    margenes <- ingresos - input$costo
    data.frame(
      "Escenario" = c("Precio -5%", "Precio Base", "Precio +5%"),
      "Precio (US$/ton)" = round(precios, 2),
      "Ingreso (US$/ha)" = round(ingresos, 2),
      "Margen Bruto (US$/ha)" = round(margenes, 2)
    )
  })
  
  output$grafico_resultados <- renderPlot({
    precios <- c(input$precio * 0.95, input$precio, input$precio * 1.05)
    ingresos <- precios * input$rendimiento / 1000
    margenes <- ingresos - input$costo
    barplot(margenes, names.arg = c("Precio -5%", "Precio Base", "Precio +5%"),
            col = "green4", ylab = "Margen Bruto (US$/ha)",
            main = "Análisis de Sensibilidad del Margen Bruto")
    abline(h = 0, col = "red4", lty = 2)
  })
}

shinyApp(ui = ui, server = server)
