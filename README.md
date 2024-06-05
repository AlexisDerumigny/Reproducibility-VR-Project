# What is this?
This is a repository that contains the statistical analysis in R from the VR shoes experiment (LINK TO FULL PAPER).

- This project: Statistics processing in R based on UX and tracker data, this link is [VR shoes R statistics processing Github](https://github.com/AlexisDerumigny/Reproducibility-VR-Project).
- Processing tracking data from Unity to plots and csv files ready for statistic analysis: [Processing tracker data Github](https://github.com/AmberElferink/VRshoesDataProcessing)
- For the virtual Unity environment in the user test that the users walked in and gathered the tracking data see [VR shoes Unity Environment Github](https://github.com/AmberElferink/LocomotionEvaluation).

## Raw User Experience data / Questionnaires
The .csv files in this project are minimally processed to work with R. The originals can be found at:

- [Raw Data Consent form + demographics + Habituation questions Google Spreadsheet](https://docs.google.com/spreadsheets/d/18L1FDxcECkfh0YWAIcpaJXAqzQvc4uHcm83MKERbGXg/edit?usp=sharing)
- [Raw Data UX answers for each trial](https://docs.google.com/spreadsheets/d/1mwZUULM_gU6-xjh3AGX8X6qKFkpROcqetkRowhyOwM8/edit?usp=sharing)


If you want to use the questionnaire in your own experiment, you can copy the form for your own use with the following links:
- [Consent form + demographics + Habituation Google Form ](https://docs.google.com/forms/d/16HUnzGaGV9iMNdykEuPBm8y9UqQQHBMW23HlNOklhPY/copy)
- [UX questions for each trial Google Form](https://docs.google.com/forms/d/1SUaqCdrhtiCeiOQPW767yPz0z7UIzTfgg31t2_o47Wo/copy)


## How to install
Install Rstudio and open the project.
Our version used: R version 4.3.3 (2024-02-29 ucrt).

### Install packages:
In the R console, run the following command to install all packages: 

`install.packages(c("knitr", "pbkrtest", "lmerTest", "tidyverse", "emmeans", "gt"))`


## Troubleshooting: Package issues
The command at install packages should install all required packages. In case of issues, the file package versions.txt contains the package versions used at the time of writing.
