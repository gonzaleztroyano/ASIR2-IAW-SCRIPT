#!/bin/bash

source source/borrar.sh
source source/config_wp.sh
source source/crear_apache.sh
source source/crear_usuario.sh
source source/crear_wp.sh
source source/envio_email.sh
source source/menu.sh
source source/modificar.sh
source source/listar.sh
source source/conf_inicial.sh
source source/secrets.sh
source source/cf_updater.sh
source source/borrar_hard.sh
source source/save_passwd.sh
source source/app_list.sh
source source/show_header.sh
source source/add_app.sh
source source/cert_creation.sh

export global_base_domain=$global_base_domain
export global_cf_email=$global_cf_email
export global_cf_token=$global_cf_token
export global_cf_zone=$global_cf_zone
export global_sib_api_key=$global_sib_api_key

if [ "$EUID" -ne 0 ]
  then echo "Este script de gestión solo puede ser ejecutado por el usuario root"
  exit
fi

menu
