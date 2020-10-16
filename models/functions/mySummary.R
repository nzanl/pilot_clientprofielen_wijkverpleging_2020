# caret custom summary function

mySummary <- function (data, lev = NULL, model = NULL) { 
  pred <- data$pred
  obs <- data$obs
  
  # gebruik code van caret zelf voor RMSE , R2 en MAE
  
  isNA <- is.na(pred)
  pred <- pred[!isNA]
  obs <- obs[!isNA]
  
  if (!is.factor(obs) && is.numeric(obs))
  {
    if(length(obs) + length(pred) == 0)
    {
      out <- rep(NA, 3)
    } else {
      if(length(unique(pred)) < 2 || length(unique(obs)) < 2)
      {
        resamplCor <- NA
      } else {
        resamplCor <- try(cor(pred, obs, use = "pairwise.complete.obs"), silent = TRUE)
        
        if (inherits(resamplCor, "try-error")) resamplCor <- NA
      }
      mse <- mean((pred - obs)^2)
      mae <- mean(abs(pred - obs))
      
      
    }
    
  } 
  # einde caret code
  
  # voeg eigen metric toe
  nclust = length(unique(pred))
  
  dist_to_20 = abs(nclust - 20)
  dist_to_50 = abs(nclust - 50)
  dist_to_150 = abs(nclust - 150)
    
  out <- c(sqrt(mse), resamplCor^2, mae, nclust, dist_to_20, dist_to_50, dist_to_150)
  
  names(out) <- c("RMSE", "Rsquared", "MAE", "Nclusters", "dist20", "dist50", "dist150")
  
  return(out)
}
