plot_fs <- function(var_set_id_sel, compare = 'meanRsquared') {
  
  res <- model_res[var_set_id == var_set_id_sel]
  res <- res[fit_method == 'random_forest']
  
  max <- res[, max(get(compare))]
  
  res[, fs_label := paste0("id", fs_id, ": ", fs_label)]
  
  if(compare %in% c('meanRsquared', 'meanCMP')) {
    # plot results
    gp <- ggplot(res, aes(x = reorder(fs_label, n_obs), y = get(compare))) +
      geom_point(size = 3) +
      #geom_point(size = 3, aes(shape = fit_method)) +
      coord_flip() +
      expand_limits(y = as.integer(max + 6)) +
      geom_text(aes(label = paste0("N = ", n_obs)), y = as.integer(max + 4)) +
      ggtitle(paste0("Model: ", res$var_set_label, " (id", res$var_set_id, ")")) +
      xlab("Label feature keuzes") +
      ylab(compare)
  } else {
    # plot results
    gp <- ggplot(res, aes(x = reorder(fs_label, n_obs), y = get(compare))) +
      geom_point(size = 3) +
      #geom_point(size = 3, aes(shape = fit_method)) +
      coord_flip() + 
      expand_limits(y = as.integer(max + 3)) + 
      geom_text(aes(label = paste0("N = ", n_obs)), y = as.integer(max + 2)) +
      ggtitle(paste0("Model: ", res$var_set_label, " (id", res$var_set_id, ")")) + 
      xlab("Label feature keuzes") + 
      ylab(compare)
  }
  
  print(gp)
  
}
