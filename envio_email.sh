function envio_email() {
    # Notas del fichero
        # VARS: $usuario_nuevo ($1)
        # VARS: $password_generada ($2)
        # VARS: $correo_cliente ($3)
        # VARS: $PASS, leída desde bashrc - DEPRECATED
        # VARS: $USERSIB, leía desde bashrc - DEPRECATED
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