# simple script to collate several genome sequencing coverage (depth) files of variable length into a single dataframe.
# assumes each has three columns exactly, of which middle col = genome posuition (x) and final col = seuqencing depth.

# version 0.1
# author Joe Parker 

bias_collate = function(input_1, input_2){
  # input_1 = data frame of coverage data
  # input_2 = data frame of coverage data
  str(input_1)
  str(input_2)
  
  # which is longer
  max_rows = min(
    length(input_1[,3]),
    length(input_2[,3])
  )
  
  # truncate them all (this would be a lot easier with an array input...)
  # notation reminder: if d[n,m] then d[n:k,i:m] is the n-kth ROWs and i-mth COLS]
  # so do d[1:limit,2:3] for 'limit' rows, cols 2 and 3 (pos and cov)
  output = input_1[1:max_rows,2:3]
  output = cbind(output, input_2[1:max_rows,3])
  # add the name of the second dataset as the name of the final depth column
  names(output) = c( names(output)[1:2], names(input_2[3]))

  return(output)
}