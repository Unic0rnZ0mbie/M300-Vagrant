#!/bin/bash
#
#	Datenbank installieren und Konfigurieren
#

#DEBUG ON
			set -o xtrace
			sudo apt-get update 
			sudo apt-get -y install debconf-utils
			# root Password setzen, damit kein Dialog erscheint und die Installation haengt!
			sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
			sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
			
			# Installation
			
			sudo apt-get -y install ufw
			#SSH port 22 für host Ip erlauben
			sudo ufw allow from 10.71.13.160 to any port 22
			#Port 3306 für MySQL für den Webserver öffnen
			sudo ufw allow from 192.168.2.100 to any port 3306
			sudo ufw allow from 192.168.2.101 to any port 3306
			
			#mysql-server installieren
			sudo apt-get -y install mysql-server 
			sudo apt-get -y install mysql-client
			
			# MySQL Port oeffnen
			sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
			
			# User für Remote Zugriff erlauben aber nur für den Webserver 192.168.2.100
			mysql -uroot -padmin <<%EOF%
				CREATE USER 'admin01'@'192.168.2.100' IDENTIFIED BY '1234';
				GRANT ALL PRIVILEGES ON *.* TO 'admin01'@'192.168.2.100';
%EOF%
			mysql -uroot -padmin <<%EOF%
				CREATE USER 'admin02'@'192.168.2.101' IDENTIFIED BY '1234';
				GRANT ALL PRIVILEGES ON *.* TO 'admin02'@'192.168.2.101';
%EOF%
			
			# Restart fuer Konfigurationsaenderung
			sudo service mysql restart
			
			# Test ob MySQL Server laueft - ansonsten Abbruch!!!
			curl -f http://localhost:3306 >/dev/null 2>&1 && { echo "MySQL up"; } || { echo "Error: MySQL down"; exit 1; }