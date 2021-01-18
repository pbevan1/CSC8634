library(ProjectTemplate)
load.project()
library(tidyverse)
# Example preprocessing script.
head(gpu)
head(task.x.y)
head(application.checkpoints)


##creating new dataframe for each eventName and their runtimes for each job, indexed by task id:
#TotalRender
TotalRender_elapsed = filter(application.checkpoints, eventName=='TotalRender') %>% mutate(timeN = as.POSIXct(
  timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId, hostname) %>%
  summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec')))
#Tiling
Tiling_elapsed = filter(application.checkpoints, eventName=='Tiling') %>% mutate(timeN = as.POSIXct(
  timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId) %>%
  summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec')))
#Saving Config
Saving_Config_elapsed = filter(application.checkpoints, eventName=='Saving Config') %>%
  mutate(timeN = as.POSIXct(timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>%
  group_by(taskId) %>% summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec')))
#Render
Render_elapsed = filter(application.checkpoints, eventName=='Render') %>% mutate(timeN = as.POSIXct(
  timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId) %>% 
  summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec')))
#Uploading
Uploading_elapsed = filter(application.checkpoints, eventName=='Uploading') %>% mutate(timeN = as.POSIXct(
  timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId) %>%
  summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec')))

sum(TotalRender_elapsed$timediff)/60/60/24

#Merging elapsed dataframes based on task id
Runtimes = inner_join(TotalRender_elapsed, Tiling_elapsed, by='taskId')
Runtimes = inner_join(Runtimes, Saving_Config_elapsed, by='taskId')
Runtimes = inner_join(Runtimes, Render_elapsed, by='taskId')
Runtimes = inner_join(Runtimes, Uploading_elapsed, by='taskId')
#changing column names
names(Runtimes) = c('taskId', 'hostname', 'TotalRender', 'Tiling', 'Saving_Config', 'Render', 'Uploading')


gpu_performance = gpu %>% group_by(hostname, gpuSerial, gpuUUID) %>%
  summarise(mean_powerDrawWatt=mean(powerDrawWatt),
            mean_gpuTempC=mean(gpuTempC), mean_gpuUtilPerc=mean(gpuUtilPerc),
            mean_gpuMemUtilPerc=mean(gpuMemUtilPerc))

Runtimes_mean = Runtimes %>% group_by(hostname) %>%
  summarise(mean_TotalRender=mean(TotalRender), mean_Tiling=mean(Tiling),
            mean_SavingConfig=mean(Saving_Config), mean_Render=mean(Render),
            mean_Uploading=mean(Uploading))

gpu_performance = inner_join(gpu_performance, Runtimes_mean, by='hostname')
