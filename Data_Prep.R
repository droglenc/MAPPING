library(gpxhelpers)

project <- "Pike Chain Area"
basedir <- file.path("c:/aaaPersonal/MAPPING",project)
setwd(basedir)

## Get track information
fn <- file.path("Data","Trail Mapping Info.xlsx")
info <- readxl::read_excel(fn,sheet="Tracks") %>%
  dplyr::filter(Project==project) %>%
  dplyr::mutate(Connected=paste(Start,End,sep=", ")) %>%
  dplyr::select(-Start,-End)

## Check if files in the directory match up with those in the info file
compareFiles2Info(pin=file.path("Tracks","aaaOriginals"),info)

## Sanitize the original gpx files (remove times, update descriptions, etc.)
##   that were created after the moddate
sanitizeTracks(pin=file.path("Tracks","aaaOriginals"),
               pout="Tracks",trkinfo=info,moddate="2022-07-26")
## Combine All Tracks into a single GPX file ... useful for GoogleEarth/Maps
combineTracks2GPX(pin="Tracks",pout="Data",fnm=project)
## Write all tracks to a single CSV
dat <- writeGPXnInfo2CSV(info,file.path("Data",paste0(project,".gpx")))
#dat <- read.csv(file.path("Data",paste0(project,".csv")))

## TEST ... Map all tracks
allTracksMap(dat)

## Try a past "walk"
walks <- readxl::read_excel(fn,sheet="Walks") %>%
  dplyr::filter(Project==project)
( walkList <- unique(walks$Walk) )

walkIDs <- walkGetTrackIDs(walks,whichWalk=walkList[24])
awalk <- walkMaker(dat,info,walkIDs,findOrder=FALSE)
walkMap(awalk)
walkElevation(awalk)
walkSummary(awalk)

## Try a future "walk"
walkIDs <- c("OGLE01","EGLS01","LEDN03","LEDN02","EGLK02","EGLK01","CTYH22",
             "KNTS01","CTYH24","TBPK01","TBPK02","HART05","HART04","HART03",
             "HART02","PINE01","CTYH06","CTYH07","CTYH08","CTYH09","CTYH10",
             "CTYH11","CTYH12","CTYH13","CTYH14","CTYH15","CTYH16","CTYH17",
             "CTYH18","CTYH19","CTYH20","CTYH21","CTYH22","EGLK01","EGLK02",
             "LEDN02","LEDN03","EGLS01","OGLE01")
awalk <- walkMaker(dat,info,walkIDs,findOrder=FALSE)
walkMap(awalk)
walkElevation(awalk)
walkSummary(awalk)
