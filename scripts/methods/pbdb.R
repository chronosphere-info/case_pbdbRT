# Functions to calculate things from the PBDB
#' @param vers - versions to repeat on
#' @param var variable in question
VarFromPBDB <- function(vers, var="divRT"){
	
	for(i in 1:length(vers)){
		# get the dataset
		x <- fetch("pbdb", var="occs", vers[i])

		# assign the stages to it. 
		x <- AssignStages(x)

		# rudimentary cleaning
		x <- Clean(x)

		# run divDyn using the stages
		dd <- divDyn::divDyn(x, bin="stg", tax="genus")

		# select the variable in question
		vari <- dd[, var]

		if(i==1){
			# create a container
			container <- matrix(NA, ncol=length(vers), nrow=length(vari))
			colnames(container) <- vers
			rownames(container) <- rownames(dd)

		}

		# store things in the container
		container[rownames(dd),i] <- vari

		cat(i, "\r")
	}
	
	# return container
	return(container)

}

# rudimentary cleaning of a PBDB dataset
Clean <- function(dat){
	# omit missing taxa
	datNoNAGEN <- dat[!is.na(dat$genus), ]

	# omit missing stages
	datNoNASTG <- datNoNAGEN[!is.na(datNoNAGEN$stg), ]
	
	# omit invalid taxon
	datOK <- datNoNASTG[!datNoNASTG$genus=="", ]

	# return
	return(datOK)	
}

#' @param dat A dataset downloaded from the Paleobiology Database 
# More about this on the divDyn github repository.
AssignStages <- function(dat){

	# load necessary data from divDyn
	data(stages, package="divDyn")
	data(keys, package="divDyn")
	
	
	# the 'stg' entries (lookup)
	stgMin <- divDyn::categorize(dat[ ,"early_interval"], keys$stgInt)
	stgMax <- divDyn::categorize(dat[ ,"late_interval"], keys$stgInt)

	# convert to numeric
	  stgMin <- as.numeric(stgMin)
	  stgMax <- as.numeric(stgMax)

	# convert to numeric
	stgMin <- as.numeric(stgMin)
	stgMax <- as.numeric(stgMax)

	# empty container
	dat$stg <- rep(NA, nrow(dat))

	# select entries, where
	stgCondition <- c(
	# the early and late interval fields indicate the same stg
	  which(stgMax==stgMin),
	# or the late_intervar field is empty
	  which(stgMax==-1))

	# in these entries, use the stg indicated by the early_interval
	  dat$stg[stgCondition] <- stgMin[stgCondition] 
	
	# execute binning from outside code in a dedicated environment
	e <- new.env()

	# copy dat to this environment
	e$dat <- dat
	# separately process the ordovician and the cambrian
	  load(url("https://github.com/divDyn/ddPhanero/raw/master/data/Stratigraphy/2018-08-31/cambStrat.RData"), envir=e)
	  source("https://github.com/divDyn/ddPhanero/raw/master/scripts/strat/2018-08-31/cambProcess.R", local=e)
	  load(url("https://github.com/divDyn/ddPhanero/raw/master/data/Stratigraphy/2018-08-31/ordStrat.RData"), envir=e) 
	  source("https://github.com/divDyn/ddPhanero/raw/master/scripts/strat/2019-05-31/ordProcess.R", local=e)

	return(e$dat)
}

