# Loading UX data ==============================================================

dataUX = read.csv(file = "UXdata2023-04-28.csv", sep = ";")

colnames(dataUX)[2] = "ParticipantID"
colnames(dataUX)[3] = "LocomotionTechnique"


dataUX <- dataUX %>%
  mutate(LocomotionTechnique =
           factor(recode(LocomotionTechnique,
                         HED = 'Head', HIP = 'Hip',
                         STF = 'StandingFootVelocity', AVG =  'AverageShoes' ),
                  levels = c("Head", "Hip",
                             "StandingFootVelocity", "AverageShoes")
           ) )


# Loading data questions =======================================================

# This is the same also for the dataset at 2023-04-28, so does not have to be changed 
data_questions = read.csv("UXdata_questions2023-04-17.csv", sep = ";")

# This is the number of columns in the data.frame `dataUX` that are present
# before the start of the questions.
offSet_questions_in_data_UX = 4

# Here questions are inverted if 1 is best, and 5 is worst.
# additionally there are some questions on speed and direction,
# where 3 is best, and 1 and 5 are worst. (speed/direction too fast/slow).
# These are corrected here.
# This also convert all questions to the `numeric` type.

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
rm(i_question, offSet_questions_in_data_UX)

