#########################################################################################
# A2_HoaglinIglewicz_check using SEs
# Based on Zoe's original HoaglinIglewicz check on LIs
#########################################################################################
# This script reads in data from two sessions (1-2) from 6 tasks (A-F) and identifies
# outlier LI.se values using the Hoaglin Iglewicz method (Hoaglin & Iglewicz, 1987)

########################################################
# Install packages
require(dplyr)


########################################################
# Read in LI data

# Read LI data from LI_mean_data.csv file - need have .csv versions of files in working directory
# Create blank data frame to hold results
myexclude <-data.frame(matrix(0,nrow=30,ncol=13))

  readfilename<-paste0('Results_Session1.csv')
  mysessdata <- read.csv(readfilename)
  readfilename<-paste0('Results_Session2.csv')
  mysessdata2 <- read.csv(readfilename)
  se.cols <- seq(from=8, to = 73, by = 13)
  allsessdata <- cbind(mysessdata$Filename,mysessdata[,se.cols],mysessdata2[,se.cols])
  colnames(allsessdata)[1] <-'Filename'
  ########################################################
  # Outliers are defined as  being 
  # more than 2.2 times the difference between the first and third quartiles (2.2 * (Q3-Q1)) 
  # below or above the first and third quartile values 
  # (e.g: lower limit = Q1 – 2.2*(Q3-Q1); upper limit = Q3 + 2.2*(Q3-Q1)). 
  # Because we are using SE, we only want to lose unusually high values, so focus on upper limit
  
 #Here base limits on all tasks, since we want same reliability cutoff for all
  myv<-vector()
  for (t in 1:12){
    myv<-c(myv,allsessdata[,(t+1)])
  }
  lower_quartile <- quantile(myv,probs=.25)
  upper_quartile <- quantile(myv,probs=.75)
  quartile_diff <- upper_quartile - lower_quartile
  upper_limit <- upper_quartile + 1.65*quartile_diff #one-tailed so use lower z-value
 for (t in 1:12){
  w <- which(allsessdata[,t+1] > upper_limit)
  myexclude[w,t+1] <- 1
}


write.csv(myexclude, "LI_se_exclusions.csv")

