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
  
  ## Check if GPX files in the directory match up with those in the info file
  cli::cli_h1("Checking Track Info file and GPX files")
  OK <- gpxhelpers::compareFiles2Info(pin=p_trks_orig,df_info)
  ## If GPX files and info file do not match then abort rest of the process
  if (!OK) cli::cli_abort("Need to fix issue with GPX files and info file.")
  ## IF GPX files and info file do match then continue

  ## Determine status of GPX files in pin
  tmp <- gpxhelpers::findFileStatus(df_info,p_trks_orig,p_trks_sntzd)
  df_info <- tmp$trkinfo
  
  ## Isolate the new and modified tracks
  new_tracks <- dplyr::filter(df_info,status=="NEW")
  mod_tracks <- dplyr::filter(df_info,status=="MODIFIED")
  
  ## Determine if there are any new or modified tracks to handle
  cat("\n")
  cli::cli_h1("Sanitizing Tracks")
  if (nrow(new_tracks)==0 & nrow(mod_tracks)==0) {
    cli::cli_alert_warning("No new or modified tracks to sanitize!!")
  }  else {
    ## Write out the new track information file (assures info file is older than
    ##   the sanitized track files)
    write.csv(df_info,paste0(p_data,"/",project,"_trkinfo.csv"),row.names=FALSE)
    
    ## Remove files from pout that are not listed in the info file
    if (length(tmp$trks_rmvd)>0) {
      file.remove(paste0(file.path(p_trks_sntzd,tmp$trks_rmvd),".gpx"))
      cli::cli_alert_info("Files not in info file but in {p_trks_sntzd} were removed: {paste(tmp$trks_rmvd,collapse=', ')}")
    }
    
    ## Sanitize new and modified tracks
    if(nrow(new_tracks)==0) cli::cli_alert_info("No new tracks to sanitize.")
    else gpxhelpers::sanitizeTracks(trkinfo=new_tracks,pin=p_trks_orig,pout=p_trks_sntzd)
    
    if(nrow(mod_tracks)==0) cli::cli_alert_info("No modified tracks to sanitize.")
    else gpxhelpers::sanitizeTracks(trkinfo=mod_tracks,pin=p_trks_orig,pout=p_trks_sntzd)
  }  

  ## Combine All Tracks into a single GPX file ... useful for GoogleEarth/Maps
  cat("\n")
  cli::cli_h1("Create Master GPX File")
  gpxhelpers::makeMasterGPX(tmp,pin=p_trks_sntzd,pout=p_data,fnm=project)

  ## Write all tracks to a single CSV
  cat("\n")
  cli::cli_h1("Create Master CSV File")
  dat <- gpxhelpers::makeMasterCSV(tmp,pin=p_trks_sntzd,pout=p_data,
                                   fnm=paste0(project,"_trkdat"))

  ## Send completion message
    cat("\n")
    cli::cli_alert_success("Data preparation for {project} project is complete!")

  ## Return list of results
  list(trkdat=dat,trkinfo=df_info)
}


