construct_model_filelist <- function(model_list_sub, 
                                     feature_set_list_sub, 
                                     varsets, 
                                     aanb_list, 
                                     folder = "../work/Output/") {
 
  # init data.frame for model
  model_filelist <- data.frame(filename = as.character(),
                               fs_id = as.integer(),
                               ds_id = as.integer(),
                               model_id = as.integer(),
                               var_set_id = as.integer(),
                               aanb_ex = as.integer())
  
  for (i in 1:nrow(feature_set_list_sub)) {
    for (j in 1:nrow(model_list_sub)){
      
      if(model_list_sub[j,]$varsets == "all") {
        # selecteer alle var_set_ids van aanbieder type all
        var_set_ids <- varsets[aanb_type == "all",]$var_set_id
      } else if (model_list_sub[j,]$varsets == "nanda"){
        var_set_ids <- varsets[aanb_type == "nanda",]$var_set_id
      }  else if (model_list_sub[j,]$varsets == "omaha"){
        var_set_ids <- varsets[aanb_type == "omaha",]$var_set_id
      }   else {# zijn ids, split deze uit
        var_set_ids <- unlist(strsplit(as.character(model_list_sub[j,]$varsets), split = ";"))
      } 
      
      n_var_sets <- length(var_set_ids)
      
      for(k in 1:n_var_sets){
        # als het model int_validate doet, dan aanbieders langslopen, behalve bij intercept only
        # collect filenames and meta-info about feature_set etc.
        if(model_list_sub[j,]$int_validate == 1 & 
           varsets[var_set_id == var_set_ids[k],]$var_set_label != "intercept only") {
          
          n_aanb_list <- length(aanb_list)
          
          for (l in 1:n_aanb_list) {
            filename <- paste0("fit_", "FS", feature_set_list_sub[i,]$fs_id, "_DS", ds_id, "_model",
                               model_list_sub[j,]$model_id, "_vs_varid", var_set_ids[k], "ex", aanb_list[l], ".rds")
            filename <- paste0(folder, filename)
            #print(filename)
            model_filelist <- rbind(model_filelist, data.frame(filename = filename, 
                                                               fs_id = feature_set_list_sub[i,]$fs_id,
                                                               ds_id = ds_id,
                                                               model_id = model_list_sub[j,]$model_id,
                                                               var_set_id = var_set_ids[k],
                                                               aanb_ex = aanb_list[l]))
          }
          
        } else { #intercept only
          filename <- paste0("fit_", "FS", feature_set_list_sub[i,]$fs_id, "_DS", ds_id, "_model",
                             model_list_sub[j,]$model_id, "_vs_varid", var_set_ids[k], ".rds")
          filename <- paste0(folder, filename)
          #print(filename)
          model_filelist <- rbind(model_filelist, data.frame(filename = filename, 
                                                             fs_id = feature_set_list_sub[i,]$fs_id,
                                                             ds_id = ds_id,
                                                             model_id = model_list_sub[j,]$model_id,
                                                             var_set_id = var_set_ids[k],
                                                             aanb_ex = NA))
        }
      }
    }
  }
  return(model_filelist)
}



