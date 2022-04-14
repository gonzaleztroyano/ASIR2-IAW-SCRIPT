    # VARS:
        # Usuario en el que configurar app
function install_prestashop(){ 
    usuario=${1}
    mkdir -p /var/www/${usuario}/tienda
    chown ${usuario}:${usuario} /var/www/${usuario}/tienda
    chmod -R 770 /var/www/${usuario}/tienda

    touch /var/log/apache2/${usuario}.${global_base_domain}-tienda.log
    touch /var/log/apache2/${usuario}.${global_base_domain}-tienda-access.log

    chmod 644 /var/log/apache2/${usuario}.${global_base_domain}-tienda.log
    chmod 644 /var/log/apache2/${usuario}.${global_base_domain}-tienda-access.log

    ln /var/log/apache2/${usuario}.${global_base_domain}-tienda.log /var/www/${usuario}/ficheros/logs/${usuario}.{$global_base_domain}-tienda.log
    ln /var/log/apache2/${usuario}.${global_base_domain}-tienda-access.log /var/www/${usuario}/ficheros/logs/${usuario}.${global_base_domain}-tienda-access.log
   
    wget -qO /etc/apache2/sites-available/tienda_${usuario}.conf https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/templates%20and%20misc/tienda_virtualhost.txt
    sed -i "s/USER-TO-CHANGE/${usuario}/g" "/etc/apache2/sites-available/tienda_${usuario}.conf"
    sed -i "s/GLOBAL-BASE-DOMAIN/${global_base_domain}/g" "/etc/apache2/sites-available/tienda_${usuario}.conf"
    a2ensite tienda_${usuario}.conf >> /dev/null
    systemctl restart apache2

    password_generada=$(openssl rand -base64 12)
    mysql -e "CREATE DATABASE tienda_${usuario};"
    mysql -e "CREATE USER '${usuario}_tienda'@localhost IDENTIFIED BY '${password_generada}';"
    mysql -e "GRANT ALL PRIVILEGES ON tienda_${usuario}.* TO '${usuario}_tienda'@'localhost';"

    if [[ ! -f /tmp/prestashop.zip ]]; then
        curl https://download.prestashop.com/download/releases/prestashop_1.7.8.5.zip --output /tmp/prestashop.zip
        if [[  ! -d /tmp/prestashop ]]; then
            mkdir /tmp/prestashop &> /dev/null
            unzip /tmp/prestashop.zip -d  /tmp/prestashop
        fi
    fi

    cp -r /tmp/prestashop/* /var/www/${usuario}/tienda/
    chmod -R 770 /var/www/${usuario}/tienda/
    chown -R ${usuario}:${usuario} /var/www/${usuario}/tienda/

    cf_updater ${usuario} tienda
    cert_creation "tienda.${usuario}"

    password_generada_user=$(openssl rand -base64 12)
    clear
    echo -e "\n=========== ATENCIÓN ===========\n\n Acceda a: https://tienda.${usuario}.${global_base_domain}\n\n=========== GRACIAS ============\n"
    read -p "¿Hecho? " trash

    clear
    echo -e "\n=========== ATENCIÓN ===========\n\n Idioma: Español (Spanish)\n\n=========== GRACIAS ============\n"
    read -p "¿Hecho? " trash

    clear
    echo -e "\n=========== ATENCIÓN ===========\n\n Acepta términos y pulsa 'Siguiente' \n\n=========== GRACIAS ============\n"
    read -p "¿Hecho? " trash

    clear
    echo -e "\n=========== ATENCIÓN ===========\n\n Nombre: \nTienda de ${usuario}\n\n Actividad: Otra\n\n Datos demostración: 'Sí'\n\n Activar SSL: Sí\n\n Correo del usuario: \n${usuario}@glez.tk\n\n Contraseña de usuario:\n${password_generada_user}\n\n=========== GRACIAS ============\n"
    read -p "¿Hecho? " trash

    clear
    echo -e "\n=========== ATENCIÓN ===========\n\n BDD:\ntienda_${usuario}\n\n Usuario:\n${usuario}_tienda\n\n Contraseña:\n${password_generada}\n\n=========== GRACIAS ============\n"
    read -p "¿Hecho? " trash
    clear
    echo "La tienda debería estar instalándose..."
    read -p "Pulsar al término de la instalación " trash

    rm -rf /var/www/ocitest141/tienda/install/

    mail_regex="^[a-zA-Z0-9_-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,12}$"
    until [[ ${correo_cliente} =~ ${mail_regex} ]];
    do
        echo -e "\e[5mERROR\e[0m: correo no válido.\n"
        read -p "Indique el correo electrónico del cliente: " correo_cliente
    done
    envio_email ${usuario} ${password_generada_user} ${correo_cliente} 4 tienda



}