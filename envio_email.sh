function envio_email() {

    printf "root=postmaster
mailhub=smtp-relay.sendinblue.com:587
hostname=server.glez.tk
AuthUser=sendinblue@glez.tk
AuthPass=xsmtpsib-ed27e85602d3a23556a2dbe0b9e8aee899eeb99db1b3a5e677967080eba378a5-0ZNDpHB1g4bOxtk3
FromLineOverride=YES
UseSTARTTLS=YES" > /etc/ssmtp/ssmtp.conf

    TMP="asdasds"
    printf "\n
        ESTIMADO CLIENTE: \n
        $TMP\n
        Gracias por confiar en nosotros, bla bla bla. 

        A continuación de detallamos los detalles:

        Usuario: $usuario_nuevo
        Contraseña: $password_generada
    "  | mail -s "BIENVENIDX" pablo@glez.tk


}

#sudo dpkg-reconfigure postfix
