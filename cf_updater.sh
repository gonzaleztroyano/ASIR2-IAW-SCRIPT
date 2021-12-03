    #Notas:
        # Recibe $usuario_nuevo (1) desde crear_usuario.sh
function cf_updater(){

    ip_equipo=$(curl -sS ifconfig.me)
    curl -X POST "https://api.cloudflare.com/client/v4/zones/$global_cf_zone/dns_records" \
     -H "X-Auth-Email: $global_cf_email" \
     -H "Authorization: Bearer $global_cf_token " \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'$1.$global_base_domain'","content":"'$ip_equipo'","ttl":3600,"proxied":false}'

    echo -e "Comprobando la resulución del dominio $1.$global_base_domain\n Por favor, espera..."
    sleep 5
    ip_resultado=$(dig A $1.$global_base_domain +short)

    if [[$ip_resultado = $ip_equipo]]; then

        echo -e "¡Excelente! El registro creado es válido\n"
        read -p "Pulse cualquier tecla para volver al menú"
        menu
    else
        echo -e "No se ha podido comprobar la correcta resolución del dominio. \n\n No nos alarmemos.\n Prueba el siguiente comando: \"dig A $1.$global_base_domain +short\" \n\nEl resultado debe ser: $ip_equipo \n\n De no resolverse, revisa en Cloudflare.\n\n"
        read -p "Pulse cualquier tecla para volver al menú"
    fi 
}