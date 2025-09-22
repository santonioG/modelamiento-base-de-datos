
      --- semana 6 - ANTONIO GONZALEZ - USUARIO: PRY2204_s6 ---

                    --- BORRADO DE OBJETOS ---

DROP TABLE receta CASCADE CONSTRAINTS;
DROP TABLE tipo_receta CASCADE CONSTRAINTS;
DROP TABLE diagnostico CASCADE CONSTRAINTS;
DROP TABLE pago CASCADE CONSTRAINTS;
DROP TABLE medicamento CASCADE CONSTRAINTS;
DROP TABLE tipo_medicamento CASCADE CONSTRAINTS;
DROP TABLE via_administracion CASCADE CONSTRAINTS;
DROP TABLE paciente CASCADE CONSTRAINTS;
DROP TABLE medico CASCADE CONSTRAINTS;
DROP TABLE especialidad CASCADE CONSTRAINTS;
DROP TABLE digitador CASCADE CONSTRAINTS;
DROP TABLE banco CASCADE CONSTRAINTS;
DROP TABLE dosis CASCADE CONSTRAINTS;
DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;
DROP TABLE metodo_pago CASCADE CONSTRAINTS;

                 --- CREACION DE TABLAS ---

CREATE TABLE receta (

cod_receta INT NOT NULL,
observaciones VARCHAR2 (500),
fecha_emision DATE DEFAULT SYSDATE NOT NULL,
fecha_vencimiento DATE,
rut_medico NUMBER(8) NOT NULL,
rut_pac NUMBER(8) NOT NULL,
cod_diagnostico INT NOT NULL,
id_tipo_receta INT NOT NULL,

CONSTRAINT receta1_pk PRIMARY KEY (cod_receta)

);

CREATE TABLE tipo_receta (

id_tipo_receta INT NOT NULL,
nombre_tipo VARCHAR2 (50) NOT NULL,

CONSTRAINT tipo_receta_pk PRIMARY KEY (id_tipo_receta)

);

CREATE TABLE diagnostico (

cod_diagnostico INT NOT NULL,
nombre VARCHAR2 (100),

CONSTRAINT diagnostico_pk PRIMARY KEY (cod_diagnostico)

);

CREATE TABLE medico (

rut_medico NUMBER (8) NOT NULL, 
dv_medico CHAR (1) NOT NULL, 
pnombre VARCHAR2 (25) NOT NULL,
segnombre VARCHAR2 (25),
primapellido VARCHAR2 (25) NOT NULL,
segapellido VARCHAR2 (25),
celular NUMBER (9) NOT NULL, 
id_especialidad INT,

CONSTRAINT medico_ck_dv CHECK (REGEXP_LIKE(dv_medico, '^[0-9Kk]$')),
CONSTRAINT medico_uq_celular UNIQUE (celular),
CONSTRAINT medico_pk PRIMARY KEY (rut_medico)

);

CREATE TABLE especialidad (

id_especialidad INT GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1  NOT NULL,
nombre VARCHAR2 (50) NOT NULL,

CONSTRAINT especialidad_pk PRIMARY KEY (id_especialidad)

);

CREATE TABLE paciente (

rut_pac NUMBER (8) NOT NULL,
dv_pac CHAR (1) NOT NULL,
pnombre VARCHAR2 (25) NOT NULL,
segnombre VARCHAR2 (25),
primapellido VARCHAR2 (25) NOT NULL,
segapellido VARCHAR2 (25),
edad DATE NOT NULL,
telefono NUMBER (11) NOT NULL,
direccion VARCHAR2 (100) NOT NULL,
id_comuna INT,

CONSTRAINT pac_ck_dv CHECK (REGEXP_LIKE(dv_pac, '^[0-9Kk]$')),
CONSTRAINT paciente_pk PRIMARY KEY (rut_pac)

);

CREATE TABLE comuna (

id_comuna INT GENERATED ALWAYS AS IDENTITY START WITH 1101 INCREMENT BY 1 NOT NULL,
nombre VARCHAR2 (50) NOT NULL,
id_ciudad INT,

CONSTRAINT comuna_pk PRIMARY KEY (id_comuna)

); 

CREATE TABLE ciudad (

id_ciudad INT NOT NULL,
nombre VARCHAR2 (50) NOT NULL,
id_region INT,

CONSTRAINT ciudad_pk PRIMARY KEY (id_ciudad)

); 

CREATE TABLE region (

id_region INT NOT NULL,
nombre VARCHAR2 (50) NOT NULL,
CONSTRAINT region_pk PRIMARY KEY (id_region)

); 

CREATE TABLE medicamento (

cod_medicamento INT NOT NULL,
nombre VARCHAR2 (30) NOT NULL,
stock_med INT NOT NULL,
dosis_recomendada VARCHAR2 (50) NOT NULL,
id_tipo INT,
id_via_admin INT,

CONSTRAINT medicamento_pk PRIMARY KEY (cod_medicamento)

);

CREATE TABLE tipo_medicamento (

id_tipo INT NOT NULL,
nombre VARCHAR2 (50),

CONSTRAINT tipo_medicamento_pk PRIMARY KEY (id_tipo)

);

CREATE TABLE via_administracion (

id_via_admin INT NOT NULL,
nombre VARCHAR2 (50) NOT NULL,

CONSTRAINT via_administracion_pk PRIMARY KEY (id_via_admin)

);

CREATE TABLE dosis (

cod_medicamento INT NOT NULL,
cod_receta INT NOT NULL,
descripcion_dosis VARCHAR2 (50) NOT NULL,

CONSTRAINT dosis_pk PRIMARY KEY (cod_medicamento,cod_receta)

);

CREATE TABLE pago (

cod_boleta INT NOT NULL,
fecha_pago DATE DEFAULT SYSDATE NOT NULL,
fecha_vencimiento DATE,
monto_total NUMBER (10,2) NOT NULL,
monto_pagado NUMBER (10,2) NOT NULL,
id_banco INT, 
cod_receta INT,
rut_digitador INT,
id_metodo_pago INT,

CONSTRAINT pago_pk PRIMARY KEY (cod_boleta)

);

CREATE TABLE metodo_pago(

id_metodo_pago INT NOT NULL,
nombre VARCHAR2 (50) NOT NULL,

CONSTRAINT metodo_pago_pk PRIMARY KEY (id_metodo_pago)

);

CREATE TABLE banco (

id_banco INT NOT NULL,
nombre VARCHAR2 (50) NOT NULL,

CONSTRAINT banco_pk PRIMARY KEY (id_banco)

);

CREATE TABLE digitador (

rut_digitador INT NOT NULL,
dv_digitador CHAR (1) NOT NULL,
pnombre VARCHAR2 (25) NOT NULL,
papellido VARCHAR2 (25) NOT NULL,

CONSTRAINT digitador_ck_dv CHECK (REGEXP_LIKE(dv_digitador, '^[0-9Kk]$')),
CONSTRAINT digitador_pk PRIMARY KEY (rut_digitador)

);

                     --- CLAVES FORANEAS --- 

-- receta ? tipo_receta, diagnostico, medico, paciente
ALTER TABLE receta ADD CONSTRAINT receta_fk1 FOREIGN KEY (rut_medico) REFERENCES medico(rut_medico);
ALTER TABLE receta ADD CONSTRAINT receta_fk2 FOREIGN KEY (rut_pac) REFERENCES paciente(rut_pac);
ALTER TABLE receta ADD CONSTRAINT receta_fk3 FOREIGN KEY (cod_diagnostico) REFERENCES diagnostico(cod_diagnostico);
ALTER TABLE receta ADD CONSTRAINT receta_fk4 FOREIGN KEY (id_tipo_receta) REFERENCES tipo_receta(id_tipo_receta);

-- paciente ? comuna
ALTER TABLE paciente ADD CONSTRAINT paciente_fk1 FOREIGN KEY (id_comuna) REFERENCES comuna(id_comuna);

-- comuna ? ciudad
ALTER TABLE comuna ADD CONSTRAINT comuna_fk1 FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad);

-- ciudad ? region
ALTER TABLE ciudad ADD CONSTRAINT ciudad_fk1 FOREIGN KEY (id_region) REFERENCES region(id_region);

-- medicamento ? tipo_medicamento, via_administracion
ALTER TABLE medicamento ADD CONSTRAINT medicamento_fk1 FOREIGN KEY (id_tipo) REFERENCES tipo_medicamento(id_tipo);
ALTER TABLE medicamento ADD CONSTRAINT medicamento_fk2 FOREIGN KEY (id_via_admin) REFERENCES via_administracion(id_via_admin);

-- dosis ? receta, medicamento
ALTER TABLE dosis ADD CONSTRAINT dosis_fk1 FOREIGN KEY (cod_receta) REFERENCES receta(cod_receta);
ALTER TABLE dosis ADD CONSTRAINT dosis_fk2 FOREIGN KEY (cod_medicamento) REFERENCES medicamento(cod_medicamento);

-- pago ? receta, banco, digitador
ALTER TABLE pago ADD CONSTRAINT pago_fk1 FOREIGN KEY (cod_receta) REFERENCES receta(cod_receta);
ALTER TABLE pago ADD CONSTRAINT pago_fk2 FOREIGN KEY (id_banco) REFERENCES banco(id_banco);
ALTER TABLE pago ADD CONSTRAINT pago_fk3 FOREIGN KEY (rut_digitador) REFERENCES digitador(rut_digitador);
ALTER TABLE pago ADD CONSTRAINT pago_fk4 FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago);

-- 
ALTER TABLE medico ADD CONSTRAINT medico_fk1 FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad);


                             --- VALIDACIONES CASO 2 ---

-- se agrega precio y se agrega check al mismo en la tabla medicamento
ALTER TABLE medicamento ADD (precio_unitario NUMBER (10,0) NOT NULL);
ALTER TABLE medicamento ADD CONSTRAINT medicamento_ck_precio CHECK (precio_unitario BETWEEN 1000 AND 2000000);

-- se agrega check a la tabla metodo de pago para restringir los tipos de pago
ALTER TABLE metodo_pago ADD CONSTRAINT metodo_pago_ck CHECK (nombre IN ('EFECTIVO','TARJETA','TRANSFERENCIA'));

-- se elimina la columna edad y se agrega fecha de nacimiento
ALTER TABLE paciente DROP COLUMN edad;
ALTER TABLE paciente ADD (fecha_nacimiento DATE NOT NULL);


