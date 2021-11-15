function envio_email() {

    #############################################################
    #############################################################
    #####                 VARIABLES DE SMTP                 #####
    #############################################################
    #        envio_email_smtp="smtp-relay.sendinblue.com:587"
    #        envio_email_user="sendinblue@glez.tk"
    #        envio_email_passwd=""
    #####
    #####

    printf "root=postmaster
mailhub=smtp-relay.sendinblue.com:587
hostname=server.glez.tk
AuthUser=sendinblue@glez.tk
AuthPass=xsmtpsib-ed27e85602d3a23556a2dbe0b9e8aee899eeb99db1b3a5e677967080eba378a5-0ZNDpHB1g4bOxtk3
FromLineOverride=YES
UseSTARTTLS=YES" > /etc/ssmtp/ssmtp.conf


    printf "\n
        ESTIMADO CLIENTE: \n
        
        Gracias por confiar en nosotros, bla bla bla. 

        A continuación de detallamos los detalles:

        Usuario: $usuario_nuevo
        Contraseña: $password_generada
    "  | mail -s "BIENVENIDX" pablo@glez.tk


}

#sudo dpkg-reconfigure postfix
#!/bin/bash

function listar() {

    salir=0

    while [ $salir != 1 ]
    do
        read -p "¿Desea buscar algún nombre de usuario en concreto? [s/n]: " buscar_usuario_filtro

        if [ $buscar_usuario_filtro = "s" ]; then

            read -p "Introduzca el término a buscar: " buscar_usuario_filtro_termino
            echo -e "Estos son los usuarios que coinciden con el término indicado: \n " 
            cat /etc/passwd | grep '/var/www' | grep $buscar_usuario_filtro_termino | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1

        elif [ $buscar_usuario_filtro = "n" ]; then
            echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1
        else 
            echo "Opción no válida. Inténtelo de nuevo."
        fi
    done
}
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

rmdir -F /tmp/wordpressfunction crear_apache() {

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
function menu() {

    while [ $select -gt 5 ]; do
        echo "1. Listar usuarias"
        echo "2. Crear usuarios"
        echo "3. Borrar usuarias"
        echo "4. Modificar usuarios"
        echo "5. Salir del programa"

        read -p "Opción seleccionada:" seleccionada

        if [[ $seleccionada = 1 ]]; then
            listar
        elif [[ $seleccionada = 2 ]]; then
            crear_apache
        elif [[ $seleccionada = 3 ]]; then
            borrar
        elif [[ $seleccionada = 4 ]]; then
            modificar
        elif [[ $seleccionada = 5 ]]; then
            exit
        else
            echo "Opción no válida"
    done
}

menu
