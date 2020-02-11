
<!-- README.md is generated from README.Rmd. Please edit that file -->
pi\_setup
=========

<!-- badges: start -->
<!-- badges: end -->
The goal of `pi_setup` is to set up the Raspberry Pis used for scanning leaves on the Plant Functional Trait Courses.

The Pis control the scanners, ensuring consistency, and validate file names.

Set up the Pi
-------------

Download the raspberian image from <https://www.raspberrypi.org/downloads/raspbian/> and follow [installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) to write the image to the Pi's SD card.

Then run

``` bash
sudo apt update
sudo apt full-upgrade
```

Install `xsane`, `inotifywait`, and `R`.

``` bash
sudo apt-get install sane sane-utils libsane-extras xsane
sudo apt-get install inotify-tools
sudo apt-get install r-base r-base-core r-base-dev
```

`xsane` controls the scanner, `inotifywait` watches for new files in the image directory (made below) and `R` validates the image file name and quality.

From the desktop, click on the raspberry (top left), then Preferences &gt;&gt; Raspberry Pi Configuration &gt;&gt; Interfaces and enable VNC and optionally SSH (SSH is useful when connecting to the pi with a phone).

Set up R
--------

Install the following packages

-   `dplyr`
-   `tidyr`
-   `fs`
-   `glue`
-   `exifr`
-   `remotes`
-   `PFTCFunctions` (with `remotes::install_github("Plant-Functional-Trait-Course/PFTCFunctions", upgrade = FALSE)`)

Some of these take a VERY long time to install from source on the Pis. It would be worth exploring installing binaries

Run the setup script
--------------------

Open the terminal and clone the `pi_setup` repo from github.com to the Pi with

`git clone https://github.com/Plant-Functional-Trait-Course/pi_setup.git`

This will make a directory called `pi_setup`. Move into this folder with

`cd pi_setup`

The `pi_setup.R` script creates the desktop icons and associated bash scripts that start the scanner and check if the files names are valid.

Edit `pi_setup.R` to set the random seed for the list of valid names (made with `PFTCFunctions::get_PFTC_envelope_codes`).

So far:

-   Peru = 1
-   Svalbard = 32

Save, and then run

``` r
source("pi_setup.R")
```

Run the leaf icon on the desktop, and test the system works by saving a scan with a valid name.

IP addresses
------------

Find the IP address of the pi with `ifconfig`

Set the USB IP address, for convenience when connecting by phone by a USB cable.

Details
-------

Follow instructions at <https://www.raspberrypi.org/forums/viewtopic.php?t=248380#p1516491> to avoid message

> this text file seems to be an executable script "what do you want to do with it"

whenever you launch one of the desktop icons.

Run `scan leaf` desktop icon and wait for `xsane` to open. Set - the save directory to `/home/pi/Desktop/leaf_scans` (or whatever directory was set by `pi_setup.R`) - The scan type to colour - Resolution to 300

Quit using the File &gt;&gt; Quit (`xsane` should then remember these settings)

Test and clone
--------------

When everything is working, clone the SD cards (keep one as backup).
