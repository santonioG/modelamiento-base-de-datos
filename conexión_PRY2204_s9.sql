
-- USUARIO PRY2204 - ANTONIO GONZÁLEZ --

-- BORRADO DE TABLAS --

DROP TABLE asignacion_turno CASCADE CONSTRAINTS;
DROP TABLE orden_mantencion CASCADE CONSTRAINTS;
DROP TABLE tecnico CASCADE CONSTRAINTS;
DROP TABLE operario CASCADE CONSTRAINTS;
DROP TABLE jefe_turno CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE maquina CASCADE CONSTRAINTS;
DROP TABLE tipo_maquina CASCADE CONSTRAINTS;
DROP TABLE turno CASCADE CONSTRAINTS;
DROP TABLE planta CASCADE CONSTRAINTS;
DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE afp CASCADE CONSTRAINTS;
DROP TABLE salud CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;
DROP SEQUENCE seq_region;

-- CREACION DE TABLAS --

CREATE TABLE region (
  id_region INT NOT NULL,
  nombre_region VARCHAR2(50) NOT NULL
);

CREATE TABLE comuna (
  id_comuna INT GENERATED ALWAYS AS IDENTITY (START WITH 1050 INCREMENT BY 5) NOT NULL,
  nombre_comuna VARCHAR2(50) NOT NULL,
  region_id INT NOT NULL
);

CREATE TABLE planta (
  id_planta INT NOT NULL,
  nombre_planta VARCHAR2(50) NOT NULL,
  direccion VARCHAR2(100) NOT NULL,
  comuna_id INT NOT NULL
);

CREATE TABLE tipo_maquina (
  id_tipo INT NOT NULL,
  nombre_tipo VARCHAR2(50) NOT NULL
);

CREATE TABLE maquina (
  id_maquina INT NOT NULL,
  id_planta INT NOT NULL,
  nombre VARCHAR2(50) NOT NULL,
  estado_activo CHAR(1) DEFAULT 'S' NOT NULL,
  tipo_id INT NOT NULL
);

CREATE TABLE afp (
 id_afp INT NOT NULL,
 nombre_afp VARCHAR2(50) NOT NULL
);

CREATE TABLE salud (
 id_salud INT NOT NULL,
 salud_nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE empleado (
  id_empleado INT NOT NULL,
  rut NUMBER(8) NOT NULL,
  dv_rut CHAR(1) NOT NULL,
  prim_nombre VARCHAR2(50) NOT NULL,
  seg_nombre VARCHAR2(50),
  prim_apellido VARCHAR2(50) NOT NULL,
  seg_apellido VARCHAR2(50),
  fecha_contratacion DATE NOT NULL,
  sueldo_base NUMBER(10,2) NOT NULL,
  estado_activo CHAR(1) DEFAULT 'S' NOT NULL,
  planta_id INT NOT NULL,
  id_afp INT NOT NULL,
  id_salud INT NOT NULL,
  jefe_directo INT
);

CREATE TABLE jefe_turno (
  id_empleado INT NOT NULL,
  area_responsabilidad VARCHAR2(50) NOT NULL,
  max_operarios NUMBER NOT NULL
);

CREATE TABLE operario (
  id_empleado INT NOT NULL,
  categoria_proceso VARCHAR2(30) NOT NULL,
  certificacion VARCHAR2(50),
  horas_turno NUMBER DEFAULT 8 NOT NULL
);

CREATE TABLE tecnico (
  id_empleado INT NOT NULL,
  especialidad VARCHAR2(30) NOT NULL,
  nivel_certificacion VARCHAR2(30),
  tiempo_respuesta NUMBER NOT NULL
);

CREATE TABLE turno (
  id_turno VARCHAR2(10) NOT NULL,
  nombre_turno VARCHAR2(20) NOT NULL,
  hora_inicio CHAR(5) NOT NULL,
  hora_fin CHAR(5) NOT NULL
);

CREATE TABLE orden_mantencion (
  id_orden INT NOT NULL,
  maquina_id INT NOT NULL,
  planta_id INT NOT NULL,
  tecnico_id INT NOT NULL,
  fecha_programada DATE NOT NULL,
  fecha_ejecucion DATE,
  descripcion VARCHAR2(200)
);

CREATE TABLE asignacion_turno (
  id_asignacion INT NOT NULL,
  fecha DATE NOT NULL,
  empleado_id INT NOT NULL,
  turno_id VARCHAR2(10) NOT NULL,
  maquina_id INT NOT NULL,
  planta_id INT NOT NULL,
  rol VARCHAR2(30) NOT NULL
);

-- CREACION DE PRIMARY KEY --

ALTER TABLE region ADD CONSTRAINT pk_region PRIMARY KEY (id_region);
ALTER TABLE comuna ADD CONSTRAINT pk_comuna PRIMARY KEY (id_comuna);
ALTER TABLE planta ADD CONSTRAINT pk_planta PRIMARY KEY (id_planta);
ALTER TABLE tipo_maquina ADD CONSTRAINT pk_tipo PRIMARY KEY (id_tipo);
ALTER TABLE maquina ADD CONSTRAINT pk_maquina PRIMARY KEY (id_maquina, id_planta);
ALTER TABLE afp ADD CONSTRAINT pk_afp PRIMARY KEY (id_afp);
ALTER TABLE salud ADD CONSTRAINT pk_salud PRIMARY KEY (id_salud);
ALTER TABLE empleado ADD CONSTRAINT pk_empleado PRIMARY KEY (id_empleado);
ALTER TABLE jefe_turno ADD CONSTRAINT pk_jefe PRIMARY KEY (id_empleado);
ALTER TABLE operario ADD CONSTRAINT pk_operario PRIMARY KEY (id_empleado);
ALTER TABLE tecnico ADD CONSTRAINT pk_tecnico PRIMARY KEY (id_empleado);
ALTER TABLE turno ADD CONSTRAINT pk_turno PRIMARY KEY (id_turno);
ALTER TABLE orden_mantencion ADD CONSTRAINT pk_orden PRIMARY KEY (id_orden);
ALTER TABLE asignacion_turno ADD CONSTRAINT pk_asignacion PRIMARY KEY (id_asignacion);

-- CREACION FOREIGN KEY --

ALTER TABLE comuna ADD CONSTRAINT fk_comuna_region
  FOREIGN KEY (region_id) REFERENCES region(id_region);

ALTER TABLE planta ADD CONSTRAINT fk_planta_comuna
  FOREIGN KEY (comuna_id) REFERENCES comuna(id_comuna);

ALTER TABLE maquina ADD CONSTRAINT fk_maquina_planta
  FOREIGN KEY (id_planta) REFERENCES planta(id_planta);

ALTER TABLE maquina ADD CONSTRAINT fk_maquina_tipo
  FOREIGN KEY (tipo_id) REFERENCES tipo_maquina(id_tipo);

ALTER TABLE empleado ADD CONSTRAINT fk_empleado_planta
  FOREIGN KEY (planta_id) REFERENCES planta(id_planta);

ALTER TABLE empleado ADD CONSTRAINT fk_empleado_afp
  FOREIGN KEY (id_afp) REFERENCES afp(id_afp);

ALTER TABLE empleado ADD CONSTRAINT fk_empleado_salud
  FOREIGN KEY (id_salud) REFERENCES salud(id_salud);

ALTER TABLE empleado ADD CONSTRAINT fk_empleado_jefe
  FOREIGN KEY (jefe_directo) REFERENCES empleado(id_empleado);

ALTER TABLE jefe_turno ADD CONSTRAINT fk_jefe_empleado
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);

ALTER TABLE operario ADD CONSTRAINT fk_operario_empleado
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);

ALTER TABLE tecnico ADD CONSTRAINT fk_tecnico_empleado
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);

ALTER TABLE orden_mantencion ADD CONSTRAINT fk_orden_maquina
  FOREIGN KEY (maquina_id, planta_id) REFERENCES maquina(id_maquina, id_planta);

ALTER TABLE orden_mantencion ADD CONSTRAINT fk_orden_tecnico
  FOREIGN KEY (tecnico_id) REFERENCES tecnico(id_empleado);

ALTER TABLE asignacion_turno ADD CONSTRAINT fk_asig_empleado
  FOREIGN KEY (empleado_id) REFERENCES empleado(id_empleado);

ALTER TABLE asignacion_turno ADD CONSTRAINT fk_asig_turno
  FOREIGN KEY (turno_id) REFERENCES turno(id_turno);

ALTER TABLE asignacion_turno ADD CONSTRAINT fk_asig_maquina
  FOREIGN KEY (maquina_id, planta_id) REFERENCES maquina(id_maquina, id_planta);

-- UNICOS EN CATALOGOS
ALTER TABLE region ADD CONSTRAINT unq_region_nombre UNIQUE (nombre_region);
ALTER TABLE tipo_maquina ADD CONSTRAINT unq_tipo_nombre UNIQUE (nombre_tipo);
ALTER TABLE turno ADD CONSTRAINT unq_turno_nombre UNIQUE (nombre_turno);
ALTER TABLE afp ADD CONSTRAINT unq_afp_nombre UNIQUE (nombre_afp);
ALTER TABLE salud ADD CONSTRAINT unq_salud_nombre UNIQUE (salud_nombre);

-- UNICO RUT + DV (para evitar duplicados)
ALTER TABLE empleado ADD CONSTRAINT unq_empleado_rut UNIQUE (rut, dv_rut);

-- CHECKS DE ESTADO
ALTER TABLE empleado ADD CONSTRAINT ck_empleado_estado CHECK (estado_activo IN ('S','N'));
ALTER TABLE maquina ADD CONSTRAINT ck_maquina_estado CHECK (estado_activo IN ('S','N'));

-- FECHAS ORDEN MANTENCION (fecha_ejecucion NULL o >= programada)
ALTER TABLE orden_mantencion ADD CONSTRAINT ck_orden_fechas
  CHECK (fecha_ejecucion IS NULL OR fecha_ejecucion >= fecha_programada);

-- RESTRICCION: empleado no puede tener más de un turno en la misma fecha
ALTER TABLE asignacion_turno ADD CONSTRAINT unq_asignacion_diaria UNIQUE (fecha, empleado_id);

-- POBLAMIENTO DE TABLAS --

-- Secuencia para REGION
CREATE SEQUENCE seq_region START WITH 21 INCREMENT BY 1;

INSERT INTO region (id_region, nombre_region) VALUES (seq_region.NEXTVAL, 'Región de Valparaíso');
INSERT INTO region (id_region, nombre_region) VALUES (seq_region.NEXTVAL, 'Región Metropolitana');

-- COMUNA
INSERT INTO comuna (nombre_comuna, region_id) VALUES ('Quilpué', 21);
INSERT INTO comuna (nombre_comuna, region_id) VALUES ('Maipú', 22);

INSERT INTO planta (id_planta, nombre_planta, direccion, comuna_id)
VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050);

INSERT INTO planta (id_planta, nombre_planta, direccion, comuna_id)
VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055);

INSERT INTO turno (id_turno, nombre_turno, hora_inicio, hora_fin)
VALUES ('M0715', 'Mañana', '07:00', '15:00');

INSERT INTO turno (id_turno, nombre_turno, hora_inicio, hora_fin)
VALUES ('N2307', 'Noche', '23:00', '07:00');

INSERT INTO turno (id_turno, nombre_turno, hora_inicio, hora_fin)
VALUES ('T1523', 'Tarde', '15:00', '23:00');

-- INFORME 1: turnos con inicio > 20:00 (desc)
SELECT  nombre_turno || ' ' || id_turno AS TURNO,
       hora_inicio AS ENTRADA,
       hora_fin AS SALIDA
FROM turno
WHERE hora_inicio > '20:00'
ORDER BY hora_inicio DESC;

-- INFORME 2: turnos diurnos 06:00–14:59 (asc)
SELECT nombre_turno || ' ' || id_turno || ' ' AS TURNO,
       hora_inicio AS ENTRADA,
       hora_fin AS SALIDA
FROM turno
WHERE hora_inicio BETWEEN '06:00' AND '14:59'
ORDER BY hora_inicio ASC;
