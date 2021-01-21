head(gpu_performance)



gpu_grid = grid.arrange(plt_temp, plt_utilPerc, plt_memUtilPerc, nrow = 2)

render_grid = grid.arrange(plt_TotalRender, plt_Tiling, plt_SavingConfig, plt_Render, plt_Uploading, nrow = 3)

ggplot(gpu_performance, aes(x=mean_SavingConfig)) + 
  geom_histogram(color='red', binwidth=0.0001) + xlab('Mean duration of configuration overhead (s)') +
  theme(plot.title = element_text(hjust = 0.5)) + theme(text = element_text(size=8))

dim(gpu)




pca_gpu_perf = prcomp(gpu_performance, scale=TRUE)
