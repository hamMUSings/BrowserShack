# BrowserShack Installation
- Install [DietPi](https://dietpi.com)
  - https://dietpi.com/docs/install/#how-to-install-dietpi-native-pc
  - DietPi .iso Downloads: https://dietpi.com/#download
  - When prompted to install applications skip it
    - DietPi will ask if you want to install an empty system.  Answer yes.

- Run the following command to download the setup script, make it executable, and run it.  The script will take care of the rest of the basic setup.  
  - ```wget https://raw.githubusercontent.com/hamMUSings/BrowserShack/refs/heads/dev/install.sh | sudo chmod +x | sudo bash```
  
If you need to change settings such as what serial port or video capture card to use you can do so in Dockge and change the docker-compose.yaml file settings where most of these exist.