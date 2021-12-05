# Inicio de sesión SSH utilizando Cloudflare Teams #19

Ya se encuentra desplegado el sitio en Cloudflare. 

## Configuración en *Teams Dashboard* 

1. Acceder a la Consola de Teams. En el menú, seleccionamos *Access* > *Applications*. Hacemos clic en *Add an Application*.

2. Seleccionamos "Self-Hosted" como tipo de aplicación.

[Selector de tipo de aplicacion](https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/guides/images/cf-guide-ssh-1.png)

3. En la siguiente pantalla, definimos la configuración:
    1. *SSH villablanca.me* como nombre
    2. *ssh-server[.]villablanca[.]me*, como dominio de aplicación
    3. Aplication image, una imagen en la que se vea SSH. 
    4. Seleccionamos tanto OTP con Google como IdP. 
    5. En las reglas de acceso, seleccionamos el grupo de permitidos. También indicamos algunos correos adicionales a los que se les permitirá el acceso. 
    6. Se activa la funcionalidad para solicitar justificación de acceso. 
    7. Activamos *SSH Browser rendering* en la siguiente pantalla.  

## Configuración tunnel

1. Descargamos e instalamos la última versión disponible de *cloudflared*:
```
sudo wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i ./cloudflared-linux-amd64.deb
```

2. Nos autenticamos:
```
cloudflared tunnel login
```
Nos mostrará una URL en la terminal como la siguiente: `https://dash.cloudflare.com/argotunnel?callback=https%3A%2F%2Flogin.cloudflareaccess.org?XXXXXXXXXXXXXXXX`

3. Al abrirla, debemos seleccionar nuestro sitio y autorizar la conexión:

[Autorizar la conexión](https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/guides/images/cf-guide-ssh-2.png)

4. Creamos el tunnel:
```
cloudflared tunnel create <Nombre-del-tunnel>
```

5. Para ver los túneles de nuestra cuenta podemos utilizar:
```
cloudflared tunnel list
```
6. Editamos el archivo de configuración:

```
nano ~/.cloudflared/config.yml
```
Ejemplo de configuración para SSH tunneling:

```
tunnel: XXXXXXXX-XXXXX-XXXX-XXXX-XXXXXXXXXXXX
credentials-file: /root/.cloudflared/XXXXXXXX-XXXXX-XXXX-XXXX-XXXXXXXXXXXX.json

ingress:
  - hostname: ssh-server[.]villablanca[.]me
    service: ssh://localhost:22
  - service: http_status:404
```

7. Enrutar el tráfico. Para ello, accedemos al panel de administración de Cloudflare y creamos un nuevo registro CNAME, enrutando el tráfico a través de la red de Cloudflare (activando la *nubecita* naranja). El registro tendrá el siguiente contenido:

    Para el host, lo definido en Teams y en el yaml:
    ```
    ssh-server[.]villablanca[.]me
    ``` 
    Para el contenido/objetivo del CNAME:
    ```
    XXXXXXXX-XXXXX-XXXX-XXXX-XXXXXXXXXXXX.cfargotunnel.com
    # Siendo XX[...]XX el ID del *tunnel*. 
    ```
[Registro CNAME](https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/guides/images/cf-guide-ssh-3.png)

8. Corremos el tunnel:

```
cloudflared tunnel run <Nombre-del-tunnel>
```

Al hacerlo, la utilidad crea 4 conexiones con dos centros de datos independientes. En nuestro caso, 2 a MAD y 2 CDG (Paris). 

Este es un extracto:

```
2021-12-05T13:26:34Z INF Generated Connector ID: 3ba6dbe8-0201-48cf-8337-c6d8175b54df
2021-12-05T13:26:34Z INF cloudflared will not automatically update if installed by a package manager.
2021-12-05T13:26:34Z INF Initial protocol http2
2021-12-05T13:26:34Z INF Starting metrics server on 127.0.0.1:41771/metrics
2021-12-05T13:26:35Z INF Connection 85bade8e-9a32-436c-977d-286e8336300e registered connIndex=0 location=MAD
2021-12-05T13:26:36Z INF Connection 071a2d8a-3d67-416c-b7b3-4089772e81ae registered connIndex=1 location=CDG
2021-12-05T13:26:37Z INF Connection aae5adb7-37f5-4ee9-abdb-8916feefa7f8 registered connIndex=2 location=MAD
2021-12-05T13:26:38Z INF Connection d5d62d9d-e561-439f-84fc-43baafb6100a registered connIndex=3 location=CDG
```

Podemos iniciar sesión desde el buscador:

[Login Page](https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/guides/images/cf-guide-ssh-4.png)


## Correr el túnel como servicio

Sin embargo, al "matar" la terminal o el proceso anterior, habremos "matado" también el túnel. 

Debemos ejecutar los siguientes comandos:
```
cloudflared service install
systemctl start cloudflared
systemctl enable cloudflared
```

## Configurar certificados de vida corta. 

El nombre en castellano es bastante más "extraño" que en inglés: *short-lived certificates*. 

Nota importante respecto a los nombres de UNIX y el Single Sign-On:

*Cloudflare Access will take the identity from a token and, using short-lived certificates, authorize the user on the target infrastructure. Access matches based on the identity that precedes an email domain. Unix usernames must match the identity preceding the email domain.*

*For example, if the user's identity in your Okta or GSuite provider is jdoe@example.com then Access will look to match that identity to the Unix user jdoe.*



1. Accedemos a Cloudflare Teams > *Access* > *Service Auth*. 
2. Seleccionamos la aplicación, que hemos conigurado en el prier paso de esta guía y hacemos clic en *Generate Certificate*. 
3. Editamos el archivo en `/etc/ssh/ca.pub`. Aquí, copiamos la clave pública que nos muestra Cloudflare en la pantalla de Teams. 
4. Después, en el archivo de configuración de SSH, `/etc/ssh/sshd_config` añadimos la siguiente línea:
    ```
    TrustedUserCAKeys /etc/ssh/ca.pub
    ```
5. Reiniciamos el servicio SSH:
    ```
    sudo service ssh restart
    ```

Ahora podemos utilizar el servicio de SSH a través del navegador:
[Registro CNAME](https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/guides/images/cf-guide-ssh-5.png)
