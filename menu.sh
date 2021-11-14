function menu() {

    while [ $select -gt 5 ]; do
        echo "1. Listar usuarias"
        echo "2. Crear usuarios"
        echo "3. Borrar usuarias"
        echo "4. Modificar usuarios"
        echo "5. Salir del programa"

        read -p "Opción seleccionada:" seleccionada

        if [[ $seleccionada = 1 ]]; then
            listar
        elif [[ $seleccionada = 2 ]]; then
            crear_apache
        elif [[ $seleccionada = 3 ]]; then
            borrar
        elif [[ $seleccionada = 4 ]]; then
            modificar
        elif [[ $seleccionada = 5 ]]; then
            exit
        else
            echo "Opción no válida"
    done
}