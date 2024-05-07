setwd("D:/DOKUMENTY/STUDIA/SEMESTR 6/NEWD/PROJEKT/NEWD/PROJEKT2_1")
data <- read.table("data/armia_krajowa_1944.txt", header = TRUE, sep = ';', colClasses = c("character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
head(data)
