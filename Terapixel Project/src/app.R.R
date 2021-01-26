library(shiny)
vars = setdiff(names(gpu_performance_12_2), 'mean_Tiling')
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      selectInput('xcol', 'X Variable', vars),
      selectInput('ycol', 'Y Variable', vars, selected = vars[[2]]),
      # Input: Slider for the number of clusters ----
      sliderInput(inputId = "clusters",
                  label = "Number of clusters:",
                  2,
                  min = 1,
                  max = 15)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: kmeans ----
      plotOutput(outputId = "kmeans")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  selectedData <- reactive({
    gpu_performance_12_2[, c(input$xcol, input$ycol)]
  })
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$kmeans <- renderPlot({
    
    x    <- kmeans(gpu_performance_12_2, input$clusters, iter.max=50, nstart=20)
    
    ggplot(selectedData(), aes_string(x = input$xcol, y = input$ycol)) +
      geom_point(colour=x$cluster, shape=x$cluster, size=2.5) + xlab(input$xcol) + ylab(input$ycol)
    
  })
  
}

shinyApp(ui, server)