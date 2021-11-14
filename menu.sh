function menu() {

    while [ $select -ne 5 ]; do
    echo "1. Listar usuarias"
    echo "2. Crear usuarios"
    echo "3. Borrar usuarias"
    echo "4. Modificar usuarios"
    echo "5. Salir del programa"

    read -p "Opción seleccionada:" seleccionada

    case $seleccionada in
        1)
                listar()
         ;;
        2)
                crear()
        ;;
        3)
                borrar()
        ;;
        4)
                modificar()
        ;;
        5)
                exit 
        ;;
    esac
done
}