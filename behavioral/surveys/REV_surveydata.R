#clean up REV Questionnaire Data


#The code assumes that this Markdown file is in the folder ~/REV_scripts/behavioral/surveys, and the folder structure follows the same hierarchical organization pattern (shown below in the Dir setups)

homeBase = '~/Dropbox/AH Grad Stuff/SAP' #this is the only thing you should need to change

#In order to run this script, first set your working directory to wherever the current file is saved
setwd(paste0(homeBase,'/REV_scripts/behavioral/surveys'))

scriptDir = paste0(homeBase, '/REV_scripts/behavioral/')
catDir = paste0(scriptDir, '/REV_SST/info/')

idDir = paste0(homeBase,'/REV_BxData/')
dataDir = paste0(idDir, '/questionnaire_data/FromQualtrics/')

## Install and load required packages
list.of.packages <- c("stringr", "tidyverse", "reshape2", "ggplot2", "psych", "gridExtra", "knitr", "lme4", "memisc", "withr", "haven")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, library, character.only = TRUE)
#=====================================================================================================================

#Note: The data frame created does not contain all survey data. Will need to create a complete data frame in the future.
### Key:

#**Key to variables in the screen_data data frame:**
#- Gender: Male = 1, Female = 2  
#- Use alcohol: 1 = yes, 2 = no  
#- Make tobacco a factor 1 = yes, 2 = no  
#- Self-control trouble with drugs: 1 = no, NA with score in subcategory = yes  
#- Self-control trouble with food: 1 = no, NA with score in subcategory = yes  

#=====================================================================================================================

#FUNCTIONS:

### function to get indices of various column names (based on scale prefixes)
#grepfun<- function(coln,df) grep(coln, colnames(df))
grepfun<- function(coln,df){
  for(i in 1:length(coln)){
    a<-grep(coln[i], colnames(df))
  }
  return(a)
}

### function to get the indices for a vector of variable column name prefixes
## useL = list of column name prefix strings
## outL = blank list object (where indices will be stored)
outL=findIndexInBL<- function(df, useL, outL,...){
  for(a in 1:length(useL)){
    x<-grepfun(useL[a], df)
    outL[[a]]<-x
  }
  return(outL)
}

#=====================================================================================================================

#IMPORT QUALTRICS DATA:

#categories <- as.data.frame(read.table("~/Desktop/REV_scripts/behavioral/REV_SST/info/participantCategories.txt"))
categories <- as.data.frame(read.table(paste0(catDir, "participantCategories.txt")))
colnames(categories) <- c("ID", "compltd.study", "num.categories", "food", "alcohol", "tobacco", "drugs")
categories <- categories[2:145,]

## General survey
#gen_survey <- as.data.frame(as.data.set(spss.system.file('~/Dropbox/REV/behavioral_data/questionnaire_data/FromQualtrics/REV_General_Survey.sav')))
gen_survey<-read_sav(paste0(dataDir, "REV_General_Survey.sav"))

## Baseline survey
#base_survey <- as.data.frame(as.data.set(spss.system.file('~/Dropbox/REV/behavioral_data/questionnaire_data/FromQualtrics/REV_Baseline_Survey.sav')))
base_survey<-read_sav(paste0(dataDir, "REV_Baseline_Survey.sav"))

## Screening data
#screen_data <- as.data.frame(read.csv('~/Dropbox/REV/behavioral_data/questionnaire_data/FromQualtrics/rev_screening.csv', stringsAsFactors = FALSE, skip = 1))
screen_data <- as.data.frame(read.csv(paste0(dataDir, "rev_screening.csv"), stringsAsFactors = FALSE, skip = 1))

#=====================================================================================================================

#SCREENING DATA COLUMN NAMES:

colnames(screen_data) = c('responseID', 'responseSet', 'name', 'extData', 'email', 'ip', 'status', 'start', 'end', 'finish', 'scoreSum', 'scoreWeightAvg', 'scoreWeightSD', 'ID', 'screener', 'date', 'instruct1', 'instruct2', 'instruct3', 'instruct4', 'otherStudies', 'ageRange', 'ineligible1', 'englishNative', 'englishFluent', 'ineligible2', 'handedness', 'ineligible3', 'gender', 'pregnant', 'ineligible4', 'instruct5', 'selfControlProblms', 'foods', 'chocolate', 'cookies', 'donuts', 'fries', 'iceCream', 'pasta', 'pizza', 'alcohol', 'tobacco', 'drugs', 'marijuana', 'heroin', 'meth', 'pills', 'cocaine', 'endorsed', 'ineligible5', 'dietRestrict', 'instruct6', 'ineligible6', 'instruct7', 'ineligible7', 'mentalHealth', 'instruct8', 'earlyAdverse', 'ineligible8', 'ineligible9', 'instruct9', 'SSRI', 'ineligible10', 'ineligible11', 'ineligible12', 'instruct10', 'MRI', 'instruct11', 'food1', 'food2', 'food3', 'food4', 'food5', 'alcohol1', 'alcohol2', 'alcohol3', 'alcohol4', 'alcohol5', 'tobacco1', 'tobacco2', 'tobacco3', 'tobacco4', 'tobacco5', 'drugs1', 'drugs2', 'drugs3', 'drugs4', 'drugs5', 'eligible', 'ineligible13', 'enroll', 'lat', 'long', 'acc', 'empty')

# Correct participant IDs (only for participants who were enrolled and later assigned subject IDs)
screen_data[89,14] = '0099'
screen_data[210,14] = '0265'
screen_data[300,14] = '0421'
screen_data[362, 14] = '0489'
screen_data[520, 14] = '0749'
screen_data[583, 14] = '0826'
screen_data[574, 14] = '0854'

# Remove duplicate screening rows (only for participants who were enrolled and later assigned subject IDs)
screen_data <- screen_data[-c(86, 198, 296, 514), ] # 0087, 0246, 0412, 0615

#=====================================================================================================================

#CLEAN PHONE SCREENING DATA:

# Subset the screening data. Drop unneeded columns
screen_data <- dplyr::select(screen_data, scoreSum:enroll, -(contains('ineligible')), -(contains('instruct')), -(contains('Weight')), -(eligible), -(scoreSum))

# Pad the screening IDs with zeros to length four. Missing IDs will become 0000, improperly entered IDs will be corrected (e.g. 90 becomes 0090)
screen_data$ID <- withr::with_options(c(scipen = 999), str_pad(screen_data$ID, 4, pad = "0"))

# Screening IDs of participants who were assigned a study ID
screen_ID <- c('0014', '0016', '0028', '0004', '0012', '0030', '0033', '0011', '0034', '0119', '0139', '0142', '0060', '0041', '0149', '0156', '0083', '0088', '0092', '0115', '0099', '0194', '0130', '0055', '0198', '0183', '0166', '0165', '0180', '0177', '0191', '0218', '0220', '0224', '0246', '0223', '0255', '0286', '0291', '0263', '0261', '0452', '0276', '0280', '0257', '0362', '0243', '0396', '0349', '0265', '0326', '0420', '0329', '0328', '0301', '0338', '0365', '0345', '0357', '0459', '0247', '0421', '0353', '0376', '0381', '0378', '0454', '0380', '0400', '0506', '0479', '0488', '0412', '0515', '0505', '0583', '0493', '0489', '0524', '0513', '0527', '0526', '0540', '0582', '0553', '0638', '0575', '0615', '0596', '0560', '0721', '0610', '0679', '0682', '0686', '0660', '0693', '0087', '0687', '0685', '0661', '0664', '0740', '0749', '0698', '0944', '0735', '0746', '0757', '0826', '0783', '0995', '0779', '0774', '0943', '0802', '0765', '0809', '0797', '0816', '0819', '0868', '0974', '0823', '0837', '0848', '0830', '0854', '1005', '0873', '0967', '0890', '0916', '1013', '0972', '0923', '0983', '0986', '0952', '0985', '1001', '1042', NA, '1002')

# See which IDs are missing from screen_data (used to correct the IDs, should have no mismatches now since IDs corrected)
missing_IDs <- screen_ID[!screen_ID %in% screen_data$ID]

# Only keep data for participants who enrolled
screen_data <- screen_data[screen_data$ID %in% screen_ID, ]

screen_data$ID <- as.factor(screen_data$ID)
#table(screen_data$ID)

idkey <- as.data.frame(read.csv(paste0(idDir, 'IDkey.csv'), header = TRUE, stringsAsFactors = FALSE))
names(idkey)[names(idkey)=="Screening.ID"]<-"ID" #rename screening ID as 'ID' to merge with screening_data df
idkey$ID <- withr::with_options(c(scipen = 999), str_pad(idkey$ID, 4, pad = "0")) #so they'll match up with the screen_data IDs

screen_data<-merge(idkey,screen_data, by="ID")
screen_data<-screen_data[,c(2,32,35:54)] #only keep important screening data variables (including participant ID, *not* screening ID)

names(screen_data)[names(screen_data)=="Participant.ID"]<-"ID" #rename participant ID as 'ID' to merge with survey_data df later
screen_data$ID<-substring(screen_data$ID, 4) #get rid of 'REV' variable head (make IDs just 3-number codes so they'll match up with the base_survey and gen_survey IDs)

#=====================================================================================================================

#CLEANING ACROSS DFS (two birds with one stone):

#Get rid of instruction variables
for(s in c("base_survey","gen_survey")){
  df<-get(s)
  #MM Note: Since I had to use haven to read in the data, my first step is converting the variable names to all lowercase (to match the rest of the code!)
  names(df)<-tolower(names(df))
  inst<-grepfun("_ins", df) #Instructions variable cols (to get rid of)
  df<-dplyr::select(df,-c(v1:v2,inst)) #because this part was done for all the survey cleanings
  assign(s, df)
}

#=====================================================================================================================

#CLEAN BASE SURVEY DATA:

## Truncate the data set to only columns that contain data
#base_survey <- dplyr::select(base_survey, -(v1:v2), -(v4:sc0_2), -(bscs_inst), -(bscs_h_ins), -(audit_inst), -(pacs_instr), -(bscs_inst))
base_survey <- dplyr::select(base_survey, -(v4:sc0_2)) #Column removal unique to this survey (I think?)

torename <- dplyr::select(base_survey, v3:demo_4)

colnames(torename) <- c('survey_ID', 'ID', 'probs_alcohol', 'probs_cocaine', 'probs_heroin', 'probs_marijuana', 'probs_meth', 'probs_pills', 'probs_tobacco', 'probs_chocolate', 'probs_cookies', 'probs_donuts', 'probs_fries', 'probs_icecream', 'probs_pasta', 'probs_pizza', 'gender', 'age', 'ethnicity', 'handedness')

base_survey <- cbind(torename, dplyr::select(base_survey, -(v3:demo_4)))

# Compare survey ID to manually entered ID & print those that do not match (baseline survey)

base_survey$survey_ID <- gsub("[^0-9]", "", base_survey$survey_ID) 
base_survey$ID <- gsub("[^0-9]", "", base_survey$ID) 

mismatch_ID <- base_survey$survey_ID != base_survey$ID

base_survey<- cbind(mismatch_ID, base_survey)

# See record of all problem IDs and corrections here: https://docs.google.com/spreadsheets/d/1Y9awcY7CsBBBFB1rKMZ_1UfrYxeo3hD9kJEFC58_lQk/edit#gid=368975328

# Correct mismatched participant IDs based on study records 

base_survey[7,2] = '014'
base_survey[9,2] = '013'
base_survey[11,2] = '001'
base_survey[14,2] = '005'
base_survey[43,2] = '050'
base_survey[87,2] = '086'
base_survey[94,2] = '088'
base_survey <- base_survey[-c(77,42,27,10),] # Remove duplicate survey for participants 039,031, 018
base_survey <- base_survey[,-c(1,2)] # drop the mismatch column & redundant survey_ID column

### I ran the below code multiple times while examining the data frame to find the problem IDs:
# Find duplicate manually entered IDs
#dups <-base_survey[duplicated(base_survey$ID)|duplicated(base_survey$ID, fromLast=TRUE),]
#View(dups)

# Find duplicate survey link IDs
#dups_link <-base_survey[duplicated(base_survey$survey_ID)|duplicated(base_survey$survey_ID, fromLast=TRUE),]
#View(dups_link)

base_survey <- merge(categories[,1:2], base_survey, by="ID", all=TRUE)

#=====================================================================================================================

#CLEAN GENERAL SURVEY DATA:

# Truncate the data set to only columns that contain data
#gen_survey <- dplyr::select(gen_survey, -(v1:v2), -(v4:v10), -(fhh_inst), -(fhh_inst.0), -(fhh_inst.1), -(fhh_inst.2))
gen_survey <- dplyr::select(gen_survey, -c(v4:v10))

torename <- dplyr::select(gen_survey, v3:fhh_4)

colnames(torename) <- c('survey_ID', 'ID', 'month_born', 'year_born', 'state_born', 'gender', 'ethnicity', 'hispanic', 'education_lvl')

gen_survey <- cbind(torename, dplyr::select(gen_survey, -(v3:fhh_4)))

# Compare survey ID to manually entered ID & print those that do not match (general survey)

gen_survey$survey_ID <- gsub("[^0-9]", "", gen_survey$survey_ID) 
gen_survey$ID <- gsub("[^0-9]", "", gen_survey$ID) 

mismatch_ID <- gen_survey$survey_ID != gen_survey$ID

gen_survey<- cbind(mismatch_ID, gen_survey)

# See record of all problem IDs and corrections here: https://docs.google.com/spreadsheets/d/1Y9awcY7CsBBBFB1rKMZ_1UfrYxeo3hD9kJEFC58_lQk/edit#gid=368975328

# Correct mismatched participant IDs based on study records 

gen_survey[7,2] = '013'
gen_survey[9,2] = '001'
gen_survey[13,2] = '011'
gen_survey[21,2] = '005'
gen_survey[28,2] = '045'
gen_survey[30,2] = '014'
gen_survey[47,3] = '064'
gen_survey[24,2] = '064'
gen_survey[125,2] = '116'
gen_survey[135,3] = '144'

gen_survey <- gen_survey[-c(8, 14, 55, 39, 66, 146, 112),] # Remove duplicate survey for participants 018, 023, 031, 005, 045, 116, 118

gen_survey <- gen_survey[,-c(1,2)] # drop the mismatch column & redundant survey_ID column

### I ran the below code multiple times while examining the data frame to find the problem IDs:
# Find duplicate manually entered IDs
#dups <-gen_survey[duplicated(gen_survey$ID)|duplicated(gen_survey$ID, fromLast=TRUE),]
#View(dups)

# Find duplicate survey link IDs
#dups_link <-gen_survey[duplicated(gen_survey$survey_ID)|duplicated(gen_survey$survey_ID, fromLast=TRUE),]
#View(dups_link)

gen_survey <- merge(categories[,1:2], gen_survey, by="ID", all=TRUE)

#=====================================================================================================================

#CREATE SINGLE DATA FRAME FOR BASE AND GEN SURVEYS:

## Prep gender columns to be combined
#gen_survey$gender <- as.character(gen_survey$gender)
#base_survey$gender <- as.character(base_survey$gender)
gen_survey$gender<-as.character(as_factor(gen_survey$gender))
base_survey$gender<-as.character(as_factor(base_survey$gender)) #as_factor is from haven lib

gen_survey <- gen_survey %>% 
  mutate(gender= replace(gender, 
                         which(gender == 'female'), 'Female')) 
gen_survey <- gen_survey %>% 
  mutate(gender= replace(gender, 
                         which(gender == 'male'), 'Male')) 

## Change the values in the ethnicity column to the format used in the base survey so they match

# MM note to self: ethnicity categories are different in gen_survey and base_survey...
#gen_survey$ethnicity <- as.character(gen_survey$ethnicity)
#base_survey$ethnicity <- as.character(base_survey$ethnicity)
gen_survey$ethnicity <- as.character(as_factor(gen_survey$ethnicity))
gen_survey$hispanic <- as.character(as_factor(gen_survey$hispanic))

#gen_survey categories:
#  ethnicity = ["white" NA  "black" "american indian" "other"]
#  hispanic = ["no" NA "yes"]
base_survey$ethnicity <- as.character(as_factor(base_survey$ethnicity))

#base_survey categories:
#  ethnicity = ["White, not of Hispanic Origin" NA  "Hispanic"  "Black, not of Hispanic Origin" "American Indian or Alaskan Native" "Other"]
#  no hispanic category (since it's already in the ethnicity variable)

# For ethnicity columns where ethnicity = white and hispanic = no, White, not of Hispanic Origin
gen_survey <- gen_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'white' & hispanic == 'no'), 'White, not of Hispanic Origin')) 

# For ethnicity columns where ethnicity = white and hispanic = yes, Hispanic
gen_survey <- gen_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'white' & hispanic == 'yes'), 'Hispanic')) 

# White
gen_survey <- gen_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'white'), 'White, not of Hispanic Origin')) #since the only white people still labelled 'white' are those with is.na(hispanic) 
base_survey <- base_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'white'), 'White, not of Hispanic Origin')) 

# For ethnicity columns where ethnicity = black and hispanic = no, Black, not of Hispanic Origin
gen_survey <- gen_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'black'), 'Black, not of Hispanic Origin')) # No participants "Black, Hispanic" based on base survey responses

gen_survey <- gen_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'american indian'), 'American Indian or Alaskan Native'))

gen_survey <- gen_survey %>% 
  mutate(ethnicity= replace(ethnicity, 
                            which(ethnicity == 'other'), 'Other'))

# Replace missing gender and ethnicity values in the base_survey with those from the general survey
base_survey$ethnicity <- ifelse(test = is.na(base_survey$ethnicity), yes = gen_survey$ethnicity, no = base_survey$ethnicity)

base_survey$gender <- ifelse(test = is.na(base_survey$gender), yes = gen_survey$gender, no = base_survey$gender)

# Create the combined data frame 
survey_data <- merge(base_survey, gen_survey, by=c('ID'), all=TRUE)

survey_data <- rename(survey_data, c("ethnicity.x" = "ethnicity", 
                                     "gender.x" = "gender", 
                                     "compltd.study.x" = "compltd_study"))

survey_data$ethnicity <- as.factor(survey_data$ethnicity)
survey_data$gender <- as.factor(survey_data$gender)

# Manually enter participants ages calculated based on year/month born and date survey taken
# ID : survey : birth  : age
# 103: 05-2016: 11-1979: 36
# 099: 04-2016: 05-1979: 36
# 096: 04-2016: 09-1961: 54
# 092: 02-2016: 09-1977: 38
# 087: 02-2016: 11-1076: 39
# 083: 01-2016: 11-1978: 37
# 081: 01-2016: 10-1962: 53
# 071: 12-2015: 12-1970: 45
# 061: 12-2015: 02-1980: 35
# 028: 08-2015: 05-1962: 53

survey_data[103, 18] = 36
survey_data[99, 18] = 36
survey_data[96, 18] = 54
survey_data[92, 18] = 38
survey_data[87, 18] = 39
survey_data[83, 18] = 37
survey_data[81, 18] = 53
survey_data[71, 18] = 45
survey_data[61, 18] = 35
survey_data[28, 18] = 53

# Manually enter missing category and gender data based on study notes & phone screening
survey_data[7,c(9,17)] = c(1, "Male") # Male, tobacco
survey_data[28,c(9, 7, 6)] = c(rep(1,3)) # tobacco, meth, marijuana
survey_data[61, c(9, 5, 7)] = c(rep(1,3)) #tobacco, heroin, meth
survey_data[71, c(9:11, 13:16, 6, 3)] = c(rep(1,9)) # chocolate, cookie, ice cream, pasta, pizza, fries, marijuana, alcohol, tobacco
survey_data[081, c(3, 9, 11, 13, 15, 16)] = c(rep(1,6)) #alcohol, tobacco, cookies, fries, pasta, pizza 
survey_data[083, c(9:12, 14:16)] = c(rep(1, 7)) # tobacco, chocolate, cookies, donuts, ice cream, pasta, pizza
survey_data[087, c(3, 14:16, 6)] = c(rep(1, 5)) # alcohol, ice cream, pasta, pizza, Marijuana
survey_data[092, c(6:8, 3)] = c(rep(1,4)) # Marijuana, meth, pills, alcohol
survey_data[096, c(10:14, 16)] = c(rep(1,6)) # chocolate, cookie, donut, fries, ice cream, pizza
survey_data[099, c(11:14, 16, 3, 9, 6, 8)] = c(rep(1,9)) # cookies, donuts, fries, pizza, ice cream, tobacco, alcohol, Marijuana, Pills
survey_data[103, c(6, 9:17)] = c(rep(1, 9), "Male") # Marijuana, chocolate, cookies, donuts, fries, ice cream, pasta, pizza, tobacco
survey_data[139, c(11, 12, 14:17)] = c(rep(1, 5), "Male") # cookies, donuts, ice cream, pasta, pizza

cols <- colnames(dplyr::select(survey_data, starts_with("probs_")))

survey_data[cols] <- sapply(survey_data[cols], as.numeric)

# Add category information to the data frame
survey_data$categories <- as.numeric(categories$num.categories) # The number of major categories the participant endorsed (options were: food, tobacco, drugs, alcohol)

survey_data$subcategories <- rowSums(survey_data[,c(3:16)], na.rm = TRUE) # The total different categories of images a participant saw

survey_data <- survey_data[-143,] # ID 143 was not assigned to a participant

# Make the endorsed categories variables into factors
for(col in cols) {
  survey_data[col][is.na(survey_data[col])] <- 0
}
survey_data[cols] <-
  lapply(survey_data[cols], factor,
         levels = c(0,1),
         labels = c("no", "yes"))

survey_data$compltd_study<-droplevels(survey_data$compltd_study) #because there were a couple of funky factor levels with no cases
survey_data$compltd_study <- 
  factor(survey_data$compltd_study, 
         levels = c(0,1),
         labels = c("no","yes"))

survey_data <- dplyr::select(survey_data, -(compltd.study.y), -(gender.y:hispanic), -starts_with("location"))

# Use participant ID to add screening data to 'survey_data'
survey_data<-merge(survey_data, screen_data, by="ID")

#=====================================================================================================================

#FROM SCREEN_DATA:
#  food1-5
#  alcohol1-5
#  tobacco1-5
#  drugs1-5

#Scale: 1not at all - 5very much

#1. I am good at resisting ___. 
#2. I have a hard time breaking the habit of using ___.
#3. I use ___ if it is enjoyable.
#4. ___ sometimes keeps me from getting work done.
#5. Sometimes, I can't stop myself from using ___, even if I know it is wrong.


#=====================================================================================================================
## The next two chunks will change NAs to '999' for questionnaires that are not associated with endorsed craving stimuli!
## This means that true NAs will now be coded 999 (though we can obviously change that again later)
#=====================================================================================================================

#PREP VARIABLES FOR MISSING CHECK:

Vices<-colnames(dplyr::select(survey_data, starts_with("probs_")))
for(i in Vices){
assign(i, list())
}
ViceLS<-paste0(Vices,"L")

#First, get each survey associated with each vice indices for alcohol variables
probs_alcoholL<- c("BSCS_A", "DUH_A", "ACQ_SF_R", "AUDIT", "PACS")
probs_cocaineL<- c("BSCS_C", "DUH_C", "CCQ_Brief")
probs_heroinL<- c("BSCS_H", "HCQ_SF")
probs_marijuanaL<- c("BSCS_Ma", "DUH_Ma", "MCQ_SF")
probs_methL<- c("BSCS_Me","DUH_Me", "MCIY")
probs_pillsL<- c("BSCS_P", "DUH_P", "CEQ_S_P")
probs_tobaccoL<- c("FTND", "QSU")
probs_chocolateL<- c("LE", "DEBQ", "FCI_Ch")
probs_cookiesL<- c("LE", "DEBQ", "FCI_Co")
probs_donutsL<- c("LE", "DEBQ", "FCI_D")
probs_friesL<- c("LE", "DEBQ", "FCI_F")
probs_icecreamL<- c("LE", "DEBQ", "FCI_I")
probs_pastaL<- c("LE", "DEBQ", "FCI_Pa")
probs_pizzaL<- c("LE", "DEBQ", "FCI_Pi")

#Then get all indices for the associated survey items
ct<-1
for(v in Vices){
p<-get(v)
l<-tolower(get(ViceLS[ct])) #list of 'starts_with'/grep-able column names associated with v (probs_*)
p=findIndexInBL(survey_data,l,p)
p<-unlist(p)
assign(v, p[p>20])
ct<-ct+1
survey_data[p]
}

#=====================================================================================================================

#REPLACE NAs

#This is the chunk where we actually recode true NAs to '999'

#do the thing
for(v in 1:length(Vices)){
e<-Vices[v] #Name of problem endorsed
p<-get(Vices[v]) #Indices of all items from scales that are associated with that problem
print(paste0(e, ": ", get(ViceLS[v]))) #display the problem and name of associated scales (my own sanity check)
for(i in p){
survey_data[i][is.na(survey_data[i]) & survey_data[e]=="no"]<-999 #change real NAs to 999
print(variable.names(survey_data[i]))
}
} #print to double check that I've put the right variables together!
  
  
  #Get number of items associated with each possible endorsed problem
  for(v in Vices){
    s<-length(get(v))
    assign(paste0(v,"_ct"),s)
  }

ViceCT<-paste0(Vices,"_ct")

survey_data$PROBitemTally<-0 #This is where we'll put each participants 'total possible problem-related items'

for(v in 1:length(Vices)){
  e<-Vices[v]
  survey_data$PROBitemTally<-ifelse(survey_data[e]=="yes", survey_data$PROBitemTally+get(ViceCT[v]), survey_data$PROBitemTally)
}

#The last problem-specific item is column 202, so everyone should have answered 203-515
survey_data$itemTally<-survey_data$PROBitemTally+length(203:515) #Each participants' total number of items they should have responded to

#=====================================================================================================================

#GET SUBJECT-WISE NA COUNTS

#The last problem-specific item is column 202, so everyone will have 203-515
survey_data$subNAcount <- apply(survey_data[,21:515], 1, function(x) sum(is.na(x))) #out of all items that should have been answered
survey_data$PROBsubNAcount <- apply(survey_data[,21:202], 1, function(x) sum(is.na(x))) #this is just for the problem variables

survey_data$itemTally<-as.numeric(survey_data$itemTally); survey_data$PROBitemTally<-as.numeric(survey_data$PROBitemTally)
survey_data<- survey_data %>% group_by() %>%
  mutate(subNAprop=subNAcount/itemTally, PROBsubNAprop=PROBsubNAcount/PROBitemTally)

#=====================================================================================================================

#SConS QUESTIONNAIRE SCORING

## Reverse coding items
# scons_cols <- colnames(survey_data[,450:462])
# survey_data[scons_cols] <-
#       lapply(survey_data[scons_cols], plyr::mapvalues,
#       from = c("Not at all 1", "2", "3", "4", "Very Much 5"),
#       to = c(1,2,3,4,5))

scons_cols<-colnames(survey_data[(grepfun("scons_",survey_data))])

reverse_cols = c("scons_2", "scons_3", "scons_4", "scons_5", "scons_7", "scons_9", "scons_10", "scons_12", "scons_13")
survey_data[scons_cols] <- 
  lapply(survey_data[scons_cols], as.numeric)
survey_data[,reverse_cols] = 6 - survey_data[,reverse_cols] # Reverse score the SConS items in reverse_cols

survey_data$scons_total <- rowSums(survey_data[scons_cols]) # Total SConS score

# How many survey responses do we have? 114
table(!is.na(survey_data[,"scons_total"]))

#=====================================================================================================================

#BIS QUESTIONNAIRE SCORING

## Reverse coding items
# BIS_cols <- colnames(survey_data[,400:429])
# survey_data[BIS_cols] <-
#       lapply(survey_data[BIS_cols], plyr::mapvalues,
#       from = c("Rarely/Never", "Occasionally", "Often", "Almost Always/Always"),
#       to = c(1,2,3,4))

BIS_cols<-colnames(survey_data[(grepfun("bis_",survey_data))])
BIS_cols<-BIS_cols[-grep('bas_',BIS_cols)] #remove combined 'bisbas_' variable names from list

reverse_cols = c("bis_7", "bis_13","bis_19","bis_6", "bis_1", "bis_5","bis_8","bis_11", "bis_17", "bis_22", "bis_30")
survey_data[BIS_cols] <- 
  lapply(survey_data[BIS_cols], as.numeric)
survey_data[,reverse_cols] = 5 - survey_data[,reverse_cols] # Reverse score the BIS items in reverse_cols

## Creating the subscales
BISkey_list <- list(attention=c("bis_4","bis_7","bis_10","bis_13","bis_16","bis_19","bis_24","bis_27"), motor=c("bis_2","bis_6","bis_9","bis_12","bis_15","bis_18","bis_21","bis_23","bis_26","bis_29"), non_planning=c("bis_1","bis_3","bis_5","bis_8","bis_11","bis_14","bis_17","bis_20","bis_22","bis_25","bis_28","bis_30"))

survey_data$bis_attn <- rowSums(survey_data[,BISkey_list[[1]]]) # BIS attention score
survey_data$bis_motor <- rowSums(survey_data[,BISkey_list[[2]]]) # BIS motor score
survey_data$bis_noplan <- rowSums(survey_data[,BISkey_list[[3]]]) # BIS non-planning score
survey_data$bis_total <- rowSums(survey_data[,c("bis_attn", "bis_motor", "bis_noplan")]) # BIS total score

# How many survey responses do we have? 116
table(!is.na(survey_data[,"bis_total"]))

#=====================================================================================================================
#STILL NEED TO SCORE ALL OTHER QUESTIONNAIRES!

print("Heads up: Not done with scoring!")



