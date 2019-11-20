#!/bin/bash

# update apt repository
sudo apt update

# update tools
sudo apt install -y git make nodejs npm libavahi-compat-libdnssd-dev pigpio

# install library to initiate shutdown
git clone https://github.com/adafruit/Adafruit-GPIO-Halt
cd Adafruit-GPIO-Halt/
make
sudo make install
sed '/^exit 0/i /usr/local/bin/gpio-halt 21 &' /etc/rc.local

# install npm packages
sudo npm install -g --unsafe perm homebridge
sudo npm install -g homebridge-opc
sudo npm install -g rpio --unsafe-perm=true --allow-root
sudo npm install -g homebridge-gpio-rgb-ledstrip --unsafe-perm=true --allow-root

# create the homebridge config
mkdir ~/.homebridge
cat <<EOF >> ~/.homebridge/config.json
{
  "bridge": {
    "name": "HomebridgePi",
    "username": "CD:23:3D:A3:BF:32",
    "port": 51827,
    "pin": "194-29-542"
  },
  
  "description": "RaspberryPi Homebridge",
  "ports": {
    "start": 52100,
    "end": 52150,
    "comment": "This section is used to control the range of ports that separate accessory (like camera or television) should be bind to."
   },

   "accessories": [
    {
      "accessory": "SmartLedStrip",
      "name": "Theater Lights",
      "rPin": 22,
      "gPin": 24,
      "bPin": 17
    }] 
}
EOF
