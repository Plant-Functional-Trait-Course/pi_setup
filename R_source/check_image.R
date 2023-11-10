check_image <- function(pathfile, scan_path, check_ij = TRUE){
  require("glue")
  
  resolution <- 300
  imageHeight <- 3508
  imageWidth <- 2552
  tolerance <- 20
  
  BitsPerSample <- 8 # colour depth
  
  file <- basename(pathfile)  
  
  stop2 <- function(msg) {
    x11(height = 10, width = 10, canvas = "pink", pointsize = 18)
    plot(1, 1, type = "n", axes = FALSE, ann = FALSE)
    title(main = paste(strwrap(msg, width = 30), collapse = "\n"), col.main = "red", line = -1)
    locator(1)
    graphics.off()

    stop(msg)

  }
  

  # check extension
  if(!grepl("([^\\s]+(\\.(jpg|jpeg))$)", file, ignore.case = TRUE)){
    stop2(glue("File extension on {file} not permitted - use '.jpg'"))
  }
  
  # check file name is permitted
 
  if(!grepl("^[A-Z]{3}\\d{4}\\.(jpg|jpeg)$", file, ignore.case = TRUE)){
    stop2(glue("File name {file} not expected format (3-letters, 4-numbers)"))
  }
  file_base <- gsub("(^[A-Z]{3}\\d{4}).*", "\\1", file)

  all_codes <- readRDS("envelope_codes.RDS")# import all_codes  

  if(!file_base %in% all_codes$hashcode){
    stop2(glue("File name {file} not in list of permitted names"))
  }
  

  # check exif information is good
  exif <- exifr::read_exif(
    path = file.path(scan_path, pathfile),
    tags = c("XResolution", "YResolution", "BitsPerSample", "ImageHeight", "ImageWidth"))
  
  #correct resolution
  if(exif$XResolution != resolution | exif$YResolution != resolution){
    stop2(glue("Scan resolution is {exif$XResolution} (x) {exif$YResolution} (y) not expected {resolution}"))
  }
  
  #correct size (with tolerance)
  if(abs(exif$ImageHeight - imageHeight) > tolerance | 
     abs(exif$ImageWidth - imageWidth) > tolerance){
    stop2(glue("Scan size is {exif$ImageWidth} x {exif$ImageHeight} pixels not expected {imageWidth} x {imageHeight} (A4)"))
  }

    #colour depth
  if(exif$BitsPerSample != BitsPerSample){
    stop2(glue("Colour depth is {exif$BitsPerSample} bits not expected {BitsPerSample} (full colour)"))
  }
  
  #imagej check
  if(isTRUE(check_ij)){
    #to do
  }
  
  print("Passed checks")
}
  

# check_image("folder/good.jpgx")
# check_image("folder/AA1111.jpg")
# check_image("folder/AAA1111.jpg")
# check_image("folder/AAA4667.jpg")
