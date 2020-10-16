# PM list met metrics is misschien beter

calc_fold_metric <- function(cfit, metric = c("rsq_trad")){ 
  
  metrics <- c("mae", "rmse", "mase", "mape", "rsq", "rsq_trad")
  
  if(!(metric %in% metrics)) stop("metric unknown")
  
  # extract resample values
  df <- data.table(cfit$pred)
  
  if(metric == "rsq"){
    res <- df[cp == unlist(cfit$bestTune), 
              .(metric = yardstick::rsq_vec(truth = obs, estimate = pred)), .(Resample)]$metric
  }
  if(metric == "rsq_trad"){
    res <- df[cp == unlist(cfit$bestTune), 
              .(metric = yardstick::rsq_trad_vec(truth = obs, estimate = pred)), .(Resample)]$metric
  }
  if(metric == "mae"){
    res <- df[cp == unlist(cfit$bestTune), 
              .(metric = yardstick::mae_vec(truth = obs, estimate = pred)), .(Resample)]$metric
  }
  if(metric == "mase"){
    res <- df[cp == unlist(cfit$bestTune), 
              .(metric = yardstick::mase_vec(truth = obs, estimate = pred)), .(Resample)]$metric
  }
  if(metric == "mape"){
    res <- df[cp == unlist(cfit$bestTune), 
              .(metric = yardstick::mape_vec(truth = obs, estimate = pred)), .(Resample)]$metric
  }
  res
}
