args = commandArgs(trailingOnly = TRUE)
print(args)
rmarkdown::render(args[1],output_file=paste('../',args[2],sep=''))
