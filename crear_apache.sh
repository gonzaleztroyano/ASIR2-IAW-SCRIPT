function crear_apache() {

    read -p "Introduce el usuario a crear: " usuario_nuevo

    usuario_nuevo=${usuario_nuevo,,}
    echo -e "\e[5mAtención \e[0m: Se va a proceder a crear el usuario \e[1m$usuario_nuevo\e[0m"

    read -p "¿Es correcta la información? [s/n]: " crear_apache_correct_user

    if [[ $crear_apache_correct_user = "n" ]]; then
        echo -e "¡Recibido! \n Volviendo al menú. " 
        menu
    fi

    egrep "^$crear_apache_correct_user" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$crear_apache_correct_user exists!"
    fi
    echo -e "Creando usuario:  \e[1m$usuario_nuevo\e[0m"
    mkdir -p /var/www/$usuario_nuevo/ficheros/logs
       mkdir /var/www/$usuario_nuevo/web
       mkdir /var/www/$usuario_nuevo/blog

    password_generada=$(openssl rand -base64 12)
    password_hasheada=$(perl -e'print crypt($password_generada, "aa")')

    # TODO: #2 que no pida introducir la contraseña, confirmación ni datos adicionales
    useradd -M --home /var/www/$usuario_nuevo --shell /bin/false -p $password_hasheada $usuario_nuevo
    chmod 755 /var/www/$usuario_nuevo/
    chown -R $usuario_nuevo:$usuario_nuevo /var/www/$usuario_nuevo/
    chown root:root /var/www/$usuario_nuevo/
    chmod -R 770 /var/www/$usuario_nuevo/*


    echo "Usuario " + $usuario_nuevo + " creado"
    echo "===============ANOTE================"
    echo "||         LA CONTRASEÑA          ||"
    echo "||                                ||"
    echo "||                                ||"
    echo "||  $password_generada              ||"
    echo "||                                ||"
    echo "||                                ||"
    echo "===================================="

    chmod 755 /var/www/$usuario_nuevo/
    chown -R $usuario_nuevo:$usuario_nuevo /var/www/$usuario_nuevo/
    chown root:root /var/www/$usuario_nuevo/
    chmod -R 770 /var/www/$usuario_nuevo/*


        #Creación del sitio de Apache
        wget -O /etc/apache2/sites-available/$usuario_nuevo.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-DOCS/main/misc/virtualhost.txt
        sed -i "s/USER-TO-CHANGE/$usuario_nuevo/g" "/etc/apache2/sites-available/$usuario_nuevo.conf"
        
        # Añadir página html para el sitio

        printf "Bienvenido al sitio del usuario $usuario_nuevo" > /var/www/$usuario_nuevo/web/index.html

        #TODO: COMPROBAR si dentro del sed se pueden usar variables.
        a2ensite $usuario_nuevo.conf
        systemctl reload apache2

    #Configuración ChrootDirectory

        printf "ChrootDirectory /var/www/$usuario_nuevo" >> /etc/ssh/sshd_config.d/$usuario_nuevo.conf

    ## AQUÍ LLAMAR A crear_wp

}
