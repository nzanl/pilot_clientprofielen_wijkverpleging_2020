# inlezen en preppen feature_set

prep_fset <- function(model, fs_list, varlist, varsets){
  
  if(nrow(varsets) > 1) stop("no unique varsets list selected")
  if(nrow(model) > 1) stop("no unique model selected")
  
  # inlezen feature set obv aanbieder type 
  df <- read_fset(fs_list$fs_id, varsets$aanb_type)
  
  # selecteer aanbieders om te fitten (nu dubbelop, misschien later nog handig)
  
  if(varsets$aanb_type == "all") aanb_sel <- c(101:104)
  if(varsets$aanb_type == "nanda") aanb_sel <- c(101:102)
  if(varsets$aanb_type == "omaha") aanb_sel <- c(103:104)
  
  df <- df[AanbiederID %in% aanb_sel, ]
  
  # selecteer de lijst met benodigde var_sets, muv aanb_type en var_set_id kolom
  var_set_list <- setdiff(colnames(varsets)[varsets == 1], 
                          c("var_set_id", "aanb_type"))
  
  if(!identical(var_set_list, character(0))){
   # lijst met benodigde indep vars
    pred_vars <- varlist[setname %in% var_set_list]$varname
  } else { pred_vars <- c()}
  # de benodige dep var
  dep_var <- varsets$dep_var
  
  
  
  if(model$int_validate == 1) { var_sel <- colnames(df) %in% c(dep_var, pred_vars, "AanbiederID")
  } else {
    var_sel <- colnames(df) %in% c(dep_var, pred_vars)
  }
  # selecteer benodigde vars uit de fs
  df <- df[, var_sel, with = FALSE]
  
  setnames(df, dep_var, "y")
  return(df)
}
