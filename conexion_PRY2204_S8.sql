-- USUARIO PRY2204_S8 - ANTONIO GONZÁLEZ --

DROP TABLE detalle_venta CASCADE CONSTRAINTS;

DROP TABLE venta CASCADE CONSTRAINTS;

DROP TABLE producto CASCADE CONSTRAINTS;

DROP TABLE proveedor CASCADE CONSTRAINTS;

DROP TABLE marca CASCADE CONSTRAINTS;

DROP TABLE categoria CASCADE CONSTRAINTS;

DROP TABLE empleado CASCADE CONSTRAINTS;

DROP TABLE administrativo CASCADE CONSTRAINTS;

DROP TABLE vendedor CASCADE CONSTRAINTS;

DROP TABLE afp CASCADE CONSTRAINTS;

DROP TABLE salud CASCADE CONSTRAINTS;

DROP TABLE medio_pago CASCADE CONSTRAINTS;

DROP TABLE comuna CASCADE CONSTRAINTS;

DROP TABLE region CASCADE CONSTRAINTS;

DROP SEQUENCE seq_salud;

DROP SEQUENCE seq_empleado;

              --- CREACION DE TABLAS ---


CREATE TABLE detalle_venta (
    id_venta    INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad    NUMBER(4) NOT NULL
);

CREATE TABLE venta (
    id_venta    INT
        GENERATED ALWAYS AS IDENTITY ( START WITH 5050 INCREMENT BY 3 )
    NOT NULL,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER(10) NOT NULL,
    id_mpago    INT NOT NULL,
    id_empleado INT NOT NULL
);

CREATE TABLE producto (
    id_producto     INT NOT NULL,
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER NOT NULL,
    origen_nacional CHAR(1) NOT NULL,
    stock_minimo    NUMBER(3) NOT NULL,
    activo          CHAR(1) NOT NULL,
    id_marca        INT NOT NULL,
    id_categoria    INT NOT NULL,
    id_proveedor    INT NOT NULL
);

CREATE TABLE proveedor (
    id_proveedor     INT NOT NULL,
    nombre_proveedor VARCHAR2(150) NOT NULL,
    rut_proveedor    NUMBER(8) NOT NULL,
    dv_rut           CHAR(1) NOT NULL,
    telefono         VARCHAR2(10) NOT NULL,
    email            VARCHAR2(200) NOT NULL,
    direccion        VARCHAR2(200) NOT NULL,
    id_comuna        INT NOT NULL
);

CREATE TABLE marca (
    id_marca     INT NOT NULL,
    nombre_marca VARCHAR2(50) NOT NULL
);

CREATE TABLE categoria (
    id_categoria     INT NOT NULL,
    nombre_categoria VARCHAR2(255) NOT NULL
);

CREATE TABLE empleado (
    id_empleado        INT NOT NULL,
    rut_empleado       NUMBER(8) NOT NULL,
    dv_rut             CHAR(1) NOT NULL,
    nombre_empleado    VARCHAR2(25) NOT NULL,
    apellido_paterno   VARCHAR2(25) NOT NULL,
    apellido_materno   VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base        NUMBER(10) NOT NULL,
    bono_jefatura      NUMBER(10),
    activo             CHAR(1) NOT NULL,
    tipo_empleado      VARCHAR2(25) NOT NULL,
    cod_empleado       INT,
    id_salud           INT NOT NULL,
    id_afp             INT NOT NULL
);

CREATE TABLE administrativo (
    id_empleado INT NOT NULL
);

CREATE TABLE vendedor (
    id_empleado    INT NOT NULL,
    comision_venta NUMBER(5, 2) NOT NULL
);

CREATE TABLE afp (
    id_afp  INT
        GENERATED ALWAYS AS IDENTITY ( START WITH 210 INCREMENT BY 6 )
    NOT NULL,
    nom_afp VARCHAR2(255) NOT NULL
);

CREATE TABLE salud (
    id_salud  INT NOT NULL,
    nom_salud VARCHAR2(40) NOT NULL
);

CREATE TABLE medio_pago (
    id_mpago     INT NOT NULL,
    nombre_mpago VARCHAR2(50) NOT NULL
);

CREATE TABLE comuna (
    id_comuna  INT NOT NULL,
    nom_comuna VARCHAR2(100) NOT NULL,
    id_region  INT NOT NULL
);

CREATE TABLE region (
    id_region  INT NOT NULL,
    nom_region VARCHAR2(255) NOT NULL
);

          
          --- CREACION DE PRIMARY KEY ---


ALTER TABLE detalle_venta ADD CONSTRAINT pk_detalle_venta PRIMARY KEY ( id_venta,
                                                                        id_producto );

ALTER TABLE venta ADD CONSTRAINT pk_venta PRIMARY KEY ( id_venta );

ALTER TABLE producto ADD CONSTRAINT pk_producto PRIMARY KEY ( id_producto );

ALTER TABLE proveedor ADD CONSTRAINT pk_proveedor PRIMARY KEY ( id_proveedor );

ALTER TABLE marca ADD CONSTRAINT pk_marca PRIMARY KEY ( id_marca );

ALTER TABLE categoria ADD CONSTRAINT pk_categoria PRIMARY KEY ( id_categoria );

ALTER TABLE empleado ADD CONSTRAINT pk_empleado PRIMARY KEY ( id_empleado );

ALTER TABLE administrativo ADD CONSTRAINT pk_administrativo PRIMARY KEY ( id_empleado );

ALTER TABLE vendedor ADD CONSTRAINT pk_vendedor PRIMARY KEY ( id_empleado );

ALTER TABLE afp ADD CONSTRAINT pk_afp PRIMARY KEY ( id_afp );

ALTER TABLE salud ADD CONSTRAINT pk_salud PRIMARY KEY ( id_salud );

ALTER TABLE medio_pago ADD CONSTRAINT pk_medio_pago PRIMARY KEY ( id_mpago );

ALTER TABLE comuna ADD CONSTRAINT pk_comuna PRIMARY KEY ( id_comuna );

ALTER TABLE region ADD CONSTRAINT pk_region PRIMARY KEY ( id_region );
  
         
         --- CREACION DE FOREIGN KEY ---
         
         
-- detalle_venta ? venta
ALTER TABLE detalle_venta
    ADD CONSTRAINT fk_detalle_venta_venta FOREIGN KEY ( id_venta )
        REFERENCES venta ( id_venta );

-- detalle_venta ? producto
ALTER TABLE detalle_venta
    ADD CONSTRAINT fk_detalle_venta_producto FOREIGN KEY ( id_producto )
        REFERENCES producto ( id_producto );

-- venta ? medio_pago
ALTER TABLE venta
    ADD CONSTRAINT fk_venta_medio_pago FOREIGN KEY ( id_mpago )
        REFERENCES medio_pago ( id_mpago );

-- venta ? empleado
ALTER TABLE venta
    ADD CONSTRAINT fk_venta_empleado FOREIGN KEY ( id_empleado )
        REFERENCES empleado ( id_empleado );

-- producto ? marca
ALTER TABLE producto
    ADD CONSTRAINT fk_producto_marca FOREIGN KEY ( id_marca )
        REFERENCES marca ( id_marca );

-- producto ? categoria
ALTER TABLE producto
    ADD CONSTRAINT fk_producto_categoria FOREIGN KEY ( id_categoria )
        REFERENCES categoria ( id_categoria );

-- producto ? proveedor
ALTER TABLE producto
    ADD CONSTRAINT fk_producto_proveedor FOREIGN KEY ( id_proveedor )
        REFERENCES proveedor ( id_proveedor );

-- proveedor ? comuna
ALTER TABLE proveedor
    ADD CONSTRAINT fk_proveedor_comuna FOREIGN KEY ( id_comuna )
        REFERENCES comuna ( id_comuna );

-- comuna ? region
ALTER TABLE comuna
    ADD CONSTRAINT fk_comuna_region FOREIGN KEY ( id_region )
        REFERENCES region ( id_region );

-- administrativo ? empleado
ALTER TABLE administrativo
    ADD CONSTRAINT fk_administrativo_empleado FOREIGN KEY ( id_empleado )
        REFERENCES empleado ( id_empleado );

-- vendedor ? empleado
ALTER TABLE vendedor
    ADD CONSTRAINT fk_vendedor_empleado FOREIGN KEY ( id_empleado )
        REFERENCES empleado ( id_empleado );

-- empleado ? salud
ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_salud FOREIGN KEY ( id_salud )
        REFERENCES salud ( id_salud );

-- empleado ? afp
ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_afp FOREIGN KEY ( id_afp )
        REFERENCES afp ( id_afp );

-- empleado ? empleado (jerarquía)
ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_cod_empleado FOREIGN KEY ( cod_empleado )
        REFERENCES empleado ( id_empleado );
       
        
       --- CREACION DE RESTRICCIONES UNICAS Y CHECK ---

ALTER TABLE proveedor ADD CONSTRAINT un_proveedor_email UNIQUE ( email );

ALTER TABLE marca ADD CONSTRAINT un_marca_nombre UNIQUE ( nombre_marca );

ALTER TABLE empleado ADD CONSTRAINT ck_sueldo_base CHECK ( sueldo_base >= 400000 );

ALTER TABLE vendedor
    ADD CONSTRAINT ck_comision_venta CHECK ( comision_venta >= 0
                                             AND comision_venta <= 0.25 );

ALTER TABLE producto ADD CONSTRAINT ck_stock_minimo CHECK ( stock_minimo >= 3 );

ALTER TABLE detalle_venta ADD CONSTRAINT ck_cantidad_minima CHECK ( cantidad >= 1 );


       --- CREACION DE SECUENCIAS --- 

CREATE SEQUENCE seq_salud START WITH 2050 INCREMENT BY 10 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_empleado START WITH 750 INCREMENT BY 3 NOCACHE NOCYCLE;


        --- POBLAMIENTO DE TABLAS ---
 
        --- REGION ---
INSERT INTO region (id_region,nom_region)
VALUES (1,'Región Metropolitana');

INSERT INTO region (id_region,nom_region)
VALUES (2,'Valparaíso');

INSERT INTO region (id_region,nom_region)
VALUES (3,'Biobío');

INSERT INTO region (id_region,nom_region)
VALUES (4,'Los Lagos');

         --- PREVISION SALUD ---
INSERT INTO salud (id_salud,nom_salud)
VALUES (seq_salud.NEXTVAL,'Fonasa');

INSERT INTO salud (id_salud,nom_salud)
VALUES (seq_salud.NEXTVAL,'Isapre Colmena');

INSERT INTO salud (id_salud,nom_salud)
VALUES (seq_salud.NEXTVAL,'Isapre Banmédica');

INSERT INTO salud (id_salud,nom_salud)
VALUES (seq_salud.NEXTVAL,'Isapre Cruz Blanca');

          --- AFP ---  
INSERT INTO afp (nom_afp)
VALUES ('AFP Habitat');

INSERT INTO afp (nom_afp)
VALUES ('AFP Cuprum');

INSERT INTO afp (nom_afp)
VALUES ('AFP Provida');

INSERT INTO afp (nom_afp)
VALUES ('AFP PlanVital');

          --- MEDIO DE PAGO ---        
INSERT INTO medio_pago (id_mpago,nombre_mpago)
VALUES (11,'Efectivo');         
 
INSERT INTO medio_pago (id_mpago,nombre_mpago)
VALUES (12,'Tarjeta Débito');   

INSERT INTO medio_pago (id_mpago,nombre_mpago)
VALUES (13,'Tarjeta Crédito');   

INSERT INTO medio_pago (id_mpago,nombre_mpago)
VALUES (14,'Cheque');   

        --- EMPLEADO ---
INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 11111111, '1', 'Marcela','González', 'Pérez', TO_DATE('15-03-2022', 'DD-MM-YYYY'),
950000, 80000, 'S', 'Administrativo',NULL, 2050, 210 );

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 22222222, '2', 'José','Muñoz', 'Ramírez', TO_DATE('10-07-2021', 'DD-MM-YYYY'),
900000, 75000, 'S', 'Administrativo',NULL, 2060, 216);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 33333333, '3', 'Verónica','Soto', 'Alarcón', TO_DATE('05-01-2020', 'DD-MM-YYYY'),
880000, 70000, 'S', 'Vendedor',NULL, 2060, 228);


INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 44444444, '4', 'Luis','Reyes', 'Fuentes', TO_DATE('01-04-2023', 'DD-MM-YYYY'),
560000, NULL, 'S', 'Vendedor',NULL, 2070, 228);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 55555555, '5', 'Claudia','Fernández', 'Lagos', TO_DATE('15-04-2023', 'DD-MM-YYYY'),
600000, NULL, 'S', 'Vendedor',NULL, 2070, 216);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 66666666, '6', 'Carlos','Navarro', 'Vega', TO_DATE('01-05-2023', 'DD-MM-YYYY'),
610000, NULL, 'S', 'Administrativo',NULL, 2060, 210);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 77777777, '7', 'Javiera','Pino', 'Rojas', TO_DATE('10-05-2023', 'DD-MM-YYYY'),
650000, NULL, 'S', 'Administrativo',NULL, 2050, 210);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 88888888, '8', 'Diego','Mella', 'Contreras', TO_DATE('12-05-2023', 'DD-MM-YYYY'),
620000, NULL, 'S', 'Vendedor',NULL, 2060, 216);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 99999999, '9', 'Fernanda','Salas', 'Herrera', TO_DATE('18-05-2023', 'DD-MM-YYYY'),
570000, NULL, 'S', 'Vendedor',NULL, 2070, 228);

INSERT INTO empleado (id_empleado, rut_empleado, dv_rut, nombre_empleado, apellido_paterno, apellido_materno, 
fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado,cod_empleado, id_salud, id_afp) 
VALUES (seq_empleado.NEXTVAL, 10101010, '0', 'Tomás','Vidal', 'Espinoza', TO_DATE('01-06-2023', 'DD-MM-YYYY'),
530000, NULL, 'S', 'Vendedor',NULL, 2050, 222);

             --- VENTA ---
INSERT INTO venta (fecha_venta, total_venta,id_mpago,id_empleado)
VALUES (TO_DATE('12-05-2023', 'DD-MM-YYYY'),225990,12,771);

INSERT INTO venta (fecha_venta, total_venta,id_mpago,id_empleado)
VALUES (TO_DATE('23-10-2023', 'DD-MM-YYYY'),524990,13,777);

INSERT INTO venta (fecha_venta, total_venta,id_mpago,id_empleado)
VALUES (TO_DATE('17-02-2023', 'DD-MM-YYYY'),466990,11,759);

-- INFORME UNO:
SELECT
  e.id_empleado AS "IDENTIFICADOR",
  e.nombre_empleado || ' ' || e.apellido_paterno || ' ' || e.apellido_materno AS "NOMBRE COMPLETO",
  e.sueldo_base AS "SALARIO",
  e.bono_jefatura AS "BONIFICACION",
  e.sueldo_base + e.bono_jefatura AS "SALARIO SIMULADO"
FROM empleado e
WHERE e.activo = 'S'
  AND e.bono_jefatura IS NOT NULL
ORDER BY
  e.sueldo_base + e.bono_jefatura DESC,
  e.apellido_paterno DESC;

-- INFROME DOS:
SELECT
  e.nombre_empleado || ' ' || e.apellido_paterno || ' ' || e.apellido_materno AS "EMPLEADO",
  e.sueldo_base AS "SUELDO",
  e.sueldo_base * + 0.08 AS "POSIBLE AUMENTO",
  e.sueldo_base * 1.08 AS "SALARIO SIMULADO"
FROM empleado e
WHERE e.sueldo_base BETWEEN 550000 AND 800000
ORDER BY e.sueldo_base ASC;

