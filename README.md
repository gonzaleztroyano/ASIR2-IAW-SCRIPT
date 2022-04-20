# ASIR2-IAW-SCRIPT
## Pablo González - 2º ASIR

## ¿Qué es esto?

Este repositorio contendrá el código de los scripts y funciones de la utilidad de gestión del "hosting" creado para el módulo de Implantación de Aplicaciones Web. 

La utilidad permite:
 * Configurar un servidor web de forma automática. 
 * Crear usuarios y desplegar para estos sitios estáticos
 * Configurar un blog con [WordPress](https://wordpress.com/).
 * Configurar una tienda online con [PrestaShop](https://www.prestashop.com/). 
 * El envío de las notificaciones para los usuarios añadidos. 
 * La actualización de los registros DNS de forma programática, así como su verificación. Utilizando la [API de Cloudflare](https://api.cloudflare.com/).
 * La configuración del acceso seguro por SFTP para los usuarios. 
 * La generación de certificados SSL de Let's Encrypt y la configuración de los sitios web con [certbot](https://certbot.eff.org/)

![Menu Principal de la utilidad](./templates%20and%20misc/menu.png)


### Contenido del repositorio

 * [Script principal de la utilidad. Carga el resto de funciones](./source/gestion.sh)
 * [Menú de la utilidad](./source/menu.sh).
 * [Función listar usuarios](./source/listar.sh).
 * [Función de envío de emails utilizando la API de SendInBlue](./source/envio_email.sh).
 * [Función para crear y desplegar Apache](./source/crear_apache.sh).
 * [Función para crear un sitio de WordPress](./source/crear-wp.sh).
 * [Función para configurar un sitio en WordPress](./source/config_wp.sh)
 * [Función para instalar y configurar PrestaShop](./source/install_prestashop.sh)
 * [Función para borrar usuarios](./source/borrar.sh) y para [hacerlo de forma definitiva](./source/borrar_hard.sh)
 * [Función para modificar usuarios](./source/modificar.sh). 
 * [Función para actualizar registros con la API de Cloudflare](./source/cf_updater.sh)
 * [Función para realizar la configuración inicial del servidor](./source/conf_inicial.sh)
 * [Función para configurar los secretos y las varibales usadas por el script](./source/secrets.sh)
 * [Función para decidir qué aplicaciones (WP/PS) añadir a un usuario](./source/add_app.sh)
 * [Función para listar las aplicaiones de los usuarios](./source/app_list.sh)
 * [Función para solicitar y aplicar certificados TLS de Let's Encrypt](./source/cert_creation.sh)
 * [Función que muestra la cabecera del script](./source/show_header.sh)


## Uso del script

 1. Clonar este repositorio

 ```
 git clone https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT.git 
 ```

 2. Otorgar permisos de ejecución a los scripts.

 ```
 chmod u+x *.sh
 ```

 3. Conseguir las claves de API e información relativa. 

 4. Ejecutar el script inicial, que irá llamando al resto de funciones

 ``` 
 ./gestion.sh
 ```

 5. Si es la primera vez que lo ejecutas:

  * Deberás instalar las aplicaciones y módulos necesarios. Así como configurar los servicios. Para hacerlo puedes ejecutar la opción 8 del menú en *gestión.sh*
  * Deberás ejecutar la opción de configuración de secretos dentro del menú, es la opción 7 del menú en *gestión.sh*


## Dependencia entre las funciones

En el siguiente esquema se pueden ver las diferentes relaciones y dependencias entre las distintas funciones que componen la utilidad:

![Dependencias entre las funciones](./templates%20and%20misc/dependencies-functions.png)

### Licencia
Esta obra se publica bajo la licenca Creative Commons BY 4.0 ES.


Autor y año de publicación: Pablo González, 2021 y 2022.

Más información en [el archivo de licencia](./license.md).
