fit_cart <- function(df, model, varsets, aanb){
  train.control <- trainControl(method = model$cv_method, 
                                number = model$nr_folds, 
                                repeats = model$nr_repeats, 
                               selectionFunction = model$selectionFunction,
                               summaryFunction = mySummary,
                                savePredictions = TRUE)
  
  n_pred <- ncol(df) - 1
  
  # hyperparameter grid
  cart.grid <- expand.grid(cp = seq(0, 0.02, 0.001))

  cart_formula <- as.formula(paste("y", "~ ."))
  
  set.seed(model$random_seed)
  
  # intercept only model
  if(n_pred == 0) df$cnst <- 1
  
  # https://github.com/topepo/caret/blob/master/models/files/rpart.R
  cart_fit <- train(cart_formula,
                    data = df,
                    method = "rpart",
                    trControl = train.control,
                    metric = model$metric,
                    maximize = ifelse(model$metric %in% c("RMSE", "MAE", 
                                                    "dist20", "dist50", 
                                                    "dist150"), FALSE,
                                      TRUE),
                    control = rpart::rpart.control(minbucket = model$minbucket),
                    tuneGrid = cart.grid) 
  
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
  
  saveRDS(cart_fit, file = target)
}


# test tolerance function
df <- data.frame(Rsquared = c(5, 10, 12, 20, 21.5, 21.7, 22))

caret::tolerance(df, metric = "Rsquared", tol = 1.5, maximize = TRUE)

caret::tolerance(df, metric = "Rsquared", tol = 1.35, maximize = TRUE)

