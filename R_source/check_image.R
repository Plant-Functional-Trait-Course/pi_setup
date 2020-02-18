check_image <- function(pathfile, check_ij = TRUE){
  scan_dir <- "REPLACE_WITH_SCAN_DIR"
  resolution <- 300
  imageSize <- "2552x3508"
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
    stop2(paste0("File extension on ", file, " not permitted - use '.jpg'"))
  }
  
  # check file name is permitted
 
  if(!grepl("^[A-Z]{3}\\d{4}\\.(jpg|jpeg)$", file, ignore.case = TRUE)){
    stop2(paste0("File name ", file, " not expected format (3-letters, 4-numbers)"))
  }
  file_base <- gsub("(^[A-Z]{3}\\d{4}).*", "\\1", file)

  all_codes <- readRDS("envelope_codes.RDS")# import all_codes  

  if(!file_base %in% all_codes$hashcode){
    stop2(paste0("File name ", file, " not in list of permitted names"))
  }
  

  # check exif information is good
  exif <- exifr::read_exif(file.path(scan_dir, file))
  #correct resolution
  if(exif$XResolution != resolution | exif$YResolution != resolution){
    stop2(paste0("Scan resolution is ", exif$XResolution, " not expected ", resolution))
  }
  
  #correct size (with tolerance)
  if(exif$ImageSize != imageSize){
    stop2(paste0("Scan size is ", exif$ImageSize, " pixcels not expected ", imageSize, " (A4)"))
  }

    #colour depth
  if(exif$BitsPerSample != BitsPerSample){
    stop2(paste0("Colour depth is ", exif$BitsPerSample, " bits not expected ", BitsPerSample, " (full colour)"))
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