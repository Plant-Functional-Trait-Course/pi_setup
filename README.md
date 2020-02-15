
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

The first time you run the pi you need a screen (connect with an MDVI cable) and an external USB keyboard and mouse. Start the pi by plugging in the power and follow the instructions for a first time setup. It will ask you to set a password - you will need this later with the VNC viewer.

Next open the terminal (ctrl-alt-t or use the menu) and then run

``` bash
sudo apt update
sudo apt full-upgrade
```

Install `xsane`, `inotifywait`, `R`, and `curl`.

``` bash
sudo apt-get install sane sane-utils libsane-extras xsane
sudo apt-get install inotify-tools
sudo apt-get install r-base r-base-core r-base-dev
sudo apt-get install libcurl4-openssl-dev
```

`xsane` controls the scanner, `inotifywait` watches for new files in the image directory (made below) and `R` validates the image file name and quality. `curl` is required by the `exifr` `R` package.

From the desktop, click on the raspberry (top left), then Preferences &gt;&gt; Raspberry Pi Configuration &gt;&gt; Interfaces and enable VNC and optionally SSH (SSH is useful when connecting to the pi with a phone).

Install the setup script
------------------------

Open the terminal and clone the `pi_setup` repo from github.com to the Pi with

``` bash
git clone https://github.com/Plant-Functional-Trait-Course/pi_setup.git
```

This will make a directory called `pi_setup`. Move into this folder with

``` bash
cd pi_setup
```

Set up R
--------

Open R from the terminal by typing R

``` bash
R
```

Install the following packages

-   `dplyr`
-   `tidyr`
-   `fs`
-   `glue`
-   `exifr`
-   `remotes`
-   `PFTCFunctions` (with `remotes::install_github("Plant-Functional-Trait-Course/PFTCFunctions", upgrade = FALSE)`)

Some of these take a VERY long time to install from source on the Pis. It would be worth exploring installing binaries, especially for `dplyr` and `tidyr`.

Run the set-up script
---------------------

The `pi_setup.R` script creates the desktop icons and associated bash scripts that start the scanner and check if the files names are valid.

Edit `pi_setup.R` to set the random seed for the list of valid names (made with `PFTCFunctions::get_PFTC_envelope_codes`).

So far:

-   Peru 2018 = 1
-   Svalbard 2018 = 32

Save, and then run

``` r
source("pi_setup.R")
```

If there are no errors, you can quit `R`.

``` r
q(save = "no")
```

IP addresses
------------

Set static ethernet and USB IP address (this might cause conflicts if you are using ethernet to connect to the internet, but is very convenient when using VNC to connect to laptops (ethernet) or phone (USB).

Right click on the wifi icon at the top left of the screen, then select Wireless & Wired Network Services.

In the menu, select `eth0` in the top right drop-down box, then write in the desired IPv4 Address. IPv4 address should have a format like `192.168.42.42`. Repeat for `usb0` (you will probably need a phone connected by usb to see this option).

Setting static IP adress might make it difficult to connect to a ethernet network.

Details
-------

Follow instructions at <https://www.raspberrypi.org/forums/viewtopic.php?t=248380#p1516491> to avoid message

> this text file seems to be an executable script "what do you want to do with it"

whenever you launch one of the desktop icons.

Plug in the scanner and run the `scan leaf` desktop icon and wait for `xsane` to open. Set - the save directory to `/home/pi/Desktop/leaf_scans` (or whatever directory was set by `pi_setup.R`) - The scan type to colour - Resolution to 300

Quit using the File &gt;&gt; Quit (`xsane` should then remember these settings).

Laptop set-up
-------------

Download and install the VNC viewer from <https://www.realvnc.com/en/connect/download/viewer/>

Connect to the Pi with an ethernet cable and open VNC viewer. Enter the IP address to connect. You can now see the Pi desktop on your screen, and control the Pi with your keyboard and mouse/touchpad.

Phone set-up
------------

Being able to connect the pi to a phone by USB cable is sometimes convenient to check the pi are happy.

Install the VNC Viewer - Remote Desktop app by RealVNC Limited.

The VX ConnectBot by Martin Matuska allows SSH to connect to the pi as an alternative to VNC. This gives a command line interface is quite useful given the limited screen size.

Plug the phone into the pi with a USB-micro-USB cable (the phones charging cable is fine). Next, enable USB tethering in the phone's hotspot menu. This step is easy to forget - but the next step won't work without it. Now open VNC or VX ConnectBot and follow instructions. You will need the IP address.

Test and clone
--------------

When everything is working, clone the SD cards (keep one SD card as backup).
