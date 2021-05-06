# AERO-DWH

## Instalación y configuración :wrench:

### XAMPP

* [XAMPP 7.2.9](https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.2.9/)

### Apache Superset con Docker

1. Descargar la imagen apache/superset

```
docker pull apache/superset
```
2. Creación de la imagen personalizada a partir del Dockerfile situado en [/docker](https://github.com/josemanuelvinhas/AERO-DWH/tree/main/docker). El siguiente comando debe ser ejecutado donde esté situado el Dockerfile

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
4. Acceder a la url [http://localhost:8080/login/](http://localhost:8080/login/)
```
Username: admin

Passwrod: admin
```
5. En la base de datos debe existir un usuario con privilegios 
```
GRANT ALL PRIVILEGES ON *.* TO 'superset' IDENTIFIED BY 'superset';
```
6. Se puede probar la conexión desde superset usando la siguiente URI:
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



## Autores :black_nib:

* **Eliana Patricia Aray Cappello** - [earay17](https://github.com/earay17)
* **Yomar Costa Orellana** - [Yomiquesh](https://github.com/Yomiquesh)
* **Diego Vázquez Baptista** -  [dvbaptista17](https://github.com/dvbaptista17)
* **José Manuel Viñas Cid** -  [josemanuelvinhas](https://github.com/josemanuelvinhas)
