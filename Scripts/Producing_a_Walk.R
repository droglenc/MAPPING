## Make sure data is prepped first ... esp if added new tracks recently
library(gpxhelpers)
project <- "Pike Chain Area"
basedir <- file.path("C:/aaaPersonal/MAPPING",project)
datfile <- paste0(project,".csv")
walk <- "RYND1"
walkReports(walk,project,datfile,basedir,showFileInBrowser=TRUE,quiet=TRUE)
