#!/bin/bash

set -e

# Create a dedicated directory
mkdir -p /home/ubuntu/minecraft
cd /home/ubuntu/minecraft

# Download and extract Java 21
wget https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.1%2B12/OpenJDK21U-jre_x64_linux_hotspot_21.0.1_12.tar.gz
tar -xzf OpenJDK21U-jre_x64_linux_hotspot_21.0.1_12.tar.gz
mv jdk-21.0.1+12-jre java

# Download Minecraft server
wget -q https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar

# Accept the EULA
echo "eula=true" > /home/ubuntu/minecraft/eula.txt

# Create systemd service
sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/home/ubuntu/minecraft
ExecStart=/home/ubuntu/minecraft/java/bin/java -Xmx1G -Xms1G -jar server.jar nogui
Restart=on-failure
User=ubuntu

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft
