###############################################################################
# Phylogenetics project about Devonian fishes
# 29.07.2022
###############################################################################
library(dplyr)
library(divDyn)
# load data
taxa <- read.csv2("data/substage_age_2021_mod.csv")
# arrange data correctly
names(taxa)[1] <- "taxon"
taxa <- select(taxa, c("taxon", "max", "min")) #"stg"
# omit NA value in line 49 (Eusthenopteron_foordi)
taxa <- taxa[!is.na(taxa$max),]


# create subsample (boring method)
set.seed(12345)

rnd <- sample(1:120, 20, replace = FALSE) #random numbers
sub.tax <- taxa[rnd,]

#write.csv2(sub.tax, "output/subtaxa_rnd.csv")


# get stage nbrs from divDyn
data(stages)

#### typos
# Bathovian -> Bathonian
# Givetian: deleted spaces
# Tournasian -> Tournaisian
# Ludlow -> Ludfordian (changed based on the max and min, Ludlow is a series)

for(i in 1:length(taxa$stg)){
  
  if (length(grep("-", taxa$stg[i]))>0) { # split by hyphen and only use first
      stgsplit <- unlist(strsplit(taxa$stg[i], "-"))
      stgname <- stgsplit[1]
      } else {
      stgname <- taxa$stg[i]
      }
  
  taxa$stg[i] <- stages$stg[which(stages$stage==stgname)] # add stage numbers instead of names
  
}

taxa$stg <- as.numeric(taxa$stg) #function needs numeric input


# create subsample

################# "you have less than 3 bins"
subsample(taxa, tax="taxon", bin="stg", q=30, duplicates= TRUE)
cr <- subsample(taxa, tax="taxon", bin="stg", q=20, type="cr",
                iter=200)
