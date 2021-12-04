function crear_apache() {
    # Notas del fichero
        # VARS: Recibe $usuario_nuevo ($1)

    # Creación del sitio de Apache
        wget -qO /etc/apache2/sites-available/$1.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/templates%20and%20misc/virtualhost.txt
        sed -i "s/USER-TO-CHANGE/$1/g" "/etc/apache2/sites-available/$1.conf"
        sed -i "s/GLOBAL-BASE-DOMAIN/$global_base_domain/g" "/etc/apache2/sites-available/$1.conf"
        
        
    # Añadir página html para el sitio
        touch /var/www/$1/web/index.html
        printf "Bienvenido al sitio del usuario $1" > /var/www/$1/web/index.html
    
    #Activar el sitio
        a2ensite $1.conf >> /dev/null
        systemctl reload apache2

    # Configuración ChrootDirectory y SSH
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak
        touch /temp/sshd_config
        sed -r "s/^(Match User marcador.*$)/\1,${usuario1}/g" "/etc/ssh/sshd_config" > /temp/sshd_config

        mv /temp/sshd_config /etc/ssh/sshd_config
}
