addVarsToVarlist <- function(varlist, vars) {
  extra_vars <- cbind(vars, deparse(substitute(vars)), 1)
  colnames(extra_vars) <- c("varname", "setname", "N")
  
  varlist <- rbind(varlist, extra_vars, fill = T)
  varlist
}