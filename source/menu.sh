function menu() {
        clear
        echo ""
        echo ""
cat << "EOF" 


    _____  _____ _____  _____ _____ _______   _____  ______    _____ ______  _____ _______ _____ ____  _   _  
   / ____|/ ____|  __ \|_   _|  __ \__   __| |  __ \|  ____|  / ____|  ____|/ ____|__   __|_   _/ __ \| \ | | 
  | (___ | |    | |__) | | | | |__) | | |    | |  | | |__    | |  __| |__  | (___    | |    | || |  | |  \| | 
   \___ \| |    |  _  /  | | |  ___/  | |    | |  | |  __|   | | |_ |  __|  \___ \   | |    | || |  | | . ` | 
   ____) | |____| | \ \ _| |_| |      | |    | |__| | |____  | |__| | |____ ____) |  | |   _| || |__| | |\  | 
  |_____/ \_____|_|  \_\_____|_|      |_|    |_____/|______|  \_____|______|_____/   |_|  |_____\____/|_| \_| 
                                                                                                             
                                CC BY 4.0 Internacional Pablo González
                        https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT                                                                                

                                   
EOF

        echo ""
        echo ""
        echo "  1. Listar usuarias"
        echo "  2. Crear usuarios"
        echo "  3. Borrar usuarias"
        echo "  4. Modificar usuarios"
        echo "  5. Salir del programa"
        echo ""
        echo "  6. Configuración de secretos"
        echo "  7. Configuración inicial del servidor."
        echo "  8. Borrar usuario directamente (sin preguntar)"
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
            elif [[ $seleccionada = 6 ]]; then
                secrets
            elif [[ $seleccionada = 7 ]]; then
                conf_inicial
            elif [[ $seleccionada = 8 ]]; then
                borrar_hard
            else
                echo "Opción no válida"
                menu
        fi
}