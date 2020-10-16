# download and save example datasets


zorgpolissen <- read.csv2(url("https://raw.githubusercontent.com/nzanl/polis_differentiatie_2018/master/Input/NZA_ACM_polisdata_OPENBAAR.csv"), header=TRUE,
                      stringsAsFactors = FALSE, dec = ",")

zorgpolissen <- na.omit(zorgpolissen)

zorgpolissen$jaar <- paste0("J", zorgpolissen$jaar)

zorgpolissen_achmea <- subset(zorgpolissen, concern == "Achmea")
zorgpolissen_achmea$AanbiederID <- 101
write.csv2(zorgpolissen_achmea, "datasources/achmea/200901/200901_zorgpolissen_achmea.csv")

zorgpolissen_cz <- subset(zorgpolissen, concern == "CZ")
zorgpolissen_cz$AanbiederID <- 102
write.csv2(zorgpolissen_cz, "datasources/cz/200901/200901_zorgpolissen_cz.csv")

zorgpolissen_vgz <- subset(zorgpolissen, concern == "VGZ")
zorgpolissen_vgz$AanbiederID <- 103
write.csv2(zorgpolissen_vgz, "datasources/vgz/200901/200901_zorgpolissen_vgz.csv")

zorgpolissen_menzis <- subset(zorgpolissen, concern == "Menzis")
zorgpolissen_menzis$AanbiederID <- 104
write.csv2(zorgpolissen_menzis, "datasources/menzis/200901/200901_zorgpolissen_menzis.csv")

zorgpolissen_overig <- subset(zorgpolissen, !(concern %in%  c("Achmea", "CZ", "VGZ", "Menzis")))
zorgpolissen_overig$AanbiederID <- 105
write.csv2(zorgpolissen_overig, "datasources/overig/200901/200901_zorgpolissen_overig.csv")
