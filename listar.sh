function listar() {

    salir=0

    while [ $salir != 1 ]
    do
        read -p "¿Desea buscar algún nombre de usuario en concreto? [s/n]: " buscar_usuario_filtro

        if [ $buscar_usuario_filtro = "s" ]; then

            read -p "Introduzca el término a buscar: " buscar_usuario_filtro_termino
            echo -e "Estos son los usuarios que coinciden con el término indicado: \n " 
            cat /etc/passwd | grep '/var/www' | grep $buscar_usuario_filtro_termino | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1

        elif [ $buscar_usuario_filtro = "n" ]; then
            echo -e "Usuarios del sistema web: \n " 
            cat /etc/passwd | grep '/var/www' | cut -d ':' -f 1
            echo -e "\n -- FIN DE LA LISTA -- \n "
            salir=1
        else 
            echo "Opción no válida. Inténtelo de nuevo."
        fi
    done
}
