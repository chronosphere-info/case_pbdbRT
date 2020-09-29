#!/usr/bin/Rscript

# Script to trace range-through diversity from the Paleobiology Database
# Ádám T. Kocsis
# 2020-09-29
# Erlangen 

# 1. libraries
library(chronosphere)
library(divDyn)

# load all functions
source()

# 2. pbdb versions
pbdbDat <- datasets("pbdb")

# the occs, default variable
occsVer<- pbdbDat[pbdbDat$var=="occs",]$ver

# make sure it is unique
occsVer <- unique(occsVer)

# execute function for all vers
rtDiv <- VarFromPBDB(occsVer, var="divRT")

# plot the whole matrix separately
PlotRTseparate(rtDiv, path="export/divRT/")

# plot the whole matrix 2. on one plot
PlotRTsingle(rtDiv)




