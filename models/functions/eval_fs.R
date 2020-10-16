eval_fs <- function(df = model_res, sel_cols, sel_vs, sel_model, sel_mins = 1, sel_minb = 1, output = 'meanRsquared') {
  
  ctrl <- rpart.control(minsplit = sel_mins,
                        minbucket = sel_minb,
                        maxdepth = 30,
                        cp = 0.001)
  
  cart_formula <- as.formula(paste(output, "~ ."))
  
  rp_fit <- rpart(formula = cart_formula,
                  data = df[var_set_id %in% sel_vs & model_id == sel_model, c(output, sel_cols), with=F], 
                  method = 'anova',
                  model = T,
                  control = ctrl)
  
  png_out_name <- paste0("../work/fs_eval/", "fseval", "_m", sel_model, "_vs", sel_vs, "_", output, ".png")
  
  png(file = png_out_name, 
      width = 2*640, # The width of the plot in inches
      height = 2*480,
      pointsize = 18) # The height of the plot in inches
  
  plot <- rpart.plot::prp(rp_fit, 
                          type = 2, 
                          extra = 101, #box.col = pals[col.index], 
                          nn = TRUE, 
                          varlen = 0, 
                          faclen = 0, 
                          shadow.col = "grey", 
                          box.palette="RdBu",
                          fallen.leaves = TRUE, branch.lty = 3)
  
}