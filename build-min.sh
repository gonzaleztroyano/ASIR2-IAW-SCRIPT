#!/bin/bash
rm ./gestion.min.sh
{
    cat borrar.sh
    echo ""
    cat envio_email.sh
    echo ""
    cat listar.sh
    echo ""
    cat modificar.sh
    echo ""
    cat crear_wp.sh
    echo ""
    cat config_wp.sh
    echo ""
    cat crear_apache.sh
    echo ""
    cat menu.sh 
    echo ""
    echo "menu"
} >> gestion.min.sh

sed -i '/^[ \t]*#/d' ./gestion.min.sh
sed -i '/^$/d' ./gestion.min.sh