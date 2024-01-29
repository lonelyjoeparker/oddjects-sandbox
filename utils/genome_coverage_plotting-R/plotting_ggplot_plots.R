# script which should use ggplot2 to plot the read data with appropriate legend, smoothed lines, etc

# version 0.1
# author Joe Parker 
library(ggplot2)

bias_plot = function(input, start_coordinates, window_length, which_columns){
  # input = data frame of coverage data
  # start_coordinates  = position to start plot at (x pos)
  # window_length = overall plotting window length (x pos)
  # which_columns = which of the coverage data columns to plot
  # NB if start + length > input size, error.
  
  # housekeeping: check the window we've been asked for isn't too big:
  max_pos = max(input$pos)
  xlims = c(0,max_pos)
  if(start_coordinates + window_length > max_pos){
    warning("Window requested falls outside the genome alignment. Using naive xpos limits, eg the whole alignent")
  } else {
    xlims = c(start_coordinates/10^6, (start_coordinates+window_length)/10^6)
  }
  # housekeeping: get the max coverage (y-lim)
  max_coverage = max(input[2:ncol(input)])
  ylims = c(0, max_coverage)
  
  
  # first, do a naive non-ggplot way:
  plot(input$pos/10^6, input[,2],
       main = "coverage bias",
       xlab = "alignment position, Mbp",
       xlim = xlims,
       ylab = "read depth",
       ylim = ylims
       )
  lines(input$pos/10^6, input[,2])
  points(input$pos/10^6, input[,3],col="red")
  lines(input$pos/10^6, input[,3],col="red")
  legend(start_coordinates/10^6,max_coverage,names(input)[2:ncol(input)],col=c("black","red"),fill=c("black","red"))
  # return(output)
}

bias_ggplot = function(input, start_coordinates, window_length, which_columns, supress_save=F){
  # input = data frame of coverage data
  # start_coordinates  = position to start plot at (x pos)
  # window_length = overall plotting window length (x pos)
  # which_columns = which of the coverage data columns to plot
  # no save = suppress .png save behaviour? Default=F
  # NB if start + length > input size, error.
  
  # housekeeping: check the window we've been asked for isn't too big:
  max_pos = max(input$pos)
  xlims = c(0,max_pos)
  if(start_coordinates + window_length > max_pos){
    warning("Window requested falls outside the genome alignment. Using naive xpos limits, eg the whole alignent")
  } else {
    xlims = c(start_coordinates/10^6, (start_coordinates+window_length)/10^6)
  }
  # housekeeping: get the max coverage (y-lim)
  max_coverage = max(input[2:ncol(input)])
  ylims = c(0, max_coverage)
  
  # basic debugging assertion:
  print(ylims)
  
  # basic ggplot:
  ggplot(mpg, aes(x=displ, y=hwy)) + geom_point()
  
  # now try a ggplot with the data
  ggplot(input, aes(x=pos, y=input[,2])) + geom_point() + geom_smooth()

  # now try one with the other data, work out how to add the layers properly in ggplot later
  # ggplot(input, aes(x=pos, y=input[,3])) + geom_point() + geom_smooth() # this also works but it doesn't look as cool and overwrites the other plot
  
  if (supress_save == F){
    # now try to save the active plot
    ggsave('~/Downloads/ggplotTestSave.png')
  } else {
    warning('Suppressing plot save - nothing written to disc.')
  }
}

bias_ggplot_simple = function(input, image_filename, supress_save=F){
  # input = data frame of coverage data
  # image_filename = name of image to save to
  # supress_save = suppress .png file output? Default: F
    
  # now try a ggplot with the data
  ggplot(input, aes(x=pos, y=input[,3])) + geom_point() + geom_smooth() + ggtitle(paste("Genome coverage:\n", image_filename)) + xlab("Genome position") + ylab("Read depth")
  
  if (supress_save==F){
    # now try to save the active plot
    ggsave(image_filename,width = 10,height = 4)
  } else {
    warning('Suppressing plot save - nothing written to disc.')
  }
}