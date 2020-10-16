# wrapper voor caret

fit_model <- function(model, fs_list, varlist, varsets){
  #GENERAL
  print("model specs")
  print(as.character(model))
  #seed
  set.seed(model$random_seed)
  
  # inlezen data
  df <- prep_fset(model, fs_list, varlist, varsets)
  print("feature specs")
  print(as.character(varsets))
  
  # here run preprocess script
  filename <- paste0("pre_process_scripts/", model$pre_process, ".R")
  source(filename, local = TRUE)
  
  aanb_list <- unique(df$AanbiederID)
  
  if(model$int_validate == 1 &
     length(aanb_list) > 1){
    
    for(aanb in aanb_list){
      df_ss <- df[AanbiederID != aanb]
      df_ss$AanbiederID <- NULL
      
      # fit model on subset of providers
      fit_wrapper(df_ss, model, varsets, aanb = aanb)
    }
  } else {
    # Fit model on all providers
    fit_wrapper(df, model, varsets)
    }
  return(-1)
}

fit_wrapper <- function(df, model, varsets, aanb = NA){
  
  # data ready; fit model
  if(varsets$var_set_label != "intercept only"){
    
    if(model$fit_method == "random_forest"){
      
      fit_random_forest(df, model, varsets)
      
    } else if (model$fit_method == "cart"){
      
      fit_cart(df, model, varsets, aanb)
      
    } else if (model$fit_method == "ols"){
      
      fit_ols(df, model, varsets, aanb)
      
    } else {
      
      stop("fit_method unknown")
    }
  } else {
    
    fit_intercept(df, model, varsets, aanb)
    
  } 
  #  if(model$fit_method == "rf_plus_cart"){
  #    fit_rf_plus_cart(df, model) # Nog niet geimplementeerd
  #  }  
}
