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
source secrets.sh
source cf_updater.sh

if [ "$EUID" -ne 0 ]
  then echo "Este script de gestión solo puede ser ejecutado por el usuario root"
  exit
fi

menu
