#!/bin/bash

source borrar.sh
source config_wp.sh
source crear_apache.sh
source crear_usuario.sh
source crear_wp.sh
source envio_email.sh
source menu.sh
source modificar.sh
source listar.sh
source conf_inicial.sh
source secrets.sh
source cf_updater.sh

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
