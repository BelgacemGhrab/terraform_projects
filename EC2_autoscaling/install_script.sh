#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo echo "<h3 align='center'> Hello World from : Hostname $(hostname -f) </h3>" > /var/www/html/index.html
sudo apt install stress -y