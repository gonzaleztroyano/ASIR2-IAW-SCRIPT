    # Notas del fichero
        # Related issue: #21
function secrets() {
    echo "Introduzca los secretos y variables solicitadas"
    echo ""
    read -rp "Introduce el dominio base para la configuración: " base_domain
    echo -e "Guadado. \n"
    read -rp "Introduce el email de la cuenta en Cloudflare: " cf_email
    echo -e "Guadado. \n"
    read -rp "Introduce el ID de zona en Cloudflare: " cf_zone
    echo -e "Guadado. \n"
    read -rp "Introduce el token API de Cloudflare: " cf_token
    echo -e "Guadado. \n"
    read -rp "Introduce el token API de SendInBlue: " sib_api_key

    {
    echo "base_domain=$base_domain"
    echo "cf_email=$cf_email"
    echo "cf_zone=$cf_zone"
    echo "cf_token=$cf_token"
    echo "sib_api_key=$sib_api_key"
    } >> ~/.bashrc

    echo -e "\n \n Se han guardado los secretos. "
    read -p "Pulse cualquer tecla para continuar" trash
    menu

}