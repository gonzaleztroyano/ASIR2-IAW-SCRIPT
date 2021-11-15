function crear_wp(){
#!/bin/bash
    # Notas del fichero
        # TODO: Poder crear solo un WP 
        # TODO: Acceso remoto a la base de datos
        # TODO: PHPMyAdmin

    # Crear usuario, base de datos, permisos
        mysql -e "CREATE DATABASE wp_$1;"
        mysql -e "CREATE USER '$1'@localhost IDENTIFIED BY '$2';"

        mysql -e "GRANT ALL ON wp_$1.* TO '$1'@'localhost' IDENTIFIED BY '$2';"
    
    # Crear Virtualhost y activar sitio

        echo -e "<VirtualHost *:80> \n ServerAdmin $1@localhost \n ServerName blog.$1.iaw.com \n DocumentRoot /var/www/$1/blog \n ErrorLog /var/www/$1/ficheros/logs/blog.$1.iaw.com \n CustomLog //var/www/$1/ficheros/logs/blog.$1.iaw.com-access combined \n </VirtualHost> \n" > /etc/apache2/sites-available/wp_$1.conf
        
        # a2enmod rewrite
        a2ensite wp_$1.conf
        sudo systemctl restart apache2

    # Descargar WP y extraer a tmp
        curl https://wordpress.org/latest.tar.gz --output /tmp/latest.tar.gz
        mkdir /tmp/wordpress
        tar xzf /tmp/latest.tar.gz -C /tmp/wordpress
    
    # Mover archivos y configurar permisos. Limiar temporales
        mv /tmp/wordpress/wordpress/* /var/www/$1/blog/
        chmod -R 770 /var/www/$1/blog
        chown -R www-data:www-data /var/www/$1/blog
        rm -Rf /tmp/wordpress
        rm /tmp/latest.tar.gz
}