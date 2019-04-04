#!/bin/bash
#
#	Datenbank installieren und Konfigurieren
#
# Debug ON!!!
			set -o xtrace	
			sudo apt-get update
			sudo apt-get -y install ufw
			sudo ufw -y enable
			#SSH port 22 für host Ip erlauben
			sudo ufw allow from 10.71.13.160 to any port 22
			
			
			#DB schnittstelle installieren
			sudo apt-get -y install debconf-utils apache2 nmap
			sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
			sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
			sudo apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client  
			
			# Admininer SQL UI 
			sudo mkdir /usr/share/adminer
			sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
			sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
			echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
			sudo a2enconf adminer.conf 
		
			
			sudo service apache2 restart 
			# Test ob Apache Server laueft - ansonsten Abbruch!!!
			curl -f http://localhost >/dev/null 2>&1 && { echo "Apache up"; } || { echo "Error: Apache down"; exit 1; }
			echo '127.0.0.1 localhost m300-web02' >> /etc/hosts
			echo '192.168.2.200 m300-db' >> /etc/hosts
			echo '192.168.2.100 m300-web01' >> /etc/hosts
			echo '192.168.2.50 m300-proxy' >> /etc/hosts