function menu() {
        clear
        echo ""
        echo ""
cat << "EOF" 


    _____  _____ _____  _____ _____ _______   _____  ______    _____ ______  _____ _______ _____ ____  _   _  
   / ____|/ ____|  __ \|_   _|  __ \__   __| |  __ \|  ____|  / ____|  ____|/ ____|__   __|_   _/ __ \| \ | | 
  | (___ | |    | |__) | | | | |__) | | |    | |  | | |__    | |  __| |__  | (___    | |    | || |  | |  \| | 
   \___ \| |    |  _  /  | | |  ___/  | |    | |  | |  __|   | | |_ |  __|  \___ \   | |    | || |  | | . ` | 
   ____) | |____| | \ \ _| |_| |      | |    | |__| | |____  | |__| | |____ ____) |  | |   _| || |__| | |\  | 
  |_____/ \_____|_|  \_\_____|_|      |_|    |_____/|______|  \_____|______|_____/   |_|  |_____\____/|_| \_| 
                                                                                                             
                                      CC BY 2.5 Pablo González
                        https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT                                                                                

                                   
EOF

        echo ""
        echo ""
        echo "  1. Listar usuarias"
        echo "  2. Crear usuarios"
        echo "  3. Borrar usuarias"
        echo "  4. Modificar usuarios"
        echo "  5. Salir del programa"
        echo ""
        read -p "     Opción seleccionada: " seleccionada

        if [[ $seleccionada = 1 ]]; then
                listar
            elif [[ $seleccionada = 2 ]]; then
                crear_usuario
            elif [[ $seleccionada = 3 ]]; then
                borrar
            elif [[ $seleccionada = 4 ]]; then
                modificar
            elif [[ $seleccionada = 5 ]]; then
                echo ""
                exit
            else
                echo "Opción no válida"
                menu
        fi
}
function borrar (){
        echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n \n"   
        read -p "¿Qué usuario desea borrar? " usuario_a_borrar
        check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w $usuario_a_borrar)
        if [[ $check_usuario_existe != "$usuario_a_borrar" ]]; then
            echo "El usuario indicado no existe" 
            read -p "Pulse cualquier tecla para volver al menú inicial " caca
            return 1
        else    
            usermod -L $usuario_a_borrar        
            at now + 30 days "userdel $usuario_a_borrar"        
            a2dissite $usuario_a_borrar.conf
            a2dissite wp_$usuario_a_borrar.conf
            mysql -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM $usuario_a_borrar;"
            systemctl reload apache2
            echo "rm -Rf /var/www/$usuario_a_borrar" | at now + 30 days
            echo "mysql -e 'DROP DATABASE IF EXISTS wp_$usuario_a_borrar;'" | at now + 30 days
            echo "mysql -e 'DROP USER IF EXISTS $usuario_a_borrar;'" | at now + 30 days
            echo "$usuario_a_borrar, sus sitios y accesos hasn sido deshabilitados correctamente"
            echo "$usuario_a_borrar y sus sitios han sido programados para eliminación en 30 días."
            read -p "Pulse intro para volver al menú" caca
        return 0
    fi
}
function config_wp(){
        db_name=wp_$1
        db_user=$1
        db_pw=$2
        cp /var/www/$1/blog/wp-config-sample.php /var/www/$1/blog/wp-config.php
        chown $1:$1 /var/www/$1/blog/wp-config.php
            sed -i "s/database_name_here/$db_name/g" "/var/www/$1/blog/wp-config.php"
            sed -i "s/username_here/$1/g" "/var/www/$1/blog/wp-config.php"
            sed -i "s/password_here/$2/g" "/var/www/$1/blog/wp-config.php"           
}
function crear_apache() {
        wget -O /etc/apache2/sites-available/$1.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-DOCS/main/misc/virtualhost.txt
        sed -i "s/USER-TO-CHANGE/$1/g" "/etc/apache2/sites-available/$1.conf"  
        touch /var/www/$1/web/index.html
        printf "Bienvenido al sitio del usuario $1" > /var/www/$1/web/index.html    
        a2ensite $1.conf >> /dev/null
        systemctl reload apache2
        printf "ChrootDirectory /var/www/$1" >> /etc/ssh/sshd_config.d/$1.conf
}
function crear_usuario(){
        read -p "Introduce el usuario a crear: " usuario_nuevo
        usuario_nuevo=${usuario_nuevo,,}
        echo -e "\e[5mAtención \e[0m: Se va a proceder a crear el usuario \e[1m$usuario_nuevo\e[0m"
        read -p "¿Es correcta la información? [s/n]: " crear_apache_correct_user
        if [[ $crear_apache_correct_user = "n" ]]; then
            echo -e "¡Recibido! \n Volviendo al menú. " 
            return 0
        fi
        egrep "^$usuario_nuevo" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
            echo "$crear_apache_correct_user exists!"
            echo ""
            read -p "pulse cualquier tecla para continuar" caca
            return 1
        fi
        echo -e "Creando usuario:  \e[1m$usuario_nuevo\e[0m"
        mkdir -p /var/www/$usuario_nuevo/{blog,web,ficheros}
        mkdir -p /var/www/$usuario_nuevo/ficheros/logs
        password_generada=$(openssl rand -base64 12)
        useradd -M -U --home /var/www/$usuario_nuevo --shell /bin/bash  $usuario_nuevo
        printf "$usuario_nuevo:$password_generada" | chpasswd
        echo "Usuario " $usuario_nuevo " creado"
        echo "===============ANOTE================"
        echo "||         LA CONTRASEÑA          ||"
        echo "||                                ||"
        echo "||                                ||"
        echo "||      $password_generada          ||"
        echo "||                                ||"
        echo "||                                ||"
        echo "===================================="
        chmod 755 /var/www/$usuario_nuevo/
        chown -R $usuario_nuevo:$usuario_nuevo /var/www/$usuario_nuevo/
        chown root:root /var/www/$usuario_nuevo/
        chmod -R 770 /var/www/$usuario_nuevo/*
        read -p "Pulse cualquier tecla para continuar " caca     
        crear_apache $usuario_nuevo
        crear_wp $usuario_nuevo $password_generada
        config_wp $usuario_nuevo $password_generada
        read -p "Indique el correo electrónico del cliente: " correo_cliente
        envio_email $usuario_nuevo $password_generada $correo_cliente
        echo "El usuario $usuario_nuevo se ha creado correctamente. "
        read -rsp "Pulse cualquier tecla para continuar  " -n 1
        menu
}
function crear_wp(){
        mysql -e "CREATE DATABASE wp_$1;"
        mysql -e "CREATE USER '$1'@localhost IDENTIFIED BY '$2';"
        mysql -e "GRANT ALL ON wp_$1.* TO '$1'@'localhost' IDENTIFIED BY '$2';"    
        echo -e "<VirtualHost *:80> \n   ServerAdmin $1@localhost \n   ServerName blog.$1.iaw.com \n   DocumentRoot /var/www/$1/blog \n   ErrorLog /var/www/$1/ficheros/logs/blog.$1.iaw.com \n   CustomLog /var/www/$1/ficheros/logs/blog.$1.iaw.com-access combined \n   AssignUserID $1 $1  \n</VirtualHost> \n" > /etc/apache2/sites-available/wp_$1.conf
        a2ensite wp_$1.conf >> /dev/null
        sudo systemctl restart apache2
        curl https://wordpress.org/latest.tar.gz --output /tmp/latest.tar.gz
        mkdir /tmp/wordpress
        tar xzf /tmp/latest.tar.gz -C /tmp/wordpress    
        mv /tmp/wordpress/wordpress/* /var/www/$1/blog/
        chmod -R 770 /var/www/$1/blog
        chown -R $1:$1 /var/www/$1/blog
        rm -Rf /tmp/wordpress
        rm /tmp/latest.tar.gz
}
function envio_email() {
    printf "\n
        ESTIMADO CLIENTE: \n
        \n
        Gracias por confiar en nosotros para su almacenamiento premium.

        A continuación le detallamos sus detalles de acceso:

        Usuario: $1
        Contraseña: $2

        Sus dominios son los siguientes:

        Página web: $1.iaw.com
        Blog: blog.$1.iaw.com
        
    "  | mail -s "BIENVENIDX" $3    
}
function listar () {
    salir=0
    while [ $salir != 1 ]
    do
        echo ""
        read -p "¿Desea buscar algún nombre de usuario en concreto? [s/N]: " buscar_usuario_filtro
        if [ $buscar_usuario_filtro = "s" ]; then
            read -p "Introduzca el término a buscar: " buscar_usuario_filtro_termino
            echo -e "Estos son los usuarios que coinciden con el término indicado: \n " 
            cat /etc/passwd | grep '/var/www' | grep $buscar_usuario_filtro_termino | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1
        else
            echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1
        fi
    done
    read -p "Pulse cualquier tecla para volver al menú." caca
    menu
}
function modificar(){
        echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n \n"
        read -p "¿Qué usuario deseas modificar? " usuario_a_modificar
        check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w $usuario_a_modificar)
        if [[ $check_usuario_existe != $usuario_a_modificar ]]; then
            echo "El usuario indicado no existe" 
            menu
        else
            read -p "Introduce una nueva contraseña para el usuario $usuario_a_modificar: " password_nueva_1
            read -p "Introduce de nuevo la contraseña para el usuario $usuario_a_modificar: " password_nueva_2        
            if [[ $password_nueva_1 = $password_nueva_2 ]]; then
                    printf "$usuario_a_modificar:$password_nueva_1"  | chpasswd
                    echo "¡Contraseña actualizada!"
                    read -p "Pulse cualquier tecla para continuar" caca
                    menu
            else
                echo "\e[5mERROR \e[0m: las contraseñas no coinciden"
                menu
            fi
        fi
}   

menu