# hier var selection uitvoeren: zowel simpele als complex

# Check predictors

# ok alles integer of numeric
print("aantal cols pre filtering")

print(as.character(ncol(df)))

print("uitvoeren droppen predictors zonder/weinig variatie: start")

print(as.character(ncol(df)))

drop_indices <- nearZeroVar(df,
                            freqCut = 95/5, 
                            uniqueCut = 10)

sel_indices <- !(1:ncol(df) %in% drop_indices)

df <- df[, sel_indices, with = FALSE]

print("uitvoeren droppen predictors zonder/weinig variatie: success")
print(as.character(ncol(df)))
