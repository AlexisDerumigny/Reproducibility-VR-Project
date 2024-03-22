
dataTime = read.csv(file = "completionTime.csv", header = TRUE,
                            sep = ",", dec=".")


colnames(dataTime)[
  which(colnames(dataTime) == "SubjectNr")] = "ParticipantID"


