project <- "Iron River Area"
basedir <- here::here()

## Prep data
source(paste0(file.path(basedir,"Scripts"),"/dataPrepHelper.R"))
dat <- dataPrepHelper(project=project,basedir=basedir)

## Make vector of colors for Iron River Area
clrs <- c("Highway"="#CC0000","Paved"="#336666",
          "Gravel"="#CC6600","Offroad"="#CC9900",
          "Trail"="#999933", "ATV"="#663300")

## TEST ... Map all tracks
gpxhelpers::allTracksMap(dat,clrs)

## Try a past "walk"
walks <- readxl::read_excel(fn,sheet="Walks") |>
  dplyr::filter(Project==project)
( walkList <- unique(walks$Walk) )

walkIDs <- gpxhelpers::walkGetTrackIDs(walks,whichWalk=walkList[24])
awalk <- gpxhelpers::walkMaker(dat,info,walkIDs,findOrder=FALSE)

gpxhelpers::walkMap(awalk,clrs)
gpxhelpers::walkElevation(awalk)
gpxhelpers::walkSummary(awalk)

## Try a future "walk"
walkIDs <- c("OGLE01","EGLS01","LEDN03","LEDN02","EGLK02","EGLK01","CTYH22",
             "KNTS01","CTYH24","TBPK01","TBPK02","HART05","HART04","HART03",
             "HART02","PINE01","CTYH06","CTYH07","CTYH08","CTYH09","CTYH10",
             "CTYH11","CTYH12","CTYH13","CTYH14","CTYH15","CTYH16","CTYH17",
             "CTYH18","CTYH19","CTYH20","CTYH21","CTYH22","EGLK01","EGLK02",
             "LEDN02","LEDN03","EGLS01","OGLE01")
awalk <- gpxhelpers::walkMaker(dat,info,walkIDs,findOrder=FALSE)
gpxhelpers::walkMap(awalk,clrs)
gpxhelpers::walkElevation(awalk)
gpxhelpers::walkSummary(awalk)
