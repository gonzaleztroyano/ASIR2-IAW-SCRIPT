# Notas del fichero
        # VARS: No incoming data
        # MUST DO:
            # Disable user Linux
                # AT +30d to remove user
            # Disable apache & WP site
                # Remove access WP 
                # AT +30d Delete DB & site data
function borrar (){

    # Listar usuarios
        echo -e "Usuarios del sistema web: \n " 
            grep '/var/www'  < /etc/passwd | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n \n"
   
    # Pedir usuario a modificar
        read -p "¿Qué usuario desea borrar? " usuario_a_borrar

    # Comprobar si el usuario existe
        check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w $usuario_a_borrar)

        if [[ $check_usuario_existe != "$usuario_a_borrar" ]]; then

    # Si el usuario NO existe, error y volver
            echo "El usuario indicado no existe" 
            read -p "Pulse cualquier tecla para volver al menú inicial " caca
            menu
        else
    
    # Si el usuario SÍ existe, proceder:

        # Disable user 
            usermod -L $usuario_a_borrar
        
        # AT +30 remove user
            at now + 30 days "userdel $usuario_a_borrar"
        
        # Disable apache & WP site
            a2dissite $usuario_a_borrar.conf >/dev/null
            a2dissite wp_$usuario_a_borrar.conf >/dev/null
            mysql -e "REVOKE ALL PRIVILEGES ON wp_$usuario_a_borrar.* FROM $usuario_a_borrar;"
            systemctl reload apache2
        # AT +30d Delete DB & site data
            echo "rm -Rf /var/www/$usuario_a_borrar" | at now + 30 days
            echo "mysql -e 'DROP DATABASE IF EXISTS wp_$usuario_a_borrar;'" | at now + 30 days
            echo "mysql -e 'DROP USER IF EXISTS $usuario_a_borrar;'" | at now + 30 days

        #Confirmación
            echo "$usuario_a_borrar, sus sitios y accesos hasn sido deshabilitados correctamente"
            echo "$usuario_a_borrar y sus sitios han sido programados para eliminación en 30 días."
            read -p "Pulse intro para volver al menú" caca
        menu
    fi

}

