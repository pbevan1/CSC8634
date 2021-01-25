
#creating list of event names for looping
Events = c('TotalRender', 'Tiling', 'Saving Config', 'Render', 'Uploading')
##cached## looping through event names in application checkpoints data and extracting runtimes
##cached## for (i in Events){
##cached##   nam = paste(i, 'Elapsed', sep = "_")
##cached##   assign(nam, filter(application.checkpoints, eventName==i) %>% mutate(timeN = as.POSIXct(
##cached##     timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId, hostname) %>%
##cached##       summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec'))))
##cached## }

Events_Elapsed = list(TotalRender_Elapsed, Tiling_Elapsed, `Saving Config_Elapsed`, Render_Elapsed, Uploading_Elapsed)

##cached## #joining data by task ID and hostname
##cached## Runtimes = Events_Elapsed %>% reduce(left_join, by = c("taskId", "hostname"), copy=TRUE)
##cached## #joining task.x.y on
##cached## Runtimes = Runtimes %>% left_join(task.x.y[,-2], by="taskId")
##cached## #changing names of 'Runtimes' columns
##cached## names(Runtimes) = c('taskId', 'hostname', 'TotalRender', 'Tiling',
##cached##                     'Saving_Config', 'Render', 'Uploading', 'x', 'y', 'Level')
##cached## #after noticing TotalRender does not include Tiling, adding new column including tiling.
##cached## Runtimes = Runtimes %>% mutate(TotalRender_IncTil=Uploading+Saving_Config+Render+Tiling)
##cached## #Reordering Columns to be more presentable
##cached## Runtimes = Runtimes[,c(1,2,11,3:10)]
##cached## Runtimes[, 3:8] <- sapply(Runtimes[, 3:8], as.numeric)

#filtering different levels and saving as different dataframes
Runtimes_12 = filter(Runtimes, Level==12)
Runtimes_8 = filter(Runtimes, Level==8)
Runtimes_4 = filter(Runtimes, Level==4)

#defining function for geometric mean to summarise ratio values
gm_mean = function(x, na.rm=TRUE){
  exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
}

#grouping gpus by gpu serial number and calculating means for gpu data
#geometric mean used for ratios.
#Converted to numeric for analysis
gpu_performance = gpu %>% group_by(hostname, gpuSerial, gpuUUID) %>%
  summarise(mean_powerDrawWatt=as.numeric(mean(powerDrawWatt)),
            mean_gpuTempC=mean(gpuTempC), mean_gpuUtilPerc=as.numeric(gm_mean(gpuUtilPerc)),
            mean_gpuMemUtilPerc=as.numeric(gm_mean(gpuMemUtilPerc)))

#Grouping runtimes per hostname/vm and calculating means for render data
#Converted to numeric for analysis
Runtimes_12_mean = Runtimes_12 %>% group_by(hostname) %>%
  summarise(mean_TotalRender_IncTil=as.numeric(mean(TotalRender_IncTil)), mean_TotalRender=as.numeric(mean(TotalRender)), mean_Tiling=as.numeric(mean(Tiling)),
            mean_SavingConfig=as.numeric(mean(Saving_Config)), mean_Render=as.numeric(mean(Render)),
            mean_Uploading=as.numeric(mean(Uploading)), mean_Level=as.numeric(mean(Level)))
Runtimes_8_mean = Runtimes_8 %>% group_by(hostname) %>%
  summarise(mean_TotalRender_IncTil=as.numeric(mean(TotalRender_IncTil)), mean_TotalRender=as.numeric(mean(TotalRender)), mean_Tiling=as.numeric(mean(Tiling)),
            mean_SavingConfig=as.numeric(mean(Saving_Config)), mean_Render=as.numeric(mean(Render)),
            mean_Uploading=as.numeric(mean(Uploading)), mean_Level=as.numeric(mean(Level)))
Runtimes_4_mean = Runtimes_4 %>% group_by(hostname) %>%
  summarise(mean_TotalRender_IncTil=as.numeric(mean(TotalRender_IncTil)), mean_TotalRender=as.numeric(mean(TotalRender)), mean_Tiling=as.numeric(mean(Tiling)),
            mean_SavingConfig=as.numeric(mean(Saving_Config)), mean_Render=as.numeric(mean(Render)),
            mean_Uploading=as.numeric(mean(Uploading)), mean_Level=as.numeric(mean(Level)))

#merging gpu data and runtimes data by hostname (one entry per gpu)
gpu_performance_12 = inner_join(gpu_performance, Runtimes_12_mean, by='hostname')
gpu_performance_8 = inner_join(gpu_performance, Runtimes_8_mean, by='hostname')
gpu_performance_4 = inner_join(gpu_performance, Runtimes_4_mean, by='hostname')

#removing hostname and gpu id as not providing additional information
gpu_performance_12 = subset(gpu_performance_12, select = -c(1, 3, 14))
gpu_performance_8 = subset(gpu_performance_8, select = -c(1, 3, 14))
gpu_performance_4 = subset(gpu_performance_4, select = -c(1, 3, 14))

#converting gpu serial number to rowname to allow PCA but still index by gpu
gpu_performance_12 = data.frame(column_to_rownames(gpu_performance_12, var = "gpuSerial"))
gpu_performance_8 = data.frame(column_to_rownames(gpu_performance_8, var = "gpuSerial"))
gpu_performance_4 = data.frame(column_to_rownames(gpu_performance_4, var = "gpuSerial"))

#computing sum of all event type runtimes (seconds)
Runtime_Totals = as.data.frame(colSums(Runtimes[,c(5:8)]))
colnames(Runtime_Totals) = 'Totals'
Runtime_Totals = tibble::rownames_to_column(Runtime_Totals, "Event")
Runtime_Totals = Runtime_Totals %>% mutate(perc=percent(Totals/sum(Totals)))
Runtime_Totals$Event = c('Tiling (2.23%)', 'Saving_Config (0.01%)', 'Render (94.56%)', 'Uploading (3.20%)')

cbbPalette = c('#000000', "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")