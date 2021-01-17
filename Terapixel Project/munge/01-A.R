library(ProjectTemplate)
load.project()
library(tidyverse)
# Example preprocessing script.
head(gpu)
head(task.x.y)
head(application.checkpoints)

TotalRender = filter(application.checkpoints, eventName=='TotalRender')
TotalRender %>% mutate(timeN = as.POSIXct(timestamp, format = '%H:%M:%S')) %>% group_by(taskId) %>% summarise(timediff = difftime(first(timeN), last(timeN), unit = 'sec'))

TotalRender_elapsed = TotalRender %>% mutate(timeN = as.POSIXct( TotalRender$timestamp, format="%Y-%m-%dT%H:%M:%OS"))%>% group_by(taskId) %>% summarise(timediff = abs(difftime(first(timeN), last(timeN), unit = 'sec')))
