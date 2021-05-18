# AERO-DWH

## Instalación y configuración :wrench:

### Kettel

* [Pentaho Data Integration 9.1.0.0-324 (Kettle)](https://sourceforge.net/projects/pentaho/files/Pentaho%209.1/client-tools/pdi-ce-9.1.0.0-324.zip/download)

1. Modificar _kettel.properties_ y añadir la variable FILES con la ruta del directorio AERO-DWH. Ejemplo: 
```
FILES = C:\\jvcid17\\Desktop\\AERO-DWH
```
2. Reiniciar Kettel para poder usar la variable añadida

3. Desde las transformaciones y jobs se puede referenciar a esa carpeta usando _${FILES}_. Ejemplo:

<p align="center">
  <img src="https://user-images.githubusercontent.com/47904083/117650381-ecbabc80-b190-11eb-8998-f4f71f1e80b5.png">
</p>

### XAMPP

* [XAMPP 7.2.9](https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.2.9/)

### Apache Superset

#### Apache Superset con Docker

1. Descargar la imagen apache/superset

```
docker pull apache/superset:01de3096b3688266c3895b65285d52d0063be3b5
```
2. Creación de la imagen personalizada mediante el Dockerfile situado en [/docker](https://github.com/josemanuelvinhas/AERO-DWH/tree/main/docker). El siguiente comando debe ser ejecutado en el directorio donde esté situado el Dockerfile

```
docker build -t superset:latest .
```
3. Creación y configuración del contenedor
```
docker run -d -p 8080:8088 --name superset superset

docker exec -it superset superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@superset.com --password admin

docker exec -it superset superset db upgrade

docker exec -it superset superset load_examples

docker exec -it superset superset init
```
4. Acceso a superset mediante la url [http://localhost:8080/login/](http://localhost:8080/login/)
```
Username: admin

Passwrod: admin
```
5. En la base de datos debe existir un usuario con privilegios 
```
GRANT ALL PRIVILEGES ON *.* TO 'superset' IDENTIFIED BY 'superset';
```
6. Probar la conexión desde superset usando la siguiente URI:
```
mysql://superset:superset@host.docker.internal:3306/sakila_dwh
```
<p align="center">
  <img src="https://user-images.githubusercontent.com/47904083/117272988-ff18bb80-ae5b-11eb-8136-19dbf825418f.png">
</p>

(¡OJO! Pueden existir usuarios cuyo nombre de usuario puede ser _cualquiera_ que evitan que otros usuarios pueden conectarse. Se deben eliminar estas cuentas de la base de datos).

<p align="center">
  <img src="https://user-images.githubusercontent.com/47904083/117272154-3044bc00-ae5b-11eb-94b8-a1ae2ae32c36.png">
</p>

7. EXTRA: Parar y arrancar el contenedor

```
docker stop superset

docker start superset
```

#### Apache Superset - Procesado de  Templates

1. Inicio de sesión interactiva en docker superset
```
docker exec -u 0 -it superset /bin/bash
```
2. Actualización de repos de apt e instalación de nano para edición de config.py
```
apt-get update
apt-get install nano
```
3. Edición de config.py de Superset para activación de procesamiento de plantillas
```
nano superset/config.py
```
<p align="center">
  <img src="https://user-images.githubusercontent.com/47904083/118299002-83181680-b4e0-11eb-88d0-c63d6d640bf3.png">
</p>

```
superset init
```

4. Parar e iniciar el contenedor
```
docker stop superset
docker start superset
```

#### Apache Superset - Añadir token mapbox

1. Inicio de sesión interactiva en docker superset
```
docker exec -u 0 -it superset /bin/bash
```
2. Actualización de repos de apt e instalación de nano para edición de config.py
```
apt-get update
apt-get install nano
```
3. Edición de config.py de Superset para añadir el token de mapbox
```
nano superset/config.py
```
4. Editar la variable MAPBOX_API_KEY y añadir el token
```
pk.eyJ1IjoianZjaWQxNyIsImEiOiJja290c3QwaG8wMDE0MnFrM216cWU2NTB3In0._R5Txs8HuuMCAOSsCkflrw
```
<p align="center">
  <img src="https://user-images.githubusercontent.com/47904083/118623376-7b9a8b00-b7c8-11eb-900b-295385d17548.png">
</p>

```
superset init
```

5. Parar e iniciar el contenedor
```
docker stop superset
docker start superset
```


## Autores :black_nib:

* **Eliana Patricia Aray Cappello** - [earay17](https://github.com/earay17)
* **Yomar Costa Orellana** - [Yomiquesh](https://github.com/Yomiquesh)
* **Diego Vázquez Baptista** -  [dvbaptista17](https://github.com/dvbaptista17)
* **José Manuel Viñas Cid** -  [josemanuelvinhas](https://github.com/josemanuelvinhas)
