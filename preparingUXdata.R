# Loading UX data ===========================================================

con <- file("UXdata2023-04-28.csv", "r", blocking = FALSE)

data = readLines(con)
close.connection(con)
rm(con)

df = strsplit(data, split=";")
rm(data)

n_row = length(df)
n_col = 65

dataUX = matrix(nrow = n_row - 1, ncol = n_col)
for (i in 1:(n_row-1)){
  for (j in 1:n_col){
    dataUX[i,j] = df[[i+1]][j]
  }
}
rm(i, j, n_col, n_row)

dataUX = as.data.frame.matrix(dataUX)


colnames(dataUX) <- df[[1]]

colnames(dataUX)[2] = "ParticipantID"
colnames(dataUX)[3] = "Condition"

# df not used anymore
rm(df)

dataUX <- dataUX %>%
  mutate(Condition =
           factor(recode(Condition,
                         HED = 'Head', HIP = 'Hip',
                         STF = 'StandingFootVelocity', AVG =  'AverageShoes' ),
                  levels = c("Head", "Hip",
                             "StandingFootVelocity", "AverageShoes")
           ) )


# Loading data questions ============================================

data_questions = read.csv("UXdata_questions2023-04-17.csv", #this is the same also for the dataset at 2023-04-28, so does not have to be changed 
                          sep = ";")

# here questions are inverted if 1 is best, and 5 is worst.
# additionally there are some questions on speed and direction, where 3 is best, and 1 and 5 are worst. (speed/direction too fast/slow) These are corrected here.
for (i_question in 1:61){
  if (data_questions$ToBeInverted[i_question] == -1){
    dataUX[, i_question + 3] = 6 - as.numeric(dataUX[, i_question + 3])        #invert if 1 is best and 5 is worst, to 1 is worst and 5 is best
  } else if (data_questions$ToBeInverted[i_question] == -2){                 
    dataUX[, i_question + 3] = 5 - as.numeric(dataUX[, i_question + 3]) * 4/3  # this scaling is for the VR sickness questions since those are Likert scale 0 to 3, and should now be mapped from 1 to 5 to normalize
  } else {
    dataUX[, i_question + 3] = as.numeric(dataUX[, i_question + 3])            # else, keep default scaling.
  }
} 
rm(i_question)

# Fixing column names

colnames(dataUX)[which(colnames(dataUX) == "Condition")] = "LocomotionTechnique"

