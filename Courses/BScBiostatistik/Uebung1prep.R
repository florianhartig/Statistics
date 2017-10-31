Daten <- read.csv("C:/Users/LocalAdmin/Work/Teaching/@UR/Statistik@Git/Courses/BScBiostatistik/Biostatistik Umfrage.csv", 
                  na.strings = "", fileEncoding = "UTF-8", sep=",")

names(Daten) = c("Datum", "Einwohnerzahl", "Distanz", "Körpergröße", "SchwierigkeitStudium", "Semesterferien", 
                 "Geschlecht", "Augenfarbe", "Transport", "Feierabendgetränk", "Vegetarier")
head(Daten)

Daten$Einwohnerzahl <- as.integer(Daten$Einwohnerzahl)
Daten$Datum <- NULL

Daten <- rbind(Daten, rep(NA, ncol(Daten)))

write.csv(Daten, "C:/Users/LocalAdmin/Work/Teaching/@UR/Statistik@Git/Courses/BScBiostatistik/Daten.csv", row.names = F)



