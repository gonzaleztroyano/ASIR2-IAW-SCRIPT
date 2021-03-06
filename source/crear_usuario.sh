function crear_usuario(){
    # Pido nombre de usuario. Paso a minúsculas. Reconfirmo
        read -p "Introduce el usuario a crear: " usuario_nuevo
        usuario_nuevo=${usuario_nuevo,,}
        echo -e "\e[5mAtención \e[0m: Se va a proceder a crear el usuario \e[1m${usuario_nuevo}\e[0m"
        read -p "¿Es correcta la información? [s/n]: " crear_apache_correct_user

    # Si no es correcto, salgo. Si existe, salgo
        if [[ ${crear_apache_correct_user} = "n" ]]; then
            echo -e "¡Recibido! \n Volviendo al menú. " 
            menu
        fi

        egrep "^${usuario_nuevo}" /etc/passwd >/dev/null
        if [ ${?} -eq 0 ]; then
            echo "${usuario_nuevo} exists!"
            echo ""
            read -p "pulse cualquier tecla para continuar" caca
            menu
        fi
    # Crear carpetas
        echo -e "Creando usuario:  \e[1m${usuario_nuevo}\e[0m"
        mkdir -p /var/www/${usuario_nuevo}/{blog,web,ficheros}
        mkdir -p /var/www/${usuario_nuevo}/ficheros/logs
    # Genero las contraseñas y añado el usuario. Muestro la contraseña
        password_generada=$(openssl rand -base64 12)

        useradd -M -U --home /var/www/${usuario_nuevo} --shell /bin/bash  ${usuario_nuevo}
        printf "${usuario_nuevo}:${password_generada}" | chpasswd

        echo "Usuario " ${usuario_nuevo} " creado"
        # echo "===============ANOTE================"
        # echo "||         LA CONTRASEÑA          ||"
        # echo "||                                ||"
        # echo "||                                ||"
        # echo "||      ${password_generada}          ||"
        # echo "||                                ||"
        # echo "||                                ||"
        # echo "===================================="

    # Modificar permisos y ownership
        chmod 755 /var/www/${usuario_nuevo}/
        chown -R ${usuario_nuevo}:${usuario_nuevo} /var/www/${usuario_nuevo}/
        chown root:root /var/www/${usuario_nuevo}/
        chmod -R 770 /var/www/${usuario_nuevo}/*

    # Pausa de confirmación
        read -p "Pulse cualquier tecla para continuar " caca 
    
    # Llamar a funciones extrañas
        crear_apache ${usuario_nuevo}
        #crear_wp ${usuario_nuevo} ${password_generada}
        #config_wp ${usuario_nuevo} ${password_generada}
        cf_updater ${usuario_nuevo}

        # Hasta que no se introduzca un email correcto, no se continúa con la ejecución.
        read -p "Indique el correo electrónico del cliente: " correo_cliente
        mail_regex="^[a-zA-Z0-9_-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,12}$"
        until [[ ${correo_cliente} =~ ${mail_regex} ]];
        do
            echo -e "\e[5mERROR\e[0m: correo no válido.\n"
            read -p "Indique el correo electrónico del cliente: " correo_cliente
        done

        envio_email ${usuario_nuevo} ${password_generada} ${correo_cliente} 1

        cert_creation ${usuario_nuevo}

    # Guardar contraseña por si fuera necesario.
        # No se utiliza por el momento
        #    save_passwd ${usuario_nuevo} ${password_generada}
    
    # Guardar el inventario de los recursos
        destination="/root/app_list/${usuario_nuevo}"

       echo "001" > ${destination}

    # Confirmación y menú
        echo -e "\nEl usuario ${usuario_nuevo} y sus sitios web se ha creado correctamente. "
        read -rsp "Pulse cualquier tecla para continuar  " -n 1
        systemctl reload ssh
        menu
}