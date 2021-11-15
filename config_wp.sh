config-wp(){

    # Definición de variables
        db_name=wp_$1
        db_user=$1
        db_pw=$2

    # Archivo wp-config.php

        # Copiar el archivo de ejemplo
        cp /var/www/$1/blog/wp-config-sample.php /var/www/$1/blog/wp-config.php

        # Sustitución de valores
            sed -i "s/database_name_here/$db_name/g" "/var/www/$1/blog/wp-config.php"
            sed -i "s/username_here/$1/g" "/var/www/$1/blog/wp-config.php"
            sed -i "s/username_here/$1/g" "/var/www/$1/blog/wp-config.php"

            
}