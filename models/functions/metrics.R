##################################################
# Collection of functions that quantify goodness of fit between
# predictions and actual values


Calculate_R2 <- function(true_vals, pred_vals){
  residuals <- true_vals - pred_vals
  SS_res <- sum(residuals^2)
  SS_tot <- sum( (true_vals - 
                    mean(true_vals) )^2)
  R_square <- 1 - SS_res/SS_tot
  R_square
}

Calculate_RMSE <- function(true_vals, pred_vals){
  residuals <- true_vals - pred_vals
  MSE <- sqrt(mean(residuals^2))
  MSE
}

Calculate_R2_cor <- function(true_vals, pred_vals){
  corr <- cor(true_vals, pred_vals)
  R2 <- corr^2
  R2
}

Calculate_MAE <- function(true_vals, pred_vals){
  residuals <- true_vals - pred_vals
  MAE <- mean(abs(residuals))
  MAE
}

Calculate_GGAA <- function(true_vals, pred_vals, weights){
  residuals <- true_vals - pred_vals
  GGAA <- weighted.mean(abs(residuals), weights)
  GGAA
}

Calculate_CPM <- function(true_vals, pred_vals){
  residuals <- abs(true_vals - pred_vals)
  Sum_res <- sum(residuals)
  Sum_tot <- sum( abs(true_vals - 
                    mean(true_vals) ))
  CPM <- 1 - Sum_res/Sum_tot
  CPM
}
