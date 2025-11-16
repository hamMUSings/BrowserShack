#!/bin/bash
# Install banner -- nothing but decorative
echo ""
echo " ██████  ██████   ██████  ██     ██ ███████ ███████ ██████  ███████ ██   ██  █████   ██████ ██   ██"
echo " ██   ██ ██   ██ ██    ██ ██     ██ ██      ██      ██   ██ ██      ██   ██ ██   ██ ██      ██  ██ "
echo " ██████  ██████  ██    ██ ██  █  ██ ███████ █████   ██████  ███████ ███████ ███████ ██      █████  "
echo " ██   ██ ██   ██ ██    ██ ██ ███ ██      ██ ██      ██   ██      ██ ██   ██ ██   ██ ██      ██  ██ "
echo " ██████  ██   ██  ██████   ███ ███  ███████ ███████ ██   ██ ███████ ██   ██ ██   ██  ██████ ██   ██"
echo "                        -... .-. --- .-- ... . .-. ... .... .- -.-. -.-"
echo "                                                                       Alpha v0.5633305 10/25"
echo ""

uninstall="false"

# Logic for arguments sent to the script
while getopts u flag
do
    case "${flag}" in
        u) uninstall="true";;
    esac
done

# ---------------------------------- Install Script Switch ----------------------------------
if [ $uninstall == "false" ]; then
 
	echo "On the next two DietPi menu screens set your hostname & enable your audio (you do not need to select an audio device)"
	read -p "Press enter to continue"
	echo ""

	# -------- Set Hostname and Enable Audio via DietPi Menus --------
	/boot/dietpi/dietpi-config 5
	/boot/dietpi/dietpi-config 14

	echo ""
	echo ""
	echo "Sit back, hop on a 2m net or work some DX but get comfy as the setup & installs may take a bit of time depending on your system speed..."
	echo ""
	read -p "Press enter to continue"
	echo ""
	echo "Transmitting...."

	# -------- Install apps that are available via DietPi --------
	/boot/dietpi/dietpi-software install 162 # Docker
	/boot/dietpi/dietpi-software install 134 # Docker Compose
	/boot/dietpi/dietpi-software install 17  # Git
	/boot/dietpi/dietpi-software install 152 # Avahi-Daemon --- to register the hostname with DNS

	HOST_VAR=(hostname)
	
	# -------- Create docker backbone network --------
	docker network create --driver bridge --subnet 10.10.0.0/16 --ip-range 10.10.5.0/24 --gateway 10.10.5.254 browsershack-backend
	
	# -------- Create stacks folder for Dockge --------
	#mkdir /opt/stacks 
	mkdir -p /mnt/dietpi_userdata/dockge/stacks

	# -------- Create  folder for weblauncher --------
	mkdir /mnt/dietpi_userdata/busyboxhttpd

	mkdir /mnt/dietpi_userdata/browsershack-setup
	cd /mnt/dietpi_userdata/browsershack-setup

	# -------- Clone Browsershack project files  --------
	git clone -b dev https://github.com/hamMUSings/BrowserShack.git
	cd BrowserShack


	# -------- Copy docker-compose files for Dockge  --------
	#cp -r ./dockge_stacks/* /opt/stacks
	cp -r ./dockge_stacks/* /mnt/dietpi_userdata/dockge/stacks
	# -------- Copy website lauincher files & set hostname --------
	cp -r ./web_launcher/* /mnt/dietpi_userdata/busyboxhttpd

	# -------- set hostname --------
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/index.html
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/handmic.html
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/audioplayer.html
	
	# ------- set MariaDB password so unique for each installation --------
	MARIADB_PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
    sed -i "s/CHANGEME!/$MARIADB_PW/g" /mnt/dietpi_userdata/dockge/stacks/wavelog/compose.yaml

	# -------- Install Dockge --------
	# Create directories that store your stacks and stores Dockge's stack
	#mkdir -p /opt/dockge
	cd /mnt/dietpi_userdata/dockge

	# Download the compose.yaml
	#curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml
	curl "https://dockge.kuma.pet/compose.yaml?port=5001&stacksPath=/mnt/dietpi_userdata/dockge/stacks" --output compose.yaml

	# Start the server
	docker compose up -d
	
	# enable the config portion of the script
	config="true"

# ---------------------------------- Uninstall Script Switch ----------------------------------
elif [ $uninstall == "true" ]; then
        #Uninstall goes here
        echo "uninstall"
fi

        echo "config"
			# -------- Enumerate serial port options in a very round about way for the menu items --------
	ls /dev/ttyU* /dev/ttyS* | grep tty > ttyoptions.txt                         # ls gets the devices, grep makes them into rows, write them to a text file (round about)
	readarray -t options < ttyoptions.txt                                        # reads text file into an array for the menu choice
	rm ttyoptions.txt

	# -------- Enumerate USB Video options in a very round about way for the menu items --------
	ls /dev/video* | grep video > uvcoptions.txt			                     # ls gets the devices, grep makes them into rows, write them to a text file (round about)
	readarray -t uvcoptions < uvcoptions.txt                                     # reads text file into an array for the menu choice
	rm uvcoptions.txt

	# -------- User inputs to select serial & video ports to use in conf files --------
	echo ""
	echo "Please select the serial port to use for HAMLIB Radio Control:"
	echo ""
	PS3="Please enter your choice: "
	select option in "${options[@]}"; do
		 if [[ "$option" == "" ]];                                               # if the return value is empty ask again as a proper answer will return the path of the port
		 then
			echo "Invalid option"
		 else
			hamlibser=$option                                                    # sets the variable with the answer and exits the loop
			break
		 fi
	done
	
	sed -i "s/\\/dev\\/HAMLIBSER/$hamlibser/g" /mnt/dietpi_userdata/dockge/stacks/control_stack/compose.yaml
	
	# next
	echo ""
	echo "Please select the serial port to use for IP-KVM / Mouse Control:"
	echo ""
	PS3="Please enter your choice: "
	select option in "${options[@]}"; do
		 if [[ "$option" == "" ]];
		 then
			echo "Invalid option"
			is_always_execute=false;
		 else
			ipkvmser=$option
			break
		 fi
	done
	sed -i "s/\\/dev\\/IPKVMSER/$ipkvmser/g" /mnt/dietpi_userdata/dockge/stacks/control_stack/compose.yaml

	# next
	echo ""
	echo "Please select the USB video device to use for IP-KVM streaming:"
	echo ""
	PS3="Please enter your choice: "
	select option in "${uvcoptions[@]}"; do
		 if [[ "$option" == "" ]];                                               
		 then
			echo "Invalid option"
		 else
			uvcdev=$option	                                                     
			break
		 fi
	done
	sed -i "s/\\/dev\\/IPKVMVIDEO/$uvcdev/g" /mnt/dietpi_userdata/dockge/stacks/control_stack/compose.yaml

 

