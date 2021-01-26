
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

Runtimes_12_BP = Runtimes_12[,c(2,3)]
bymedian = with(Runtimes_12_BP, reorder(hostname, TotalRender_IncTil, median))
km2_cluster = rownames_to_column(as.data.frame(km_2$cluster), var='gpuSerial')
km2_cluster$gpuSerial = as.numeric(km2_cluster$gpuSerial)
km2_cluster = left_join(km2_cluster, gpu_performance[,c(1,2)], by='gpuSerial')[,-1]
Runtimes_12_BP = left_join(Runtimes_12_BP, km2_cluster, by='hostname')
colnames(Runtimes_12_BP) = c('hostname', 'TotalRender_IncTil', 'cluster')

#collection of outliers at ~25s, wonder why?
(bp_runtime = ggplot(Runtimes_12_BP, aes(x=bymedian, y=TotalRender_IncTil, alpha=0.1)) + 
  geom_boxplot(outlier.size=0.1, alpha=0.3, lwd=0.0000001)) # + scale_color_manual(values=c("black", "red")))


getwd()
