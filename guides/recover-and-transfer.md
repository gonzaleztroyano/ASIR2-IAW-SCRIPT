# Recuperación y transferencia de datos

En este documento se recoge el proceso de migración de los datos de un servidor a otro. 

## Contenido a transferir:
 * Los usuarios previamente creados en el servidor. Lo ideal sería mantener contraseñas e IDs de usuario. De no ser posible se estudiarán opciones. 
 * El contenido de los sitios estáticos de los usuarios, `situado en /var/www/<usuario>/web`. 
 * El contenido de la web de WordPress, `situado en /var/www/<usuario>/blog`.
 * La base de datos de los sitios en WordPress. 
 * Configuraciones personalizadas, aplicaciones, etc. 

## Cronología de la migración
 1. Lo ideal es que los usuarios no perciban la transferencia y de hacerlo sea de forma posterior por la mejora del servicio. De ser necesario suspender la prestación del servicio, se redirigirá a los usuarios a una página de información. También se notificará la situación de forma previa. 
 2. P

## Puesta a punto del servidor

* Inicio de sesión SSH en el servidor 
    * Cambiar el FQDN a server.villablanca[.]me. En OVH puede ser necesario añadir un TXT
    * Cambiar la contraseña del usuario principal:
        ```
        passwd
        ```
    * Copiar la clave pública pertinente al archivo de keys autorizadas. Bloquear el acceso SSH mediante usuario/contraseña, en el archivo `/etc/ssh/sshd_config`.

## Instalación paquetes y configuración inicial

Descargar los archivos desde GitHub y hacer ejecutable gestion.sh
```
git clone https://github.com/gonzaleztroyano/ASIR2-IAW-SCRIPT.git
chmod u+x ./ASIR2-IAW-SCRIPT/gestion.sh
```

Ejecutar el script y seleccionar la opción 7 del menú (*Configuración inicial del servidor*). Se encargará de actualizar los repositorios, así como instalar todos los componentes.

## Migración de usuarios

Los archivos importantes para los usuarios son:
 * `/etc/passwd`
 * `/etc/shadow`
 * `/etc/group`
 * `/etc/gshadow`

### En equipo origen
#### Usuarios y grupos
Creamos una carpeta, donde iremos depositando todas las exportaciones:
```
mkdir /root/move/
```
Indicamos el límite del UID menor para exportar y exportamos ``/etc/passwd`:
```
export UGIDLIMIT=1002
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > /root/move/passwd.mig
```
Realizamos la misma operación para ``/etc/group`:
```
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > /root/move/group.mig
```
Igual para `/etc/shadow`:
```
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > /root/move/shadow.mig
```

Para `/etc/gshadow` podemos directamente copiar y pegar los usuarios que no son del sistema. 

Copiar al nuevo servidor:
```
scp -r /root/move/* <user>@<IP-FQDN>:mover
```
#### Contenido web

Nos situamos en a ruta correspondiente, listos para hacer un TAR. 

```
cd /var/www
tar -zcvpf /root/move/webs /var/www
tar -zcvpf /root/move/apache-conf /etc/apache2/* 
```

Lo copiamos al nuevos servidor:
```
scp -r /root/move/webs <user>@<IP-FQDN>:mover
scp -r /root/move/apache-conf <user>@<IP-FQDN>:mover
```

#### Certificados SSL 

Nos situamos en a ruta correspondiente, listos para hacer un TAR. Copaimos.

```
cd /etc/letsencrypt/
tar -zcvpf /root/move/le-content /etc/letsencrypt/*
scp -r /root/move/le-content <user>@<IP-FQDN>:mover
```

#### Bases de datos
```
mysqldump -u root -p --all-databases > alldb.sql
# Luego copiamos con SCP
```


### En equipo destino

#### Usuarios y grupos
Por seguridad, hacemos copias de seguridad de los archivos que se verán afectados. Si nuestro hosting/proveedor nos lo permite, también es recomendable realizar una *snapshot* del disco. 
```
mkdir /root/mover
cp /etc/passwd /etc/shadow /etc/group /etc/gshadow /root/mover/
```

Restaurar los archivos en los sitios correspondientes:
```
cd /root/mover
cat passwd.mig >> /etc/passwd
cat group.mig >> /etc/group
cat shadow.mig >> /etc/shadow
cat gshadow.mig >> /etc/gshadow
```

Reinicamos, suplicamos que no se rompa nada, cruzamos los dedos y vemos a ver qué se ha roto:
```
reboot now
```

#### Contenido web

Utilizaremos el tar generado en el servidor de origen para las webs:

```
cd / # Importante!
tar -zxvf /home/ubuntu/mover/webs
tar -zxvf /home/ubuntu/mover/apache-conf
```

La recuperación debe mantener permisos y propiedades:

![Ejemplo de archivos recuperados](https://raw.githubusercontent.com/gonzaleztroyano/ASIR2-IAW-SCRIPT/main/guides/images/recover-guide-1.png)

#### Certificados SSL 
```
cd / # Importante!
tar -zxvf /home/ubuntu/mover/
```

#### Módulos y cosas raras de Apache
*IMPORTANTE*
La primera vez con este error solo me ha llevado 1 hora, por lo que podemos estar satisfechos. 
```
a2dismod mpm_event
a2enmod mpm_itk.load
a2enmod ssl.load
a2enmod php7.2.load
service apache2 start
```

#### Bases de datos
````
mysql -u root -p < alldb.sql

#IMPORTANTE
 service mysql reload
````

### DNS
Cambiar todos los registro DNS pertinentes. Cabe recordar que se pueden volver a cambiar en caso de fallo. 