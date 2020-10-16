# read and process caret fitobjects

process_results <- function(model_filelist, max_results = 1e5){
  first_model <- 1
  
  n_results <- min(nrow(model_filelist), max_results)
  
  for (i in 1:n_results) {
    filename <- as.character(model_filelist[i,]$filename)
    if(file.exists(filename)) {
      # progress reporting
      
      if(i %% 50 != 0){
        cat(".") 
      } else { 
        str <- paste0(i , "/", n_results)
        cat(str)
        cat("\n")
      }
      
      cfit <- readRDS(filename) # caret fit object
      
      # calculate metrics
      res_tmp <- calc_metrics(cfit)
      
      if(first_model == 1){
        # create
        res <- cbind(model_filelist[i,], res_tmp)
        first_model <- 0
      } else { # append
          res <- plyr::rbind.fill(res,
                               cbind(model_filelist[i,], res_tmp))
      }
    } else {
        warning(sprintf('Warning: Model "%s" not found\n', filename))
      }
  }
  return(res)
}


