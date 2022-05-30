## Make sure data is prepped first ... esp if added new tracks recently
library(gpxhelpers)
project <- "Bayfield County"
basedir <- file.path("C:/aaaPersonal/MAPPING",project)
datfile <- paste0(project,".csv")
walk <- "SQRL1"
walkReports(walk,project,datfile,basedir,showFileInBrowser=TRUE)
