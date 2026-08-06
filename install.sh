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

	# ---------------------------------- Actual Install Start ----------------------------------- 
	echo "On the next two DietPi menu screens set your hostname, enable your audio (you do not need to select an audio device), and select your graphic driver"
	read -p "Press enter to continue"
	echo ""

	# -------- Set Hostname and Enable Audio via DietPi Menus --------
	/boot/dietpi/dietpi-config 5
	/boot/dietpi/dietpi-config 14
	/boot/dietpi/dietpi-config 102

	echo ""
	echo ""
	echo "Sit back, hop on a 2m net or work some DX but get comfy as the setup & installs may take a bit of time depending on your system speed..."
	echo ""
	read -p "Press enter to continue"
	echo ""
	echo "Transmitting...."

	HOST_VAR=(hostname)
	read -p "Enter host hostname: " HOST_VAR
	
	# Get IP for OME input
	HOST_IP=$(hostname -I | awk '{print $1}')

	# -------- Install apps that are available via DietPi --------
	/boot/dietpi/dietpi-software install 162 # Docker
	/boot/dietpi/dietpi-software install 134 # Docker Compose
	/boot/dietpi/dietpi-software install 17  # Git
	/boot/dietpi/dietpi-software install 152 # Avahi-Daemon --- to register the hostname with DNS
	/boot/dietpi/dietpi-software install 173 # LXQt 
	/boot/dietpi/dietpi-software install 29 # XRDP

	# -------- Create docker backbone network --------
	docker network create --driver bridge --subnet 10.10.0.0/16 --ip-range 10.10.5.0/24 --gateway 10.10.5.254 browsershack-backend
	
	# -------- Create stacks folder for Dockge --------
	mkdir -p /mnt/dietpi_userdata/dockge/stacks
	
	# -------- Create stacks folder for websocketd dns quick lookup --------
	mkdir -p /mnt/dietpi_userdata/dockge/hamlib-server-dns

	# -------- Create folder for weblauncher --------
	mkdir /mnt/dietpi_userdata/busyboxhttpd

	# -------- Create folder for wavelog-db --------	
	mkdir -p /mnt/dietpi_userdata/wavelog-db
	
	# -------- Create folder for ome config docker volume --------
	mkdir -p /mnt/dietpi_userdata/docker-data/volumes/voice_stack_ome-origin-conf/_data

	# -------- Create folder for BrowserShack setup files --------	
	mkdir /mnt/dietpi_userdata/browsershack-setup
	cd /mnt/dietpi_userdata/browsershack-setup

	# -------- Clone BrowserShack project files  --------
	git clone -b dev https://github.com/hamMUSings/BrowserShack.git
	cd BrowserShack


	# -------- Copy docker-compose files for Dockge  --------
	#cp -r ./dockge_stacks/* /opt/stacks
	cp -r ./dockge_stacks/* /mnt/dietpi_userdata/dockge/stacks

	# -------- Copy website launcher files & set hostname --------
	cp -r ./web_launcher/* /mnt/dietpi_userdata/busyboxhttpd

	# -------- Copy/Rename AppImages & Menu items --------
	mkdir /mnt/dietpi_userdata/AppImages
	cp ./digipanel-install/AppImages/GridTracker2-2.260723.0-x86_64.AppImage /mnt/dietpi_userdata/AppImages/GridTracker2.AppImage
	cp ./digipanel-install/AppImages/wsjtx-3.0.2-linux-x86_64.AppImage /mnt/dietpi_userdata/AppImages/wsjtx.AppImage 
	cp ./digipanel-install/AppImages/JS8Call-v3.0.3-x86_64.AppImage /mnt/dietpi_userdata/AppImages/JS8Call.AppImage
	chmod +x /mnt/dietpi_userdata/AppImages/*
	cp -r .digipanel-install/menu/* ~/.local/share/applications

	# -------- set hostname --------
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/index.html
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/handmic.html
	sed -i "s/IIPPPPLLAACCEEHHOOLLDDEEERR/$HOST_IP/g" /mnt/dietpi_userdata/busyboxhttpd/handmic.html
	sed -i "s/HHOOSSTTPPLLAACCEEHHOOLLDDEEERR/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/audioplayer.html
	sed -i "s/IIPPPPLLAACCEEHHOOLLDDEEERR/$HOST_IP/g" /mnt/dietpi_userdata/dockge/stacks/guacamole/guac_home/user-mapping.xml

	# -------- Copy Server.xml config files for ome  --------
	cp -r ./ome-config/* /mnt/dietpi_userdata/docker-data/volumes/voice_stack_ome-origin-conf/_data
	
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
	
	# Start stacks that do not need user edits
	cd /mnt/dietpi_userdata/dockge/stacks/wavelog
	docker compose up -d 
	
	cd /mnt/dietpi_userdata/dockge/stacks/browsershack_web_frontend
	docker compose up -d
	
	#cd /mnt/dietpi_userdata/dockge/stacks/digipanel-xpra
	cd /mnt/dietpi_userdata/dockge/stacks/guacamole
	docker compose up -d

	echo "BrowserShack is installed.  Navigate to http://$HOST_VAR:5001 to continue setup..."
# ---------------------------------- Uninstall Script Switch ----------------------------------
elif [ $uninstall == "true" ]; then
		
	# Stop all stacks and remove images, containers, and volumes from that stack

	cd /mnt/dietpi_userdata/dockge/stacks/wavelog
	docker compose down --rmi all -v --remove-orphans
	
	cd /mnt/dietpi_userdata/dockge/stacks/browsershack_web_frontend
	docker compose down --rmi all -v --remove-orphans
	
	cd /mnt/dietpi_userdata/dockge/stacks/guacamole
	docker compose down --rmi all -v --remove-orphans

	cd /mnt/dietpi_userdata/dockge/stacks/control_stack
	docker compose down --rmi all -v --remove-orphans

	cd /mnt/dietpi_userdata/dockge/stacks/voice_stack
	docker compose down --rmi all -v --remove-orphans

	cd /mnt/dietpi_userdata/dockge
	docker compose down --rmi all -v --remove-orphans
	
	# Remove docker network  
	docker network rm browsershack-backend
	
	# Remove Files as installed
	rm -r /mnt/dietpi_userdata/dockge/stacks
	rm -r /mnt/dietpi_userdata/busyboxhttpd
	rm -r /mnt/dietpi_userdata/dockge
	rm -r /mnt/dietpi_userdata/browsershack-setup
	rm -r /mnt/dietpi_userdata/wavelog-db
	rm -r /mnt/dietpi_userdata/AppImages
	rm ~/.local/share/applications/wsjtx.desktop
	rm ~/.local/share/applications/js8call.desktop
	rm ~/.local/share/applications/gridtracker2.desktop
	
	# Uninstall dietpi-software installed
	read -p "Uninstall git? (y/N)" REM_GIT
	read -p "Uninstall avahi (y/N)? " REM_AVAHI
	read -p "Uninstall docker and docker compose? (y/N)" REM_DOCKER
	read -p "Uninstall xrdp? (y/N)" REM_XRDP
	read -p "Uninstall LXQt? (y/N)" REM_LXQT
	
	# Check GIT Answer
	if [ $REM_GIT == "y" ]; then
		/boot/dietpi/dietpi-software uninstall 17  # Git
	else
		echo "Git: NOT REMOVED. Please remove via dietpi-software menu"
	fi
	
	# Check Avahi Answer
	if [ $REM_AVAHI == "y" ]; then
		/boot/dietpi/dietpi-software uninstall 152 # Avahi-Daemon
	else
		echo "Avahi: NOT REMOVED. Please remove via dietpi-software menu"
	fi
	
	# Check Docker and Docker Compose Answer
	if [ $REM_DOCKER == "y" ]; then
		/boot/dietpi/dietpi-software uninstall 162 # Docker
		/boot/dietpi/dietpi-software uninstall 134 # Docker Compose
	else
		echo "Docker and Docker Compose: NOT REMOVED. Please remove via dietpi-software menu"
	fi

	# Check xrdp Answer
	if [ $REM_XRDP == "y" ]; then
		/boot/dietpi/dietpi-software uninstall 29  # xrdp
	else
		echo "XRDP: NOT REMOVED. Please remove via dietpi-software menu"
	fi

	# Check LXQt Answer
	if [ $REM_LXQt == "y" ]; then
		/boot/dietpi/dietpi-software uninstall 173  # LXQt
	else
		echo "LXQt: NOT REMOVED. Please remove via dietpi-software menu"
	fi

    # Uninstall goes here
    echo "Uninstall Complete - You may now delete the install.sh file"
fi




