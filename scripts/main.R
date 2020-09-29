#!/usr/bin/Rscript

# Script to trace range-through diversity from the Paleobiology Database
# Ádám T. Kocsis
# 2020-09-29
# Erlangen 

# working directory
workDir <-file.path(Sys.getenv("WorkSpace"), "2019-07-08_chronosphere", "case_pbdbRT")
setwd(workDir)

# 1. libraries
library(chronosphere)
library(divDyn)

# load all functions
source("https://github.com/chronosphere-portal/case_pbdbRT/raw/master/scripts/methods/pbdb.R")
source("https://github.com/chronosphere-portal/case_pbdbRT/raw/master/scripts/methods/plots.R")

# 2. pbdb versions
pbdbDat <- datasets("pbdb")

# the occs, default variable
occsVer<- pbdbDat[pbdbDat$var=="occs",]$ver

# make sure it is unique
occsVer <- unique(occsVer)

# execute function for all vers
rtDiv <- VarFromPBDB(occsVer, var="divRT")
saveRDS(rtDiv, file="export/rtDiv_20200929.rds")

# plot the whole matrix separately
data(stages)
PlotRTcumulative(x=stages$mid, y=rtDiv, path="export/divRT/", png="divRT")

# plot the whole matrix 2. on one plot
PlotRTsingle(x=stages$mid, y=rtDiv, path="export/", png="divRT")




