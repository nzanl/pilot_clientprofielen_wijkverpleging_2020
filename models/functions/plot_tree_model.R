plot_tree_model <- function(rpart_model){
  require(rpart.plot)
  # gebaseerd op rattle::fancyRpartPlot()
  rpart.plot::prp(rpart_model, 
                  type = 2, 
                  extra = 101, #box.col = pals[col.index], 
                  nn = TRUE, 
                  varlen = 0, 
                  faclen = 0, 
                  shadow.col = "grey", 
                  box.palette="RdBu",
                  fallen.leaves = TRUE, branch.lty = 3)
  
}