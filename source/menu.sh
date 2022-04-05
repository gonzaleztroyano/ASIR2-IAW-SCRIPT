function menu() {

    show_header

        echo ""
        echo ""
        echo "  1. Listar usuarias"
        echo "  2. Crear usuarios"
        echo "  31. Añadir aplicación a un usuario"
        echo "  32. Ver las aplicaciones de un usuario"
        echo "  4. Borrar usuarias"
        echo "  5. Modificar usuarios"
        echo "  6. Salir del programa"
        echo ""
        echo "  7. Configuración de secretos"
        echo "  8. Configuración inicial del servidor."
        echo "  9. Borrar usuario directamente (sin preguntar)"
        echo ""
        read -p "     Opción seleccionada: " seleccionada

        if [[ $seleccionada = 1 ]]; then
                listar
            elif [[ $seleccionada = 2 ]]; then
                crear_usuario
            elif [[ $seleccionada = 31 ]]; then
                add_app
            elif [[ $seleccionada = 32 ]]; then
                app_list bonito
            elif [[ $seleccionada = 4 ]]; then
                borrar
            elif [[ $seleccionada = 5 ]]; then
                modificar
            elif [[ $seleccionada = 6 ]]; then
                echo ""
                exit
            elif [[ $seleccionada = 7 ]]; then
                secrets
            elif [[ $seleccionada = 8 ]]; then
                conf_inicial
            elif [[ $seleccionada = 9 ]]; then
                borrar_hard
            else
                echo "Opción no válida"
                menu
        fi
}