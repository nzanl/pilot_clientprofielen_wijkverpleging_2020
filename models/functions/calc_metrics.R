# needs metrics.R for various performance metric functions

calc_metrics <- function(fit){
  
  # calc metrics
  output <- setDT(fit$pred)
  
  # select only results for best hyperparameter
  hyperparameter <- names(fit$bestTune)[1]
  
  if(hyperparameter == "cp") { # CART
    output  <- output[cp == fit$bestTune$cp, ]
  } else if (hyperparameter == "mtry") { # Random Forest
    output  <- output[mtry == fit$bestTune$mtry, ] 
    } else if (hyperparameter == "intercept") { # ols
      output <- output[intercept == fit$bestTune$intercept, ]
    } else {
      stop("fit_method ontbreekt / niet bekend")
    }
  
  # metrics per fold-repeat Fold01.Rep01 ...
  res <- output[, 
                list(n_obs = nrow(fit$trainingData), 
                     #mtry = fit$bestTune$mtry,
                     MAPE = Calculate_MAE(obs, pred), 
                     CPM = Calculate_CPM(obs, pred), 
                     RMSE = Calculate_RMSE(obs, pred), 
                     Rsquared = Calculate_R2(obs, pred)), .(Resample)]
  
  # average per repeat over folds
  # SD over folds
  res <- res[, list(n_obs = unique(n_obs),
                    #mtry = unique(mtry),
                    minMAPE = min(MAPE), 
                    MAPE = mean(MAPE), 
                    maxMAPE = max(MAPE), 
                    sdMAPE = sd(MAPE),
                    minCPM = min(CPM), 
                    CPM = mean(CPM), 
                    maxCPM = max(CPM), 
                    sdCPM = sd(CPM),
                    minRMSE = min(RMSE),
                    RMSE = mean(RMSE), 
                    maxRMSE = max(RMSE),
                    sdRMSE = sd(RMSE),
                    minRsquared = min(Rsquared),
                    Rsquared = mean(Rsquared),
                    maxRsquared = max(Rsquared),
                    sdRsquared = sd(Rsquared),
                    n_resamp = .N), .(substr(Resample, 8, 12))] 
  
  # average over all fold-repeats, both for mean and sd
  res <- res[, list(n_obs = unique(n_obs),
                    #mtry = unique(mtry),
                    minMAPE = mean(minMAPE), 
                    meanMAPE = mean(MAPE), 
                    maxMAPE = mean(maxMAPE), 
                    sdMAPE = mean(sdMAPE),
                    Rp_minMAPE = min(MAPE),
                    Rp_maxMAPE = max(MAPE),
                    minCPM = mean(minCPM)*100, 
                    meanCPM = mean(CPM)*100, 
                    maxCPM = mean(maxCPM)*100, 
                    sdCPM = mean(sdCPM)*100,
                    Rp_minCPM = min(CPM)*100,
                    Rp_maxCPM = max(CPM)*100,
                    minRMSE = mean(minRMSE), 
                    meanRMSE = mean(RMSE), 
                    maxRMSE = mean(maxRMSE), 
                    sdRMSE = mean(sdRMSE),
                    Rp_minRMSE = min(RMSE),
                    Rp_maxRMSE = max(RMSE),
                    minRsquared = mean(minRsquared)*100,
                    meanRsquared = mean(Rsquared)*100,
                    maxRsquared = mean(maxRsquared)*100,
                    sdRsquared = mean(sdRsquared)*100,
                    Rp_minRsquared = min(Rsquared)*100,
                    Rp_maxRsquared = max(Rsquared)*100,
                    n_resamp = unique(n_resamp),
                    n_repeats = .N)]
  
  # add number of terminal nodes (aka clusters) for rpart
  if(hyperparameter == "cp") {
    res$n_clusters  <- sum(fit$finalModel$frame$var == "<leaf>")
  } else if (hyperparameter == "mtry") {
    res$n_clusters  <- NA # select only results for best mtry
  } else if (hyperparameter == "intercept") {
    res$n_clusters <- NA 
    } else {
    stop("fit_method ontbreekt / niet bekend")
  }
  
  # add number of predictors
  
  res$n_preds <- ncol(fit$trainingData) - 1
  res
  
}

