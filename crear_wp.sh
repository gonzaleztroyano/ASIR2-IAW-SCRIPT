## NOTA: EL CONTENIDO DE ESTE ARCHIVO ES TEMPORAL y NO VÁLIDO:

#!/bin/bash

echo "Venga, colega. ¡Vamos alla!"
echo ""
echo "=============================="
echo "||       Actualizando       ||"
echo "||   Paquetes disponibles   ||"
echo "||        desde APT         ||"
echo "=============================="

apt update

## Instalar Apache y UFW
sudo apt -y install apache2 ufw

## Permitir Apache
sudo ufw allow in "Apache Full"

## Paquetes necesarios
apt install -y php libapache2-mod-php php-mysql php-cli mariadb-server mariadb-client php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

## Recargar apache
sudo systemctl restart apache2

######## MARIADB ###########
mysql -u root -p

CREATE DATABASE miprimerwp;
CREATE USER 'pepi'@localhost IDENTIFIED BY 'usuario';
GRANT ALL ON miprimerwp.* TO 'pepi'@'localhost' IDENTIFIED BY 'usuario';
 
;

echo -e "<VirtualHost *:80> \n ServerAdmin webmaster@localhost \n ServerName wp.iaw.com \n DocumentRoot /var/www/wordpress/ \n ErrorLog /var/log/apache2/wp.iaw.com \n CustomLog /var/log/c-wp.iaw.com combined \n </VirtualHost> \n" > /etc/apache2/sites-available/wp.conf

a2enmod rewrite
a2ensite wp.conf
sudo systemctl restart apache2

wget https://wordpress.org/latest.tar.gz

tar xvzf latest.tar.gz

mv wordpress/ /var/www/wordpress
chmod -R 770 /var/www/wordpress

chown -R www-data:www-data /var/www/wordpress