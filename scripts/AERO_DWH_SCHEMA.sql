DROP DATABASE IF EXISTS AERO_DWH;
CREATE DATABASE AERO_DWH;
USE AERO_DWH;

DROP TABLE IF EXISTS DIM_PERSONA;
CREATE TABLE DIM_PERSONA (
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

DROP TABLE IF EXISTS DIM_LUGAR;
CREATE TABLE DIM_LUGAR (
    LUGAR_KEY VARCHAR(50) NOT NULL,  
    ID_RECORRIDO SMALLINT,
    CIUDAD VARCHAR(50) NOT NULL,
    PAIS VARCHAR(50) NOT NULL,
    NUMERO_HABITANTES_PAIS VARCHAR(50) NOT NULL,
    CLIMA VARCHAR(50) NOT NULL,
    MICROCLIMA VARCHAR(50) NOT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY (LUGAR_KEY)
);

DROP TABLE IF EXISTS DIM_EVENTO;
CREATE TABLE DIM_EVENTO ( 
    EVENTO_KEY INT(10) NOT NULL AUTO_INCREMENT,
    EVENTO VARCHAR(50) NOT NULL,
    FECHA_EVENTO DATE NOT NULL,
    PAIS_EVENTO VARCHAR(50) NOT NULL,
    CIUDAD_EVENTO VARCHAR(50) NOT NULL,
    PRIMARY KEY(EVENTO_KEY)
);


DROP TABLE IF EXISTS DIM_MOTIVO;
CREATE TABLE DIM_MOTIVO (
    MOTIVO_KEY INT(10) NOT NULL AUTO_INCREMENT,  
    MOTIVO VARCHAR(50) NOT NULL,
    ULTIMA_ACTUALIZACION timestamp,
    PRIMARY KEY (MOTIVO_KEY)
);

DROP TABLE IF EXISTS FACT_VIAJE;
CREATE TABLE FACT_VIAJE (
    VIAJE_KEY INT(10), 
    IMPORTE_BILLETE INTEGER NOT NULL,
    RETRASO DOUBLE NOT NULL,
    DISTANCIA_RECORRIDO INTEGER NOT NULL,
    DESTINO_REPETIDO CHAR(4),
    PERSONA_KEY INT(10) NOT NULL,
    FECHA_KEY INT(10) NOT NULL,
    LUGAR_ORIGEN_KEY INT(10) NOT NULL,
    LUGAR_DESTINO_KEY INT(10) NOT NULL,
    EVENTO_KEY INT(10),
    MOTIVO_KEY INT(10) NOT NULL,
    FOREIGN KEY (PERSONA_KEY) REFERENCES DIM_PERSONA(PERSONA_KEY),
    FOREIGN KEY (FECHA_KEY) REFERENCES DIM_FECHA(FECHA_KEY),
    FOREIGN KEY (LUGAR_ORIGEN_KEY) REFERENCES DIM_LUGAR(LUGAR_KEY),
    FOREIGN KEY (LUGAR_DESTINO_KEY) REFERENCES DIM_LUGAR(LUGAR_KEY),
    FOREIGN KEY (EVENTO_KEY) REFERENCES DIM_EVENTO(EVENTO_KEY),
    FOREIGN KEY (MOTIVO_KEY) REFERENCES DIM_MOTIVO(MOTIVO_KEY),
    KEY DIM_PERSONA_HECHO_VUELOS_FK (PERSONA_KEY),
    KEY DIM_FECHA_HECHO_VUELOS_FK (FECHA_KEY),
    KEY DIM_LUGAR_ORIGEN_HECHO_VUELOS_FK (LUGAR_ORIGEN_KEY),
    KEY DIM_LUGAR_DESTINO_HECHO_VUELOS_FK (LUGAR_DESTINO_KEY),
    KEY DIM_EVENTO_HECHO_VUELOS_FK (EVENTO_KEY),
    KEY DIM_MOTIVO_HECHO_VUELOS_FK (MOTIVO_KEY),
    ULTIMA_ACTUALIZACION timestamp
);

DROP USER 'user_dwh'@'localhost';
CREATE USER 'user_dwh'@'localhost' IDENTIFIED BY 'user_dwh';
GRANT ALL PRIVILEGES ON * . * TO 'user_dwh'@'localhost';
FLUSH PRIVILEGES;
