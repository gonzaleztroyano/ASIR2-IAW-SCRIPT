    #Notas:
        # Recibe $usuario_nuevo (1) desde crear_usuario.sh
function cf_updater(){
    user_subdomain=$1
    echo $user_subdomain
    echo $global_base_domain
    echo $global_cf_email
    echo $global_cf_token
    echo $global_cf_zone
    echo $global_sib_api_key
    ip_equipo=$(curl -sS ifconfig.me)
    curl -X POST "https://api.cloudflare.com/client/v4/zones/${global_cf_zone}/dns_records" \
     -H "X-Auth-Email: ${global_cf_email}" \
     -H "Authorization: Bearer ${global_cf_token} " \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${user_subdomain}.${global_base_domain}'","content":"'${ip_equipo}'","ttl":3600,"proxied":false}' | jq .

    curl -X POST "https://api.cloudflare.com/client/v4/zones/${global_cf_zone}/dns_records" \
     -H "X-Auth-Email: ${global_cf_email}" \
     -H "Authorization: Bearer ${global_cf_token} " \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'blog.${user_subdomain}.${global_base_domain}'","content":"'${ip_equipo}'","ttl":3600,"proxied":false}' | jq .

    echo -e "Comprobando la resulución del dominio ${user_subdomain}.${global_base_domain}\n Por favor, espera..."
    sleep 5
    ip_resultado=$(dig A ${user_subdomain}.${global_base_domain} +short)

    if [[ ${ip_resultado} = ${ip_equipo} ]]; then

        echo -e "¡Excelente! El registro creado es válido\n"
        read -p "Pulse cualquier tecla para continuar el proceso."
    else
        echo -e "No se ha podido comprobar la correcta resolución del dominio. \n\n No nos alarmemos.\n Prueba el siguiente comando: \"dig A ${user_subdomain}.${global_base_domain} +short\" \n\nEl resultado debe ser: ${ip_equipo} \n\n De no resolverse, revisa en Cloudflare.\n\n"
    fi
}