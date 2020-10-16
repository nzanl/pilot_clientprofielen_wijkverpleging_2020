fit_random_forest <- function(df, model, varsets){
  
  train.control <- trainControl(method = model$cv_method, 
                                number = model$nr_folds, 
                                repeats = model$nr_repeats, 
                                selectionFunction = model$selectionFunction,
                                summaryFunction = mySummary,
                                savePredictions = TRUE)
  
  n_pred <- ncol(df) - 1
  
  # set mtry
  if(n_pred > 0){
    if(model$mtry == "heuristic"){
      mtry_vec <- round(n_pred/3)
    } else { # range
      mtry_vec <- round(exp(seq(from = log(1), 
                                to = log(n_pred), 
                                length.out = model$n_mtry)))
      }
  } else {mtry_vec <- c(1)}
  
  # hyperparameter grid
  rf.grid <- expand.grid(mtry = mtry_vec, 
                         splitrule = model$splitrule, 
                         min.node.size = model$min_node)
  
  rf_formula <- as.formula(paste("y", "~ ."))
  
  set.seed(model$random_seed)
  
  # intercept only model
  if(n_pred == 0) df$cnst <- 1
  
  rf.fit <- train(rf_formula, 
                  data = df,
                  method = "ranger",
                  trControl = train.control,
                  metric = model$metric,
                  maximize = ifelse(model$metric %in% c("RMSE", "MAE", 
                                                        "dist20", "dist50", 
                                                        "dist150"), FALSE,
                                    TRUE),
                  tuneGrid = rf.grid)
  
  # store result
  target <- paste0("../work/Output/fit_", "FS", fs_list$fs_id, "_DS", ds_id, "_model",
                   model$model_id, "_vs_varid", varsets$var_set_id, ".rds")
  print("Saving to ")
  print(target)
  
  saveRDS(rf.fit, file = target)
  
} 
