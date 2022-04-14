function envio_email() {
    # Notas del fichero
        # VARS: $usuario_nuevo ($1)
        # VARS: $password_generada ($2)
        # VARS: $correo_cliente ($3)
        # VARS: plantilla ($4)
          # Plantilla #1 --> Inicial
          # Plantilla #2 --> Cambio contraseña
          # Plantilla #3 --> Nuevo servicio (WP)
          # Plantilla #4 --> Nuevo servicio (PS)
        # VARS: Servicio nuevo ($5):
          # blog --> WP
          # tienda --> PS
     plantilla=${4}

     if [[ ${plantilla} = 1 ]]; then
curl --request POST \
     --url https://api.sendinblue.com/v3/smtp/email \
     --header 'Accept: application/json' \
     --header 'Content-Type: application/json' \
     --header "api-key: "$global_sib_api_key"" \
     --data '
{
     "to": [
          {
               "email": "'"$3"'"
          }
     ],
     "params": {
          "SUBS_USERNAME": "'"$1"'",
          "SUBS_PASSWORD": "'"$2"'",
          "SUBS_HOST": "'"$1"'",
          "SUBS_BASE_DOMAIN": "'"$global_base_domain"'"
     },
     "templateId": 1
}
' 
     elif [[ ${plantilla} = 2 ]]; then
curl --request POST \
     --url https://api.sendinblue.com/v3/smtp/email \
     --header 'Accept: application/json' \
     --header 'Content-Type: application/json' \
     --header "api-key: "$global_sib_api_key"" \
     --data '
{
     "to": [
          {
               "email": "'"$3"'"
          }
     ],
     "params": {
          "SUBS_USERNAME": "'"$1"'",
          "SUBS_PASSWORD": "'"$2"'"
     },
     "templateId": 2
}
'
     elif [[ ${plantilla} = 3 ]]; then
curl --request POST \
     --url https://api.sendinblue.com/v3/smtp/email \
     --header 'Accept: application/json' \
     --header 'Content-Type: application/json' \
     --header "api-key: "$global_sib_api_key"" \
     --data '
{
     "to": [
          {
               "email": "'"$3"'"
          }
     ],
     "params": {
          "SUBS_HOST": "'"$1"'",
          "SUBS_SERVICE": "'"$5"'",
          "SUBS_BASE_DOMAIN": "'"$global_base_domain"'"
     },
     "templateId": 3
}
' 
     elif [[ ${plantilla} = 4 ]]; then
curl --request POST \
     --url https://api.sendinblue.com/v3/smtp/email \
     --header 'Accept: application/json' \
     --header 'Content-Type: application/json' \
     --header "api-key: "$global_sib_api_key"" \
     --data '
{
     "to": [
          {
               "email": "'"$3"'"
          }
     ],
     "params": {
          "SUBS_USERNAME": "'"$1"'",
          "SUBS_PASSWORD": "'"$2"'",
          "SUBS_HOST": "'"$1"'",
          "SUBS_SERVICE": "'"$5"'",
          "SUBS_BASE_DOMAIN": "'"$global_base_domain"'"
     },
     "templateId": 4
}
'     
fi
}
