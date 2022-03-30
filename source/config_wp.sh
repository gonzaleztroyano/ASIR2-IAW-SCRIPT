function config_wp(){
    # Definición de variables
        db_name=wp_$1
        db_user=$1
        db_pw=$2
    # Archivo wp-config.php
        # Copiar el archivo de ejemplo
        cp /var/www/$1/blog/wp-config-sample.php /var/www/$1/blog/wp-config.php
        chown $1:$1 /var/www/$1/blog/wp-config.php
        # Sustitución de valores
            sed -i "s/database_name_here/$db_name/g" "/var/www/$1/blog/wp-config.php"
            sed -i "s/username_here/$1/g" "/var/www/$1/blog/wp-config.php"
            sed -i "s/password_here/$2/g" "/var/www/$1/blog/wp-config.php"
        
        #32: https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/issues/32
        SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
        STRING='put your unique phrase here'
        printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s /var/www/$1/blog/wp-config.php
}