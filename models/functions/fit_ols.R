fit_ols <- function(df, model, varsets, aanb){
  
  train.control <- trainControl(method = model$cv_method, 
                                number = model$nr_folds, 
                                repeats = model$nr_repeats, 
                               selectionFunction = model$selectionFunction,
                               summaryFunction = mySummary,
                                savePredictions = TRUE)
  
  n_pred <- ncol(df) - 1
  
  # hyperparameter grid
  #cart.grid <- expand.grid(cp = seq(0, 0.02, 0.001))

  ols_formula <- as.formula(paste("y", "~ ."))
  
  set.seed(model$random_seed)
  
  # convert all casemix questions to factors
  vars_to_convert <- c("VR_cognitie"  ,  "VR_kleden"  ,    "VR_maaltijd" ,   
             "VR_mobiliteit" , "VR_toilet"  ,    "VR_voeden" ,    
             "VR_wassen" ,  "VR_continentie", "VR_medicatie")   

  # check which are present, if any
  vars_to_convert <- intersect(colnames(df), vars_to_convert)
  
  if(length(vars_to_convert) > 0) {
    for (col in vars_to_convert) 
      set(df, j = col, value = as.factor(df[[col]]))
  }
  
  # intercept only model
  if(n_pred == 0) df$cnst <- 1
  
  # https://github.com/topepo/caret/blob/master/models/files/rpart.R
  ols_fit <- train(ols_formula,
                    data = df,
                    method = "lm",
                    trControl = train.control,
                    metric = model$metric,
                    maximize = ifelse(model$metric %in% c("RMSE", "MAE", 
                                                    "dist20", "dist50", 
                                                    "dist150"), FALSE,
                                      TRUE)) 
  
  # store result
  if(model$int_validate == 1){
    target <- paste0("../work/Output/fit_", "FS", fs_list$fs_id, "_DS", ds_id, "_model",
                     model$model_id, "_vs_varid", varsets$var_set_id, "ex", aanb, ".rds")
  } else {
  target <- paste0("../work/Output/fit_", "FS", fs_list$fs_id, "_DS", ds_id, "_model",
                   model$model_id, "_vs_varid", varsets$var_set_id, ".rds")
  }
  print("Saving to ")
  print(target)
  
  saveRDS(ols_fit, file = target)
}



