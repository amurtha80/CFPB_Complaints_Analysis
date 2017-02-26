##Leverage 'dplyr' package as preferred data manipulation library
library(dplyr)
library(ggplot2)
library(reshape2)
library(zoo)

#Alias source file into macro variable
source01 <- "N:\\CFPB External Data\\Consumer_Complaints.csv"

#Read in *.csv file into raw dataset
cfpbRawData <- read.csv(source01, sep=",", header = TRUE, 
                        stringsAsFactors = FALSE)

#Look at sample of data file
head(cfpbRawData)

#Filter to only SunTrust data
cfpbSunTrustData <- filter(cfpbRawData, Company == "SunTrust Banks, Inc.")

#Format Date.received from a factor to a date field
cfpbSunTrustData$Date.received <- as.Date(cfpbSunTrustData$Date.received, 
                                          format = "%m/%d/%Y")

#Format Product from a factor to a character field
cfpbSunTrustData$Product <- as.character(cfpbSunTrustData$Product)

#Add quarterly value to SunTrust data
cfpbSunTrustData <- mutate(cfpbSunTrustData, 
                           Quarter = as.yearqtr(cfpbSunTrustData$Date.received,
                                              format = "%Y-%m-%d"))

#Add record value of 1 to each observation for SunTrust data
cfpbSunTrustData <- mutate(cfpbSunTrustData, n = 1)

dat <- summarise(cfpbSunTrustData, sum(Product, Quarter))

dat <- melt(dat, id.vars="Product")

#Look at total number of complaints on a quarterly basis
plot <- ggplot(dat, aes(x=factor(Quarter)), fill=Product) + 
  ggtitle("SunTrust CFPB Complaints by Quarter") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

plot + geom_bar()
