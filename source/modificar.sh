function modificar(){

    # Notas del fichero
        # 
    
    # Listar usuarios

        echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n \n"
    
    # Pedir usuario a modificar

        read -p "¿Qué usuario deseas modificar? " usuario_a_modificar
    
    # Comprobar si el usuario existe

        check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w $usuario_a_modificar)

        if [[ $check_usuario_existe != $usuario_a_modificar ]]; then

            echo "El usuario indicado no existe" 
            menu
        else
        
    # Si existe, actuar:
        # Pedir contraseña nueva, dos veces por seguridad
            read -p "Introduce una nueva contraseña para el usuario $usuario_a_modificar: " password_nueva_1
            read -p "Introduce de nuevo la contraseña para el usuario $usuario_a_modificar: " password_nueva_2
        
        # Comparar contraseñas
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
        #TODO: #39 Enviar correo con la contraseña cambiada.
    menu
}   