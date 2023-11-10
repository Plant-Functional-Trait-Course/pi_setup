main <- function(){
  x <- readLines("stdin")
  source("R/check_image.R")
  cat("\n\n\n")
  x <- strsplit(x, split = " ")[[1]]

  check_image(x[[3]], scan_path = x[[1]])

  cat("done")
}

main()
