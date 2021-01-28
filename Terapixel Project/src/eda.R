
#taking three random samples based on GPU serial number for use identifying tiles in heatmap
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
#overlaying tiles rendered by sample of GPUs
heatmap + geom_tile(data = hostname_sample_1,  width = width, height = height, fill = "blue") + 
  geom_tile(data = hostname_sample_2,  width = width, height = height, fill = "green") + 
  geom_tile(data = hostname_sample_3,  width = width, height = height, fill = "yellow") + 
  ggtitle('Heatmap of total render duration per tile, sample GPUs highlighted in blue, green & yellow') + 
  theme(plot.title = element_text(hjust = 0.5))

#plotting heatmap of runtimes with respect to the coordinates of the tiles
heatmap = ggplot(Runtimes_12, aes(x, y, fill= TotalRender_IncTil)) +
  geom_tile() +
  scale_fill_gradient(low="white", high="red",
                      limits=range(Runtimes_12$TotalRender_IncTil))
tmp <- ggplot_build(heatmap)$data[[1]][2,]  # get the first data point from geom_raster
width <- tmp$xmax - tmp$xmin  # calculate the width of the rectangle
height <- tmp$ymax - tmp$ymin  # calculate the height of the rectangle
#overlaying tiles that took around 25s to render
heatmap + geom_tile(data = filter(Runtimes, TotalRender<26, TotalRender>23),  width = width, height = height, fill = "black")+ 
  ggtitle('Heatmap of total render duration per tile, 23s <Totalrender< 26s highlighted') + 
  theme(plot.title = element_text(hjust = 0.5))

#k-means pca plot for saving to png for structured abstract key images
(km2_pc_plot = ggplot(gpu_performance_12, aes(x=pca_gpu_perf$x[,1], y=pca_gpu_perf$x[,2])) +
    geom_point(colour=km_2$cluster, shape=km_2$cluster, size=2.5) + xlab('First PC') + ylab('Second PC') + 
    ggtitle('k-means (k=2) clustering of GPU performance data in space of first two principle components')) + 
  theme(plot.title = element_text(hjust = 0.5))
