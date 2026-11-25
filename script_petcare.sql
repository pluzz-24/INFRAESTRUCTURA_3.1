-- ============================================================
-- PROYECTO PETCARE - Oracle Autonomous Database
-- PARTE A: ejecutar como ADMIN (Database Actions > SQL)
-- ============================================================
CREATE USER petcare IDENTIFIED BY "REEMPLAZAR_CONTRASENA";
GRANT CREATE SESSION, CREATE TABLE TO petcare;
ALTER USER petcare QUOTA 20M ON DATA;

-- Acceso web: Database Actions > Administration > Database Users >
-- editar PETCARE > activar Web Access > guardar (debe aparecer REST Enabled)
-- Contrasena: robusta, sin espacios, comillas, # ni $

-- ============================================================
-- PARTE B: conectarse como PETCARE y ejecutar
-- ============================================================
CREATE TABLE PROPIETARIOS (
  ID_PROPIETARIO NUMBER GENERATED ALWAYS AS IDENTITY,
  NOMBRE         VARCHAR2(100) NOT NULL,
  DOCUMENTO      VARCHAR2(20)  NOT NULL,
  TELEFONO       VARCHAR2(20),
  CORREO         VARCHAR2(100),
  DIRECCION      VARCHAR2(150),
  CONSTRAINT PK_PROPIETARIOS PRIMARY KEY (ID_PROPIETARIO),
  CONSTRAINT UQ_PROPIETARIOS_DOC UNIQUE (DOCUMENTO)
);

CREATE TABLE MASCOTAS (
  ID_MASCOTA       NUMBER GENERATED ALWAYS AS IDENTITY,
  NOMBRE           VARCHAR2(80) NOT NULL,
  ESPECIE          VARCHAR2(30) NOT NULL,
  RAZA             VARCHAR2(60),
  FECHA_NACIMIENTO DATE,
  PESO_KG          NUMBER(5,2),
  ID_PROPIETARIO   NUMBER NOT NULL,
  CONSTRAINT PK_MASCOTAS PRIMARY KEY (ID_MASCOTA),
  CONSTRAINT FK_MASCOTAS_PROPIETARIO FOREIGN KEY (ID_PROPIETARIO)
    REFERENCES PROPIETARIOS (ID_PROPIETARIO)
);

-- Verificación de tablas
SELECT table_name FROM user_tables;
SELECT column_name, data_type, data_length, nullable FROM user_tab_columns WHERE table_name = 'PROPIETARIOS' ORDER BY column_id;
SELECT column_name, data_type, data_length, nullable FROM user_tab_columns WHERE table_name = 'MASCOTAS' ORDER BY column_id;
SELECT constraint_name, constraint_type, table_name FROM user_constraints WHERE table_name IN ('PROPIETARIOS','MASCOTAS');

-- (Opcional) datos de prueba para la demostración
INSERT INTO PROPIETARIOS (NOMBRE, DOCUMENTO, TELEFONO, CORREO, DIRECCION) VALUES ('Laura Gómez','1012345678','3101234567','laura@correo.com','Cra 15 # 80-20');
INSERT INTO PROPIETARIOS (NOMBRE, DOCUMENTO, TELEFONO, CORREO, DIRECCION) VALUES ('Carlos Pérez','80123456','3209876543','carlos@correo.com','Cl 100 # 10-35');
INSERT INTO MASCOTAS (NOMBRE, ESPECIE, RAZA, FECHA_NACIMIENTO, PESO_KG, ID_PROPIETARIO) VALUES ('Max','Perro','Golden Retriever',DATE '2020-03-12',30.5,1);
INSERT INTO MASCOTAS (NOMBRE, ESPECIE, RAZA, FECHA_NACIMIENTO, PESO_KG, ID_PROPIETARIO) VALUES ('Rocky','Perro','Bulldog',DATE '2019-11-25',22,2);
COMMIT;

SELECT m.NOMBRE AS MASCOTA, m.ESPECIE, p.NOMBRE AS PROPIETARIO
FROM MASCOTAS m JOIN PROPIETARIOS p ON p.ID_PROPIETARIO = m.ID_PROPIETARIO;