function add_app() {
    show_header

    echo -e "Usuarios del sistema web: \n " 
        cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
        echo -e "\n -- FIN DE LA LISTA -- \n \n"
    
    read -p "Indicar el usuario sobre el que se desea listar las aplicaciones instaladas: " usuario_a_listar_apps
    
    check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w ${usuario_a_listar_apps})
    if [[ ${check_usuario_existe} != ${usuario_a_listar_apps} ]]; then

        echo "El usuario indicado no existe" 
        read "Volver al menú..."
        menu
    else
        app_list tabla ${usuario_a_listar_apps}
        apps_instaladas=$?
    fi

    echo -e "\n ¿Qué aplicación desea instalar?\n     1. Instalar WordPress\n     2. Instalar PrestaShop"
    read -p " Indique aplicación a instalar [1/2]: " app_a_instalar
    
    if [[ ${apps_instaladas:1:1} = 1 ]] && [[ ${app_a_instalar} = 1 ]]; then
        echo -e "\n\033[1mERROR:\033[0m WordPress ya está instalada para el usuario ${usuario_a_listar_apps}"
        read -p "Pulse cualquier tecla para volver al menú..." trash
        menu
    fi

    if [[ ${apps_instaladas:0:1} = 1 ]] && [[ ${app_a_instalar} = 2 ]]; then
        echo -e "\n\033[1mERROR:\033[0m PrestaShop ya está instalada para el usuario ${usuario_a_listar_apps}"
        read -p "Pulse cualquier tecla para volver al menú..." trash
        menu
    fi

    if [[ ${app_a_instalar} = 1 ]]; then
        password_generada=$(openssl rand -base64 12)
        crear_wp ${usuario_a_listar_apps} ${password_generada}
        config_wp ${usuario_a_listar_apps} ${password_generada}
        
        cf_updater ${usuario_a_listar_apps} blog

        cert_creation "blog.${usuario_a_listar_apps}"
        
        destination="/root/app_list/${usuario_a_listar_apps}"
        if [[ ${apps_instaladas:1:1} = 1 ]]; then # PS ya está instalado
            echo "111" > ${destination}
        else # WP no instalado
            echo "011" > ${destination}
        fi

        read -p "Indique el correo electrónico del cliente: " correo_cliente
        mail_regex="^[a-zA-Z0-9_-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,12}$"
        until [[ ${correo_cliente} =~ ${mail_regex} ]];
        do
            echo -e "\e[5mERROR\e[0m: correo no válido.\n"
            read -p "Indique el correo electrónico del cliente: " correo_cliente
        done
        envio_email ${usuario_nuevo} not_applicable ${correo_cliente} 3 blog
        
        echo "Se ha instalado correctamente la aplicación WordPress para el usuario ${usuario_a_listar_apps}"
        read -p "Pulse cualquier tecla para continuar" caca
        menu
    fi

    if [[ ${app_a_instalar} = 2 ]]; then
        install_prestashop ${usuario_a_listar_apps}

        destination="/root/app_list/${usuario_a_listar_apps}"
        if [[ ${apps_instaladas:1:1} = 1 ]]; then # WP ya está instalado
            echo "111" > ${destination}
        else # WP no instalado
            echo "101" > ${destination}
        fi
    fi

    if [[ ${app_a_instalar} != 1 ]] || [[ ${app_a_instalar} != 1 ]]; then 
        echo -e "\n\033[1mERROR:\033[0m Opción no válida"
        read -p "Pulse cualquier tecla para volver al menú..." trash
        menu
    fi


}