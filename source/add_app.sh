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
        echo -e "\033[1mERROR:\033[0m WordPress ya está instalada para el usuario"
        read "Pulse cualquier tecla para volver al menú..."
        menu
    fi

    if [[ ${apps_instaladas:0:1} = 1 ]] && [[ ${app_a_instalar} = 2 ]]; then
        echo -e "\033[1mERROR:\033[0m PrestaShop ya está instalada para el usuario"
        read "Pulse cualquier tecla para volver al menú..."
        menu
    fi

    if [[ $app_a_instalar = 1 ]]; then
        password_generada=$(openssl rand -base64 12)
        crear_wp $usuario_a_listar_apps $password_generada
        config_wp $usuario_a_listar_apps $password_generada

        echo "Se ha instalado correctamente la aplicación WordPress para el usuario ${usuario_a_listar_apps}"
        menu
    fi


}