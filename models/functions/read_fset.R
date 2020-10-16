
# LET OP heeft dir_pilot als global var nodig

# LET OP heeft ds_id als global var nodig

read_fset <- function(fs_id, aanb_type = "all") {
  char_fs_id <- sprintf("%02d", fs_id)
  char_ds_id <- sprintf("%02d", ds_id)
  
  if(aanb_type == "nanda") {
    aanb <- "aanb_nd" 
  } else if(aanb_type == "omaha"){
      aanb <- "aanb_om"
  } else { 
    aanb <- "all"
  }
  
  fpattern <- paste0("^FSID_", char_fs_id, "_DSID_", char_ds_id,  ".*\\_features_", aanb, ".rds$") 
  
  fdir <- paste0(dir_pilot, "/Output")
  
  fname <- list.files(path = fdir,
                      pattern = fpattern)
  
  fname <- paste0(fdir, "/", fname)
  
  df <- readRDS(fname)
  
  return(df)
}

