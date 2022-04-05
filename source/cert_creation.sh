function cert_creation(){
    # VARS:
        # $1 = subdominio a crear
    subdomain=${1}
    read -p "¿Estamos ante un sitio de pruebas? [s/*]" ans_sitio_pruebas
        ans_sitio_pruebas=${ans_sitio_pruebas,,}
        
    if [[ ans_sitio_pruebas -eq "s" ]]; then
        certbot --apache --test-cert -d ${subdomain}.${global_base_domain} 
    else 
        certbot --apache -d ${subdomain}.${global_base_domain}
    fi
}