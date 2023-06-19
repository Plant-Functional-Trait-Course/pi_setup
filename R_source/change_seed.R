
main <- function() {
  # get current seed
  current_seed <- tryCatch(
    readLines("this_seed_used.txt")
    )
  if(inherits(res, "try-error")) {
    print("Current seed not found")
    current_seed <- "Unknown"
  }
  
  # dry new seed  
  current_seed <- PFTCFunctions::get_seed(current_seed)
  
  #save used seed to file for later reference
  writeLines(as.character(seed), con = "this_seed_used.txt")
  
  
 # create leaf codes
  all_codes <- PFTCFunctions::get_PFTC_envelope_codes(seed = seed)
  saveRDS(all_codes, file = "envelope_codes.RDS")
  
}