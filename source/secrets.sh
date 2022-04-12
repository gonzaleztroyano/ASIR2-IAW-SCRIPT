    # Notas del fichero
        # Related issue: #21
function secrets() {
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
    echo -e "\e[1mIntroduzca los secretos y variables solicitadas\e[0m"
    echo ""
    read -rp "[1/5] - Dominio base para la configuración: " base_domain
    echo -e "\tGuardado. \n"
    read -rp "[2/5] - Email de la cuenta en Cloudflare: " cf_email
    echo -e "\tGuardado. \n"
    read -rp "[3/5] - ID de zona en Cloudflare: " cf_zone
    echo -e "\tGuardado. \n"
    read -rp "[4/5] - Token API de Cloudflare: " cf_token
    echo -e "\tGuardado. \n"
    read -rp "[5/5] - Token API de SendInBlue: " sib_api_key

    {
    echo "global_base_domain=\"$base_domain\""
    echo "global_cf_email=\"$cf_email\""
    echo "global_cf_zone=\"$cf_zone\""
    echo "global_cf_token=\"$cf_token\""
    echo "global_sib_api_key=\"$sib_api_key\""
    echo "export global_base_domain"
    echo "export global_cf_email"
    echo "export global_cf_zone" 
    echo "export global_cf_token" 
    echo "export global_sib_api_key"
    } >> ~/.bashrc

    export global_base_domain=\"$base_domain\"
    export global_cf_email=\"$cf_email\"
    export global_cf_zone=\"$cf_zone\"
    export global_cf_token=\"$cf_token\"
    export global_sib_api_key=\"$sib_api_key\"

    echo -e "\n \nSe han guardado los secretos.\nEs posible que debas reiniciar la sesión para ver aplicados los cambios."
    read -p "Pulse cualquer tecla para continuar" trash
    menu
}
