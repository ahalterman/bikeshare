# Script to clean the DC Capital Bikeshare ride data.
# Data is available from here: http://www.capitalbikeshare.com/trip-history-data

library(XML)

setwd("~/Cabi")

# Get lat-long data for the bike stations: 
bikeshare <- xmlParse("http://www.capitalbikeshare.com/data/stations/bikeStations.xml")
bikeshare <- xmlToDataFrame(bikeshare, stringsAsFactors = FALSE)
write.csv(bikeshare, "bikelatlongs")

datalinks <- c("http://www.capitalbikeshare.com/assets/files/trip-history-data/2010-4th-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2011-1st-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2011-2nd-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2011-3rd-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2011-4th-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2012-1st-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2012-2nd-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2012-3rd-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2012-4th-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2013-1st-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2013-2nd-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2013-3rd-quarter.csv", "http://www.capitalbikeshare.com/assets/files/trip-history-data/2013-4th-quarter.zip")


## The CSVs come with different column names almost every quarter. The ones I've picked:
# Duration, StartDate, StartTime, StartStation, StartTerminal, EndDate, EndTime, EndStation, EndTerminal, Bike, MemberType
# Should have a StartDateTime instead. In POSIX. Use lubridate to extract pieces.

# 2011, 4th Quarter
bikes <- read.csv("~/Cabi/2011-4th-quarter.csv", stringsAsFactors=FALSE)
bikes[bikes$End.station=="","End.station"] <- "NA (NA)"
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
bikes$Start.Terminal <- unlist(regmatches(bikes$Start.station, gregexpr("(?<=\\().*?(?=\\))", bikes$Start.station, perl=TRUE)))
bikes[bikes$End.station=="","End.station"] <- "NA (NA)"
names(bikes)[names(bikes)=="End.station"] <- "End.Station"
names(bikes)[names(bikes)=="Start.station"] <- "Start.Station"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
bikes$End.Terminal <- unlist(regmatches(bikes$End.Station, gregexpr("(?<=\\().*?(?=\\))", bikes$End.Station, perl=TRUE)))
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2011-4th-quarter-cleaned.csv")


# 2012, 1st Quarter
bikes <- read.csv("~/Cabi/2012-1st-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- bikes$Duration.Sec
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2012-1st-quarter-cleaned.csv")

# 2012, 2nd Quarter
bikes <- read.csv("~/Cabi/2012-2nd-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- bikes$Duration..sec
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Bike.Key"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2012-2nd-quarter-cleaned.csv")

# 2012, 3rd Quarter
bikes <- read.csv("~/Cabi/2012-3rd-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Subscriber.Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2012-3rd-quarter-cleaned.csv")

# 2012, 4th Quarter
bikes <- read.csv("~/Cabi/2012-4th-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Subscription.Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2012-4th-quarter-cleaned.csv")

# 2013, 1st Quarter
bikes <- read.csv("~/Cabi/2013-1st-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Subscription.Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2013-1st-quarter-cleaned.csv")

# 2013, 2nd Quarter
bikes <- read.csv("~/Cabi/2013-2nd-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.time, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.time, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.Date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.Date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Subscription.Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2013-2nd-quarter-cleaned.csv")

# 2013, 3rd quarter
bikes <- read.csv("~/Cabi/2013-3rd-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Subscription.Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2013-3rd-quarter-cleaned.csv")

# 2013, 4th Quarter
bikes <- read.csv("~/Cabi/2013-4th-quarter.csv", stringsAsFactors=FALSE)
bikes$Duration <- gsub("h ", ":", bikes$Duration)
bikes$Duration <- gsub("min. ", ":", bikes$Duration)
bikes$Duration <- gsub("sec", "", bikes$Duration)
bikes$Duration <- period_to_seconds(hms(bikes$Duration))
bikes$Start.Time <- sapply(strsplit(bikes$Start.date, " "), "[", 2)
bikes$Start.Date <- sapply(strsplit(bikes$Start.date, " "), "[", 1)
bikes$End.Time <- sapply(strsplit(bikes$End.date, " "), "[", 2)
bikes$End.Date <- sapply(strsplit(bikes$End.date, " "), "[", 1)
bikes$Start.Date <- gsub("-", "", as.character(as.Date(bikes$Start.date, format="%m/%d/%Y")))
bikes$End.Date <- gsub("-", "", as.character(as.Date(bikes$End.date, format="%m/%d/%Y")))
names(bikes)[names(bikes)=="Subscription.Type"] <- "Member.Type"
names(bikes)[names(bikes)=="Bike."] <- "Bike"
names(bikes)[names(bikes)=="Start.terminal"] <- "Start.Terminal"
names(bikes)[names(bikes)=="End.terminal"] <- "End.Terminal"
bikes <- bikes[,c("Duration","Start.Date","Start.Time","Start.Station","Start.Terminal","End.Date","End.Time","End.Station", "End.Terminal","Bike","Member.Type")]
write.csv(bikes, file="2013-4th-quarter-cleaned.csv")

system.time(tmp <- read.csv("2013-4th-quarter-cleaned.csv"))

