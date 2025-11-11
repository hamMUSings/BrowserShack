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

unistall="false"

# Logic for arguments sent to the script
while getopts u: flag
do
    case "${flag}" in
        #u) uninstall=${OPTARG};;
		u) uninstall="true";;
    esac
done

if [ $unistall == "false" ]; then
	echo "One the next two DietPi menu screens set your hostname & enable your audio (you do not need to select an audio device)"
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
	cp -r ./dockge_stacks/* /opt/stacks /mnt/dietpi_userdata/dockge/stacks
	# -------- Copy website lauincher files & set hostname --------
	cp -r ./web_launcher/* /mnt/dietpi_userdata/busyboxhttpd

	# --- set hostname ---
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/index.html
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/handmic.html
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/audioplayer.html
	

	# -------- Install Dockge --------
	# Create directories that store your stacks and stores Dockge's stack
	#mkdir -p /opt/dockge
	cd /mnt/dietpi_userdata/dockge

	# Download the compose.yaml
	#curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml
	curl "https://dockge.kuma.pet/compose.yaml?port=5001&stacksPath=/mnt/dietpi_userdata/dockge/stacks" --output compose.yaml

	# Start the server
	docker compose up -d

elif [ "uninstall" == "true" ]; then
	#Uninstall goes here

fi
# TO DO
# docker hamlib build first
# radio on / off / ssupend
# sed for links
# Uninstall script

 

