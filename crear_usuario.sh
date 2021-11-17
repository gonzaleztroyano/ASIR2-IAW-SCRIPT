function crear_usuario(){
    # Pido nombre de usuario. Paso a minúsculas. Reconfirmo
        read -p "Introduce el usuario a crear: " usuario_nuevo
        usuario_nuevo=${usuario_nuevo,,}
        echo -e "\e[5mAtención \e[0m: Se va a proceder a crear el usuario \e[1m$usuario_nuevo\e[0m"
        read -p "¿Es correcta la información? [s/n]: " crear_apache_correct_user

    # Si no es correcto, salgo. Si existe, salgo
        if [[ $crear_apache_correct_user = "n" ]]; then
            echo -e "¡Recibido! \n Volviendo al menú. " 
            return [n]
        fi

        egrep "^$crear_apache_correct_user" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
            echo "$crear_apache_correct_user exists!"
            echo ""
            read -p "pulse cualquier tecla para continuar" caca
            return [n]
        fi
    # Crear carpetas
        echo -e "Creando usuario:  \e[1m$usuario_nuevo\e[0m"
        mkdir -p /var/www/$usuario_nuevo/ficheros/logs
        mkdir /var/www/$usuario_nuevo/web
        mkdir /var/www/$usuario_nuevo/blog


    # Genero las contraseñas y añado el usuario. Muestro la contraseña
        password_generada=$(openssl rand -base64 12)
        password_hasheada=$(perl -e'print crypt($password_generada, "aa")')

        useradd -M --home /var/www/$usuario_nuevo --shell /bin/bash -p $password_hasheada $usuario_nuevo

        echo "Usuario " + $usuario_nuevo + " creado"
        echo "===============ANOTE================"
        echo "||         LA CONTRASEÑA          ||"
        echo "||                                ||"
        echo "||                                ||"
        echo "||  $password_generada              ||"
        echo "||                                ||"
        echo "||                                ||"
        echo "===================================="

    # Modificar permisos y ownership
        chmod 755 /var/www/$usuario_nuevo/
        chown -R $usuario_nuevo:$usuario_nuevo /var/www/$usuario_nuevo/
        chown root:root /var/www/$usuario_nuevo/
        chmod -R 770 /var/www/$usuario_nuevo/*


    


    # Pausa de confirmación
        read "Pulse cualquier tecla para continuar"
    
    # Llamar a funciones extrañas
        crear_apache($usuario_nuevo)
        crear_wp($usuario_nuevo $password_generada)
        config_wp($usuario_nuevo $password_generada)

        read -p "Indique el correo electrónico del cliente: " correo_cliente
        envio_email($usuario_nuevo $password_generada $correo_cliente)

}