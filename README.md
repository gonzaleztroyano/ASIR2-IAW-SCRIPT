# ASIR2-IAW-SCRIPT
## Pablo González - 2º ASIR

## ¿Qué es esto?

Este repositorio contendrá el código de los scripts y funciones de la utilidad de gestión del "hosting" creado para el módulo de Implantación de Aplicaciones Web. 

La utilidad permite:
 * Configurar un servidor web de forma automática. 
 * Crear usuarios y desplegar para estos sitios estáticos, así como un blog con WordPress. 
 * El envío de las notificaciones para los usuarios añadidos. 
 * La actualización de los registros DNS de forma programática, así como su verificación. 
 * La configuración del acceso seguro por SFTP para los usuarios. 
 * La generación de certificados SSL de Let's Encrypt y la configuración de los sitios web con [certbot](https://certbot.eff.org/)

![image](https://user-images.githubusercontent.com/44492590/144755996-fe94e0c4-10e9-47d7-a966-102e44016e4d.png)


### Contenido del repositorio

 * [Script principal de la utilidad. Carga el resto de funciones](./gestion.sh)
 * [Menú de la utilidad](./menu.sh).
 * [Función listar usuarios](./listar.sh).
 * [Función de envío de email utilizando la API de SendInBlue](./envio_email.sh).
 * [Función para crear y desplegar Apache](./crear_apache.sh).
 * [Función para crear un sitio de WordPress](./crear-wp.sh).
 * [Función para configurar un sitio en WordPress](./config_wp.sh)
 * [Función para borrar usuarios](./borrar.sh) y para [hacerlo de forma definitiva](./borrar_hard.sh)
 * [Función para modificar usuarios](./modificar.sh). 
 * [Función para actualizar registros con la API de Cloudflare](./cf_updater.sh)
 * [Función para realizar la configuración inicial del servidor](./conf_inicial.sh)
 * [Función para configurar los secretos y las varibales usadas por el script](./secrets.sh)

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

  * Deberás instalar las aplicaciones y módulos necesarios. Así como configurar los servicios. Para hacerlo puedes ejecutar la opción 7 del menú en *gestión.sh*
  * Deberás ejecutar la opción de configuración de secretos dentro del menú, es la opción 6 del menú en *gestión.sh*

## Estado del servicio - villablanca.me

Haz clic en [este enlace](https://status.villablanca.me/) para acceder a la página de *status* en vivo.

![image](https://user-images.githubusercontent.com/44492590/144756126-46b13dec-de8d-4844-8a62-844318f4dac0.png)

## Ejemplos de sitios alojados:
* https[://]blueskynepal[.]villablanca[.]me
* https[://]blog[.]blueskynepal[.]villablanca[.]me

### Licencia
Esta obra se publica bajo la licenca Creative Commons BY 4.0 ES.


Autor y año de publicación: Pablo González, 2021.

Más información en [el archivo de licencia](./license.md).
