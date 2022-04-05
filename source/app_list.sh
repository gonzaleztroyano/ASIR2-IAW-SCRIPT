function app_list() {
    # Modo "silent":
        # No muestra header
        # Pide usuario, comprueba
        #Retorna valor binario
    # Modo "bonito"
        # Muestra header
        # Pide usuario, comprueba
        # Muestra tablita
    # VARS:
        # $1: mode: "silent" or "bonito"

    if [[ $1 = "bonito" ]]; then
        show_header
    fi

    # Listar usuarios
        echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n \n"
    
    # Pedir usuario a modificar
        read -p "Indicar el usuario sobre el que se desea listar las aplicaciones instaladas: " usuario_a_listar_apps
    
    # Comprobar si el usuario existe
        check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w ${usuario_a_listar_apps})
        if [[ ${check_usuario_existe} != ${usuario_a_listar_apps} ]]; then

            echo "El usuario indicado no existe" 
            read "Volver al menú..."
            menu
        else
        # Si existe, actuar:
            bin_apps=$(cat /root/app_list/${usuario_a_listar_apps})
            
            if [[ $1 = "silent" ]]; then
                return ${bin_apps}
            fi

            if [[ ${bin_apps:0:1} = 0 ]]; then  
                has_ps="❌"
                elif [[ ${bin_apps:0:1} = 1 ]]; then
                    has_ps="✅"
                else
                    has_ps="?"
            fi

            if [[ ${bin_apps:1:1} = 0 ]]; then  
                has_wp="❌"
                elif [[ ${bin_apps:0:1} = 1 ]]; then
                    has_wp="✅"
                else
                    has_wp="?"
            fi

            if [[ ${bin_apps:2:1} = 0 ]]; then  
                has_ss="❌"
                elif [[ ${bin_apps:0:1} = 1 ]]; then
                    has_ss="✅"
                else
                    has_ss="?"
            fi

            if [[ $1 = "bonito" ]]; then

                show_header
                echo -e "   Para el usuario:    ${usuario_a_listar_apps}\n"
                echo "|==================================================|"
                echo "|                       ||                         |"
                echo "|     Sitio estático    ||         ${has_ss}       |"
                echo "|                       ||                         |"
                echo "|==================================================|"
                echo "|                       ||                         |"
                echo "|     Sitio WordPress   ||         ${has_wp}       |"
                echo "|                       ||                         |"
                echo "|==================================================|"
                echo "|                       ||                         |"
                echo "|    Sitio PrestaShop   ||         ${has_ps}       |"
                echo "|                       ||                         |"
                echo "|==================================================|"
                echo -e "\n \n Volver al menú..."
                read
                menu
            fi
        fi
}