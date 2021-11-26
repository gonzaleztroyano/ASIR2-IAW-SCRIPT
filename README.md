# ASIR2-IAW-SCRIPT
## Pablo González - 2º ASIR

Este repositorio contendrá el código de los scripts y funciones de la utilidad de gestión del "hosting" creado para el módulo de Implantación de Aplicaciones Web. 

### Contenido del repositorio

 * [Script inicial de la utilidad](./gestion.sh)
 * [Menú de la utilidad](./menu.sh).
 * [Función listar usuarios](./listar.sh).
 * [Función de envío de email](./envio_email.sh).
 * [Función para crear y desplegar Apache](./crear_apache.sh).
 * [Función para crear un sitio de WordPress](./crear-wp.sh).
 * [Función para configurar un sitio en WordPress](./config_wp.sh)
 * [Función para borrar usuarios](./borrar.sh).
 * [Función para modificar usuarios](./modificar.sh). 

## Uso del script

 1. Clonar este repositorio

 ```
 git clone https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT.git 
 ```

 2. Otorgar permisos de ejecución a los scripts.

 ```
 chmod u+x *.sh
 ```

 3. Configurar datos SMTP, siguiendo como ejemplo [esta guía](https://www.linuxhowto.net/how-to-set-up-postfix-smtp-relay-on-ubuntu-with-sendinblue/).

 4. Ejecutar el script inicial, que irá llamando al resto de funciones

 ``` 
 ./gestion.sh
 ```



### Licencia

Esta obra se publica bajo la licenca Creative Commons BY 4.0 International.

Autor y año de publicación: Pablo González, 2021.

Más información en [el archivo de licencia](./license.md).
