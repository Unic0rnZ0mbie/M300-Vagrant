#!/bin/bash
#
#	Datenbank installieren und Konfigurieren
#
# Debug ON!!!
			set -o xtrace	
			sudo apt-get update
			sudo apt-get -y install ufw
			sudo ufw -y enable
			sudo ufw allow http
			#SSH port 22 für host Ip erlauben
			sudo ufw allow from 10.71.13.160 to any port 22
			
			#Reverse Proxy installieren
			sudo apt-get -y install libxml2-dev
			sudo apt-get -y install apache2
			#Reverse Proxy module unter Apache aktivieren
			sudo a2enmod proxy
			sudo a2enmod proxy_html
			sudo a2enmod proxy_http
			sudo a2enmod proxy_balancer
			sudo a2enmod status
			sudo a2enmod rewrite
			sudo a2enmod lbmethod_byrequests
			
			sudo service apache2 restart
			
			sudo mkdir /var/www/balancer-manager
			
						
			cp /vagrant/001-default.conf /etc/apache2/sites-available/
			sudo a2ensite 001-default.conf
			sudo service apache2 restart 
			
			# Test ob Apache Server laueft - ansonsten Abbruch!!!
			curl -f http://localhost >/dev/null 2>&1 && { echo "Apache up"; } || { echo "Error: Apache down"; exit 1; }
			echo '127.0.0.1 localhost m300-proxy' >> /etc/hosts
			echo '192.168.2.200 m300-db' >> /etc/hosts
			echo '192.168.2.100 m300-web01' >> /etc/hosts
			echo '192.168.2.101 m300-web02' >> /etc/hosts