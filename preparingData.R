# 1a. Loading UX data ==========================================================

dataUX = read.csv(file = "UXdata2023-04-28.csv", sep = ";", check.names	= FALSE)

colnames(dataUX)[2] = "ParticipantID"
colnames(dataUX)[3] = "LocomotionTechnique"


dataUX <- dataUX %>%
  mutate(LocomotionTechnique =
           factor(recode(LocomotionTechnique,
                         HED = 'Head', HIP = 'Hip',
                         STF = 'StandingFootVelocity', AVG =  'AverageShoes' ),
                  levels = c("Head", "Hip",
                             "StandingFootVelocity", "AverageShoes")
           ),
         orderCondition = factor(orderCondition, levels = 1:4))


# 1b. Loading data questions ===================================================

# This is the same also for the dataset at 2023-04-28, so does not have to be changed.
data_questions = read.csv("UXdata_questions2023-04-17.csv", sep = ";")

# This is the number of columns in the data.frame `dataUX` that are present
# before the start of the questions.
offSet_questions_in_data_UX = 4

# Here questions are inverted if 1 is best, and 5 is worst.
# additionally there are some questions on speed and direction,
# where 3 is best, and 1 and 5 are worst. (speed/direction too fast/slow).
# These are corrected here.
# This also converts all questions to the `numeric` type.

for (i_question in 1:61){
  indexColumnQuestion = i_question + offSet_questions_in_data_UX
  if (data_questions$ToBeInverted[i_question] == -1){
    
    dataUX[, indexColumnQuestion] = 6 - as.numeric(dataUX[, indexColumnQuestion])
    # Invert if 1 is best and 5 is worst, to 1 is worst and 5 is best
    
  } else if (data_questions$ToBeInverted[i_question] == -2) {
    
    dataUX[, indexColumnQuestion] = 5 - as.numeric(dataUX[, indexColumnQuestion]) * 4/3
    # This scaling is for the VR sickness questions since those are Likert scale 0 to 3,
    # and should now be mapped from 1 to 5 to normalize.
    
  } else {
    dataUX[, indexColumnQuestion] = as.numeric(dataUX[, indexColumnQuestion])
    # else, keep default scaling and convert to `numeric` type.
  }
}

# Cleaning up unused variables
rm(i_question, offSet_questions_in_data_UX, indexColumnQuestion)


# 2. Preparing time data =======================================================

dataTime = read.csv(file = "completionTime.csv", header = TRUE,
                    sep = ",", dec=".")

colnames(dataTime)[
  which(colnames(dataTime) == "SubjectNr")] = "ParticipantID"


# 3, Preparing tracking loss data ==============================================


dataTrackingLoss = read.csv(file = "trackerloss_200ms.csv", header = TRUE,
                            sep = ";")

colnames(dataTrackingLoss)[
  which(colnames(dataTrackingLoss) == "SubjectNr")] = "ParticipantID"


# 4. Merging all together ======================================================

dataTimeTrackingLoss = full_join(
  x = dataTrackingLoss |> select(! all_of("Index")),
  y = dataTime |> select(! all_of("Index")),
  by = c("ParticipantID", "LocomotionTechnique"),
  suffix = c(".x", ".y"),
  keep = NULL
)

data_all = full_join(
  x = dataTimeTrackingLoss,
  y = dataUX |> mutate(ParticipantID = as.integer(ParticipantID)),
  by = c("ParticipantID", "LocomotionTechnique"),
  suffix = c(".x", ".y"),
  keep = NULL
)

rm(dataTime, dataTimeTrackingLoss, dataTrackingLoss, dataUX)


# 5. Creating `data_UX_pivot`  =================================================

# Put in tidy format: one value per line
# (repeat questions for each participant and each LocomotionTechnique)

dataUX_pivot = pivot_longer(
  data = data_all, cols = !all_of(c("Timestamp", "ParticipantID" , 
                                    "LocomotionTechnique", "orderCondition",
                                    "NrTrackerlosses", "completionTime")),
  names_to = "QuestionName"
)

dataUX_pivot$QuestionGroup = NA

for (i_question in 1:61){
  question = data_questions$Question_description[i_question]
  group = data_questions$QuestionGroup[i_question]
  dataUX_pivot$QuestionGroup[
    which(dataUX_pivot$QuestionName == question) ] = group
}

# Selecting only ``valid questions''
# the two questions on speed questions with 3 being best, 5 and 1 being worst
# are labeled 0 and counted as "invalid"
valid_questions = data_questions$Question_description[which(data_questions$ToBeInverted != 0)]

dataUX_pivot_Speed = dataUX_pivot[which(!dataUX_pivot$QuestionName %in% valid_questions), ]

dataUX_pivot = dataUX_pivot[which(dataUX_pivot$QuestionName %in% valid_questions), ]

# Scaling the values to be between 0 and 100.
dataUX_pivot$value = (dataUX_pivot$value - 1) * 100 / 4

# Renaming SSQ to VR Sickness
dataUX_pivot$QuestionGroup = if_else(condition = dataUX_pivot$QuestionGroup == "SSQ",
                                     true = "VR Sickness",
                                     false = dataUX_pivot$QuestionGroup)

rm(group, i_question, question, valid_questions)

