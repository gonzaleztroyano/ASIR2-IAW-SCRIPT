function crear_apache() {
    # Creación del sitio de Apache
        wget -O /etc/apache2/sites-available/$1.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-DOCS/main/misc/virtualhost.txt
        sed -i "s/USER-TO-CHANGE/$1/g" "/etc/apache2/sites-available/$1.conf"
        
    # Añadir página html para el sitio
        printf "Bienvenido al sitio del usuario $1" > /var/www/$1/web/index.html

        #TODO: COMPROBAR si dentro del sed se pueden usar variables.
        a2ensite $1.conf
        systemctl reload apache2

    # Configuración ChrootDirectory
        printf "ChrootDirectory /var/www/$1" >> /etc/ssh/sshd_config.d/$1.conf

}
