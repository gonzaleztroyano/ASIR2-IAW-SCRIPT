function envio_email() {
    # Notas del fichero
        # VARS: $usuario_nuevo ($1)
        # VARS: $password_generada ($2)
        # VARS: $correo_cliente ($3)

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
          "SUBS_BASE_DOMAIN": "'"$base_domain"'"
     },
     "templateId": 1
}
' 
}