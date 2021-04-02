DROP DATABASE IF EXISTS AERO_DWH;
CREATE DATABASE AERO_DWH;
USE AERO_DWH;

DROP TABLE IF EXISTS DIM_PERSONAS;
CREATE TABLE DIM_PERSONAS (
    CLAVE_PERSONA INT(10) NOT NULL AUTO_INCREMENT,
    DNI_EMPLEADO VARCHAR(9) NOT NULL,
    PASAPORTE VARCHAR(20) NOT NULL,
    SEXO VARCHAR(10) NOT NULL,
    PROFESION VARCHAR(30) NOT NULL,
    CARGO VARCHAR(30) NOT NULL,
    SUELDO DOUBLE NOT NULL,
    PROCEDENCIA VARCHAR(50) NOT NULL,
    PROVINCIA_ORIGEN VARCHAR(50) NOT NULL,
    LOCALIDAD_ORIGEN VARCHAR(50) NOT NULL,
    PAIS_ORIGEN VARCHAR(50) NOT NULL,
    EDAD INTEGER NOT NULL,
    DISCAPACIDAD INTEGER NOT NULL,
	ULTIMA_ACTUALIZACION DATETIME NOT NULL DEFAULT '2020-01-01 00:00:00',
    PRIMARY KEY (CLAVE_PERSONA)
);

DROP TABLE IF EXISTS DIM_FECHA;
CREATE TABLE DIM_FECHA(
    CLAVE_FECHA INT(10) NOT NULL,
    FECHA DATE NOT NULL,
    DIA_EN_MES INTEGER NOT NULL,
    DIA_NOMBRE VARCHAR(10) NOT NULL,
    SEMANA_EN_ANHO INTEGER NOT NULL,
    MES_NUMERO INTEGER NOT NULL,
    MES_NOMBRE VARCHAR(15) NOT NULL,
    TRIMESTRE INTEGER NOT NULL,
    AÑO INTEGER NOT NULL,
    ES_FIN_DE_SEMANA CHAR(10) NOT NULL,
    PRIMARY KEY (CLAVE_FECHA)
);

DROP TABLE IF EXISTS DIM_ORIGEN_DESTINO;
CREATE TABLE DIM_ORIGEN_DESTINO (
    CLAVE_ORIGEN_DESTINO INT(10) NOT NULL AUTO_INCREMENT,  
    ID_RECORRIDO SMALLINT NOT NULL,
    CIUDAD_ORIGEN VARCHAR(50) NOT NULL,
    CIUDAD_DESTINO VARCHAR(50) NOT NULL,
    PAIS_ORIGEN VARCHAR(50) NOT NULL,
    PAIS_DESTINO VARCHAR(50) NOT NULL,
    NUMERO_HABITANTES_PAIS INTEGER NOT NULL,
    ULTIMA_ACTUALIZACION DATETIME NOT NULL DEFAULT '2020-01-01 00:00:00',
    PRIMARY KEY (CLAVE_ORIGEN_DESTINO)
);

DROP TABLE IF EXISTS DIM_HORA;
CREATE TABLE DIM_HORA (
    CLAVE_HORA INT(10) NOT NULL,
    HORA TIME NOT NULL,
    HORAS24 tinyint(3) DEFAULT NULL,
    HORAS12 tinyint(3) DEFAULT NULL,
    MINUTOS tinyint(3) DEFAULT NULL,
    AM_PM char(3) DEFAULT NULL,
    PRIMARY KEY (CLAVE_HORA)
);

DROP TABLE IF EXISTS DIM_VIAJE;
CREATE TABLE DIM_VIAJE (
    CLAVE_VIAJE INT(10) NOT NULL AUTO_INCREMENT,
    ID_VUELO SMALLINT NOT NULL,
    ID_RECORRIDO SMALLINT NOT NULL,
    EVENTO VARCHAR(50) NOT NULL,
    MOTIVO_VIAJE VARCHAR(50) NOT NULL,
    DURACION_REAL SMALLINT NOT NULL,
    DURACION_ESTIMADA SMALLINT NOT NULL,
    DISTANCIA INTEGER NOT NULL,
    TIPO_VUELO VARCHAR(50) NOT NULL,
    ULTIMA_ACTUALIZACION DATETIME NOT NULL DEFAULT '2020-01-01 00:00:00',
    PRIMARY KEY(CLAVE_VIAJE)
);

DROP TABLE IF EXISTS DIM_METEO;
CREATE TABLE DIM_METEO (
    CLAVE_METEO INT(10) NOT NULL AUTO_INCREMENT,
    PRECIPITACIONES INTEGER NOT NULL,
    TEMPERATURA INTEGER NOT NULL,
    PRESION VARCHAR(50) NOT NULL,
    MICROCLIMA VARCHAR(50) NOT NULL,
    CLIMA VARCHAR(50) NOT NULL,
    CIUDAD VARCHAR(50) NOT NULL,
    PAIS VARCHAR(50) NOT NULL,
    DIA Date NOT NULL,
    ULTIMA_ACTUALIZACION DATETIME NOT NULL DEFAULT '2020-01-01 00:00:00',
    PRIMARY KEY (CLAVE_METEO)
);

DROP TABLE IF EXISTS FACT_VUELOS;
CREATE TABLE FACT_VUELOS (
    NUMERO_PASAJEROS INTEGER NOT NULL,
    NUMERO_BILLETES INTEGER NOT NULL,
    CANTIDAD INTEGER NOT NULL,
    IMPORTE_TOTAL_BILLETES INTEGER NOT NULL,
    CLAVE_PERSONA INTEGER NOT NULL,
    CLAVE_METEO INTEGER NOT NULL,
    CLAVE_VIAJE INTEGER NOT NULL,
    CLAVE_ORIGEN_DESTINO INTEGER NOT NULL,
    CLAVE_FECHA INTEGER NOT NULL,
    CLAVE_HORA INTEGER NOT NULL,
    KEY DIM_PERSONAS_HECHO_VUELOS_FK (CLAVE_PERSONA),
    KEY DIM_METEO_HECHO_VUELOS_FK (CLAVE_METEO),
    KEY DIM_VIAJE_HECHO_VUELOS_FK (CLAVE_VIAJE),
    KEY DIM_ORIGEN_DESTINO_HECHO_VUELOS_FK (CLAVE_ORIGEN_DESTINO),
    KEY DIM_FECHA_HECHO_VUELOS_FK (CLAVE_FECHA),
    KEY DIM_HORA_HECHO_VUELOS_FK (CLAVE_HORA)
);

DROP USER 'user_dwh'@'localhost';
CREATE USER 'user_dwh'@'localhost' IDENTIFIED BY 'user_dwh';
GRANT ALL PRIVILEGES ON * . * TO 'user_dwh'@'localhost';
FLUSH PRIVILEGES;
