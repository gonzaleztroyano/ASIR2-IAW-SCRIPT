function app_list() {
    # Modo "silent":
        # No muestra header
        # Pide usuario, comprueba
        # Retorna valor binario
    # Modo "bonito"
        # Muestra header
        # Pide usuario, comprueba
        # Muestra tablita
    # Modo "tabla"
        # No muestra header
        # Pide usuario, comprueba
        # Muestra tablita. 
        # Retorna valor binario 
    # VARS:
        # $1: mode: "silent" or "bonito" or "tabla"
        # $2: user: id usuario ya comprobado

    if [[ $1 = "bonito" ]]; then
        show_header
    fi

    if [[ ${#} = 1 ]]; then
        # Listar usuarios
            echo -e "Usuarios del sistema web: \n " 
                cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
                echo -e "\n -- FIN DE LA LISTA -- \n \n"
        
        # Pedir usuario a modificar
            read -p "Indicar el usuario sobre el que se desea listar las aplicaciones instaladas: " usuario_a_listar_apps
        
        # Comprobar si el usuario existe
    fi
    if [[ ${#} = 2 ]]; then
        usuario_a_listar_apps=${2}
    fi
        check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w ${usuario_a_listar_apps})
        if [[ ${check_usuario_existe} != ${usuario_a_listar_apps} ]]; then

            echo "El usuario indicado no existe" 
            read "Volver al menú..."
            menu
        else
        # Si existe, actuar:
            bin_apps=$(cat /root/app_list/${usuario_a_listar_apps})
            
            if [[ $1 = "silent" ]]; then
                return "${bin_apps}"
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
                elif [[ ${bin_apps:1:1} = 1 ]]; then
                    has_wp="✅"
                else
                    has_wp="?"
            fi

            if [[ ${bin_apps:2:1} = 0 ]]; then  
                has_ss="❌"
                elif [[ ${bin_apps:2:1} = 1 ]]; then
                    has_ss="✅"
                else
                    has_ss="?"
            fi

            if [[ $1 = "bonito" ]] || [[ $1 = "tabla" ]]; then

                show_header
                echo -e "   Para el usuario:    ${usuario_a_listar_apps}\n"
                echo "|==================================================|"
                echo "|                       ||                         |"
                echo "|     Sitio estático    ||           ${has_ss}            |"
                echo "|                       ||                         |"
                echo "|==================================================|"
                echo "|                       ||                         |"
                echo "|     Sitio WordPress   ||           ${has_wp}            |"
                echo "|                       ||                         |"
                echo "|==================================================|"
                echo "|                       ||                         |"
                echo "|    Sitio PrestaShop   ||           ${has_ps}            |"
                echo "|                       ||                         |"
                echo "|==================================================|"
                echo ""
                if [[ ${1} = "tabla" ]]; then
                    return "${bin_apps}"
                fi
            echo -e "\n \n Volver al menú..."
            read
            menu
            fi
        fi
}