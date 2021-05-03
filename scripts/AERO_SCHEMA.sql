SET NAMES 'utf8';
DROP DATABASE IF EXISTS AERO;
CREATE DATABASE AERO;
USE AERO;
ALTER DATABASE AERO CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE RECORRIDO (
	ID_RECORRIDO SMALLINT,
	ORIGEN VARCHAR (3) NOT NULL,
	DESTINO VARCHAR (3) NOT NULL,
	CIUDAD_DESTINO VARCHAR (50) NOT NULL,
	CIUDAD_ORIGEN VARCHAR (50) NOT NULL,
	PAIS_ORIGEN VARCHAR(50),
	PAIS_DESTINO VARCHAR (50),
	DISTANCIA INTEGER NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT valid_destino CHECK (REGEXP_LIKE (DESTINO, '^[A-Z]{3}')),    
    CONSTRAINT valid_origen CHECK (REGEXP_LIKE (ORIGEN, '^[A-Z]{3}')),
	CONSTRAINT RECORRIDO_PK PRIMARY KEY (ID_RECORRIDO)
);

CREATE TABLE AEROLINEA(
    ID_AEROLINEA SMALLINT NOT NULL,
    TELEFONO VARCHAR (20) NOT NULL,
    NOMBRE VARCHAR (50) NOT NULL,
    DIRECCION VARCHAR (100) NOT NULL,
	PRIMARY KEY (ID_AEROLINEA)
);

CREATE TABLE TRIPULACION(
   ID_TRIPULACION VARCHAR(7),
   NUMTRIPULANTES SMALLINT(2) NOT NULL,
   ID_AEROLINEA SMALLINT NOT NULL,
   CONSTRAINT FK_TRIP FOREIGN KEY (ID_AEROLINEA) REFERENCES AEROLINEA (ID_AEROLINEA) ON DELETE CASCADE,
   CONSTRAINT PK_TRIP PRIMARY KEY (ID_TRIPULACION)
);

CREATE TABLE AVION (
	MATRICULA VARCHAR(30),
	MARCA VARCHAR(30) NOT NULL,
	MODELO VARCHAR(30) NOT NULL,
	CAPACIDAD SMALLINT(3) NOT NULL,
	FECHALIMITEREVISION DATE NOT NULL,
	ID_RECORRIDO SMALLINT NOT NULL, 
	ID_AEROLINEA SMALLINT NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT FK_AVION_AEROLINEA FOREIGN KEY (ID_AEROLINEA) REFERENCES AEROLINEA (ID_AEROLINEA) ON DELETE CASCADE,
	CONSTRAINT PK_AVION PRIMARY KEY (MATRICULA)
);

CREATE TABLE EMPLEADO(
	DNI_EMPLEADO VARCHAR(9) ,
	NUSS VARCHAR (13) NOT NULL,
	CARGO VARCHAR(30),
	PROFESION VARCHAR(30),
	SUELDO DOUBLE NULL,
	NOMBRE VARCHAR (30) NOT NULL,
	APELLIDOS VARCHAR (30) NOT NULL,
	TELEFONO VARCHAR (20) NOT NULL,
	FECHA_NACIMIENTO DATE NOT NULL,
	CORREO VARCHAR(50) NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT valid_dni CHECK (REGEXP_LIKE(DNI_EMPLEADO, '[0-9]{8}[A-Z]{1}')),
    CONSTRAINT valid_nuss CHECK (REGEXP_LIKE(NUSS, '[A-Z]{4}[0-9]{9}')),
	CONSTRAINT PK_EMPLEADO PRIMARY KEY (DNI_EMPLEADO),
	CONSTRAINT unull_empleado UNIQUE (NUSS)
);

CREATE TABLE PROPIETARIO(
	ID_PROPIETARIO VARCHAR(10),
	TELEFONO VARCHAR(20) NOT NULL,
	CONSTRAINT valid_id_propietario CHECK (REGEXP_LIKE(ID_PROPIETARIO, '^[A-Z]{2}[0-9]{2}')),
	CONSTRAINT PK_PROP PRIMARY KEY (ID_PROPIETARIO)
);

CREATE TABLE RECURSOIT(
    ID_RECURSOIT VARCHAR(5),
    LICENCIA VARCHAR(30) NOT NULL,
    ID_PROPIETARIO VARCHAR(10),
    CONSTRAINT FK_PROP FOREIGN KEY (ID_PROPIETARIO) REFERENCES PROPIETARIO (ID_PROPIETARIO) ON DELETE SET NULL,
	CONSTRAINT PK_RECURSO PRIMARY KEY (ID_RECURSOIT)
);

CREATE TABLE DEPARTAMENTO(
		ID_DEPARTAMENTO SMALLINT,
		NOMBRE VARCHAR(20) NOT NULL, 
		DIRECCION VARCHAR(30) NOT NULL, 
		PRESUPUESTO VARCHAR(20) NOT NULL,
		ID_PROPIETARIO VARCHAR(10),
        CONSTRAINT FK_DEP FOREIGN KEY (ID_PROPIETARIO) REFERENCES PROPIETARIO (ID_PROPIETARIO) ON DELETE SET NULL,
		CONSTRAINT PK_DEPT PRIMARY KEY (ID_DEPARTAMENTO)
);

CREATE TABLE TELEFONO(
	NUMERO VARCHAR(20) NOT NULL,
	ID_DEPARTAMENTO SMALLINT NOT NULL,
    PRIMARY KEY (NUMERO, ID_DEPARTAMENTO),
	CONSTRAINT FK_TELEFONO FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO) ON DELETE CASCADE
);

CREATE TABLE EMPLEADOAEROLINEA(
	DNI_EMP_AEROLINEA VARCHAR(9),
    ID_AEROLINEA SMALLINT NOT NULL,
	CONSTRAINT FK_EMPAEROLINEA FOREIGN KEY (DNI_EMP_AEROLINEA) REFERENCES EMPLEADO(DNI_EMPLEADO),
	CONSTRAINT FK_EMP_AEROLINEA FOREIGN KEY (ID_AEROLINEA) REFERENCES AEROLINEA (ID_AEROLINEA),
	CONSTRAINT PK_EMPAEROLINEA PRIMARY KEY (DNI_EMP_AEROLINEA)
);

ALTER TABLE EMPLEADOAEROLINEA ADD ID_SUPERVISOR  VARCHAR(9) REFERENCES EMPLEADOAEROLINEA(DNI_EMP_AEROLINEA);


CREATE TABLE EMPLEADOAEROPUERTO(
    DNI_EMP_AEROPUERTO VARCHAR(9),
	CONSTRAINT PK_EMPAIRPORT PRIMARY KEY (DNI_EMP_AEROPUERTO),
	CONSTRAINT FK_EMPAIRPORT FOREIGN KEY (DNI_EMP_AEROPUERTO) REFERENCES EMPLEADO (DNI_EMPLEADO),
	CONTRATO VARCHAR(10) NOT NULL,
	DIRECCION VARCHAR(50) NOT NULL,
    JORNADA VARCHAR(10) NOT NULL,   
    JEFE_DEPARTAMENTO SMALLINT,
	ID_DEPARTAMENTO SMALLINT NOT NULL, 
	CONSTRAINT FK_EMP_INDEP FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO) ON DELETE CASCADE,
	CONSTRAINT FK_EMP_JEFEDEP FOREIGN KEY (JEFE_DEPARTAMENTO) REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO) ON DELETE CASCADE
);

    
CREATE TABLE OPERACIONES_PISTA(
    ID_OPERACIONES_PISTA SMALLINT,
	NUMVEHICULOS VARCHAR (3) NOT NULL ,
	UNIFORME VARCHAR(30) NOT NULL ,
	CONSTRAINT FK_OPERACIONES FOREIGN KEY (ID_OPERACIONES_PISTA) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO) ON DELETE CASCADE,
	CONSTRAINT PK_OPERACIONES PRIMARY KEY (ID_OPERACIONES_PISTA)
);

CREATE TABLE CONTROLAEREO( 
    ID_CONTROLAEREO SMALLINT,
	CONSTRAINT FK_CONTROLAEREO FOREIGN KEY (ID_CONTROLAEREO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO) ON DELETE CASCADE,
	COMUNICACION_TORRE VARCHAR(20) NOT NULL,
	CONSTRAINT PK_CONTROLAEREO PRIMARY KEY (ID_CONTROLAEREO)
);

CREATE TABLE TORRECONTROL(
	ID_TORRECONTROL CHAR NOT NULL PRIMARY KEY,
    TELEFONO VARCHAR (10) NOT NULL,
	POSICIONGEOGRAFICA VARCHAR(50) NOT NULL, 
	SERVICIO VARCHAR(30) NOT NULL, 
    ID_CONTROLAEREO SMALLINT,
    ID_PROPIETARIO VARCHAR(10),
	CONSTRAINT valid_idtorrecontrol CHECK (REGEXP_LIKE(ID_TORRECONTROL, '^[A-Z]{1}$')),
    CONSTRAINT FK_PROPI FOREIGN KEY (ID_PROPIETARIO) REFERENCES PROPIETARIO (ID_PROPIETARIO) ON DELETE SET NULL,
	CONSTRAINT FK_TORRES FOREIGN KEY (ID_CONTROLAEREO) REFERENCES CONTROLAEREO (ID_CONTROLAEREO) ON DELETE SET NULL
);

CREATE TABLE TERMINAL(
  ID_TERMINAL SMALLINT,
  SUPERFICIE VARCHAR(5) NOT NULL ,
  CONTROL_SEGURIDAD VARCHAR(30) NOT NULL,
  CONSTRAINT PK_TERMINAL PRIMARY KEY(ID_TERMINAL)
);

CREATE TABLE PUERTA_EMBARQUE(
	ID_TERMINAL SMALLINT NOT NULL,
	NUMPUERTAEMBARQUE VARCHAR(3) NOT NULL,
	CONSTRAINT PK_PUERTA PRIMARY KEY (ID_TERMINAL, NUMPUERTAEMBARQUE),
	CONSTRAINT valid_NUMPUERTAEMBARQUE CHECK (REGEXP_LIKE(NUMPUERTAEMBARQUE, '^[A-Z][0-9]+')),
    CONSTRAINT FK_PUERTA FOREIGN KEY (ID_TERMINAL) REFERENCES TERMINAL (ID_TERMINAL) ON DELETE CASCADE
);

CREATE TABLE PISTA (
	ID_PISTA SMALLINT NOT NULL PRIMARY KEY,
	LONGITUD SMALLINT NOT NULL,
	ID_TORRECONTROL CHAR,
	ID_OPERACIONES_PISTA SMALLINT,
	CONSTRAINT FK_PISTA_TW FOREIGN KEY (ID_TORRECONTROL) REFERENCES TORRECONTROL (ID_TORRECONTROL) ON DELETE SET NULL,
	CONSTRAINT FK_PISTA_OP FOREIGN KEY (ID_OPERACIONES_PISTA) REFERENCES OPERACIONES_PISTA (ID_OPERACIONES_PISTA) ON DELETE SET NULL
);

CREATE TABLE VUELO (
    ID_VUELO SMALLINT,
	MATRICULA VARCHAR(30)  NOT NULL ,
	ID_RECORRIDO SMALLINT NOT NULL ,
	HORA_SALIDA_ESTIMADA VARCHAR(8) NOT NULL ,
	HORA_LLEGADA_ESTIMADA VARCHAR(8) NOT NULL ,
	DURACION_ESTIMADA FLOAT NOT NULL,
	HORA_SALIDA_REAL VARCHAR(8) NOT NULL ,
	HORA_LLEGADA_REAL VARCHAR(8) NOT NULL ,
	DURACION_REAL FLOAT NOT NULL,
	FECHA DATE NOT NULL,
	TIPO_VUELO VARCHAR(30)  NOT NULL ,
    ID_PISTA SMALLINT NOT NULL,
	ID_AEROLINEA SMALLINT NOT NULL,
	ID_TERMINAL SMALLINT NOT NULL,
	ID_TRIPULACION VARCHAR(7) NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT UNIQUE_VUELO UNIQUE (MATRICULA,ID_RECORRIDO,FECHA),
	CONSTRAINT FKVUELO_PISTA FOREIGN KEY (ID_PISTA) REFERENCES PISTA (ID_PISTA) ON DELETE CASCADE,
    CONSTRAINT FKVUELO_TERMINAL FOREIGN KEY (ID_TERMINAL) REFERENCES TERMINAL (ID_TERMINAL) ON DELETE CASCADE,
    CONSTRAINT FKVUELO_AEROLINEA FOREIGN KEY (ID_AEROLINEA) REFERENCES AEROLINEA (ID_AEROLINEA) ON DELETE CASCADE,
    CONSTRAINT FKVUELO_AVION FOREIGN KEY (MATRICULA) REFERENCES AVION (MATRICULA) ON DELETE CASCADE,
    CONSTRAINT FKVUELO_RECORRIDO FOREIGN KEY (ID_RECORRIDO) REFERENCES RECORRIDO (ID_RECORRIDO) ON DELETE CASCADE,
    CONSTRAINT FKVUELO_TRIPULACION FOREIGN KEY (ID_TRIPULACION) REFERENCES TRIPULACION (ID_TRIPULACION) ON DELETE CASCADE,
	CONSTRAINT VUELO_PK PRIMARY KEY (ID_VUELO)
);


CREATE TABLE PASAJERO (
	PASAPORTE VARCHAR(20),
	NOMBRE VARCHAR(20) NOT NULL,
	APELLIDOS VARCHAR(20) NOT NULL,
	SEXO VARCHAR(10) NOT NULL,
	FECHA_NACIMIENTO DATE NOT NULL ,
	CORREO VARCHAR(20) NOT NULL,
	PAIS_ORIGEN VARCHAR(50) NOT NULL,
	LOCALIDAD_ORIGEN VARCHAR(50) NOT NULL,
	PROVINCIA_ORIGEN VARCHAR(50) NOT NULL,
	PROCEDENCIA VARCHAR(50),
	DIRECCION VARCHAR(50) NOT NULL,
	TELEFONO VARCHAR(10) NOT NULL,
	DISCAPACIDAD INTEGER,
	PROFESION VARCHAR(30) NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 	CONSTRAINT PK_AEROLINEA PRIMARY KEY (PASAPORTE)
);

CREATE TABLE BILLETE (
	ID_BILLETE VARCHAR(10) NOT NULL PRIMARY KEY,
	ID_VUELO SMALLINT NOT NULL, 
	ID_PASAJERO VARCHAR(20) NOT NULL,
	MOTIVO_VIAJE VARCHAR(40) NOT NULL,
	PRECIO REAL NOT NULL,
	FECHA_COMPRA DATE NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT FK_BILLPASAJ FOREIGN KEY (ID_PASAJERO) REFERENCES PASAJERO (PASAPORTE) ON DELETE CASCADE, 
    CONSTRAINT FK_BILLVUELO FOREIGN KEY (ID_VUELO) REFERENCES VUELO (ID_VUELO) ON DELETE CASCADE 
);
 


CREATE TABLE PASAJEROVIP(
	DNI_EMPLEADO VARCHAR(20) NOT NULL,
	PASAPORTE VARCHAR(20) NOT NULL,
	DESCUENTO DECIMAL(5,2) NOT NULL,
	ULTIMA_ACTUALIZACION timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT FKCLIENTEVIP_EMPLEADO FOREIGN KEY(DNI_EMPLEADO) REFERENCES EMPLEADO (DNI_EMPLEADO) ON DELETE CASCADE,
    CONSTRAINT FKCLIENTEVIP_PASAJERO FOREIGN KEY (PASAPORTE) REFERENCES PASAJERO (PASAPORTE) ON DELETE CASCADE,
	PRIMARY KEY (DNI_EMPLEADO,PASAPORTE)
);


CREATE TABLE HANGAR(
 	ID_HANGAR SMALLINT  NOT NULL PRIMARY KEY,
 	EQUIPAMIENTO VARCHAR(30),
 	DIRECCION VARCHAR(30) NOT NULL,
 	CAPACIDAD VARCHAR(30)  NOT NULL, 
 	ID_AEROLINEA SMALLINT,
 	CONSTRAINT FK_HANGAR FOREIGN KEY (ID_AEROLINEA) REFERENCES AEROLINEA (ID_AEROLINEA) ON DELETE SET NULL 
 );


CREATE TABLE VEHICULO(
	MATRICULA VARCHAR(10),
	MARCA VARCHAR (20) NOT NULL,
	MODELO VARCHAR (20) NOT NULL, 
	ID_DEPARTAMENTO SMALLINT,
	 CONSTRAINT valid_matricula CHECK (REGEXP_LIKE (MATRICULA, '(\d{4})([A-Z]{3})')),
    CONSTRAINT FK_VEHICULO FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO) ON DELETE SET NULL,
	CONSTRAINT PK_VEHICULO PRIMARY KEY (MATRICULA)
);

CREATE TABLE FOLLOWME(
	MATRICULA VARCHAR(10),
    COMUNICACION_TCONTROL VARCHAR(20) NOT NULL ,
	CONSTRAINT FK_FOLLOWME FOREIGN KEY (MATRICULA) REFERENCES VEHICULO (MATRICULA) ON DELETE CASCADE,
	CONSTRAINT PK_FOLLOWME PRIMARY KEY (MATRICULA)
);

CREATE TABLE TRANSPORTE_PERSONAL(
	MATRICULA VARCHAR(10),
	CAPACIDAD VARCHAR(2) NOT NULL ,
	CONSTRAINT FK_TRANSPERSONAL FOREIGN KEY (MATRICULA) REFERENCES VEHICULO (MATRICULA) ON DELETE CASCADE,
	CONSTRAINT PK_TRANSPERSONAL PRIMARY KEY (MATRICULA)
);


CREATE TABLE TRANSPORTE_PERSONAS(
	MATRICULA VARCHAR(10),
	CAPACIDAD VARCHAR(2) NOT NULL ,
	CONSTRAINT FK_TRANSPERSONAS FOREIGN KEY (MATRICULA) REFERENCES VEHICULO (MATRICULA) ON DELETE CASCADE,
	CONSTRAINT PK_TRANSPERSONAS PRIMARY KEY (MATRICULA)
);

CREATE TABLE TRANSPORTE_CARGA(
	MATRICULA VARCHAR(10),
	PESOMAXIMO VARCHAR(5) NOT NULL, 
	CONSTRAINT FK_TRANSCARGA FOREIGN KEY (MATRICULA) REFERENCES VEHICULO (MATRICULA) ON DELETE CASCADE,
	CONSTRAINT PK_TRANSCARGA PRIMARY KEY (MATRICULA)
);


CREATE TABLE TECNICO(
	ID_TECNICO SMALLINT, 
	NUMVEHICULOS SMALLINT NOT NULL ,
	CONSTRAINT FK_TECNICO FOREIGN KEY (ID_TECNICO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO) ON DELETE CASCADE,
	CONSTRAINT PK_TECNICO PRIMARY KEY (ID_TECNICO)
);

CREATE TABLE REVISION(
    ID_REVISION SMALLINT,
	FECHA DATE NOT NULL ,
	EVALUACION VARCHAR(20) NOT NULL,
	DIAGNOSTICO VARCHAR (30) NOT NULL, 
	MATRICULA VARCHAR(30)  NOT NULL,
    ID_TECNICO SMALLINT NOT NULL,
	CONSTRAINT FK_DEPREVISION FOREIGN KEY (ID_TECNICO) REFERENCES TECNICO (ID_TECNICO) ON DELETE CASCADE,
    CONSTRAINT FK_AVIONREVISION FOREIGN KEY (MATRICULA) REFERENCES AVION (MATRICULA) ON DELETE CASCADE,
	CONSTRAINT PK_DEPREVISION PRIMARY KEY (ID_REVISION)
);

CREATE TABLE SEGURIDAD(
	ID_SEGURIDAD SMALLINT,
	UNIFORMES VARCHAR(40) NOT NULL,
	UNIDADESCANINAS SMALLINT,
	CONSTRAINT FK_SEGURIDAD_K FOREIGN KEY (ID_SEGURIDAD) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO) ON DELETE CASCADE,
	CONSTRAINT PK_SEGURIDAD PRIMARY KEY (ID_SEGURIDAD)
);

CREATE TABLE SEGURIDAD_GESTIONA_TERMINAL(
	ID_SEGURIDAD SMALLINT,
	ID_TERMINAL SMALLINT,
	CONSTRAINT FKID_SEGURIDAD FOREIGN KEY (ID_SEGURIDAD) REFERENCES SEGURIDAD (ID_SEGURIDAD) ON DELETE CASCADE,
    CONSTRAINT FKID_TERMINAL FOREIGN KEY (ID_TERMINAL) REFERENCES TERMINAL (ID_TERMINAL) ON DELETE CASCADE,
	PRIMARY KEY (ID_SEGURIDAD,ID_TERMINAL)
);

DROP USER IF EXISTS 'user_aero'@'localhost';					   
CREATE USER 'user_aero'@'localhost' IDENTIFIED BY 'user_aero';
GRANT ALL PRIVILEGES ON * . * TO 'user_aero'@'localhost';
FLUSH PRIVILEGES;					 
