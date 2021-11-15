## NOTA: EL CONTENIDO DE ESTE ARCHIVO ES TEMPORAL y NO VÁLIDO:

#!/bin/bash

# TODO: Poder crear solo un WP 
# TODO: Acceso remoto a la base de datos
# TODO: PHPMyAdmin

mysql -e "CREATE DATABASE wp_$usuario_nuevo;"
mysql -e "CREATE USER '$usuario_nuevo'@localhost IDENTIFIED BY '$password_generada';"

mysql -e "GRANT ALL ON wp_$usuario_nuevo.* TO '$usuario_nuevo'@'localhost' IDENTIFIED BY '$password_generada';"
 

echo -e "<VirtualHost *:80> \n ServerAdmin $usuario_nuevo@localhost \n ServerName blog.$usuario_nuevo.iaw.com \n DocumentRoot /var/www/$usuario_nuevo/blog \n ErrorLog /var/www/$usuario_nuevo/ficheros/logs/blog.$usuario_nuevo.iaw.com \n CustomLog //var/www/$usuario_nuevo/ficheros/logs/blog.$usuario_nuevo.iaw.com-access combined \n </VirtualHost> \n" > /etc/apache2/sites-available/wp_$usuario_nuevo.conf

# a2enmod rewrite
a2ensite wp_$usuario_nuevo.conf
sudo systemctl restart apache2

curl https://wordpress.org/latest.tar.gz --output /tmp/latest.tar.gz

mkdir /tmp/wordpress
tar xvzf /tmp/latest.tar.gz -C /tmp/wordpress

mv /tmp/wordpress/* /var/www/$usuario_nuevo/blog/
chmod -R 770 /var/www/$usuario_nuevo/blog

chown -R www-data:www-data /var/www/$usuario_nuevo/blog

rmdir -F /tmp/wordpress