#  Dokumentation LB1

# K1 / 2

## Persönlicher Stand
Bis anhin habe ich noch nie mit Vagrant oder einer ähnlich Provisionierungs-Software gearbeitet, sprich ist diese Umgebung neu für mich. 
Sowohl habe ich noch nie mit der Github Umgebung gearbeitet. Jedoch arbeiten wir in unserem Betrieb noch oft mit dem Git Bash Client für Windows, also konnte ich immerhin da schon einiges an Vorwissen mitbringen. Auch bezüglich Linux konnte ich schon einiges an Erfahrungen sammeln, was mir die Arbeit erleichterte. Wir arbeiten im Betrieb mehr oder weniger ausschliesslich mit Unix basierten Servern.
Bezüglich Virtualisierung habe ich bereits ein mehr oder weniger breites Vorwissen. 
Zum Thema Sicherheit sieht es dann aber schon wieder nicht so glänzend aus, speziell mit Reverse Proxys habe ich absolut keine Vorkenntnisse.

### PLE Einrichten

## Git bash

1. Git bash herunterladen 
2. Git bash installieren

## Github Account erstellen
***
1. Auf www.github.com ein Benutzerkonto erstellen (Angabe von Username, E-Mail und Passwort)
2. E-Mail zur Verifizierung des Kontos bestätigen und anschliessend auf GitHub anmelden
3.  Mit Git bash SSH Key erstellen
$ ssh-keygen -t rsa -b 4096 -C "laurent.zuerrer@edu.tbz.ch"
4. SSH Key dem GitHub Konto hinzufügen

### Repository erstellen
***
1. Anmelden unter www.github.com 
2. Innerhalb der Willkommens-Seite auf <strong>Start a project</strong> klicken
3. Unter <strong>Repository name</strong> einen Name definieren (z.B. M300-Services)
4. Optional: kurze Beschreibung eingeben
5. Radio-Button bei <strong>Public</strong> belassen
6. Haken bei <strong>Initialize this repository with a README</strong> setzen
7. Auf <strong>Create repository</strong> klicken

### Repository klonen

$ In gewünschtes Verzeichnis wechseln
$ git clone https://github.com/mc-b/M300      #Repository klonen
$ git status zeigt den aktuellen synchronisationsstatus des Repos

## Virtualbox

1. Virtualbox herunterladen
2. Virtualbox installieren

## Visual Studio Code

1. Visual Studio Code herunterladen
2. Visual Studio Code installieren
3. Extensions installieren
4. Einstellungen anpassen

# K3 Vagrant

## Vagrant Befehle

Hier sind die wichtigsten Vagrant Befehle aufgelistet:

| Befehl           |Beschreibung                                                                             |
| -----------------|:---------------------------------------------------------------------------------------:|
| Vagrant init     |Initialisiert die Vagrant Umgebung im aktuellen Verzeichnis und erstellt ein Vagrantfile |
| Vagrant up       |Erzeugt und Konfiguriert eine Virtuelle Maschine basierend auf dem Vagrantfile           |
| Vagrant ssh      |Verbindung zur VM per SSH wird hergestellt                                               | 
| Vagrant status   |Zeigt den aktuellen Status der VM an                                                     | 
| Vagrant port     |Zeigt die Weitergeleiteten Ports der VM an                                               | 
| Vagrant halt     |VM wird gestoppt                                                                         | 
| Vagrant destroy  |VM wird gestoppt und gelöscht                                                            |  
| Vagrant box add  |Vagrant Box wird heruntergeladen                                                         | 

## VM mit Vagrant erstellen

1. cd Wohin\auch\immer
2. mkdir vagrant VM
3. mit Vagrant box add ubuntu/xenial64
4. vagrant init ubuntu/xenial64
5. vagrant up --provider virtualbox
6. danach kann per vagrant ssh auf die VM zugegrifen werden

## Vagrant Umgebung

### Übersicht 

    +---------------------------------------------------------------+
    ! Notebook - Schulnetz 10.x.x.x und Privates Netz 192.168.2.100 !                 
    ! Port: 8080 (192.158.2.100:80)                                 !	
    !                                                               !	
    !    +--------------------+          +---------------------+    !
    !    ! Web Server         !          ! Datenbank Server    !    !       
    !    ! Host: m330-web     !          ! Host: m300-db       !    !
    !    ! IP: 192.168.2.100  ! <------> ! IP: 192.168.2.200   !    !
    !    ! Port: 80           !          ! Port 3306           !    !
    !    ! Nat: 8080          !          ! Nat: -              !    !
    !    +--------------------+          +---------------------+    !
    !                                                               !	
    +---------------------------------------------------------------+
### Beschreibung

* Web Server mit Apache und MySQL UserInterface [Adminer](https://www.adminer.org/)
* Datenbank Server mit MySQL

* Die Verbindung Web - Datenbank erfolgt mittels Internen Netzwerk Adapter.
* Von Aussen ist nur der HTTP Port auf dem Web Server Erreichbar.
Um in die VM zu wechseln ist zusätzlich der in Vagrantfile definierte Name einzugeben.

	vagrant ssh database
	vagrant ssh web

Das MySQL User Interface ist via [http://localhost:8080/adminer.php](http://localhost:8080/adminer.php)

## Erste Schritte und Grundkonfiguration VM

Als erstes habe ich mit:
    
    vagrant add box ubuntu/xenial64

eine vorgefertigte Vagrant box installiert, was einfach das Betreibssystem ist.
Danach habe ich mich auf Github und im Web über die Konfigurations-möglichkeiten in einem Vagrantfile informiert. Als nächstes habe ich per:

    vagrant init ubuntu/xenial64

ein Vagrantfile erstellt welches ich bearbeitet habe.

## VM Provisioning

Die Grundkonfiguration kann ohne SHELL Befehle durchgeführt werden. Nicht jedoch die Softwareinstallation und Konfiguration in der VM selbst.
Dafür gibt es wei möglichkeiten; entweder wird das ganze in einem shell-script definiert und dieses als provisioning Argument mit gegeben:

    db.vm.provision "shell", path: "db.sh"

oder inline direkt im Vagrantfile:

    web.vm.provision "shell", inline: <<-SHELL
    SHELL

Ich habe beides verwendet, da ich beide Vorgehensweise kennenlernen wollte.

## Tests

Ich habe mit Vagrant up das Vagrantfile ausgeführt und so beide VM aufgesetzt. Als test habe ich im Webbrowser folgenden Pfad angegeben: 
 [http://localhost:8080/adminer.php](http://localhost:8080/adminer.php)
Ich habe alles korrekt konfiguriert, denn das login Fenster der Datenbank erscheint und ich kann mich mit admin/1234 anmelden.

# K4 Sicherheit

## Firewall Rules Webserver

Als erstes wird die ufw - uncomplicated Firewall installiert und aktiviert:

    sudo apt-get install ufw
    sudo ufw enable

Da ich auf dem Webserver per "web.vm.network" schon das Port forwarding eingerichtet habe, gibt es nur noch die Firewall regelt bezüglich des SSH zugriffs durch Port 22 zu erlauben.

    sudo ufw allow from 10.71.13.73 to any port 22

Wobei die IP-Adresse der Host-IP entspricht

## Firewall Rules Datenbank

Wieder wird die ufw installiert. Jedoch habe ich hier kein Port forwarding eingerichtet, da ich vom Host-System nicht auf die Datenbank zugreifen will. Sondern nur der Webserver benötigt zugriff, dies wird über folgende Regel definiert:

    sudo ufw allow from 192.168.2.100 to any port 3306

Wobei die IP-Adresse der des Webservers entspricht.

Wieder wird eine Regel hinzugefügt, dass lediglich das Host-System per port 22 und SSH auf die VM zugreifen kann.

    sudo ufw allow from 10.71.13.73 to any port 22

## Reverse Proxy

Zuerst werden folgende Module auf dem Webserver installiert:

    $ sudo apt-get install libapache2-mod-proxy-html
    $ sudo apt-get install libxml2-dev

Danach aktiviert:

    $ sudo a2enmod proxy
    $ sudo a2enmod proxy_html
    $ sudo a2enmod proxy_http

Die Datei /etc/apache2/apache2.conf wie folgt ergänzen:

    ServerName localhost 

Apache-Webserver neu starten:

    $ sudo service apache2 restart

Konfiguration
Die Weiterleitungen sind z.B. in sites-enabled/001-reverseproxy.conf eingetragen:

    # Allgemeine Proxy Einstellungen
    ProxyRequests Off
    <Proxy *>
        Order deny,allow
        Allow from all
    </Proxy>

    # Weiterleitungen master
    ProxyPass /master http://master
    ProxyPassReverse /master http://master

Hierbei entspricht /master dem File/Pfad welcher eingegeben werden muss und danach folgt der Webserver welcher damit erreicht wird.
Unter ReverseProxyPass wird dann erneut der Pfad angegeben und der eigentliche Webserver welcher angesprochen werden sollte.


# K5

## Vergelich Vorwissen - Wissenszuwahs

### Vorwissen

Ich hatte noch keine Kenntnisse über Vagrant und seine Funktionenen. Ich habe auch noch nie mit Github gearbeitet

### Wissenszuwachs

Ich weiss nun wie ich mit Vagrant und einem Vagrant File auf einen Schlag eine multi-VM Umgebung einrichten kann. Ich weiss nun auch wie ich innerhalb des Vagrantfile's, Shell Befehle an die VM weitergeben kann und so Packages in der VM selbst installieren und konfigurieren kann. Durch das kenne ich nun natürlich auch sämtliche Befehle unter Vagrant.

Zu Github habe ich vorallem gelernt wie ich ein Dokumt mit Markdown verfassen und formatieren kann. Weiter habe ich gelernt wie ich einen lokalen SSH-Key generieren kann und diesen in einem anderen Programm/Dienst hinterlegen kann.

## Reflexion

Ich muss ehrlich sein, am Anfang hatte ich überhaupt keine Motivation mich in dieses Thema gross zu vertiefen, dies lag vor allem an meiner persönlcihe Einstellung. Jeoch habe ich den "rank" gefunden und mich aufgreaft mich in dieses Theam einzuarbeiten. Ich habe festgestellt, dass diese Umgebung sehr einfach zu nutzen ist und es gibt extrem viele Projekte schon Online. Ich habe nun auch eine riesige Freude, dass ich eine Multi-VM Umgebung einrichten konnte. 
