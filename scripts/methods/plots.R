# Function to plot all variable versions
PlotRTcumulative<-function(y, x, path, png=NULL, pdf=NULL){
	if(!is.null(png)){
		if(!file.exists(path)) system(paste0("mkdir ", path))
		for(i in 1:ncol(y)){
			ver <- colnames(y)[i]
			png(file.path(path, paste0(png, "_",ver, ".png")), width=1000, height=800)
			Tp(ylim=c(0,8000))
			mtext(3, text=ver)
			for(j in 1:i) lines(x, y[,j], col="black")
			dev.off()
		}
	}

}

# ok
PlotRTsingle <-function(y, x, path, png=NULL, pdf=NULL){
	if(!is.null(png)){
		if(!file.exists(path)) system(paste0("mkdir ", path))
		png(file.path(path, paste0(png, "_all.png")), width=1000, height=800)
		Tp(ylim=c(0,8000))
		for(i in 1:ncol(y)){
			ver <- colnames(y)[i]
		#	mtext(3, text=ver)
			lines(x, y[,i], col="black")
		}
		
		dev.off()
	}

}

# new
Tp <- function(...){
	data(stages, package="divDyn")
	divDyn::tsplot(stages, boxes="sys", shading="sys",xlim=4:95, ...)

}