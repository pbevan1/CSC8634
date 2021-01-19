library(ProjectTemplate)
load.project()
library(tidyverse)
# Example preprocessing script.
head(gpu)
head(task.x.y)
head(application.checkpoints)

library(tidyverse)
#creating list of tasks for looping
Tasks = c('TotalRender', 'Tiling', 'Saving Config', 'Render', 'Uploading')
#looping through tasks in application checkpoints data and extracting runtimes
for (i in Tasks){
  nam = paste(i, 'Elapsed', sep = "_")
  assign(nam, filter(application.checkpoints, eventName==i) %>% mutate(timeN = as.POSIXct(
    timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId, hostname) %>%
      summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec'))))
}
#creating list of data created above for joining
Tasks_Elapsed = list(TotalRender_Elapsed, Tiling_Elapsed, `Saving Config_Elapsed`, Render_Elapsed, Uploading_Elapsed)

#joining data by task ID and hostname
Runtimes = Tasks_Elapsed %>% reduce(left_join, by = c("taskId", "hostname"))
#changing names of 'Runtimes' columns
names(Runtimes) = c('taskId', 'hostname', 'TotalRender', 'Tiling', 'Saving_Config', 'Render', 'Uploading')

#grouping gpus per hostname/vm and calculating means for gpu data
gpu_performance = gpu %>% group_by(hostname, gpuSerial, gpuUUID) %>%
  summarise(mean_powerDrawWatt=mean(powerDrawWatt),
            mean_gpuTempC=mean(gpuTempC), mean_gpuUtilPerc=mean(gpuUtilPerc),
            mean_gpuMemUtilPerc=mean(gpuMemUtilPerc))

#Grouping runtimes per hostname/vm and calculatin means for render data
Runtimes_mean = Runtimes %>% group_by(hostname) %>%
  summarise(mean_TotalRender=mean(TotalRender), mean_Tiling=mean(Tiling),
            mean_SavingConfig=mean(Saving_Config), mean_Render=mean(Render),
            mean_Uploading=mean(Uploading))

#merging gpu data and runtimes data by hostname
gpu_performance = inner_join(gpu_performance, Runtimes_mean, by='hostname')

summary(gpu_performance$mean_powerDrawWatt)

plot(gpu_performance$mean_powerDrawWatt)


