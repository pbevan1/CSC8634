library(tidyverse)
# Example preprocessing script.
head(gpu)
head(task.x.y)
tail(application.checkpoints, 20)
head(application.checkpoints)
sum(application.checkpoints$jobId == "1024-lvl12-7e026be3-5fd0-48ee-b7d1-abd61f747705")
application.checkpoints$timestamp[1] + application.checkpoints$timestamp[2]
x <- difftime( as.POSIXct( application.checkpoints$timestamp[1], format="%Y-%m-%dT%H:%M"), 
                                 as.POSIXct( application.checkpoints$timestamp[2], format="%Y-%m-%dT%H:%M:%OS"), 
                                 units="min")
x
help("as.POSIXct")
All_TotalRender = application.checkpoints[which(application.checkpoints$eventName=='TotalRender'),]
All_TotalRender
Sum_TotalRender = abs(difftime( as.POSIXct( All_TotalRender$timestamp[1], format="%Y-%m-%dT%H:%M"), 
               as.POSIXct( All_TotalRender$timestamp[132080], format="%Y-%m-%dT%H:%M:%OS"), 
               units="min"))
library(glue)
glue('The total time elapsed for TotalRender was {Sum_TotalRender} mins')


as.data.table(application.checkpoints)[, sum(cover), by = .(plotID, species)]

application.checkpoints$timestamp <- as.POSIXct(strptime(levels(application.checkpoints$timestamp)[application.checkpoints$timestamp], format="%m-%d-%Y:%H.%M"))
application.checkpoints %>% group_by(hostname, jobId, taskId, eventName)  %>% mutate(elapsed = difftime(timestamp, lag(timestamp))) %>% summarise(na.omit(elapsed))
application.checkpoints


as.data.table(application.checkpoints)[, sum(cover), by = .(plotID, species)]

application.checkpoints$diffTime <- c(0, difftime(lubridate::ymd_hms(application.checkpoints$timestamp[-1]), 
                                 lubridate::ymd_hms(application.checkpoints$timestamp[-nrow(application.checkpoints)]), units="auto"))
diffTime <- application.checkpoints %>% group_by(hostname, jobId, taskId, eventName) %>% summarize((diffTime))

##add to git