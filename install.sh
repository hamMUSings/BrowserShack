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

echo "One the next two DietPi menu screens set your hostname, enable your audio, and select the audio card to use"
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
/boot/dietpi/dietpi-software install 17 # Git
/boot/dietpi/dietpi-software install 152 # Avahi-Daemon --- to register the hostname with DNS

HOST_VAR=$hostname

# -------- Create stacks folder for Dockge --------
mkdir /opt/stacks 

# -------- Create  folder for weblauncher --------
mkdir /mnt/dietpi_userdata/busyboxhttpd

mkdir browsershack-setup
cd browsershack-setup

# -------- Clone Browsershack project files  --------
git clone -b dev https://github.com/hamMUSings/BrowserShack.git
cd BrowserShack


# -------- Copy docker-compose files for Dockge  --------
cp -r ./dockge_stacks/* /opt/stacks
# -------- Copy website lauincher files & set hostname --------
cp -r ./web_launcher/* /mnt/dietpi_userdata/busyboxhttpd

# --- set hostname ---
sed -i "s/AVAHI-HOST/$HOST_VAR/g" /mnt/dietpi_userdata/busyboxhttpd/index.html	

# -------- Install Dockge --------
# Create directories that store your stacks and stores Dockge's stack
mkdir -p /opt/dockge
cd /opt/dockge

# Download the compose.yaml
curl https://raw.githubusercontent.com/louislam/dockge/master/compose.yaml --output compose.yaml

# Start the server
docker compose up -d

 

