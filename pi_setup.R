# pi setup - source this file

# install pftc functions
if (!require("PFTCFunctions")) {
  remotes::install_github("Plant-Functional-Trait-Course/PFTCFunctions")
  library("PFTCFunctions")
}

library("glue")

# check working directory is correct
if (!fs::file_exists("pi_setup.Rproj")) {
  stop("Working directory should be pi_setup.Rproj directory")
}

# functions

get_scan_dir <- function(scan_dir) {
  finished <- FALSE
  while (!finished) {
    new_scan_dir <- readline(glue("scan_dir is\n {scan_dir}\n Type to change or leave blank to accept"))
    if (new_scan_dir == "") {
      finished <- TRUE
    } else {
      cat("\n")
      scan_dir <- new_scan_dir
      finished <- FALSE
    }
  }
  scan_dir
}

#### configuration ####
# set seed to get correct codes
seed <- 1
# ask to change seed
seed <- get_seed(seed)

# save used seed to file for later reference
writeLines(as.character(seed), con = "this_seed_used.txt")

# leaf scan directory
scan_dir <- "/home/pi/Desktop/leaf_scans"

scan_dir <- get_scan_dir(scan_dir)

# find working directory
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

# create leaf codes
all_codes <- get_PFTC_envelope_codes(seed = seed)
saveRDS(all_codes, file = "envelope_codes.RDS")

#### create save directory for scans ####
if (!fs::dir_exists(scan_dir)) {
  cat(glue("creating {scan_dir}"))
  fs::dir_create(scan_dir)
}

#### sh files ####
# filename check
run_filename_check.sh <- glue("#!/bin/sh
cd {wd}

  Rscript R/run_filename_check.R
")

writeLines(run_filename_check.sh, con = "run_filename_check.sh")

# leaf_scan.sh
leaf_scan.sh <- glue("#!/bin/sh
cd {wd}

xsane &

while true
do
  inotifywait -e create {scan_dir} |  Rscript R/run_check_image.R
done ")

writeLines(leaf_scan.sh, con = "leaf_scan.sh")

# change_seed.sh
change_seed.sh <- glue("#!/bin/sh
cd {wd}

Rscript R/change_seed.R
")

writeLines(change_seed.sh, con = "change_seed.sh")


# set permissions
fs::file_chmod("run_filename_check.sh", mode = "u+x")
fs::file_chmod("leaf_scan.sh", mode = "u+x")
fs::file_chmod("change_seed.sh", mode = "u+x")


#### code R files and replace scan_dir####
process_code <- function(file) {
  f <- readLines(file.path("R_source", file))
  f <- gsub("REPLACE_WITH_SCAN_DIR", scan_dir, f)
  writeLines(f, file.path("R", file))
}

# create working code directory
fs::dir_create("R")

process_code("run_filename_check.R")
process_code("check_image.R")
process_code("run_check_image.R")
process_code("change_seed.R")
