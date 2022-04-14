function crear_wp(){
    # Notas del fichero
        # VARS: Recibe $usuario_nuevo ($1) y $password_generada ($2) 
        # Lee de ".basrc" $global_base_domain
        # TODO: Poder crear solo un WP 
        # TODO: Acceso remoto a la base de datos
        # TODO: PHPMyAdmin
        # CHECK: chown de los datos de WP. ¿www-data o user?

    # Crear usuario, base de datos, permisos
        mysql -e "CREATE DATABASE wp_$1;"
        mysql -e "CREATE USER '$1'@localhost IDENTIFIED BY '$2';"
        mysql -e "GRANT ALL PRIVILEGES ON wp_$1.* TO '$1'@'localhost';"
    
    #Logging files: touch, link and permissions

        touch /var/log/apache2/blog.$1.$global_base_domain.log
        touch /var/log/apache2/blog.$1.$global_base_domain-access.log

        chmod 644 /var/log/apache2/blog.$1.$global_base_domain.log
        chmod 644 /var/log/apache2/blog.$1.$global_base_domain-access.log

        ln /var/log/apache2/blog.$1.$global_base_domain.log /var/www/$1/ficheros/logs/blog.$1.$global_base_domain.log
        ln /var/log/apache2/blog.$1.$global_base_domain-access.log /var/www/$1/ficheros/logs/blog.$1.$global_base_domain-access.log

    # Crear Virtualhost y activar sitio

        wget -qO /etc/apache2/sites-available/wp_$1.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/templates%20and%20misc/wp_virtualhost
        sed -i "s/USER-TO-CHANGE/$1/g" "/etc/apache2/sites-available/wp_$1.conf"
        sed -i "s/GLOBAL-BASE-DOMAIN/$global_base_domain/g" "/etc/apache2/sites-available/wp_$1.conf"

        # activar el sitio rewrite
        a2ensite wp_$1.conf >> /dev/null
        sudo systemctl restart apache2

    # Descargar WP y extraer a tmp
        if [[ ! -f /tmp/latest.tar.gz ]]; then
            curl https://wordpress.org/latest.tar.gz --output /tmp/latest.tar.gz
            if [[  ! -d /tmp/wordpress ]]; then
                mkdir /tmp/wordpress &> /dev/null 
                tar xzf /tmp/latest.tar.gz -C /tmp/wordpress            
            fi
        fi
    # Mover archivos y configurar permisos. Limiar temporales
        cp /tmp/wordpress/wordpress/* /var/www/$1/blog/
        chmod -R 770 /var/www/$1/blog
        chown -R $1:$1 /var/www/$1/blog
        rm -Rf /tmp/wordpress
        rm /tmp/latest.tar.gz
}