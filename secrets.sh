    # Notas del fichero
        # Related issue: #21
function secrets() {
    clear
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
    echo "base_domain=\"$base_domain\""
    echo "cf_email=\"$cf_email\""
    echo "cf_zone=\"$cf_zone\""
    echo "cf_token=\"$cf_token\""
    echo "sib_api_key=\"$sib_api_key\""
    } >> ~/.bashrc

    echo -e "\n \n Se han guardado los secretos. "
    read -p "Pulse cualquer tecla para continuar" trash
    menu

}