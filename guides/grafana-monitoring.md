# Supervisión métricas y logs con Grafana

## Instalación

1. Entramos a la interfaz de Grafana y hacemos clic en *Install Grafana Agent*.
2. Seleccionamos *Linux Server* como origen de las métricas. 
3. Veremos un comando de instalación preparado. Lo copiamos y lo ejecutamos, con permisos de superusuario en el servidor a confiugrar. 

## Configuración. 

El archivo de configuración principal de grafana se encuentra en `/etc/grafana-agent.yaml`. 

Vamos a añadir el siguiente contenido donde corresponde (en LOKI):

```
    scrape_configs:
      - job_name: villablancame_varlogs
        static_configs:
          - targets: [localhost]
            labels:
              job: varlogs
              __path__: /var/log/*log
      - job_name: villablancame_apachelogs_general
        static_configs:
          - targets: [localhost]
            labels:
              job: villablancame_apachelogs_general
              __path__: /var/log/apache2/*log
      - job_name: villablancame_apachelogs_clients
        static_configs:
          - targets: [localhost]
            labels:
              job: villablancame_apachelogs_clients
              __path__: /var/www/*/ficheros/logs/*.log
```

Reiniciamos el servicio:

```
systemctl restart grafana-agent.service
systemctl status grafana-agent.service
```