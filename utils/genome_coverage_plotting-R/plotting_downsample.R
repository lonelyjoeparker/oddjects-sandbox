# simple script to downsample the data ready for plotting

# version 0.1
# author Joe Parker 

bias_downsample = function(input_data, downsample_factor){
  # input = data frame of coverage data
  # downsample_factor = factor to downsample by
  output = input_data[seq(1, nrow(input_data), downsample_factor), ]
  return(output)
}