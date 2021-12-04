conf_inicial(){
    echo -e "Actualizando la lista de paquetes disponibles en los repositorios..."
    apt-get update -y > /dev/null
    echo -e "¡Hecho!\nInstalando paquetes necesarios..."
    echo -e
    apt-get install -i apache2 php7.4 libapache2-mod-php libapache2-mod-php php-mysql php-cli mariadb-server mariadb-client php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip libapache2-mpm-itk > /dev/null
    a2enmod rewrite
    
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    wget -qO /etc/ssh/sshd_config https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-DOCS/main/misc/sshd_config

}
