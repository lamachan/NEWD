############################################################################################
##########   Introducing the Warring-States Japan Battle Data: Replication File   ##########
############################################################################################

# Analysis run using R version 4.2.1

rm(list=ls())

# load required packages
require(foreign)
require(sandwich)
require(stargazer)

# input battle data location below and load Warring-States Japan Battle Data
data<-read.csv("INPUT HARD DRIVE LOCATION HERE/WarringStatesJapan_battledataV1.csv",encoding="UTF-8")


######################################
#####   Descriptive Statistics   #####
######################################

### Battle initiation and victory (discussed on p. 8)

# separate out battle initiation and victory data
battleinit<-cbind(data[1],data[12:13])

# drop duplicate observations
battleinit<-unique(battleinit)

# calculate victory percentage among belligerents initiating battle
mean(battleinit$victoryA[battleinit$initiatorA==1],na.rm=T)

# result: 0.8230676

# battle initiators are victorious 82% of the time

# drop unnecessary data
rm(battleinit)


### Coalition battle and victory (discussed on p. 8)

# separate out coalition and victory data
battlecoal<-cbind(data[1],data[13:14],data[16:17])

# drop duplicate observations
battlecoal<-unique(battlecoal)

# drop missing data
battlecoal<-na.omit(battlecoal)

# divide the total number of coalition victories by the total number of coalition battles
sum(battlecoal$victoryA[battlecoal$coalitionA==1],battlecoal$victoryB[battlecoal$coalitionB==1],na.rm=T)/
  sum(battlecoal$coalitionA,battlecoal$coalitionB,na.rm=T)

# result: 0.5819015

# coalitions in battle are victorious 58% of the time


### One-sided coalition battle and victory (discussed on p. 8) ###

# divide the total number of one-sided coalition victories by the total number of one-sided coalition battles
sum(battlecoal$victoryA[battlecoal$coalitionA==1&battlecoal$coalitionB==0],battlecoal$victoryB[battlecoal$coalitionB==1&battlecoal$coalitionA==0])/
  (length(battlecoal$victoryA[battlecoal$coalitionA==1&battlecoal$coalitionB==0])+length(battlecoal$victoryB[battlecoal$coalitionB==1&battlecoal$coalitionA==0]))

# result: 0.6323268

# one-sided coalitions in battle are victorious 63% of the time

# drop unnecessary data
rm(battlecoal)


#################################################################
#####   The Diffusion of Conflict in Warring-States Japan   #####
#################################################################

# input monadic diffusion data location below and load Warring-States Japan monadic diffusion data
data<-read.csv("INPUT HARD DRIVE LOCATION HERE/WarringStatesJapan_diffusiondata_monadic.csv")

### Table 2: Linear Probability Analysis (presented on p. 12 and Table A5 in Appendix)

lm1<-lm(battle~adjacent_battle+neighbors+area+terrain_ruggedness+factor(year)+factor(province),data=data)
lm2<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+factor(year)+factor(province),data=data)
lm3<-lm(battle~road_battle+neighbors+area+terrain_ruggedness+factor(year)+factor(province),data=data)

robse1<-sqrt(diag(vcovHC(lm1,type="HC1")))
robse2<-sqrt(diag(vcovHC(lm2,type="HC1")))
robse3<-sqrt(diag(vcovHC(lm3,type="HC1")))

stargazer(lm1,lm2,lm3,type="text",se=list(robse1,robse2,robse3),omit=c("factor"))


##################################
#####   Robustness Tests     #####
##################################

### Table A6: Logistic Regression Analysis (discussed on p. 12 and presented in Appendix)

glm1<-glm(battle~adjacent_battle+neighbors+area+terrain_ruggedness+factor(year)+factor(province),family=binomial(link="logit"),data=data)
glm2<-glm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+factor(year)+factor(province),family=binomial(link="logit"),data=data)
glm3<-glm(battle~road_battle+neighbors+area+terrain_ruggedness+factor(year)+factor(province),family=binomial(link="logit"),data=data)

robseglm1<-sqrt(diag(vcovHC(glm1,type="HC2")))
robseglm2<-sqrt(diag(vcovHC(glm2,type="HC2")))
robseglm3<-sqrt(diag(vcovHC(glm3,type="HC2")))

stargazer(glm1,glm2,glm3,type="text",se=list(robseglm1,robseglm2,robseglm3),omit=c("factor"))

### Table A7: Linear Probability Analysis with Lagged DV (discussed on p. 12 and presented in Appendix)

lm4<-lm(battle~adjacent_battle+lagged_battle+neighbors+area+terrain_ruggedness,data=data)
lm5<-lm(battle~adjacent_battle+road_battle+lagged_battle+neighbors+area+terrain_ruggedness,data=data)
lm6<-lm(battle~road_battle+lagged_battle+neighbors+area+terrain_ruggedness,data=data)

robse4<-sqrt(diag(vcovHC(lm4,type="HC1")))
robse5<-sqrt(diag(vcovHC(lm5,type="HC1")))
robse6<-sqrt(diag(vcovHC(lm6,type="HC1")))

stargazer(lm4,lm5,lm6,type="text",se=list(robse4,robse5,robse6),omit=c("factor"))


### Table A8: Logistic Regression Analysis with Lagged DV (discussed on p. 12 and presented in Appendix)

glm4<-glm(battle~adjacent_battle+lagged_battle+neighbors+area+terrain_ruggedness,family=binomial(link="logit"),data=data)
glm5<-glm(battle~adjacent_battle+road_battle+lagged_battle+neighbors+area+terrain_ruggedness,family=binomial(link="logit"),data=data)
glm6<-glm(battle~road_battle+lagged_battle+neighbors+area+terrain_ruggedness,family=binomial(link="logit"),data=data)

robseglm4<-sqrt(diag(vcovHC(glm4,type="HC2")))
robseglm5<-sqrt(diag(vcovHC(glm5,type="HC2")))
robseglm6<-sqrt(diag(vcovHC(glm6,type="HC2")))

stargazer(glm4,glm5,glm6,type="text",se=list(robseglm4,robseglm5,robseglm6),omit=c("factor"))


### Table A9: Linear Probability Analysis with Peace_years (discussed on p. 12 and presented in Appendix)

lm7<-lm(battle~adjacent_battle+peace_years+neighbors+area+terrain_ruggedness,data=data)
lm8<-lm(battle~adjacent_battle+road_battle+peace_years+neighbors+area+terrain_ruggedness,data=data)
lm9<-lm(battle~road_battle+peace_years+neighbors+area+terrain_ruggedness,data=data)

robse7<-sqrt(diag(vcovHC(lm7,type="HC1")))
robse8<-sqrt(diag(vcovHC(lm8,type="HC1")))
robse9<-sqrt(diag(vcovHC(lm9,type="HC1")))

stargazer(lm7,lm8,lm9,type="text",se=list(robse7,robse8,robse9),omit=c("factor"))


### Table A10: Linear Probability Analysis with Region Controls (1) (discussed on p. 12 and presented in Appendix)  

lm10<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_tousan+factor(year)+factor(province),data=data)
lm11<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_toukai+factor(year)+factor(province),data=data)
lm12<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_hokuriku+factor(year)+factor(province),data=data)
lm13<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_kinai+factor(year)+factor(province),data=data)

robse10<-sqrt(diag(vcovHC(lm10,type="HC1")))
robse11<-sqrt(diag(vcovHC(lm11,type="HC1")))
robse12<-sqrt(diag(vcovHC(lm12,type="HC1")))
robse13<-sqrt(diag(vcovHC(lm13,type="HC1")))

stargazer(lm10,lm11,lm12,lm13, type="text",se=list(robse10,robse11,robse12,robse13),omit=c("factor"))


### Table A11: Linear Probability Analysis with Region Controls (2) (discussed on p. 12 and presented in Appendix)  

lm14<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_nankai+factor(year)+factor(province),data=data)
lm15<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_sanin+factor(year)+factor(province),data=data)
lm16<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_sanyou+factor(year)+factor(province),data=data)
lm17<-lm(battle~adjacent_battle+road_battle+neighbors+area+terrain_ruggedness+region_saikai+factor(year)+factor(province),data=data)

robse14<-sqrt(diag(vcovHC(lm14,type="HC1")))
robse15<-sqrt(diag(vcovHC(lm15,type="HC1")))
robse16<-sqrt(diag(vcovHC(lm16,type="HC1")))
robse17<-sqrt(diag(vcovHC(lm17,type="HC1")))

stargazer(lm14,lm15,lm16,lm17, type="text",se=list(robse14,robse15,robse16,robse17),omit=c("factor"))


### Table A12: Linear Probability Analysis with Dyadic Data (discussed on p. 12 and presented in Appendix)

# input dyadic diffusion data location below and load Warring-States Japan dyadic diffusion data
data2<-read.csv("INPUT HARD DRIVE LOCATION HERE/WarringStatesJapan_diffusiondata_dyadic.csv")

lm18<-lm(prov1_battle~prov2_battle+neighbors+area+prov1_terrain_ruggedness+factor(year)+factor(province1),data=data2)
lm19<-lm(prov1_battle~prov2_battle+road_battle+neighbors+area+prov1_terrain_ruggedness+factor(year)+factor(province1),data=data2)
lm20<-lm(prov1_battle~road_battle+neighbors+area+prov1_terrain_ruggedness+factor(year)+factor(province1),data=data2)

robse18<-sqrt(diag(vcovHC(lm18,type="HC1")))
robse19<-sqrt(diag(vcovHC(lm19,type="HC1")))
robse20<-sqrt(diag(vcovHC(lm20,type="HC1")))

stargazer(lm18,lm19,lm20,type="text",se=list(robse18,robse19,robse20),omit=c("factor"))
