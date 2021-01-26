
#taking three random samples based on GPU serial number
hostname_sample_1 = Runtimes_12[Runtimes_12$hostname==sample(Runtimes_12$hostname,1),]
hostname_sample_2 = Runtimes_12[Runtimes_12$hostname==sample(Runtimes_12$hostname,1),]
hostname_sample_3 = Runtimes_12[Runtimes_12$hostname==sample(Runtimes_12$hostname,1),]

#plotting heatmap of runtimes with respect to the coordinates of the tiles
heatmap = ggplot(Runtimes_12, aes(x, y, fill= TotalRender_IncTil)) +
  geom_tile() +
  scale_fill_gradient(low="white", high="red",
                      limits=range(Runtimes_12$TotalRender_IncTil))
tmp <- ggplot_build(heatmap)$data[[1]][2,]  # get the first data point from geom_raster
width <- tmp$xmax - tmp$xmin  # calculate the width of the rectangle
height <- tmp$ymax - tmp$ymin  # calculate the height of the rectangle
heatmap + geom_tile(data = hostname_sample_1,  width = width, height = height, fill = "blue") + 
  geom_tile(data = hostname_sample_2,  width = width, height = height, fill = "green") + 
  geom_tile(data = hostname_sample_3,  width = width, height = height, fill = "yellow")