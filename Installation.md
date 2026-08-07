# BrowserShack Installation

## Pre-Requisite
- Radio with video out and mouse in for full features
  - USB Video Capture card
  - CH9239 UART/TTL serial port to USB HID (Human Interface Device) converter
- X86_64 machine with DietPi installed

### Install DietPi Linux Distro

- [DietPi](https://dietpi.com) 
  - https://dietpi.com/docs/install/#how-to-install-dietpi-native-pc
  - DietPi .iso Downloads: https://dietpi.com/#download
  - When prompted to install applications skip it
    - ![dietpi software menu](documantation_images/dietpi_software1.png)
  - DietPi will ask if you want to install an pure minimal system.  Answer ok.
    - ![dietpi software menu warning](documantation_images/dietpi_software2.png)

## Highly Recommended Before Installing BrowserShack

As some of the BrowserShack setup uses the current IP address to configure connections and menu items the following are highly recommended:

- Connect to Network Interface you plan to permanently run the server on
  - ie - if you are going to use it on wifi make sure DietPi is connected via wifi and not ethernet

- Static or DHCP Reserved IP address
  - If it will be turned on intermittently a static or DHCP reserved IP is highly recommended to the connections always work

## Base BroswerShack Install

This install script walks you through a few dietpi setup screens, installs required base apps via DietPi software menu, installs Dockge docker compose manager, and copies neccessary files for BrowserShack to their correct locations so DietPi backup can be used and the docker containers are premapped to the locations.

- Webpage files
  - hostname is dynamically replaced in web page link files
- docker-compose.yaml files for each container to Dockge locations
- OvenMediaEngine Server.xml configuration file
- Desktop Appimages & custom menu items
- RDP credential and connection file

Run the following command to download the setup script, make it executable, and run it.  The script will take care of the rest of the basic setup.  
  ```wget https://raw.githubusercontent.com/hamMUSings/BrowserShack/refs/heads/devrdp/install.sh && chmod +x install.sh && ./install.sh```

> [!IMPORTANT]
> DietPi menus are sometimes odd.  To exit a menu once set sometimes you have to choose "Exit" other times it is labeled "Back". And lastly sometimes when you make a selection it will continue automatically.

## Important Setup Questions

The following questions have specific reasons and the answers may be the opposite of what is expected. So please select the following answers when asked.  Other questions are up to you - ie what browser to install.

### X11 Configuration

Once you select Intel or AMD for your graphics driver to install DietPi will ask you...

- "Would like to auto-configure X11 now?"  
  - Answer ```Cancel```
    - If you select OK it will get into a menu loop that I can't get out of.

![dietpi x11 config menu question screenshot](documantation_images/x11-autoconfig.png)

### Startup Options

- Would you like to configure the DiePi-Autostart Option?
  - Answer ```Cancel```
  - We are happy with the default which is boot to LXQt but do not automatically login
  - This is a security measure

![dietpi autostart config menu question screenshot](documantation_images/dietpi-startup-setup.png)

## Open Dockge
  
Once this installation is done Dockge will be available at:

http://hostname:5001

Open it and set a secure password.  

## Reboot 

Reboot the machine to activate the graphic drivers.

Then move onto [Post Installation Configuration directions](Configuration.md).
