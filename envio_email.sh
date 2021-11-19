function envio_email() {
 
    # Notas del fichero
        # VARS: $usuario_nuevo ($1)
        # VARS: $password_generada ($2)
        # VARS: $correo_cliente ($3)
        # VARS: $PASS, leída desde bashrc 
        # VARS: $USERSIB, leía desde bashrc

    # Actualización datos SMTP
        # Preguntar y actuar

            # Variable para gestión de secretos 
#            PASS="${BASHPASSFROMRC}"
#            USERSIB="${BASHUSERSIBFROMRC}"
            
                
                #En el archivpo ~/.bashrc añadimos:
                    # BASHPASSFROMRC="%AQUÍ_VA_LA_CONTRASEÑA%"
                    # BASHUSERSIBFROMRC="%AQUÍ_VA_EL_USUARIO%"
#            read -p "¿Desea actualizar los datos SMTP [s/N]?" buscar_usuario_filtro
            
#           if [ $buscar_usuario_filtro = "s" ]; then
#                 printf "root=postmaster
#                    mailhub=smtp-relay.sendinblue.com:587
#                    hostname=server.glez.tk
#                    AuthUser=$BASHUSERSIBFROMRC
#                    AuthPass=$BASHPASSFROMRC
#                    FromLineOverride=YES
#                    UseSTARTTLS=YES" > /etc/ssmtp/ssmtp.conf
#            fi

   

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
#https://www.linuxhowto.net/how-to-set-up-postfix-smtp-relay-on-ubuntu-with-sendinblue/