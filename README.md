# BrowserShack Summary

This is a a collection of containerized tools to make a browser based FT-8/Digital focused remote setup with a very lightweight web based launcher to tie them all together.

It goes one step further and focuses on radios that have video output and keyboard/mouse input to control the radio via an simple IP KVM.  Such as a Yaesu FT-710. This eliminates complex web interface for controlling the radio and keeps it simple: use the radio like you were in front of it. Natively.

> [!NOTE]
> Designed and best used for digital modes 

> [!NOTE]
> Designed and best used for radios with video out and mouse input in -- eg Yaesu FT-710

This package includes:

* Custom Lightweight web-launcher for all the tools -- so you don't have to remember the port numbers for each docker container plus a little extra
* Hamlib server container for all other control / logging apps to bind to -- other applications don't even have to be running on this machine
* Dockge Web-Based Docker Manager -- to edit customs settings and monitor each tools docker container
* Open IP KVM - Lightweight and no security updated ip kvm that now uses ustreamer and CH9329 UART module for mouse/keyboard control ([Option]( https://www.aliexpress.us/item/3256807460786666.html?spm=a2g0o.order_list.order_list_main.5.7fb91802YVei7O&gatewayAdapt=glo2usa))
* Wavelog - Fully featured web-based logging application
* Custom DigiPanel running WSJT-X, GridTracker2, and JS8Call via an xpra session accessible via a web page
* Custom WebRTC Handmic application: Mic to the radio with PTT and bare-bones controls: Mode (USB,LSB, FM) and Frequency change
  * Includes custom websocketd server to interface handmic webpage with rigctl/rigctld
  * Audio output from the radio is included on the home page: Two Way Audio!

All this and more! Well all this and if you want to add anything you can.

## Primary Impetus for BrowserShack
One of the biggest reasons for me to consolidate these features is to keep all the audio routing for FT-8, etc local to the server. There is no reason to bring the audio to another computer to process it and then route the outbound audio back.  It only adds additional overhead that isn't needed. A secondary reason is then all the audio routing virtual cables can stay in place and my main computer, tablet, or phone doesn't have to change audio settings each session of FT-8 or ham radio after watching a youtube video or even at the same time.

## Design Goals
* Digital First 
  * Many other remote radio products focus on phone/voice as the primary mode and digital as an add on
* Web-Based Entirely
* X86-64 Native 
  * I love my Raspberry Pi/ARM machines and I ran out of horse power while running GridTracker when I got a better radio
  * More processing power for decode
  * Cost of a low power but more powerful than ARM mini-computers is very close to the cost of a Raspberry Pi 
  * Technically all the docker containers can be rebuilt for ARM with docker build I just haven't
* Docker
  * Build all parts in docker containers
  * This is a more modern approach to virtualization at the moment
  * Allows users to pick and choice which 'application' or role is important to them and easily reduce resources used with a simple start/stop of docker container
* IP-KVM Focused
  * By focusing on radios that made video out and mouse input in the web front end can be greatly simplified
  * Users can use the same UI to their radio on the computer so learning curve is less
  * One Stop learning curve -- Can easily sit down in front of the radio and the controls learned transfer
* Open Source and Free
* Build on Diet-Pi
  * Allows many hardware options to easily be supported
  * Allows easy core applications install with pre-configured optimization
  * Can be 'ported' to ARM easily and the install script will still work
  * Allows use of built in utilities:
    * Alsa config
	* Hostname setting
	* Backups
	* User data migration to a different drive / folder
* KISS Web Front end
  * Easier and simpler to build
  * Easier and simpler to maintain / contribute to the project
    * Some projects have a steep initial learning curve to contribute back or fork the goal here was to keep things as simple and straightforward as possible to allow easy initial access to modifying or contributing 
	* This includes using docker images / compose from projects that offer them already
* Phone / Voice option with WebRTC Audio routing
  * Simpler PTT web page primarily with a few other convenient options
  * Majority of controls via IP-KVM
  * WebRTC allows browser based audio in and out so no separate applications are needed
* LAN focus
  * Low security was acceptable for ease of building. As such not intended to be exposed to the internet directly
  * Remote radio work from anywhere in the house not anywhere in the world
  * Allows radio to be mounted in a less viewed area and still easily used

# Installation
 
# First Run Setup / Config

# Developer Notes

See this page for notes on forking, editing, and contributing.






 