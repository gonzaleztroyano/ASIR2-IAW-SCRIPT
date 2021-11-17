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

        if [[ "cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1 | grep -w $usuario_a_modificar " != $usuario_a_modificar]]; then

            echo "El usuario indicado no existe" 
            return [n]
        else
        fi
    # Si existe, actuar:
        # Pedir contraseña nueva, dos veces por seguridad
            read -p -s "Introduce una nueva contraseña para el usuario $usuario_a_modificar: " password_nueva_1
            read -p -s "Introduce de nuevo la contraseña para el usuario $usuario_a_modificar: " password_nueva_2
        
        # Comparar contraseñas
            if [[ $password_nueva_1 = $password_nueva_2 ]]; then
                    printf "$usuario_a_modificar:$password_nueva_1"  | chpasswd
                    echo "¡Contraseña actualizada!"
                    read -p "Pulse cualquier tecla para continuar" caca
                    return [n]
            else
                echo "\e[5mERROR \e[0m: las contraseñas no coinciden"
                return [n]
            fi
}   