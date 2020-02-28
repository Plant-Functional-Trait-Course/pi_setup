
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

Some of these take a **VERY** long time to install from source on the Pis. It would be worth exploring installing binaries, especially for `dplyr` and `tidyr`.

Run the set-up script
---------------------

The `pi_setup.R` script creates the desktop icons and associated bash scripts that start the scanner and check if the files names are valid.

``` r
source("pi_setup.R")
```

You will be asked if you want to change the random seed that is used to generate the list of valid codes (made with `PFTCFunctions::get_PFTC_envelope_codes`).

So far:

| Campaign     | Country  |  Year|  seed|
|:-------------|:---------|-----:|-----:|
| PFTC3 & Puna | Peru     |  2018|     1|
| PFTC4        | Svalbard |  2018|    32|
| PFTC5        | Peru     |  2020|     6|

You will also be asked if you want to change the directory the scans are saved to.

If there are no errors, you can quit `R`.

``` r
q(save = "no")
```

IP addresses
------------

Set static USB IP address. This is very convenient when using VNC to connect to a phone (USB).

Right click on the wifi icon at the top left of the screen, then select Wireless & Wired Network Services.

With a phone connected by usb (make sure the usb-tethering is set-up on the phone), you can select `usb0` in the top right drop-down box, then write in the desired IPv4 Address. IPv4 address should have a format like `192.168.42.42`.

It ought to be possible to set the `eth0` IP address in the same way to connect to a laptop via ethernet, but we have not managed to get that to work.

To find the ethernet IP address, connect a laptop via an ethernet cable and, in the terminal, type `ifconfig`. A section of the output will refer to `eth0` and should have the IP address. This address seems to be stable.

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

Clone and test
--------------

When everything is working, clone the SD cards (keep one SD card as backup).

### Cloning the pi (using mac, for Linux/windows see links below)

Follow these instructions very carefully. Some advice to be careful when working in the terminal!

Insert the SD card to a computer. Open Terminal and enter the following command to locate your SD Card:

``` bash
diskutil list
```

Check the name and the size of the different disks. The name will be something like `/dev/disk2` and the size will be a little bit smaller than the max size of the sd card.

In Terminal, enter the following command to create a disc image (.dmg) of your SD Card on the Desktop. You might need to enter your admin password.

``` bash
sudo dd if=/dev/disk2 of=~/Desktop/raspberrypi.dmg
```

The cloning step can take some time and the terminal does not show the progress. When the cloning is done it will give a message that the process is complete.

### Restoring an sd card

Take empty SD card or reformat it. Here are some instructions how to do this: <https://www.raspberrypi.org/documentation/installation/sdxc_formatting.md>

Insert the sd card to a computer. Open Terminal and enter the following command to locate your SD Card:

``` bash
diskutil list
```

Unmount sd card using this command in terminal. Amend the sd card name if required.

``` bash
diskutil unmountDisk /dev/disk2
```

Format sd card using this command in terminal:

``` bash
sudo newfs_msdos -F 16 /dev/disk2
```

Restore sd card from a Cloned Disc Image

``` bash
sudo dd if=~/Desktop/raspberrypi.dmg of=/dev/disk2
```

Again this step can take a while (a couple of hours).

### Testing

Start up the raspberry pi and test if the cloned pi is working.

#### Sources

How to clone raspberry pi (only tested on mac) <https://computers.tutsplus.com/articles/how-to-clone-raspberry-pi-sd-cards-using-the-command-line-in-os-x--mac-59911> <https://www.raspberrypistarterkits.com/how-to/clone-raspberry-pi-sd-card-on-windows-linux-macos/>

How to back up and restore pi (only mac version has been tested) <https://thepihut.com/blogs/raspberry-pi-tutorials/17789160-backing-up-and-restoring-your-raspberry-pis-sd-card>
