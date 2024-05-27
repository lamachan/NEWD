#####################################################################################################
#####   Introducing the Warring-States Japan Battle Data: Generating Figures & Summary Tables   #####
#####################################################################################################

# Analysis run using R version 4.2.1

rm(list=ls())

# load required packages 
require(foreign)
require(plyr)
require(stargazer)

# input battle data location below and load Warring-States Japan Battle Data
data<-read.csv("INPUT HARD DRIVE LOCATION HERE/WarringStatesJapan_battledataV1.csv",encoding="UTF-8")

#############################################
#####   Tables and Figures in Article   #####
#############################################

### Figure 1: Battles by Year, 1467-1600 (presented on p. 8)

# create year base data
Figure1<-as.data.frame(1467:1600)
names(Figure1)<-"year"

# count battle observations by year
batyr<-data[1:2]
batyr<-unique(batyr)
batyr<-count(batyr,"year")
colnames(batyr)[2]<-"battles"

# merge with year base
Figure1<-join(Figure1,batyr)
Figure1[is.na(Figure1)] <- 0

# drop unnecessary data
rm(batyr)


### Table 1: Summary Statistics for Battle Variables ###

# Table 1 was constructed cell-by-cell using Microsoft Excel because of complications due to some variables 
# being unique to the observation and some being unique to the dyad (e.g., "year" is the same for each battle 
# regardless of the dyad, whereas variables such as "sideA," "sideB," "joinerA," and "joinerB" vary by dyad).


### Figure 2: The Spread and Extent of Battle by Year, 1467-1600 ###

# separate out province-year data
provyeardata<-cbind(data[1:2],data[8])

# drop duplicate observations
provyeardata<-unique(provyeardata)

# drop all observations where province is unknown
provyeardata<-subset(provyeardata,province!="")

# first, count provinces experiencing battle by year
provyeardata2<-aggregate(province~year,provyeardata,function(x) length(unique(x)))

# divide by total provinces to get percentage
provyeardata2<-cbind(provyeardata2,provyeardata2$province/68)

# rename
names(provyeardata2)<-c("year","total number of provinces experiencing conflict","percentage of provinces experiencing conflict")

# create a year base and merge
Figure2<-as.data.frame(1467:1600)
names(Figure2)<-"year"
Figure2<-join(Figure2,provyeardata2)

# sub NA for zero
Figure2[is.na(Figure2)] <- 0

# next, to create new provinces experiencing battle by year

# first, create a table that shows the first year each province in the dataset experiences battle

provyeardata3<-as.data.frame(c(min(provyeardata$year[provyeardata$province=="aki"]),
                               min(provyeardata$year[provyeardata$province=="awaji"]),
                               min(provyeardata$year[provyeardata$province=="awa1"]),
                               min(provyeardata$year[provyeardata$province=="awa2"]),
                               min(provyeardata$year[provyeardata$province=="iga"]),
                               min(provyeardata$year[provyeardata$province=="iki"]),
                               min(provyeardata$year[provyeardata$province=="izu"]),
                               min(provyeardata$year[provyeardata$province=="izumi"]),
                               min(provyeardata$year[provyeardata$province=="izumo"]),
                               min(provyeardata$year[provyeardata$province=="ise"]),
                               min(provyeardata$year[provyeardata$province=="inaba"]),
                               min(provyeardata$year[provyeardata$province=="iyo"]),
                               min(provyeardata$year[provyeardata$province=="iwami"]),
                               min(provyeardata$year[provyeardata$province=="echigo"]),
                               min(provyeardata$year[provyeardata$province=="echizen"]),
                               min(provyeardata$year[provyeardata$province=="ecchu"]),
                               min(provyeardata$year[provyeardata$province=="oumi"]),
                               min(provyeardata$year[provyeardata$province=="oki"]),
                               min(provyeardata$year[provyeardata$province=="osumi"]),
                               min(provyeardata$year[provyeardata$province=="owari"]),
                               min(provyeardata$year[provyeardata$province=="kai"]),
                               min(provyeardata$year[provyeardata$province=="kaga"]),
                               min(provyeardata$year[provyeardata$province=="kazusa"]),
                               min(provyeardata$year[provyeardata$province=="kawachi"]),
                               min(provyeardata$year[provyeardata$province=="kii"]),
                               min(provyeardata$year[provyeardata$province=="kouzuke"]),
                               min(provyeardata$year[provyeardata$province=="sagami"]),
                               min(provyeardata$year[provyeardata$province=="satsuma"]),
                               min(provyeardata$year[provyeardata$province=="sado"]),
                               min(provyeardata$year[provyeardata$province=="sanuki"]),
                               min(provyeardata$year[provyeardata$province=="shinano"]),
                               min(provyeardata$year[provyeardata$province=="shima"]),
                               min(provyeardata$year[provyeardata$province=="shimousa"]),
                               min(provyeardata$year[provyeardata$province=="shimotsuke"]),
                               min(provyeardata$year[provyeardata$province=="suo"]),
                               min(provyeardata$year[provyeardata$province=="suruga"]),
                               min(provyeardata$year[provyeardata$province=="settsu"]),
                               min(provyeardata$year[provyeardata$province=="tajima"]),
                               min(provyeardata$year[provyeardata$province=="tango"]),
                               min(provyeardata$year[provyeardata$province=="tanba"]),
                               min(provyeardata$year[provyeardata$province=="chikugo"]),
                               min(provyeardata$year[provyeardata$province=="chikuzen"]),
                               min(provyeardata$year[provyeardata$province=="tsushima"]),
                               min(provyeardata$year[provyeardata$province=="dewa"]),
                               min(provyeardata$year[provyeardata$province=="toutoumi"]),
                               min(provyeardata$year[provyeardata$province=="tosa"]),
                               min(provyeardata$year[provyeardata$province=="nagato"]),
                               min(provyeardata$year[provyeardata$province=="noto"]),
                               min(provyeardata$year[provyeardata$province=="harima"]),
                               min(provyeardata$year[provyeardata$province=="higo"]),
                               min(provyeardata$year[provyeardata$province=="hizen"]),
                               min(provyeardata$year[provyeardata$province=="bizen"]),
                               min(provyeardata$year[provyeardata$province=="hitachi"]),
                               min(provyeardata$year[provyeardata$province=="hida"]),
                               min(provyeardata$year[provyeardata$province=="bicchu"]),
                               min(provyeardata$year[provyeardata$province=="hyuuga"]),
                               min(provyeardata$year[provyeardata$province=="bingo"]),
                               min(provyeardata$year[provyeardata$province=="buzen"]),
                               min(provyeardata$year[provyeardata$province=="bungo"]),
                               min(provyeardata$year[provyeardata$province=="houki"]),
                               min(provyeardata$year[provyeardata$province=="mikawa"]),
                               min(provyeardata$year[provyeardata$province=="mino"]),
                               min(provyeardata$year[provyeardata$province=="mimasaka"]),
                               min(provyeardata$year[provyeardata$province=="musashi"]),
                               min(provyeardata$year[provyeardata$province=="mutsu"]),
                               min(provyeardata$year[provyeardata$province=="yamashiro"]),
                               min(provyeardata$year[provyeardata$province=="yamato"]),
                               min(provyeardata$year[provyeardata$province=="wakasa"])))
# rename
names(provyeardata3)<-"year"

newprovyeardata<-count(provyeardata3,"year")

colnames(newprovyeardata)[2]<-"new provinces experiencing battle"

Figure2<-join(Figure2,newprovyeardata)

Figure2[is.na(Figure2)] <- 0

# take cumulative sum down column of new provinces experiencing battle

Figure2<-cbind(Figure2,cumsum(Figure2[4]))
colnames(Figure2)[5]<-"total number of provinces that have experienced battle"

# these data were used to construct Figure 2

# drop unnecessary data
rm(newprovyeardata,provyeardata,provyeardata2,provyeardata3)


##############################################
#####   Tables and Figures in Appendix   #####
##############################################

### Table A2: Battles by Province, 1467-1600

# separate province data and drop duplicate observations
battleprov<-cbind(data[1],data[8])
battleprov<-unique(battleprov)

# count province observations, rename, and sort by observations
TableA2<-count(battleprov$province)
names(TableA2)<-c("province","battles")
TableA2<-TableA2[order(-TableA2$battles),]

# append shima province (no battle observations)
shima<-as.data.frame(cbind("shima",0))
names(shima)<-c("province","battles")
TableA2<-rbind(TableA2,shima)

# drop unnecessary data
rm(battleprov,shima)


### Figure A2: Battles by Month, 1467-1600

# separate month data and drop duplicate observations
battlemonth<-cbind(data[1],data[3])
battlemonth<-unique(battlemonth)

# count month observations
battlemonth2<-count(battlemonth$month)
names(battlemonth2)<-c("month","battles")

# create base month data, rename, and merge
FigureA2<-as.data.frame(1:12)
names(FigureA2)<-"month"
FigureA2<-join(FigureA2,battlemonth2)

# drop unnecessary data
rm(battlemonth,battlemonth2)


### Table A3: Battles by Month for Lunisolar and Gregorian Calendar, 1467-1600

# separate month data and drop duplicate observations
battlemonth2<-cbind(data[1],data[27])
battlemonth2<-unique(battlemonth2)

# count month observations and rename
battlemonth3<-count(battlemonth2$month)
names(battlemonth3)<-c("month","battles (gregorian calendar)")

# merge with FigureA2 and rename
TableA3<-join(FigureA2,battlemonth3)
colnames(TableA3)[2]<-"battles (lunisolar calendar)"

# drop unnecessary data
rm(battlemonth2,battlemonth3)


### Figure A3: Battles by Month in the North and South, 1467-1600

# separate month and province data and drop duplicate observations
datanorth<-cbind(data[1],data[3],data[8])
datanorth<-unique(datanorth)

# subset for northern provinces
datanorth2<-rbind(subset(datanorth,province=="dewa"),
                  subset(datanorth,province=="mutsu"),
                  subset(datanorth,province=="echigo"),
                  subset(datanorth,province=="sado"))

# count month observations and rename for merge
datanorth3<-count(datanorth2$month)
names(datanorth3)<-c("month","battles (north)")

# separate month and province data and drop duplicate observations
datasouth<-cbind(data[1],data[3],data[8])
datasouth<-unique(datasouth)

# subset for southern provinces
datasouth2<-rbind(subset(datasouth,province=="satsuma"),
                  subset(datasouth,province=="osumi"),
                  subset(datasouth,province=="hyuuga"),
                  subset(datasouth,province=="higo"),
                  subset(datasouth,province=="bungo"),
                  subset(datasouth,province=="chikugo"),
                  subset(datasouth,province=="hizen"),
                  subset(datasouth,province=="chikuzen"),
                  subset(datasouth,province=="buzen"),
                  subset(datasouth,province=="iki"),
                  subset(datasouth,province=="tsushima"))

# count month observations and rename for merge
datasouth3<-count(datasouth2$month)
names(datasouth3)<-c("month","battles (south)")

# create base month data, rename, and merge
FigureA3<-as.data.frame(1:12)
names(FigureA3)<-"month"
FigureA3<-join(FigureA3,datanorth3)
FigureA3<-join(FigureA3,datasouth3)

# drop unnecessary data
rm(datanorth,datanorth2,datanorth3,datasouth,datasouth2,datasouth3)


### Figure A4: Battles by Belligerent, 1467-1600

# first, battles

# separate out belligerents on sideA, drop duplicate observations, and rename for merge
datasideA<-cbind(data[1],data[5])
datasideA<-unique(datasideA)
colnames(datasideA)[2]<-"side"

# separate out belligerents on sideB, drop duplicate observations, and rename for merge
datasideB<-cbind(data[1],data[6])
datasideB<-unique(datasideB)
colnames(datasideB)[2]<-"side"

# bind sides A and B together for the count, drop duplicate observations, count, rename, and sort
datasideAB<-rbind(datasideA,datasideB)
datasideAB<-unique(datasideAB)
FigureA4<-count(datasideAB$side)
names(FigureA4)<-c("belligerent","battles")
FigureA4<-FigureA4[order(-FigureA4$battles),]

# select top-10 individuals
FigureA4<-FigureA4[2:12,]
FigureA4<-rbind(FigureA4[1:6,],FigureA4[8:11,])

# second, initiations

# separate out belligerents and initiation on side A
datainitA<-cbind(data[1],data[5],data[12])
datainitA<-unique(datainitA)

# subset for only initiator observations
datainitA<-subset(datainitA,initiatorA==1)

# count initiating belligerents, rename, and merge with FigureA4
datainitA2<-count(datainitA$sideA)
names(datainitA2)<-c("belligerent","initiations")
FigureA4<-join(FigureA4,datainitA2)

# drop unnecessary data
rm(datasideA,datasideB,datasideAB,datainitA,datainitA2)


### Table A4: Summary Statistics

# input monadic diffusion data location below and load Warring-States Japan monadic diffusion data
data2<-read.csv("INPUT HARD DRIVE LOCATION HERE/WarringStatesJapan_diffusiondata_monadic.csv")

# create summary statistics table
TableA4<-as.data.frame(c("battle","adjacent_battle","road_battle","neighbors","area","terrain_ruggedness"))
TableA4<-cbind(TableA4,c(mean(data2$battle),mean(data2$adjacent_battle),mean(data2$road_battle),mean(data2$neighbors),mean(data2$area),mean(data2$terrain_ruggedness)))
TableA4<-cbind(TableA4,c(sd(data2$battle),sd(data2$adjacent_battle),sd(data2$road_battle),sd(data2$neighbors),sd(data2$area),sd(data2$terrain_ruggedness)))
TableA4<-cbind(TableA4,c(min(data2$battle),min(data2$adjacent_battle),min(data2$road_battle),min(data2$neighbors),min(data2$area),min(data2$terrain_ruggedness)))
TableA4<-cbind(TableA4,c(max(data2$battle),max(data2$adjacent_battle),max(data2$road_battle),max(data2$neighbors),max(data2$area),max(data2$terrain_ruggedness)))

# rename measures
names(TableA4)<-c("variable","mean","SD","min","max")

