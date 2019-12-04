rm(list = ls())

setwd("C:/Users/Tarik Porto/Documents/MATLAB/PlatEMO/PlatEMO/CSV")

problems <- c("DTLZ1", "DTLZ2", "DTLZ3", "DTLZ4", "DTLZ5", "DTLZ6", "DTLZ7",
              "WFG1", "WFG2", "WFG3", "WFG4", "WFG5", "WFG6", "WFG7", "WFG8", "WFG9")

metrics <- c("mst","shir","hv","igd")

algorithms <- c("NSGAII")

delta <- 0.6
idelta <- 2

alfa <- 0.05

result <- data.frame("alg" = c(), "prob" = c(), "mst"=c(), "shir"=c(),"hv"=c(), "igd"=c(), 
                     "good_mst"=c(), "good_shir"=c(), "good_hv"=c(), "good_igd"=c(),stringsAsFactors = FALSE)

for (i in 1:length(algorithms)) {
  
  for (j in 1:length(problems)) {
    
    mst <- read.csv(file=paste(algorithms[i],"_",problems[j],"_",metrics[1],".csv", sep=""), header=FALSE, sep=",")
    test_mst = wilcox.test(mst[,1], mst[,idelta], alternative = "less")
    
    shir <- read.csv(file=paste(algorithms[i],"_",problems[j],"_",metrics[2],".csv", sep=""), header=FALSE, sep=",")
    test_shir = wilcox.test(shir[,1], shir[,idelta], alternative = "less")
    
    hv <- read.csv(file=paste(algorithms[i],"_",problems[j],"_",metrics[3],".csv", sep=""), header=FALSE, sep=",")
    test_hv = wilcox.test(hv[,1], hv[,idelta], alternative = "greater")
    
    igd <- read.csv(file=paste(algorithms[i],"_",problems[j],"_",metrics[4],".csv", sep=""), header=FALSE, sep=",")
    test_igd = wilcox.test(-igd[,1], -igd[,idelta], alternative = "greater")
    
    row <- data.frame("alg" = c(algorithms[i]), "prob" = c(problems[j]), "mst"=c(test_mst$p.value), 
                      "shir"=c(test_shir$p.value),"hv"=c(test_hv$p.value), "igd"=c(test_igd$p.value), 
                      "good_mst"=c(test_mst$p.value < alfa), "good_shir"=c(test_shir$p.value < alfa), 
                      "good_hv"=c(test_hv$p.value >= alfa), "good_igd"=c(test_igd$p.value >= alfa),
                      stringsAsFactors = FALSE)
    
    result <- rbind(result, row)

  }
  
}

print(sum(result["good_mst"] == TRUE))

print(sum(result["good_shir"] == TRUE))

print(sum(result["good_hv"] == TRUE))

print(sum(result["good_igd"] == TRUE))

