#pi setup - source this file
#check working directory is correct
if(!fs::file_exists("pi_setup.Rproj")){
  stop("Working directory should be pi_setup.Rproj directory")
}

library("glue")

#### configuration ####
# set seed to get correct codes
seed <- 1

# leaf scan directory
scan_dir <- "/home/pi/Desktop/leaf_scans"

#find working directory
wd <- getwd()


#### create desktop icons ####
# for leaf scanner 

scanner_desktop <- glue("[Desktop Entry]
Name=Scan leaves
Comment=Setup for Plant Functional Trait Course leaf scanning
Exec={wd}/leaf_scan.sh
Icon={wd}/figures/leaf_clip_art_thumb.png
Terminal=true
Type=Application")

writeLines(scanner_desktop, con = "/home/pi/Desktop/scan_traits.desktop")

# and Yoda

name_check_desktop <- glue("[Desktop Entry]
Name=Scan name check
Comment=Validate names of leaf scans
Exec={wd}/run_filename_check.sh
Icon={wd}/figures/leaf_clip_art_thumb2.png
Terminal=true
Type=Application")

writeLines(name_check_desktop, con = "/home/pi/Desktop/name_check.desktop")


#### create leaf codes ####
#install pftc functions 
if(!require("PFTCFunctions")){
  remotes::install_github("Plant-Functional-Trait-Course/PFTCFunctions")
  library("PFTCFunctions")
}

# create leaf codes
seed <- 1
all_codes <- get_PFTC_envelope_codes(seed = seed)
saveRDS(all_codes, file = "envelope_codes.RDS")

#### create save directory for scans ####
if(!fs::dir_exists(scan_dir)){
  cat(glue("creating {scan_dir}"))
  fs::dir_create(scan_dir)
}

#### sh files ####
#filename check
run_filename_check.sh <- glue("#!/bin/sh
cd {wd}
  
  Rscript R/run_filename_check.R
")

writeLines(run_filename_check.sh, con = "run_filename_check.sh")

#leaf_scan.sh
leaf_scan.sh <- glue("#!/bin/sh
cd {wd}

xsane &

while true
do
  inotifywait -e create {scan_dir} |  Rscript R/run_check_image.R
done ")

writeLines(leaf_scan.sh, con = "leaf_scan.sh")



#### xsane config?? ####
