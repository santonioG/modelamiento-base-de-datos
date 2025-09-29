
           --- BORRADO DE TABLAS ---

DROP TABLE personal CASCADE CONSTRAINTS;
DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;
DROP TABLE compania CASCADE CONSTRAINTS;
DROP TABLE estado_civil CASCADE CONSTRAINTS;
DROP TABLE dominio CASCADE CONSTRAINTS;
DROP TABLE idioma CASCADE CONSTRAINTS;
DROP TABLE titulacion CASCADE CONSTRAINTS;
DROP TABLE titulo CASCADE CONSTRAINTS;
DROP TABLE genero CASCADE CONSTRAINTS;
DROP SEQUENCE seq_comuna;
DROP SEQUENCE seq_compania;
           
           --- CREACION DE TABLAS ---
           
CREATE TABLE region (

id_region INT GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2) NOT NULL,
nombre_region VARCHAR2 (50) NOT NULL

);

CREATE TABLE comuna (

id_comuna INT NOT NULL,
nombre_comuna VARCHAR2 (50) NOT NULL,
id_region INT NOT NULL

);

CREATE TABLE compania (

id_empresa INT NOT NULL,
nombre_empresa VARCHAR2 (100) NOT NULL,
calle VARCHAR2 (50) NOT NULL,
numeracion NUMBER (5) NOT NULL,
renta_promedio NUMBER (10,0) NOT NULL,
pct_aumento NUMBER (4,3),
id_comuna INT NOT NULL,
id_region INT NOT NULL

);

CREATE TABLE genero (

id_genero INT NOT NULL,
descripcion_genero VARCHAR2 (20) NOT NULL

);

CREATE TABLE estado_civil (

id_estado_civil INT NOT NULL,
descripcion_est_civil VARCHAR2 (25) NOT NULL

);

CREATE TABLE idioma (

id_idioma INT GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3) NOT NULL , 
nombre_idioma VARCHAR2 (50) NOT NULL

);

CREATE TABLE titulo (

id_titulo INT NOT NULL,
descrip_titulo VARCHAR2 (60) NOT NULL

);

CREATE TABLE personal (

rut_persona NUMBER (8) NOT NULL,
dv_persona CHAR (1) NOT NULL,
prim_nombre VARCHAR2 (50) NOT NULL,
seg_nombre VARCHAR2 (50),
prim_apellido VARCHAR2 (50) NOT NULL,
seg_apellido VARCHAR2 (50) NOT NULL,
fecha_contratacion DATE NOT NULL,
fecha_nacimiento DATE NOT NULL,
email VARCHAR2 (100),
calle VARCHAR2 (50) NOT NULL,
numeracion NUMBER (5) NOT NULL,
sueldo NUMBER (10,0) NOT NULL,
id_comuna INT NOT NULL,
id_region INT NOT NULL,
id_genero INT,
id_estado_civil INT,
id_empresa INT NOT NULL,
encargado_rut NUMBER (8)

);

CREATE TABLE titulacion (

id_titulo INT NOT NULL,
rut_persona NUMBER (8) NOT NULL,
fecha_titulacion DATE NOT NULL

);

CREATE TABLE dominio (

id_idioma INT NOT NULL,
rut_persona NUMBER (8) NOT NULL,
nivel CHAR (2) NOT NULL

); 
           
         --- CREACION PRIMARY KEY ---
         
ALTER TABLE region
  ADD CONSTRAINT pk_region PRIMARY KEY (id_region);
  
ALTER TABLE comuna
  ADD CONSTRAINT pk_comuna PRIMARY KEY (id_comuna, id_region);
  
ALTER TABLE compania
  ADD CONSTRAINT pk_compania PRIMARY KEY (id_empresa);  
     
ALTER TABLE genero
  ADD CONSTRAINT pk_genero PRIMARY KEY (id_genero);   
  
ALTER TABLE estado_civil
  ADD CONSTRAINT pk_estado_civil PRIMARY KEY (id_estado_civil);  

ALTER TABLE idioma
  ADD CONSTRAINT pk_idioma PRIMARY KEY (id_idioma);
  
ALTER TABLE titulo
  ADD CONSTRAINT pk_titulo PRIMARY KEY (id_titulo);  
  
ALTER TABLE personal
  ADD CONSTRAINT pk_rut_persona PRIMARY KEY (rut_persona);  
  
ALTER TABLE titulacion
  ADD CONSTRAINT pk_titulacion PRIMARY KEY (id_titulo, rut_persona);
  
ALTER TABLE dominio
  ADD CONSTRAINT pk_dominio PRIMARY KEY (id_idioma, rut_persona);  
  
  
         --- CREACION FOREIGN KEY ---
         
         
-- COMUNA --> REGION
ALTER TABLE comuna
  ADD CONSTRAINT fk_comuna_region
   FOREIGN KEY (id_region)
    REFERENCES region(id_region);

-- COMPANIA --> COMUNA (PK compuesta)
ALTER TABLE compania
  ADD CONSTRAINT fk_compania_comuna
   FOREIGN KEY (id_comuna, id_region)
    REFERENCES comuna(id_comuna, id_region);

-- PERSONAL --> COMPANIA
ALTER TABLE personal
  ADD CONSTRAINT fk_personal_compania
   FOREIGN KEY (id_empresa)
    REFERENCES compania(id_empresa);

-- PERSONAL --> COMUNA (PK compuesta)
ALTER TABLE personal
  ADD CONSTRAINT fk_personal_comuna
   FOREIGN KEY (id_comuna, id_region)
    REFERENCES comuna(id_comuna, id_region);

-- PERSONAL --> GENERO
ALTER TABLE personal
  ADD CONSTRAINT fk_personal_genero
   FOREIGN KEY (id_genero)
    REFERENCES genero(id_genero);

-- PERSONAL --> ESTADO_CIVIL
ALTER TABLE personal
  ADD CONSTRAINT fk_personal_estado_civil
   FOREIGN KEY (id_estado_civil)
    REFERENCES estado_civil(id_estado_civil);

-- PERSONAL --> PERSONAL (encargado)
ALTER TABLE personal
  ADD CONSTRAINT fk_personal_encargado
   FOREIGN KEY (encargado_rut)
    REFERENCES personal(rut_persona);

-- TITULACION --> TITULO
ALTER TABLE titulacion
  ADD CONSTRAINT fk_titulacion_titulo
   FOREIGN KEY (id_titulo)
    REFERENCES titulo(id_titulo);

-- TITULACION --> PERSONAL
ALTER TABLE titulacion
  ADD CONSTRAINT fk_titulacion_personal
   FOREIGN KEY (rut_persona)
    REFERENCES personal(rut_persona);

-- DOMINIO --> IDIOMA
ALTER TABLE dominio
  ADD CONSTRAINT fk_dominio_idioma
   FOREIGN KEY (id_idioma)
    REFERENCES idioma(id_idioma);

-- DOMINIO --> PERSONAL
ALTER TABLE dominio
  ADD CONSTRAINT fk_dominio_personal
   FOREIGN KEY (rut_persona)
    REFERENCES personal(rut_persona);
      
      
         --- CREACION DE RESTRICCIONES UNICAS Y CHECK ---
        
ALTER TABLE personal
 ADD CONSTRAINT unq_personal_email UNIQUE (email);
 
 ALTER TABLE compania
  ADD CONSTRAINT compania_un_nombre UNIQUE (nombre_empresa);
 
ALTER TABLE personal
 ADD CONSTRAINT ck_dv_persona CHECK (REGEXP_LIKE(dv_persona, '^[0-9Kk]$'));
 
 ALTER TABLE personal 
  ADD CONSTRAINT ck_sueldo_minimo CHECK (sueldo >= 450000);      

         
         -- CREACION DE SECUENCIAS --

-- Secuencia para COMUNA
CREATE SEQUENCE seq_comuna
  START WITH 1101
  INCREMENT BY 6
  NOCYCLE
  NOCACHE;

-- Secuencia para COMPANIA
CREATE SEQUENCE seq_compania
  START WITH 10
  INCREMENT BY 5
  NOCYCLE
  NOCACHE;

     
         -- POBLAMIENTO DE TABLAS --
         
             -- REGION --
             
INSERT INTO region (nombre_region) VALUES ('Arica y Parinacota');     
INSERT INTO region (nombre_region) VALUES ('Metropolitana');
INSERT INTO region (nombre_region) VALUES ('La Araucania');

             -- COMUNA --
             
INSERT INTO comuna (id_comuna, nombre_comuna, id_region)
VALUES (seq_comuna.NEXTVAL, 'Arica',7);             

INSERT INTO comuna (id_comuna, nombre_comuna, id_region)
VALUES (seq_comuna.NEXTVAL, 'Santiago',9);

INSERT INTO comuna (id_comuna, nombre_comuna, id_region)
VALUES (seq_comuna.NEXTVAL, 'Temuco',11);
             
             -- COMPANIA --
             
INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'CCyROJAS', 'Amapolas',506, 1857000, 0.5, 1101, 7);             

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'SenTTy', 'Los Alamos',3490, 897000, 0.025, 1101, 7);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'Praxia LTDA', 'Las Camelias',11098, 2157000, 0.035, 1107, 9);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'TIC spa', 'FLORES S.A',4357, 857000, NULL , 1107, 9);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'SANTANA LTDA', 'AVDA VIC. MACKENA',106, 757000, 0.015, 1101, 7);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'FLORES Y ASOCIADOS', 'PEDRO LATORRE',557, 589000, 0.015, 1107, 9);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D.32',509, 1857000, 0.025, 1113, 11);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA',206, 1857000, NULL , 1107, 9);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE',106, 957000, 0.005, 1113, 11);

INSERT INTO compania (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (seq_compania.NEXTVAL, 'FIENDS P. S.A', 'SUECIA',506, 857000, 0.015, 1113, 11);


                -- IDIOMA --      
                
INSERT INTO idioma (nombre_idioma) VALUES ('Ingles');     
INSERT INTO idioma (nombre_idioma) VALUES ('Chino');     
INSERT INTO idioma (nombre_idioma) VALUES ('Aleman');     
INSERT INTO idioma (nombre_idioma) VALUES ('Español');     
INSERT INTO idioma (nombre_idioma) VALUES ('Frances');     
     
              
             -- RECUPERACION DE DATOS --
             
-- INFORME 1:
SELECT 
  nombre_empresa AS "NOMBRE DE LA EMPRESA", 
  calle || ' ' || numeracion AS dirección,
  renta_promedio AS "RENTA PROMEDIO",
  renta_promedio + renta_promedio * pct_aumento AS "SIMULACIÓN RENTA"
FROM 
  compania
ORDER BY
  "RENTA PROMEDIO" DESC,
  "NOMBRE DE LA EMPRESA" ASC;
            
-- INFORME 2:    
SELECT
   id_empresa AS codigo,
   nombre_empresa AS empresa,
   renta_promedio AS "PROM RENTA ACTUAL",
   pct_aumento + 0.15 AS "PCT AUMENTADO EN 15%",
   renta_promedio * (pct_aumento + 0.15) AS "RENTA AUMENTADA"
FROM
  compania
ORDER BY
  "PROM RENTA ACTUAL" ASC, empresa DESC 
     
     
     
     
     