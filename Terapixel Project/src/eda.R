head(gpu_performance)


pairs(gpu_performance_12[,-6], col = rgb(red = 0, green = 0, blue = 0, alpha = 0.1))

gpu_grid = grid.arrange(plt_temp, plt_utilPerc, plt_memUtilPerc, nrow = 2)

render_grid = grid.arrange(plt_TotalRender, plt_Tiling, plt_SavingConfig, plt_Render, plt_Uploading, nrow = 3)

ggplot(gpu_performance, aes(x=mean_SavingConfig)) + 
  geom_histogram(color='red', binwidth=0.0001) + xlab('Mean duration of configuration overhead (s)') +
  theme(plot.title = element_text(hjust = 0.5)) + theme(text = element_text(size=8))

dim(gpu)





plot(pca_gpu_perf, type="l")

(pc1_pc2_gpu = pca_gpu_perf$rotation[,c(1:2)])

pca_gpu_perf$rotation[,c(1:2)]




#kmeans function with K=2 as identified by above plot
km_4 = kmeans(gpu_performance_12, 4, iter.max=50, nstart=20)

#examining the structure of the object
str(km_2)

#best gpus for k=2 clustering
bestgpu_km_2 = 

## Plot the first PC against the second PC using the cluster allocation to set
## different colours (col) and plotting characters (pch) for each cluster:
plot(pca_gpu_perf$x[,1], pca_gpu_perf$x[,2], main="Cluster solutions in ISLR data in space of first two PCs", xlab="First PC", ylab="Second PC",
     col=km_2$cluster, pch=km_2$cluster)
plot(pca_gpu_perf$x[,1], pca_gpu_perf$x[,2], main="Cluster solutions in ISLR data in space of first two PCs", xlab="First PC", ylab="Second PC",
     col=km_4$cluster, pch=km_4$cluster)
## Add labels representing the patient numbers:
#text(pca_gpu_perf$x[,1], pca_gpu_perf$x[,2], labels=rownames(gpu_performance), cex=0.5, pos=3,
#col="darkgrey")

#kmeans function with K=2 as identified by above plot
km_4 = kmeans(gpu_performance_12, 4, iter.max=50, nstart=20)
#examining the structure of the object
str(km_4)

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

#Creating scatterplot matrix with k-means clusters used to colour groups
#clustered on the full dataset.
pairs(gpu_performance_12[,-6], col = alpha(km_4$cluster, 0.1))

tail(gpu_performance_12[order(gpu_performance_12$mean_TotalRender_IncTil),],10)

#k=4 clustering
(km4_pc_plot = ggplot(gpu_performance_12, aes(x=pca_gpu_perf$x[,1], y=pca_gpu_perf$x[,2])) +
    geom_point(colour=1, shape=1, size=2.5) + xlab('First PC') + ylab('Second PC') + 
    ggtitle('k=4 clustering of GPU performance data in space of first two PCs'))