function listar() {

    salir=0

    while [ $salir != 1 ]
    do
        echo ""
        read -p "¿Desea buscar algún nombre de usuario en concreto? [s/N]: " buscar_usuario_filtro

        if [ $buscar_usuario_filtro = "s" ]; then

            read -p "Introduzca el término a buscar: " buscar_usuario_filtro_termino
            echo -e "Estos son los usuarios que coinciden con el término indicado: \n " 
            cat /etc/passwd | grep '/var/www' | grep $buscar_usuario_filtro_termino | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1

        else
            echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1
        fi
    done
    read -p "Pulse cualquier tecla para volver al menú." caca
    menu
}
