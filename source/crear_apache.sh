function crear_apache() {
    # Notas del fichero
        # VARS: Recibe ${usuario_nuevo} (${1})

    # Logging 
        touch /var/log/apache2/${1}.${global_base_domain}.log
        touch /var/log/apache2/${1}.${global_base_domain}-access.log

        chmod 644 /var/log/apache2/${1}.${global_base_domain}.log
        chmod 644 /var/log/apache2/${1}.${global_base_domain}-access.log

        ln /var/log/apache2/${1}.${global_base_domain}.log /var/www/${1}/ficheros/logs/${1}.${global_base_domain}.log

        ln /var/log/apache2/${1}.${global_base_domain}-access.log /var/www/${1}/ficheros/logs/${1}.${global_base_domain}-access.log    
    
    
    # Creación del sitio de Apache
        wget -qO /etc/apache2/sites-available/${1}.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/templates%20and%20misc/virtualhost.txt
        sed -i "s/USER-TO-CHANGE/${1}/g" "/etc/apache2/sites-available/${1}.conf"
        sed -i "s/GLOBAL-BASE-DOMAIN/${global_base_domain}/g" "/etc/apache2/sites-available/${1}.conf"
        
        
    # Añadir página html para el sitio
        touch /var/www/${1}/web/index.html
        printf "Bienvenido al sitio del usuario ${1}" > /var/www/${1}/web/index.html
        chown ${1}:${1} /var/www/${1}/web/index.html

    #Activar el sitio
        a2ensite ${1}.conf >> /dev/null
        systemctl reload apache2

    # Configuración ChrootDirectory y SSH
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak
        touch /tmp/sshd_config
        sed -r "s/^(Match User marcador.*$)/\1,${1}/" "/etc/ssh/sshd_config" > /tmp/sshd_config
        mv /tmp/sshd_config /etc/ssh/sshd_config
}
