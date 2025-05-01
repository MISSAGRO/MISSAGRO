library(shiny)
library(fmsb)  # Para radar chart

# Etiquetas de ejes
ejes <- c(
  "Datos",
  "Decisiones",
  "Asesoramiento",
  "Maquinaria",
  "Sostenibilidad",
  "Logística",
  "Gestión Económica",
  "Digitalización"
)

# Preguntas y opciones
preguntas <- list(
  "¿Cómo registra los rendimientos y datos del lote?" = c("No registra" = 1, "Registros en papel/cuaderno" = 2, "Planillas digitales (Excel, etc.)" = 3, "Software específico por lote o ambiente" = 4),
  "¿Utiliza herramientas para el monitoreo del cultivo?" = c("No utiliza" = 1, "Solo clima o agua (manual)" = 2, "Apps o sensores básicos" = 3, "Imágenes satelitales, drones, sensores en red" = 4),
  "¿Cómo decide la fertilización o aplicación de insumos?" = c("Por calendario o costumbre" = 1, "Recomendación básica" = 2, "Según diagnóstico simple" = 3, "Con mapas o prescripciones por ambiente" = 4),
  "¿Ajusta decisiones durante la campaña con datos?" = c("No ajusta" = 1, "Solo ante problemas graves" = 2, "Algunos ajustes ocasionales" = 3, "Ajustes sistemáticos con datos o alertas" = 4),
  "¿Cuenta con asesoramiento técnico?" = c("No cuenta con asesoramiento" = 1, "Consulta puntual" = 2, "Asesor externo regular" = 3, "Equipo técnico integral" = 4),
  "¿Participa en capacitaciones o actualizaciones?" = c("Nunca participa" = 1, "Esporádicamente" = 2, "1-2 veces al año" = 3, "De forma regular o en grupos técnicos" = 4),
  "¿Qué nivel de tecnología tiene su maquinaria?" = c("Convencional" = 1, "Con mejoras básicas (GPS, monitor)" = 2, "Con corte por sección o dosificación variable" = 3, "Sistemas integrados de precisión" = 4),
  "¿Realiza siembra o aplicación por ambientes?" = c("No" = 1, "Solo en zonas extremas" = 2, "En parte del campo" = 3, "En toda la superficie con prescripciones" = 4),
  "¿Utiliza prácticas sustentables?" = c("No aplica prácticas sustentables" = 1, "Solo ocasionalmente" = 2, "Una práctica regular (ej. cobertura)" = 3, "Diversas prácticas sostenibles" = 4),
  "¿Adopta tecnologías nuevas (apps, IA, etc.)?" = c("No" = 1, "Solo en pruebas" = 2, "Aplica alguna con frecuencia" = 3, "Integra activamente herramientas innovadoras" = 4),
  "¿Cómo planifica sus compras de insumos?" = c("Compra sobre la marcha" = 1, "Planifica en general" = 2, "Planifica por lote o cultivo" = 3, "Usa datos históricos o prescripciones" = 4),
  "¿Lleva registros de insumos y stock?" = c("No lleva registros" = 1, "Anota informalmente" = 2, "Registra en planillas/cuaderno" = 3, "Usa software o plataformas integradas" = 4),
  "¿Evalúa económicamente sus campañas?" = c("No evalúa resultados" = 1, "Solo general o intuitivo" = 2, "Análisis básico de ingresos/gastos" = 3, "Análisis detallado por lote o cultivo" = 4),
  "¿Usa herramientas de gestión financiera o contable?" = c("No utiliza" = 1, "Solo planillas básicas" = 2, "Software contable" = 3, "ERP agropecuario o plataforma integrada" = 4),
  "¿Cómo es la conectividad en su campo?" = c("Sin conectividad" = 1, "Muy limitada (móvil inestable)" = 2, "Aceptable para tareas básicas" = 3, "Buena conexión fija/móvil o redes internas" = 4),
  "¿Utiliza apps o plataformas digitales?" = c("No" = 1, "Solo consulta externas (clima, precios)" = 2, "Registra datos productivos" = 3, "Usa plataformas integradas y conectividad de equipos" = 4)
)

# UI
ui <- fluidPage(
  titlePanel("📡 TecnoRadar - Diagnóstico de Nivel Tecnológico"),
  sidebarLayout(
    sidebarPanel(
      h4("Completá el cuestionario"),
      lapply(1:length(preguntas), function(i) {
        selectInput(
          inputId = paste0("pregunta", i),
          label = names(preguntas)[i],
          choices = preguntas[[i]]
        )
      }),
      actionButton("evaluar", "Evaluar mi perfil", class = "btn-success")
    ),
    mainPanel(
      h3("🧠 Resultado"),
      textOutput("nivel"),
      plotOutput("radar"),
      br(),
      h4("🔍 Recomendaciones según tu perfil"),
      verbatimTextOutput("sugerencias")
    )
  )
)

# Server
server <- function(input, output) {
  observeEvent(input$evaluar, {
    respuestas <- sapply(1:16, function(i) as.numeric(input[[paste0("pregunta", i)]]))
    puntajes <- tapply(respuestas, rep(1:8, each = 2), mean)
    total <- mean(puntajes)
    
    color <- "#000000"
    clasificacion <- if (total < 1.75) {
      color <- "#e74c3c"  # rojo
      "🔴 Productor Convencional"
    } else if (total < 2.5) {
      color <- "#f39c12"  # amarillo
      "🟡 Productor en Transición"
    } else if (total < 3.25) {
      color <- "#27ae60"  # verde
      "🟢 Productor Tecnificado"
    } else {
      color <- "#2980b9"  # azul
      "🔵 Productor de Precisión"
    }
    
    output$nivel <- renderText({
      paste("Nivel alcanzado:", clasificacion)
    })
    
    output$radar <- renderPlot({
      data <- as.data.frame(rbind(
        rep(4, 8),
        rep(0, 8),
        puntajes
      ))
      colnames(data) <- ejes
      radarchart(
        data,
        axistype = 1,
        pcol = color,
        pfcol = adjustcolor(color, alpha.f = 0.25),
        plwd = 2,
        cglcol = "#dcdcdc",
        cglty = 1,
        axislabcol = "grey30",
        caxislabels = c("0", "1", "2", "3", "4"),
        vlcex = 1.3,
        cglwd = 0.8
      )
    })
  
  output$sugerencias <- renderText({
    if (total < 1.75) {
      "Como Productor Convencional, tenés mucho potencial de mejora. MISS AGRO puede ayudarte con servicios de monitoreo aéreo, digitalización de registros y capacitación técnica básica para dar los primeros pasos hacia una gestión más eficiente."
    } else if (total < 2.5) {
      "Estás en transición. Para avanzar, podés incorporar mapas de prescripción, imágenes multiespectrales y análisis de datos. MISS AGRO te acompaña en la adopción gradual de tecnologías de precisión."
    } else if (total < 3.25) {
      "Buen trabajo. Ya sos un Productor Tecnificado. Podés potenciar tu nivel sumando servicios de agricultura por ambientes, seguimiento satelital y ERP agropecuario. En MISS AGRO ofrecemos soluciones integradas para dar ese salto."
    } else {
      "Felicitaciones, estás en la vanguardia. Como Productor de Precisión, MISS AGRO puede ofrecerte innovaciones en IA, conectividad de maquinaria y apps personalizadas para optimizar aún más tu producción."
    }
  })
  })
}

shinyApp(ui, server)
