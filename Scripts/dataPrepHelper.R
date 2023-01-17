dataPrepHelper <- function(project,basedir=here::here(),verbose=TRUE) {
  ## set filenames and paths for use below
  fn_info <- file.path(basedir,"Data","Trail Mapping Info.xlsx")
  p_trks_orig <- file.path(basedir,"Tracks",project,"aaaOriginals")
  p_trks_sntzd <- file.path(basedir,"Tracks",project)
  p_data <- file.path(basedir,"Data")
  
  ## Get track information
  df_info <- readxl::read_excel(fn_info,sheet="Tracks") |>
    dplyr::filter(Project==project) |>
    dplyr::mutate(Connected=paste(Start,End,sep=", ")) |>
    dplyr::select(-Start,-End)
  write.csv(df_info,paste0(p_data,"/",project,"_trkinfo.csv"),row.names=FALSE)
  
  ## Check if files in the directory match up with those in the info file
  gpxhelpers::compareFiles2Info(pin=p_trks_orig,df_info)
  
  ## Sanitize the original gpx files (remove times, update descriptions, etc.)
  ##   that were created since last sanitized file in pout
  gpxhelpers::sanitizeTracks(trkinfo=df_info,
                             pin=p_trks_orig,pout=p_trks_sntzd)
  
  ## Combine All Tracks into a single GPX file ... useful for GoogleEarth/Maps
  gpxhelpers::combineTracks2GPX(pin=p_trks_sntzd,
                                pout=p_data,fnm=project)
  
  ## Write all tracks to a single CSV
  dat <- gpxhelpers::writeGPXnInfo2CSV(trkinfo=df_info,
                                       pin=p_trks_sntzd,pout=p_data,
                                       fnm=paste0(project,"_trkdat"))
  
  ## Send completion message
  if (verbose) {
    cat("\n")
    cli::cli_alert_success("Data preparation for {project} project is complete!")
  }
  list(trkdat=dat,trkinfo=df_info)
}

