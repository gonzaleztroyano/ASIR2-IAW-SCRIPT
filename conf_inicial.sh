conf_inicial(){
        clear
        echo ""
        echo ""
cat << "EOF" 


    _____  _____ _____  _____ _____ _______   _____  ______    _____ ______  _____ _______ _____ ____  _   _  
   / ____|/ ____|  __ \|_   _|  __ \__   __| |  __ \|  ____|  / ____|  ____|/ ____|__   __|_   _/ __ \| \ | | 
  | (___ | |    | |__) | | | | |__) | | |    | |  | | |__    | |  __| |__  | (___    | |    | || |  | |  \| | 
   \___ \| |    |  _  /  | | |  ___/  | |    | |  | |  __|   | | |_ |  __|  \___ \   | |    | || |  | | . ` | 
   ____) | |____| | \ \ _| |_| |      | |    | |__| | |____  | |__| | |____ ____) |  | |   _| || |__| | |\  | 
  |_____/ \_____|_|  \_\_____|_|      |_|    |_____/|______|  \_____|______|_____/   |_|  |_____\____/|_| \_| 
                                                                                                             
                                CC BY 4.0 Internacional Pablo González
                        https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT                                                                                

                                   
EOF
    echo -e "Actualizando la lista de paquetes disponibles en los repositorios..."
    apt-get update -y > /tmp/conf_inicial.log
    if [[ $? = 0 ]]; then 
        echo -e "\t¡Hecho!\nInstalando paquetes necesarios..."
        else
            echo -e "¡Cachis! Parece que se ha producido un error. Revise los logs en /tmp/conf_inicial.log"
            read -p "Pulsa cualquier tecla para continuar..."
            exit
    fi
    mv /tmp/conf_inicial.log /tmp/conf_inicial.log.1
    apt-get install -y apache2 php libapache2-mod-php libapache2-mod-php php-mysql php-cli mariadb-server mariadb-client php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip libapache2-mpm-itk apt-utils jq > /tmp/conf_inicial.log
    if [[ $? = 0 ]]; then 
        echo -e "\t¡Hecho!\nSe han instalado los paqutes necesarios."
    else
        echo -e "¡Cachis! Parece que se ha producido un error. Revise los logs en /tmp/conf_inicial.log"
        read -p "Pulsa cualquier tecla para continuar..."
        exit
    fi
    a2enmod rewrite >> /tmp/conf_inicial.log
    systemctl restart apache2 >> /tmp/conf_inicial.log
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    wget -qO /etc/ssh/sshd_config https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/templates%20and%20misc/sshd_config >> /tmp/conf_inicial.log
    service ssh reload >> /tmp/conf_inicial.log
    read -p "Pulsa cualquier tecla para continuar..."
    menu
}
