head(gpu_performance)

(plt_power = ggplot(gpu_performance, aes(x=mean_powerDrawWatt)) + 
  geom_histogram(color='white')) + xlab('Mean power draw of GPU (Watts)') +
  theme(plot.title = element_text(hjust = 0.5))

(plt_temp = ggplot(gpu_performance, aes(x=mean_gpuTempC)) + 
    geom_histogram(color='white', binwidth=0.5)) + xlab('Mean temp of GPU (C)') +
  theme(plot.title = element_text(hjust = 0.5))

#Clearly multimodal (different classes of GPU??)
(plt_utilPerc = ggplot(gpu_performance, aes(x=mean_gpuUtilPerc)) + 
    geom_histogram(color='white')) + xlab('Mean utilisation of GPU Core(s) (%)') +
  theme(plot.title = element_text(hjust = 0.5))

(plt_memUtilPerc = ggplot(gpu_performance, aes(x=mean_gpuMemUtilPerc)) + 
    geom_histogram(color='white')) + xlab('Mean utilisation of GPU memory (%)') +
  theme(plot.title = element_text(hjust = 0.5))

#multimodal as well - pull out lower group
(plt_TotalRender = ggplot(gpu_performance, aes(x=mean_TotalRender)) + 
    geom_histogram(color='red')) + xlab('Mean duration of total render task (s)') +
  theme(plot.title = element_text(hjust = 0.5))

(plt_Tiling = ggplot(gpu_performance, aes(x=mean_Tiling)) + 
    geom_histogram(color='red', binwidth=0.01)) + xlab('Mean duration of tiling (s)') +
  theme(plot.title = element_text(hjust = 0.5))

(plt_SavingConfig = ggplot(gpu_performance, aes(x=mean_SavingConfig)) + 
    geom_histogram(color='red', binwidth=0.0001)) + xlab('Mean duration of configuration overhead (s)') +
  theme(plot.title = element_text(hjust = 0.5))

(plt_Render = ggplot(gpu_performance, aes(x=mean_Render)) + 
    geom_histogram(color='red', binwidth=0.5)) + xlab('Mean duration of tiling (s)') +
  theme(plot.title = element_text(hjust = 0.5))

(plt_Uploading = ggplot(gpu_performance, aes(x=mean_Uploading)) + 
    geom_histogram(color='red', binwidth=0.03)) + xlab('Mean duration of tiling (s)') +
  theme(plot.title = element_text(hjust = 0.5))

gpu_grid = grid.arrange(plt_temp, plt_utilPerc, plt_memUtilPerc, nrow = 2)

render_grid = grid.arrange(plt_TotalRender, plt_Tiling, plt_SavingConfig, plt_Render, plt_Uploading, nrow = 3)
