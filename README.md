# BrowserShack

This is a a collection of contarized tools to make a browser based FT-8/Digital focused remote setup with a very lightweght web based launcher to tie them all together.

It goes one step further and focuses on radios that have video output and keyboard/mouse input to control the radio via an simple IP KVM.  Such as a Yaesu FT-710. This elimates complex web interface for controlling the radio and keeps it simple: use the radio like you were in front of it. Natively.

This package includes:

* Custom Lightweight web-launcher for all the tools -- so you don't have to remmber the port numbers for each docker container
* Hamlib server container for all other control / logging apps to bind to -- other applications don't even have to be running on this machine
* Dockge Web-Based Docker Manager -- to edit customs settings and monitor each tools docker container
* Open IP KVM - Lightweight and no security updated ip kvm that now uses ustreamer and CH9329 UART module for mouse/keyboard control (Option: https://www.aliexpress.us/item/3256807460786666.html?spm=a2g0o.order_list.order_list_main.5.7fb91802YVei7O&gatewayAdapt=glo2usa)
* Wavelog - Fully featured web-based logging application
* Custom DigiPanel running WSJT-X, GridTracker2, and JS8Call via an xpra session accessible via a webpage

All this and more! Well all this and if you want to add anything you can.

One of the biggest reasons for me to consolidate these feeatures is to keep all the audio routing for FT-8, etc local to the server. There is no reason to bring the audio to another computer to process it and then route the outbound audio back.  It only adds additional overhead that isn't needed. A secondary reason is then all the audio routing virtual cables can stay in place and my main computer, tablet, or phone doesn't have to change audio settings each session of FT-8 or ham radio after watching a youtube video or even at the same time.

In the future I may bring another tool over which would allow voice audio via web browser so the same server could be used for phone.  But that isn't a priority for me at the moment.

To Install:

Install DietPi

Run the following command to download the setup script, make it executible, and run it.  The script will take care of the rest of the basic setup.  

https://github.com/hamMUSings/BroswerShack/blob/43bf27c700be6b85ef80eb6dc19a405705a7c5f1/install.sh

If you need to change settings such as what serial port or video capture card to use you can do so in Dockge and change the docker-compose.yaml file settings where most of these exist.
 







 