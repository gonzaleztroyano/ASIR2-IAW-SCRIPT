function menu() {
        clear
        echo ""
        echo ""
cat << "EOF" 

   ___ ___ ___ _____ ___ ___  _  _ 
  / __| __/ __|_   _|_ _/ _ \| \| |
 | (_ | _|\__ \ | |  | | (_) | .` |
  \___|___|___/ |_| |___\___/|_|\_|
                                   
EOF

        echo ""
        echo ""
        echo "  1. Listar usuarias"
        echo "  2. Crear usuarios"
        echo "  3. Borrar usuarias"
        echo "  4. Modificar usuarios"
        echo "  5. Salir del programa"
        echo ""
        read -p "     Opción seleccionada: " seleccionada

        if [[ $seleccionada = 1 ]]; then
                listar
            elif [[ $seleccionada = 2 ]]; then
                crear_usuario
            elif [[ $seleccionada = 3 ]]; then
                borrar
            elif [[ $seleccionada = 4 ]]; then
                modificar
            elif [[ $seleccionada = 5 ]]; then
                echo ""
                exit
            else
                echo "Opción no válida"
                menu
        fi
}