function borrar_hard () {
    echo -e "Usuarios del sistema web: \n " 
        grep '/var/www'  < /etc/passwd | cut -d ':' -f 1
        echo -e "\n -- FIN DE LA LISTA -- \n \n"
    read -p "¿Qué usuario desea borrar? " usuario_a_borrar
    check_usuario_existe=$(cat /etc/passwd | grep "/var/www" | cut -d ":" -f 1 | grep -w ${usuario_a_borrar})
    if [[ ${check_usuario_existe} != "${usuario_a_borrar}" ]]; then
        echo "El usuario indicado no existe"
        read -p "Pulse cualquier tecla para volver al menú inicial " caca
        menu
    else
        userdel -f ${usuario_a_borrar}
        a2dissite ${usuario_a_borrar}.conf > /dev/null
        a2dissite ${usuario_a_borrar}-le-ssl.conf > /dev/null
        a2dissite wp_${usuario_a_borrar}.conf > /dev/null
        a2dissite wp_${usuario_a_borrar}-le-ssl.conf > /dev/null
        mysql -e "REVOKE ALL PRIVILEGES ON wp_${usuario_a_borrar}.* FROM ${usuario_a_borrar};"
        systemctl reload apache2 > /dev/null
        rm -Rf /var/www/${usuario_a_borrar}
        mysql -e "DROP DATABASE IF EXISTS wp_${usuario_a_borrar};"

        echo "${usuario_a_borrar} y sus sitios han sido eliminados."
        read -p "Pulse intro para volver al menú"
        menu
    fi
}
