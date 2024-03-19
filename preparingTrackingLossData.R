
dataTrackingLoss = read.csv(file = "trackerloss_200ms.csv", header = TRUE,
                            sep = ";")


colnames(dataTrackingLoss)[
  which(colnames(dataTrackingLoss) == "SubjectNr")] = "ParticipantID"
