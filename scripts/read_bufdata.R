#Streamline process of reading in CSV and Shapefile data
#from Buffalo Open Data Portal (via Socrata API)
#
#Requires RSocrata, tidyverse, and sf
#
#read_bufdata() with no arguments for a list of possible dataset titles

read_bufdata <- function(title=NULL, format='CSV'){

  if ( ! format %in% c('CSV', 'csv', 'Shapefile', 'shapefile') ){
    stop('Data format must be "CSV" or "Shapefile"')
  }
  
  datasets = RSocrata::ls.socrata('https://data.buffalony.gov')

  if( is.null(title) || ! title %in% datasets$title ){
    cat('Available datasets:\n')
    return(datasets$title)
  }

  ind = which(datasets$title == title)
  urls = datasets$distribution[[ind]]$downloadURL

  if ( format %in% c('CSV','csv') ){
    csv_url = urls[grep('rows.csv',urls)]
    if(length(csv_url)==0) stop('CSV format not available for dataset')
    return( tibble::as_tibble(RSocrata::read.socrata(csv_url)) ) 
  }

  sf_url = urls[grep('Shapefile',urls)]
  if(length(sf_url)==0) stop('Shapefile format not available for dataset')
 
  dest_dir = tempdir()
  dest <- tempfile(tmpdir=dest_dir)
  download.file(sf_url, dest, quiet=T)
  unzip(dest, exdir = dest_dir)
  shape_name = grep('.shp',list.files(dest_dir),value=T)
  setwd(dest_dir)
  sf::st_read(shape_name,quiet=TRUE) 
  
}
