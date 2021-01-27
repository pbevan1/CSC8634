# load the required packages
library(ProjectTemplate)
load.project()

#setting up variable names to allow drop down selection
vars = setdiff(names(gpu_performance_12_2), 'mean_Tiling')

#dashboard header
header = dashboardHeader(title = "Terapixel GPU")  

#setting up sidebar
sidebar = dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    #linking to github page
    menuItem("My Github Page", icon = icon("send",lib='glyphicon'), 
             href = "https://github.com/pbevan1")
  )
)


#setting up first row of boxes
frow1 = fluidRow(
  
  #inserting box for k-means plot
  box(
    plotOutput(outputId = "kmeans")
  )
  #inserting box for controlling k-means plot (sliders and drop downs)
  ,box(
    selectInput('xcol', 'X Variable', vars, selected = vars[[9]]),
    selectInput('ycol', 'Y Variable', vars, selected = vars[[10]]),
    # Input: Slider for the number of clusters ----
    sliderInput(inputId = "clusters",
                label = "Number of clusters (k-value for k-means clustering)",
                2,
                min = 1,
                max = 15),
    
    #Explanatory text below plot controls
    
    "Use the drop down boxes to compare any 2 GPU performance metrics,
    including the first 2 principle components. Set the k-value for the k-means
    clustering and see how this separates the GPUs accross different metric pairs", br(), br(),
    "Please note: k-means clustering is fixed as clustering on the full dataset,
    these plots are to allow exploration into how these groups are split"
  )
)

#setting up second row

frow2 = fluidRow(
  #inserting box for heatmap
  box(
    plotOutput(outputId = 'heatmap')
  )
  
  #inserting box for heatmap cotrols
  ,box(
    sliderInput(inputId = "runtimerow",
                label = "GPU index number\n (blue pixels show tiles rendered by this GPU):",
                512,
                min = 1,
                max = 1024),
    "The plot on the left is a heatmap image created from the total render time 
    for each tile co-ordinate. The darker the area, the longer it took to render.", br(), br(),
    "This plot is designed to give confidence that the redering of tiles is fairly
    randomly distributed amongst the different GPUs, and thus comparison of render
    time is more likely to be valid", br(), br(),
    "Note: White dots are anaomolies and should be ignored",br(), br(),
    "Play with the slider to explore the tile distribution (blue dots) for
    each of the 1024 GPU nodes"
  )
)


# combining the two fluid rows to make the body
body = dashboardBody(frow1, frow2)

#completing ui part with dashboardPage
ui = dashboardPage(title = 'Terapixel rendering GPU performance evaluation dashboard', header, sidebar, body, skin='red')

#creating server functions
server = function(input, output) { 
  
  #subsetting gpu performance data based on user selections
  selectedData = reactive({
    gpu_performance_12_2[, c(input$xcol, input$ycol)]
  })

 # 
  #creating the plotOutput content
  
  #defining k-means plot
  output$kmeans = renderPlot({
    
    #creating k-means object k to input into plot based on user selection of k-value
    k = kmeans(gpu_performance_12_2, input$clusters, iter.max=50, nstart=20)
    
    #k-means clustering plot with x and y depending on chosen variables and clusters depending on chosen k-value
    ggplot(selectedData(), aes_string(x = input$xcol, y = input$ycol)) +
      geom_point(colour=k$cluster, shape=k$cluster, size=2.5, alpha=0.7) + xlab(input$xcol) + ylab(input$ycol) +
      ggtitle('k-means clustering of GPU performance data') +
      theme(plot.title=element_text(face="bold", hjust=0.5, lineheight=4))
    
  })
  
  #setting up heatmap output
  output$heatmap = renderPlot({
    
    #picking out hostname tile rendering based on index number chosen by user
    hostname_sample_x = Runtimes_12[Runtimes_12$hostname==as.character(hostname_list[input$runtimerow,]), ]
    
    #plotting heatmap of runtimes based on coordinates of tiles
    heatmap = ggplot(Runtimes_12, aes(x, y, fill= TotalRender_IncTil)) +
      geom_tile() +
      scale_fill_gradient(low="white", high="red",
                          limits=range(Runtimes_12$TotalRender_IncTil))
    tmp <- ggplot_build(heatmap)$data[[1]][2,]  # get the first data point from geom_raster
    width <- tmp$xmax - tmp$xmin  # calculate the width of the rectangle
    height <- tmp$ymax - tmp$ymin  # calculate the height of the rectangle
    heatmap + geom_tile(data = hostname_sample_x,  width = width, height = height, fill = 'blue') +
      ggtitle('render duration heatmap with gpu tile identification') +
      theme(plot.title=element_text(face="bold", hjust=0.5, lineheight=4))
  
  })
}

shinyApp(ui, server)