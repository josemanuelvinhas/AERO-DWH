DROP DATABASE IF EXISTS AERO_DWH;
CREATE DATABASE AERO_DWH;
USE AERO_DWH;

DROP TABLE IF EXISTS DIM_PERSONAS;
CREATE TABLE DIM_PERSONAS (
    PERSONA_KEY INT(10) NOT NULL AUTO_INCREMENT,
    DNI_EMPLEADO VARCHAR(9) DEFAULT NULL,
    PASAPORTE VARCHAR(20) DEFAULT NULL,
    SEXO VARCHAR(10) DEFAULT NULL,
    PROFESION VARCHAR(30) DEFAULT NULL,
    CARGO VARCHAR(30) DEFAULT NULL,
    SUELDO INTEGER DEFAULT NULL,
    PROCEDENCIA VARCHAR(50) DEFAULT NULL,
    PROVINCIA_ORIGEN VARCHAR(50) DEFAULT NULL,
    LOCALIDAD_ORIGEN VARCHAR(50) DEFAULT NULL,
    PAIS_ORIGEN VARCHAR(50) DEFAULT NULL,
    EDAD INTEGER DEFAULT NULL,
    DISCAPACIDAD INTEGER DEFAULT NULL,
    VALIDO_DESDE DATE DEFAULT NULL,
    VALIDO_HASTA DATE DEFAULT NULL,
    VERSION SMALLINT DEFAULT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY (PERSONA_KEY)
);

DROP TABLE IF EXISTS DIM_FECHA;
CREATE TABLE DIM_FECHA(
    FECHA_KEY INT(10) NOT NULL,
    FECHA DATE NOT NULL,
    DIA_EN_MES INTEGER NOT NULL,
    DIA_NOMBRE VARCHAR(10) NOT NULL,
    SEMANA_EN_ANHO INTEGER NOT NULL,
    MES_NUMERO INTEGER NOT NULL,
    MES_NOMBRE VARCHAR(15) NOT NULL,
    TRIMESTRE INTEGER NOT NULL,
    ANHO INTEGER NOT NULL,
    ES_FIN_DE_SEMANA CHAR(10) NOT NULL,
    PRIMARY KEY (FECHA_KEY)
);

DROP TABLE IF EXISTS DIM_ORIGEN_DESTINO;
CREATE TABLE DIM_ORIGEN_DESTINO (
    ORIGEN_DESTINO_KEY INT(10) NOT NULL AUTO_INCREMENT,  
    ID_RECORRIDO SMALLINT NOT NULL,
    CIUDAD_ORIGEN VARCHAR(50) NOT NULL,
    CIUDAD_DESTINO VARCHAR(50) NOT NULL,
    PAIS_ORIGEN VARCHAR(50) NOT NULL,
    PAIS_DESTINO VARCHAR(50) NOT NULL,
    NUMERO_HABITANTES_PAIS VARCHAR(50) NOT NULL,
    ANHO INTEGER NOT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY (ORIGEN_DESTINO_KEY)
);

DROP TABLE IF EXISTS DIM_HORA;
CREATE TABLE DIM_HORA (
    HORA_KEY INT(10) NOT NULL,
    HORA TIME NOT NULL,
    HORAS24 tinyint(3) DEFAULT NULL,
    HORAS12 tinyint(3) DEFAULT NULL,
    MINUTOS tinyint(3) DEFAULT NULL,
    AM_PM char(3) DEFAULT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY (HORA_KEY)
);

DROP TABLE IF EXISTS DIM_VIAJE;
CREATE TABLE DIM_VIAJE (
    VIAJE_KEY INT(10) NOT NULL AUTO_INCREMENT,
    ID_BILLETE SMALLINT NOT NULL, 
    MOTIVO_VIAJE VARCHAR(50) NOT NULL,
    PRECIO_BILLETE REAL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY(VIAJE_KEY)
);


DROP TABLE IF EXISTS DIM_EVENTO;
CREATE TABLE DIM_EVENTO ( 
    EVENTO_KEY INT(10) NOT NULL AUTO_INCREMENT,
    EVENTO VARCHAR(50) NOT NULL,
    FECHA_EVENTO DATE NOT NULL,
    HORA_EVENTO TIME NOT NULL,
    PAIS VARCHAR(50) NOT NULL,
    CIUDAD VARCHAR(50) NOT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY(EVENTO_KEY)
);


DROP TABLE IF EXISTS DIM_METEO;
CREATE TABLE DIM_METEO (
    METEO_KEY INT(10) NOT NULL AUTO_INCREMENT,
    PRECIPITACIONES VARCHAR(50) NOT NULL,
    TEMPERATURA VARCHAR(50) NOT NULL,
    PRESION VARCHAR(50) NOT NULL,
    MICROCLIMA VARCHAR(50) NOT NULL,
    CLIMA VARCHAR(50) NOT NULL,
    CIUDAD VARCHAR(50) NOT NULL,
    PAIS VARCHAR(50) NOT NULL,
    DIA Date NOT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY (METEO_KEY)
);

DROP TABLE IF EXISTS FACT_VUELOS;
CREATE TABLE FACT_VUELOS (
    NUMERO_PASAJEROS INTEGER NOT NULL,
    NUMERO_BILLETES INTEGER NOT NULL,
    CANTIDAD INTEGER NOT NULL,
    IMPORTE_TOTAL_BILLETES INTEGER NOT NULL,
    PERSONA_KEY INTEGER NOT NULL,
    METEO_KEY INTEGER NOT NULL,
    VIAJE_KEY INTEGER NOT NULL,
    ORIGEN_DESTINO_KEY INTEGER NOT NULL,
    FECHA_KEY INTEGER NOT NULL,
    HORA_KEY INTEGER NOT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    KEY DIM_PERSONAS_HECHO_VUELOS_FK (PERSONA_KEY),
    KEY DIM_METEO_HECHO_VUELOS_FK (METEO_KEY),
    KEY DIM_VIAJE_HECHO_VUELOS_FK (VIAJE_KEY),
    KEY DIM_ORIGEN_DESTINO_HECHO_VUELOS_FK (ORIGEN_DESTINO_KEY),
    KEY DIM_FECHA_HECHO_VUELOS_FK (FECHA_KEY),
    KEY DIM_HORA_HECHO_VUELOS_FK (HORA_KEY)
);

DROP USER 'user_dwh'@'localhost';
CREATE USER 'user_dwh'@'localhost' IDENTIFIED BY 'user_dwh';
GRANT ALL PRIVILEGES ON * . * TO 'user_dwh'@'localhost';
FLUSH PRIVILEGES;
