function cert_creation(){
    read -p "¿Estamos ante un sitio de pruebas? [s/*]" ans_sitio_pruebas
        ans_sitio_pruebas=${ans_sitio_pruebas,,}
        
    if [[ ans_sitio_pruebas -eq "s" ]]; then
        certbot --apache --test-cert -d ${user_subdomain}.${global_base_domain} -d blog.${user_subdomain}.${global_base_domain} 
    else 
        certbot --apache -d ${user_subdomain}.${global_base_domain} -d blog.${user_subdomain}.${global_base_domain} 
    fi
}