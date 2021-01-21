
head(gpu)
head(task.x.y)
head(application.checkpoints)

#creating list of tasks for looping
Tasks = c('TotalRender', 'Tiling', 'Saving Config', 'Render', 'Uploading')
#looping through tasks in application checkpoints data and extracting runtimes
#for (i in Tasks){
#  nam = paste(i, 'Elapsed', sep = "_")
#  assign(nam, filter(application.checkpoints, eventName==i) %>% mutate(timeN = as.POSIXct(
#    timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId, hostname) %>%
#      summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec'))))
#}

Tasks_Elapsed = list(TotalRender_Elapsed, Tiling_Elapsed, `Saving Config_Elapsed`, Render_Elapsed, Uploading_Elapsed)

#joining data by task ID and hostname
Runtimes = Tasks_Elapsed %>% reduce(left_join, by = c("taskId", "hostname"), copy=TRUE)
#changing names of 'Runtimes' columns
names(Runtimes) = c('taskId', 'hostname', 'TotalRender', 'Tiling', 'Saving_Config', 'Render', 'Uploading')

gm_mean = function(x, na.rm=TRUE){
  exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
}

#grouping gpus per hostname/vm and calculating means for gpu data
#geometric mean used for ratios.
#Converted to numeric for analysis
gpu_performance = gpu %>% group_by(hostname, gpuSerial, gpuUUID) %>%
  summarise(mean_powerDrawWatt=as.numeric(mean(powerDrawWatt)),
            mean_gpuTempC=mean(gpuTempC), mean_gpuUtilPerc=as.numeric(gm_mean(gpuUtilPerc)),
            mean_gpuMemUtilPerc=as.numeric(gm_mean(gpuMemUtilPerc)))

#Grouping runtimes per hostname/vm and calculatin means for render data
#Converted to numeric for analysis
Runtimes_mean = Runtimes %>% group_by(hostname) %>%
  summarise(mean_TotalRender=as.numeric(mean(TotalRender)), mean_Tiling=as.numeric(mean(Tiling)),
            mean_SavingConfig=as.numeric(mean(Saving_Config)), mean_Render=as.numeric(mean(Render)),
            mean_Uploading=as.numeric(mean(Uploading)))

#merging gpu data and runtimes data by hostname
gpu_performance = inner_join(gpu_performance, Runtimes_mean, by='hostname')

#removing hostname and gpu id as not providing additional information
gpu_performance = subset(gpu_performance, select = -c(1, 3))
#converting gpu serial number to rowname to allow PCA but still index by gpu
gpu_performance = data.frame(column_to_rownames(gpu_performance, var = "gpuSerial"))
