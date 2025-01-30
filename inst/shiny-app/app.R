library(shiny)
library(DT)

# Load dataset
mediation_data <- read.csv("mediation_results.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Mediation Effects on BMD Search"),
  sidebarLayout(
    sidebarPanel(
      textInput("search_gene", "Search by Gene:", ""),
      textInput("search_snp", "Search by SNP (rsID):", ""),
      selectInput("bmd_type", "Select BMD Type:", 
                  choices = unique(mediation_data$BMD_Type), selected = NULL, multiple = TRUE),
      sliderInput("pval", "P-value Threshold:", min = 1e-10, max = 1, value = 0.05, step = 1e-5),
      actionButton("submit", "Search")
    ),
    mainPanel(
      DTOutput("results_table"),
      h3("Mediation Effects Heatmap"),
      plotOutput("heatmap"),
      h3("Effect Size Distribution by BMD Type"),
      plotOutput("boxplot")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  filtered_data <- reactive({
    req(input$submit)
    subset(mediation_data,
           (grepl(input$search_gene, Gene, ignore.case = TRUE) | 
              grepl(input$search_snp, SNP, ignore.case = TRUE)) &
             (is.null(input$bmd_type) | BMD_Type %in% input$bmd_type) &
             P_Value <= input$pval)
  })
  
  output$results_table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 10, autoWidth = TRUE))
  })
  library(ggplot2)
  
  output$heatmap <- renderPlot({
    ggplot(filtered_data(), aes(x = BMD_Type, y = Mediator, fill = Effect_Size)) +
      geom_tile() +
      scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
      theme_minimal() +
      labs(title = "Mediation Effects Heatmap", x = "BMD Type", y = "Mediator")
  })
  
  plotOutput("heatmap")
}



# Run the App
shinyApp(ui, server)
