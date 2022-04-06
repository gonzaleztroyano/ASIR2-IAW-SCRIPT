function cert_creation(){
    # VARS:
        # $1 = subdominio a crear
    subdomain=${1}
    echo -e "\n"
    read -p "¿Estamos ante un sitio de pruebas? [s/*]" ans_sitio_pruebas
    echo "Recibido. Generando y aplicando certificados..."
        ans_sitio_pruebas=${ans_sitio_pruebas,,}
        
    if [[ ans_sitio_pruebas = "s" ]]; then
        certbot --apache --test-cert --quiet --redirect -d ${subdomain}.${global_base_domain} 
    else
        certbot --apache --redirect --quiet -d ${subdomain}.${global_base_domain}
    fi
    echo "Certificados generados y aplicados correctamente."
}