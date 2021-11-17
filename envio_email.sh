function envio_email() {
 
    # Notas del fichero
        # VARS: $usuario_nuevo ($1)
        # VARS: $password_generada ($2)
        # VARS: $correo_cliente ($3)

    # Actualización datos SMTP
        # Preguntar y actuar
            read -p "¿Desea actualizar los datos SMTP [s/N]?"   
            
            if [ $buscar_usuario_filtro = "s" ]; then
                 printf "root=postmaster
                    mailhub=smtp-relay.sendinblue.com:587
                    hostname=server.glez.tk
                    AuthUser=sendinblue@glez.tk
                    AuthPass=xsmtpsib-ed27e85602d3a23556a2dbe0b9e8aee899eeb99db1b3a5e677967080eba378a5-0ZNDpHB1g4bOxtk3
                    FromLineOverride=YES
                    UseSTARTTLS=YES" > /etc/ssmtp/ssmtp.conf
            fi

   

    printf "\n
        ESTIMADO CLIENTE: \n
        \n
        Gracias por confiar en nosotros para su almacenamiento premium.

        A continuación le detallamos sus detalles de acceso:

        Usuario: $1
        Contraseña: $2

        Sus dominios son los siguientes:

        Página web: $1.iaw.com
        Blog: blog.$1.iaw.com

        
    "  | mail -s "BIENVENIDX" $3


}

#sudo dpkg-reconfigure postfix
