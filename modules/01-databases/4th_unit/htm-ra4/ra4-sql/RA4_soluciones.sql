-- =====================================================================
-- RA4_soluciones.sql · Soluciones comprobadas en MySQL 8.0
-- Temas 9 (DML) y 10 (DDL). Ejecuta ANTES ej_MYSQL.sql para crear la BD Empleados.
-- Las sentencias que dan error A PROPÓSITO van comentadas con  -- ❌  :
-- descoméntalas para ver el error y aprender el mensaje.
-- En Workbench: Edit > Preferences > SQL Editor > desmarca 'Safe Updates' y reconecta,
-- o ejecuta antes:  SET SQL_SAFE_UPDATES = 0;
-- =====================================================================

SET SQL_SAFE_UPDATES = 0;


-- #####################################################################
-- Tema 9 · Manipulación de datos (DML) sobre la BD Empleados
-- #####################################################################
USE Empleados;

-- ---------------------------------------------------------------
-- Ejercicio 9.1: Insertar un nuevo departamento ALUMNOS con el código 44 sin localidad.
INSERT INTO DEPARTMENT (DEPARTMENT_ID, NAME)
VALUES (44, 'ALUMNOS');
-- comprobación:
SELECT * FROM DEPARTMENT WHERE DEPARTMENT_ID = 44;

-- ---------------------------------------------------------------
-- Ejercicio 9.2: Insertar un empleado nuevo llamado JUAN GARCIA que va a trabajar en las mismas condiciones que ALICE y cuyo código será el de ALICE + 1.
INSERT INTO EMPLOYEE (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, MIDDLE_INITIAL, JOB_ID,
                      MANAGER_ID, HIRE_DATE, SALARY, COMMISSION, DEPARTMENT_ID)
SELECT EMPLOYEE_ID + 1, 'GARCIA', 'JUAN', MIDDLE_INITIAL, JOB_ID,
       MANAGER_ID, HIRE_DATE, SALARY, COMMISSION, DEPARTMENT_ID
FROM EMPLOYEE
WHERE FIRST_NAME = 'ALICE';
-- comprobación:
SELECT * FROM EMPLOYEE WHERE FIRST_NAME IN ('ALICE','JUAN');

-- ---------------------------------------------------------------
-- Ejercicio 9.3: Al final no se incorpora JUAN GARCIA, sino PEPE PEREZ con las mismas condiciones. Modificar el registro.
UPDATE EMPLOYEE
SET FIRST_NAME = 'PEPE', LAST_NAME = 'PEREZ'
WHERE FIRST_NAME = 'JUAN' AND LAST_NAME = 'GARCIA';
-- comprobación:
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM EMPLOYEE WHERE EMPLOYEE_ID = 7951;

-- ---------------------------------------------------------------
-- Ejercicio 9.4: Subir el sueldo un 10% a los empleados del departamento 20 y un 5% al resto.
UPDATE EMPLOYEE
SET SALARY = CASE WHEN DEPARTMENT_ID = 20 THEN SALARY * 1.10
                  ELSE SALARY * 1.05
             END;
-- comprobación:
SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY FROM EMPLOYEE ORDER BY DEPARTMENT_ID LIMIT 8;

-- ---------------------------------------------------------------
-- Ejercicio 9.5: Poner una comisión del 10% del salario a los empleados cuya función sea analista.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.10
WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE FUNCTIONS = 'ANALYST');
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, COMMISSION FROM EMPLOYEE WHERE JOB_ID = 669;

-- ---------------------------------------------------------------
-- Ejercicio 9.6: Poner a SHAPE UP con el máximo crédito.
-- ❌ (da ERROR 1093 a propósito)
-- ❌ UPDATE CUSTOMER
-- ❌ SET CREDIT_LIMIT = (SELECT MAX(CREDIT_LIMIT) FROM CUSTOMER)
-- ❌ WHERE NAME = 'SHAPE UP';
-- ✅ Solución: envolver la subconsulta en una tabla derivada (alias t)
UPDATE CUSTOMER
SET CREDIT_LIMIT = (SELECT maximo FROM (SELECT MAX(CREDIT_LIMIT) AS maximo FROM CUSTOMER) AS t)
WHERE NAME = 'SHAPE UP';
-- comprobación:
SELECT NAME, CREDIT_LIMIT FROM CUSTOMER WHERE NAME = 'SHAPE UP';

-- ---------------------------------------------------------------
-- Ejercicio 9.7: Modificar el nombre de todos los departamentos anteponiendo su código de departamento, un guion y el resto del nombre.
UPDATE DEPARTMENT
SET NAME = CONCAT(DEPARTMENT_ID, '-', NAME);
-- comprobación:
SELECT * FROM DEPARTMENT;

-- ---------------------------------------------------------------
-- Ejercicio 9.8: Borrar todos los productos cuya fecha de comienzo sea enero de 1989.
DELETE FROM PRICE
WHERE START_DATE >= '1989-01-01' AND START_DATE < '1989-02-01';
-- comprobación:
SELECT COUNT(*) AS precios_enero_1989 FROM PRICE WHERE START_DATE BETWEEN '1989-01-01' AND '1989-01-31';

-- ---------------------------------------------------------------
-- Ejercicio 9.9: Poner una comisión del 10% del salario a los empleados del departamento 20 que no tienen comisión.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.10
WHERE DEPARTMENT_ID = 20 AND COMMISSION IS NULL;
-- comprobación:
SELECT EMPLOYEE_ID, SALARY, COMMISSION FROM EMPLOYEE WHERE DEPARTMENT_ID = 20;

-- ---------------------------------------------------------------
-- Ejercicio 9.10: Del departamento 20, a los empleados que tienen el sueldo máximo, ponerles como comisión el 50% del salario.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.50
WHERE DEPARTMENT_ID = 20
  AND SALARY = (SELECT m FROM (SELECT MAX(SALARY) AS m
                               FROM EMPLOYEE WHERE DEPARTMENT_ID = 20) AS t);
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, COMMISSION FROM EMPLOYEE WHERE DEPARTMENT_ID = 20 ORDER BY SALARY DESC;

-- ---------------------------------------------------------------
-- Ejercicio 9.11: Poner una comisión del 20% del salario al empleado que tenga mayor comisión.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.20
WHERE COMMISSION = (SELECT m FROM (SELECT MAX(COMMISSION) AS m FROM EMPLOYEE) AS t);
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, COMMISSION FROM EMPLOYEE ORDER BY COMMISSION DESC LIMIT 3;

-- ---------------------------------------------------------------
-- Ejercicio 9.12: Aumentar el salario un 10% más la comisión a los empleados del departamento 30 que tengan un salario inferior a la media de su departamento y cuya función sea analista.
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.10 + IFNULL(COMMISSION, 0)
WHERE DEPARTMENT_ID = 30
  AND JOB_ID = (SELECT JOB_ID FROM JOB WHERE FUNCTIONS = 'ANALYST')
  AND SALARY < (SELECT media FROM (SELECT AVG(SALARY) AS media
                                   FROM EMPLOYEE WHERE DEPARTMENT_ID = 30) AS t);
-- comprobación:
SELECT EMPLOYEE_ID, JOB_ID, SALARY FROM EMPLOYEE WHERE DEPARTMENT_ID = 30;

-- ---------------------------------------------------------------
-- Ejercicio 9.13: El producto que menos se ha vendido ha de pasar a llamarse Patatas fritas.
UPDATE PRODUCT
SET DESCRIPTION = 'PATATAS FRITAS'
WHERE PRODUCT_ID = (SELECT PRODUCT_ID
                    FROM ITEM
                    GROUP BY PRODUCT_ID
                    ORDER BY SUM(QUANTITY) ASC
                    LIMIT 1);
-- comprobación:
SELECT * FROM PRODUCT WHERE DESCRIPTION = 'PATATAS FRITAS';

-- ---------------------------------------------------------------
-- Ejercicio 9.14: Dar de alta dos clientes cuyo vendedor asociado sea el 7499 y tengan como crédito límite 6000.
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, SALESPERSON_ID, CREDIT_LIMIT)
VALUES (300, 'CLIENTE NUEVO UNO', 7499, 6000),
       (301, 'CLIENTE NUEVO DOS', 7499, 6000);
-- comprobación:
SELECT CUSTOMER_ID, NAME, SALESPERSON_ID, CREDIT_LIMIT FROM CUSTOMER WHERE SALESPERSON_ID = 7499;

-- ---------------------------------------------------------------
-- Ejercicio 9.15: A los empleados con menos antigüedad (todos los que entraron el último año en que se contrató) ponerles como fecha de entrada 01/01/2006, el salario de DOYLE y como jefe a JOHN.
UPDATE EMPLOYEE
SET HIRE_DATE  = STR_TO_DATE('01/01/2006', '%d/%m/%Y'),
    SALARY     = (SELECT s  FROM (SELECT SALARY AS s FROM EMPLOYEE WHERE LAST_NAME = 'DOYLE') AS t1),
    MANAGER_ID = (SELECT id FROM (SELECT EMPLOYEE_ID AS id FROM EMPLOYEE WHERE FIRST_NAME = 'JOHN') AS t2)
WHERE YEAR(HIRE_DATE) = (SELECT y FROM (SELECT MAX(YEAR(HIRE_DATE)) AS y FROM EMPLOYEE) AS t3);
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE, SALARY, MANAGER_ID FROM EMPLOYEE WHERE HIRE_DATE = '2006-01-01';

-- ---------------------------------------------------------------
-- Ejercicio 9.16: Insertar un empleado de apellido Fernández con nº de identificación 6000. La fecha de alta será la de hoy, el salario el de GREGORY más un 20% y el resto de datos los mismos que GREGORY.
INSERT INTO EMPLOYEE (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, MIDDLE_INITIAL, JOB_ID,
                      MANAGER_ID, HIRE_DATE, SALARY, COMMISSION, DEPARTMENT_ID)
SELECT 6000, 'FERNANDEZ', FIRST_NAME, MIDDLE_INITIAL, JOB_ID,
       MANAGER_ID, CURDATE(), SALARY * 1.20, COMMISSION, DEPARTMENT_ID
FROM EMPLOYEE
WHERE FIRST_NAME = 'GREGORY';
-- comprobación:
SELECT * FROM EMPLOYEE WHERE EMPLOYEE_ID = 6000;

-- ---------------------------------------------------------------
-- Ejercicio 9.17: Modificar el nº de departamento de Fernández: será el departamento donde hay más empleados cuya función sea analista.
UPDATE EMPLOYEE
SET DEPARTMENT_ID = (SELECT d FROM (SELECT e.DEPARTMENT_ID AS d
                                  FROM EMPLOYEE e JOIN JOB j ON e.JOB_ID = j.JOB_ID
                                  WHERE j.FUNCTIONS = 'ANALYST'
                                  GROUP BY e.DEPARTMENT_ID
                                  ORDER BY COUNT(*) DESC, e.DEPARTMENT_ID
                                  LIMIT 1) AS t)
WHERE EMPLOYEE_ID = 6000;
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID FROM EMPLOYEE WHERE EMPLOYEE_ID = 6000;

-- ---------------------------------------------------------------
-- Ejercicio 9.18: Borrar todos los departamentos para los cuales no existen empleados.
-- Abrimos transacción para poder deshacer en el ejercicio 22
START TRANSACTION;
SAVEPOINT antes_borrados;
DELETE FROM DEPARTMENT
WHERE DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID FROM EMPLOYEE
                            WHERE DEPARTMENT_ID IS NOT NULL);
-- comprobación:
SELECT * FROM DEPARTMENT;

-- ---------------------------------------------------------------
-- Ejercicio 9.19: Borrar aquellos clientes que no han realizado compras.
DELETE FROM CUSTOMER
WHERE CUSTOMER_ID NOT IN (SELECT CUSTOMER_ID FROM SALES_ORDER);
-- comprobación:
SELECT COUNT(*) AS clientes_restantes FROM CUSTOMER;

-- ---------------------------------------------------------------
-- Ejercicio 9.20: Borrar todos los empleados cuyo jefe es DOYLE.
-- ❌ (da ERROR 1451 a propósito)
-- ❌ DELETE FROM EMPLOYEE
-- ❌ WHERE MANAGER_ID = (SELECT id FROM (SELECT EMPLOYEE_ID AS id FROM EMPLOYEE
-- ❌                                     WHERE LAST_NAME = 'DOYLE') AS t);
-- ✅ Los clientes de esos vendedores pasan a DOYLE y después se borra
UPDATE CUSTOMER
SET SALESPERSON_ID = 7505
WHERE SALESPERSON_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE MANAGER_ID = 7505);
DELETE FROM EMPLOYEE
WHERE MANAGER_ID = (SELECT id FROM (SELECT EMPLOYEE_ID AS id FROM EMPLOYEE
                                    WHERE LAST_NAME = 'DOYLE') AS t);
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEE WHERE MANAGER_ID = 7505;

-- ---------------------------------------------------------------
-- Ejercicio 9.21: Borrar el departamento 43.
DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID = 43;
-- comprobación:
SELECT * FROM DEPARTMENT WHERE DEPARTMENT_ID = 43;

-- ---------------------------------------------------------------
-- Ejercicio 9.22: Hacer ROLLBACK. Insertar a María Camacho (8000, función 669, jefe 7820, hoy, 1300, comisión 50, dept. 20, inicial Q) y a Bernabé González (9000, función 670, jefe 7820, hoy, 6000, comisión 600, dept. 43, inicial S). Comprobar si el ejercicio anterior sigue siendo válido.
ROLLBACK TO antes_borrados;
COMMIT;  -- cerramos la transacción (los ejercicios 18-21 quedan deshechos)
INSERT INTO EMPLOYEE VALUES
 (8000, 'CAMACHO',  'MARIA',   'Q', 669, 7820, CURDATE(), 1300,  50, 20),
 (9000, 'GONZALEZ', 'BERNABE', 'S', 670, 7820, CURDATE(), 6000, 600, 43);
-- ❌ (da ERROR 1451 a propósito)
-- ❌ DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID = 43;
-- comprobación:
SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 43;

-- #####################################################################
-- Tema 10 · Manipulación de tablas (DDL) · BD tiendas
-- #####################################################################
DROP DATABASE IF EXISTS tiendas;
CREATE DATABASE tiendas;
USE tiendas;

-- ---------------------------------------------------------------
-- Ejercicio 10.1: Crear las tablas TIENDAS, FABRICANTES, ARTICULOS, PEDIDOS y VENTAS con sus restricciones (PK, FK con borrado en cascada, CHECK de mayúsculas, valores > 0 y categoría 'primera', 'segunda' o 'tercera').
CREATE TABLE TIENDAS (
  NIF        VARCHAR(10) NOT NULL,
  NOMBRE     VARCHAR(20),
  DIRECCION  VARCHAR(20),
  POBLACION  VARCHAR(20),
  PROVINCIA  VARCHAR(20),
  COD_POSTAL DECIMAL(5),
  CONSTRAINT tiendas_pk        PRIMARY KEY (NIF),
  CONSTRAINT tiendas_prov_ck   CHECK (PROVINCIA = UPPER(PROVINCIA) COLLATE utf8mb4_bin)
);
CREATE TABLE FABRICANTES (
  COD_FABRICANTE DECIMAL(3) NOT NULL,
  NOMBRE         VARCHAR(15),
  PAIS           VARCHAR(15),
  CONSTRAINT fabricantes_pk        PRIMARY KEY (COD_FABRICANTE),
  CONSTRAINT fabricantes_nombre_ck CHECK (NOMBRE = UPPER(NOMBRE) COLLATE utf8mb4_bin),
  CONSTRAINT fabricantes_pais_ck   CHECK (PAIS   = UPPER(PAIS)   COLLATE utf8mb4_bin)
);
CREATE TABLE ARTICULOS (
  ARTICULO       VARCHAR(20) NOT NULL,
  COD_FABRICANTE DECIMAL(3)  NOT NULL,
  PESO           DECIMAL(3)  NOT NULL,
  CATEGORIA      VARCHAR(10) NOT NULL,
  PRECIO_VENTA   DECIMAL(4),
  PRECIO_COSTO   DECIMAL(4),
  EXISTENCIAS    DECIMAL(5),
  CONSTRAINT articulos_pk     PRIMARY KEY (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA),
  CONSTRAINT articulos_fab_fk FOREIGN KEY (COD_FABRICANTE) REFERENCES FABRICANTES (COD_FABRICANTE),
  CONSTRAINT articulos_pv_ck  CHECK (PRECIO_VENTA > 0),
  CONSTRAINT articulos_pc_ck  CHECK (PRECIO_COSTO > 0),
  CONSTRAINT articulos_peso_ck CHECK (PESO > 0),
  CONSTRAINT articulos_cat_ck CHECK (CATEGORIA IN ('primera', 'segunda', 'tercera'))
);
CREATE TABLE PEDIDOS (
  NIF              VARCHAR(10) NOT NULL,
  ARTICULO         VARCHAR(20) NOT NULL,
  COD_FABRICANTE   DECIMAL(3)  NOT NULL,
  PESO             DECIMAL(3)  NOT NULL,
  CATEGORIA        VARCHAR(10) NOT NULL,
  FECHA_PEDIDO     DATE        NOT NULL,
  UNIDADES_PEDIDAS DECIMAL(4)  NOT NULL,
  CONSTRAINT pedidos_pk     PRIMARY KEY (NIF, ARTICULO, COD_FABRICANTE, PESO, CATEGORIA, FECHA_PEDIDO),
  CONSTRAINT pedidos_fab_fk FOREIGN KEY (COD_FABRICANTE) REFERENCES FABRICANTES (COD_FABRICANTE),
  CONSTRAINT pedidos_art_fk FOREIGN KEY (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA)
                            REFERENCES ARTICULOS (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA)
                            ON DELETE CASCADE,
  CONSTRAINT pedidos_nif_fk FOREIGN KEY (NIF) REFERENCES TIENDAS (NIF),
  CONSTRAINT pedidos_uds_ck CHECK (UNIDADES_PEDIDAS > 0),
  CONSTRAINT pedidos_cat_ck CHECK (CATEGORIA IN ('primera', 'segunda', 'tercera'))
);
CREATE TABLE VENTAS (
  NIF               VARCHAR(10) NOT NULL,
  ARTICULO          VARCHAR(20) NOT NULL,
  COD_FABRICANTE    DECIMAL(3)  NOT NULL,
  PESO              DECIMAL(3)  NOT NULL,
  CATEGORIA         VARCHAR(10) NOT NULL,
  FECHA_VENTA       DATE        NOT NULL,
  UNIDADES_VENDIDAS DECIMAL(4),
  CONSTRAINT ventas_pk     PRIMARY KEY (NIF, ARTICULO, COD_FABRICANTE, PESO, CATEGORIA, FECHA_VENTA),
  CONSTRAINT ventas_fab_fk FOREIGN KEY (COD_FABRICANTE) REFERENCES FABRICANTES (COD_FABRICANTE),
  CONSTRAINT ventas_art_fk FOREIGN KEY (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA)
                           REFERENCES ARTICULOS (ARTICULO, COD_FABRICANTE, PESO, CATEGORIA)
                           ON DELETE CASCADE,
  CONSTRAINT ventas_nif_fk FOREIGN KEY (NIF) REFERENCES TIENDAS (NIF),
  CONSTRAINT ventas_uds_ck CHECK (UNIDADES_VENDIDAS > 0),
  CONSTRAINT ventas_cat_ck CHECK (CATEGORIA IN ('primera', 'segunda', 'tercera'))
);
-- comprobación:
SHOW TABLES;

-- ---------------------------------------------------------------
-- Ejercicio 10.1b: (Prueba) Comprobar que las restricciones funcionan insertando datos válidos e inválidos.
INSERT INTO TIENDAS VALUES ('11111111A', 'Deportes Sol', 'Mayor 1', 'Getafe', 'MADRID', 28901);
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO TIENDAS VALUES ('22222222B', 'Ciclos Sur', 'Real 2', 'Getafe', 'madrid', 28902);
INSERT INTO FABRICANTES VALUES (10, 'ACME', 'ESPAÑA');
INSERT INTO ARTICULOS VALUES ('Raqueta', 10, 1, 'primera', 50, 30, 100);
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO ARTICULOS VALUES ('Balon', 10, 1, 'cuarta', 20, 10, 50);
INSERT INTO PEDIDOS VALUES ('11111111A', 'Raqueta', 10, 1, 'primera', CURDATE(), 5);
-- ❌ (da ERROR 1452 a propósito)
-- ❌ INSERT INTO PEDIDOS VALUES ('99999999Z', 'Raqueta', 10, 1, 'primera', CURDATE(), 5);
-- comprobación:
SELECT * FROM PEDIDOS;

-- ---------------------------------------------------------------
-- Ejercicio 10.2: Añadir una restricción a TIENDAS para que el NOMBRE de la tienda sea de tipo título.
-- ❌ (da ERROR 3819 a propósito)
-- ❌ ALTER TABLE TIENDAS
-- ❌ ADD CONSTRAINT tiendas_nombre_ck
-- ❌ CHECK (NOMBRE = CONCAT(UPPER(LEFT(NOMBRE, 1)), LOWER(SUBSTRING(NOMBRE, 2))) COLLATE utf8mb4_bin);
-- comprobación:
SELECT NIF, NOMBRE FROM TIENDAS;

-- ---------------------------------------------------------------
-- Ejercicio 10.2b: (Continuación) Corregir los datos y volver a añadir la restricción.
UPDATE TIENDAS SET NOMBRE = 'Deportes sol' WHERE NIF = '11111111A';
ALTER TABLE TIENDAS
ADD CONSTRAINT tiendas_nombre_ck
CHECK (NOMBRE = CONCAT(UPPER(LEFT(NOMBRE, 1)), LOWER(SUBSTRING(NOMBRE, 2))) COLLATE utf8mb4_bin);
-- comprobación:
SELECT NIF, NOMBRE FROM TIENDAS;

-- ---------------------------------------------------------------
-- Ejercicio 10.3: Visualizar las constraints definidas para las tablas anteriores.
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'tiendas'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;
SELECT CONSTRAINT_NAME, CHECK_CLAUSE
FROM information_schema.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'tiendas';
SHOW CREATE TABLE PEDIDOS;

-- ---------------------------------------------------------------
-- Ejercicio 10.4: Modificar las columnas UNIDADES_PEDIDAS y UNIDADES_VENDIDAS para que puedan almacenar cantidades de 6 dígitos.
ALTER TABLE PEDIDOS MODIFY UNIDADES_PEDIDAS DECIMAL(6) NOT NULL;
ALTER TABLE VENTAS  MODIFY UNIDADES_VENDIDAS DECIMAL(6);
-- comprobación:
DESCRIBE PEDIDOS;

-- ---------------------------------------------------------------
-- Ejercicio 10.5: Impedir que se den de alta más tiendas en la provincia de 'TOLEDO'.
ALTER TABLE TIENDAS
ADD CONSTRAINT tiendas_no_toledo_ck CHECK (PROVINCIA <> 'TOLEDO');
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO TIENDAS VALUES ('33333333C', 'Toledana', 'Plaza 3', 'Talavera', 'TOLEDO', 45600);

-- ---------------------------------------------------------------
-- Ejercicio 10.6: Añadir a las tablas PEDIDOS y VENTAS una nueva columna para almacenar el PVP del artículo.
ALTER TABLE PEDIDOS ADD PVP DECIMAL(6,2);
ALTER TABLE VENTAS  ADD COLUMN PVP DECIMAL(6,2) AFTER UNIDADES_VENDIDAS;
-- comprobación:
DESCRIBE VENTAS;

-- ---------------------------------------------------------------
-- Ejercicio 10.7: Añadir a la tabla VENTAS el comentario: Unidades vendidas de los distintos artículos de los fabricantes.
ALTER TABLE VENTAS COMMENT = 'Unidades vendidas de los distintos artículos de los fabricantes';
-- comprobación:
SELECT TABLE_NAME, TABLE_COMMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tiendas' AND TABLE_NAME = 'VENTAS';

-- ---------------------------------------------------------------
-- Ejercicio 10.8: Añadir al campo PESO de la tabla PEDIDOS el comentario 'peso del articulo pedido'.
ALTER TABLE PEDIDOS MODIFY PESO DECIMAL(3) NOT NULL COMMENT 'peso del articulo pedido';
-- comprobación:
SELECT COLUMN_NAME, COLUMN_COMMENT FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'tiendas' AND TABLE_NAME = 'PEDIDOS' AND COLUMN_NAME = 'PESO';

-- ---------------------------------------------------------------
-- Ejercicio 10.9: Crear un sinónimo llamado PED para la tabla PEDIDOS.
-- MySQL no tiene CREATE SYNONYM (es de Oracle). Equivalente: una vista
CREATE VIEW PED AS SELECT * FROM PEDIDOS;
-- comprobación:
SELECT * FROM PED;

-- ---------------------------------------------------------------
-- Ejercicio 10.10: Cambiar de nombre la tabla VENTAS a NUEVAS_VENTAS.
RENAME TABLE VENTAS TO NUEVAS_VENTAS;
-- comprobación:
SHOW TABLES;

-- ---------------------------------------------------------------
-- Ejercicio 10.11: Borrar la tabla TIENDAS.
-- ❌ (da ERROR 3730 a propósito)
-- ❌ DROP TABLE TIENDAS;
-- ✅ Quitamos primero las FK hijas y después borramos
ALTER TABLE PEDIDOS       DROP FOREIGN KEY pedidos_nif_fk;
ALTER TABLE NUEVAS_VENTAS DROP FOREIGN KEY ventas_nif_fk;
DROP TABLE TIENDAS;
-- comprobación:
SHOW TABLES;

-- #####################################################################
-- Tema 10 · Modelo videoclub (ejercicios 12-19)
-- #####################################################################
DROP DATABASE IF EXISTS videoclub;
CREATE DATABASE videoclub;
USE videoclub;

-- ---------------------------------------------------------------
-- Ejercicio 10.12: Crear el modelo SOCIOS, TEMAS, PELICULAS y ALQUILER con sus datos. Las restricciones que no sean PK, FK o NOT NULL se añaden DESPUÉS de crear las tablas.
CREATE TABLE SOCIOS (
  cod_socio     INT          NOT NULL,
  nombre        VARCHAR(20)  NOT NULL,
  apellidos     VARCHAR(40)  NOT NULL,
  domicilio     VARCHAR(40),
  poblacion     VARCHAR(30),
  cod_postal    CHAR(5),
  provincia     VARCHAR(20),
  telefono      VARCHAR(9),
  sexo          CHAR(1),
  observaciones VARCHAR(100),
  CONSTRAINT socios_pk PRIMARY KEY (cod_socio)
);
CREATE TABLE TEMAS (
  cod_tema DECIMAL(2)  NOT NULL,
  tema     VARCHAR(20) NOT NULL,
  CONSTRAINT temas_pk PRIMARY KEY (cod_tema)
);
CREATE TABLE PELICULAS (
  cod_pelicula    INT         NOT NULL,
  titulo          VARCHAR(40) NOT NULL,
  interprete_1    VARCHAR(40),
  interprete_2    VARCHAR(40),
  director        VARCHAR(40),
  productora      VARCHAR(30),
  cod_tema        DECIMAL(2),
  anio_produccion YEAR,
  duracion        SMALLINT,
  precio_coste    DECIMAL(5,2),
  CONSTRAINT peliculas_pk      PRIMARY KEY (cod_pelicula),
  CONSTRAINT peliculas_tema_fk FOREIGN KEY (cod_tema) REFERENCES TEMAS (cod_tema)
);
CREATE TABLE ALQUILER (
  cod_alquiler     INT        NOT NULL AUTO_INCREMENT,
  cod_socio        INT        NOT NULL,
  cod_pelicula     INT        NOT NULL,
  fecha_alquiler   DATE       NOT NULL,
  fecha_devolucion DATE,
  devuelta         VARCHAR(2),
  precio           DECIMAL(5,2),
  CONSTRAINT alquiler_pk          PRIMARY KEY (cod_alquiler),
  CONSTRAINT alquiler_socio_fk    FOREIGN KEY (cod_socio)    REFERENCES SOCIOS (cod_socio),
  CONSTRAINT alquiler_pelicula_fk FOREIGN KEY (cod_pelicula) REFERENCES PELICULAS (cod_pelicula)
);
-- Restricciones añadidas después (CHECK)
ALTER TABLE SOCIOS    ADD CONSTRAINT socios_sexo_ck     CHECK (sexo IN ('H', 'M'));
ALTER TABLE ALQUILER  ADD CONSTRAINT alquiler_dev_ck    CHECK (devuelta IN ('si', 'no'));
ALTER TABLE ALQUILER  ADD CONSTRAINT alquiler_fechas_ck CHECK (fecha_devolucion >= fecha_alquiler);
ALTER TABLE ALQUILER  ADD CONSTRAINT alquiler_precio_ck CHECK (precio > 0);
ALTER TABLE PELICULAS ADD CONSTRAINT peliculas_dur_ck   CHECK (duracion > 0);
INSERT INTO SOCIOS VALUES
 (10300106, 'Santiago', 'Blanco Ruiz',  'Balmes 36', 'Llodio',    '01400', 'Álava',     '4531221', 'H', 'Todos los meses compra dos pelis'),
 (11369214, 'Carlos',   'Flores Vargas','Potosí 13', 'Alcorcón',  '28921', 'Madrid',    '5436785', 'H', NULL),
 (17269813, 'Ana',      'López Pintado','Mayor 43',  'Ulldecona', '43550', 'Tarragona', '897654',  'M', 'Devuelve las pelis sin rebobinar');
INSERT INTO TEMAS VALUES (1,'Suspense'), (2,'Terror'), (3,'Histórica'), (4,'Drama'), (5,'Ciencia-ficción');
INSERT INTO PELICULAS VALUES
 (1, 'El color púrpura',    'Danny Glover',   'Whoopi Goldberg', 'Steven Spielberg', 'Warner Bros',       5, 1985, 148, 18),
 (2, 'A propósito de Henry', 'Harrison Ford',  'Annette Bening',  'Mike Nichols',     'Columbia Pictures', 4, 1991, 108, 15),
 (3, 'J.F.K.',              'Kevin Costner',  'Sissy Spacek',    'Oliver Stone',     'Warner Bros',       3, 1991, 189, 20);
INSERT INTO ALQUILER (cod_socio, cod_pelicula, fecha_alquiler, fecha_devolucion, devuelta, precio) VALUES
 (10300106, 1, STR_TO_DATE('12/10/1998','%d/%m/%Y'), STR_TO_DATE('18/10/1998','%d/%m/%Y'), 'si', 5),
 (11369214, 2, STR_TO_DATE('09/09/2000','%d/%m/%Y'), STR_TO_DATE('15/09/2000','%d/%m/%Y'), 'no', 6),
 (17269813, 3, STR_TO_DATE('23/04/2002','%d/%m/%Y'), STR_TO_DATE('01/05/2002','%d/%m/%Y'), 'si', 6),
 (10300106, 2, STR_TO_DATE('16/07/2004','%d/%m/%Y'), STR_TO_DATE('25/07/2004','%d/%m/%Y'), 'no', 6),
 (11369214, 3, STR_TO_DATE('15/03/2006','%d/%m/%Y'), STR_TO_DATE('18/03/2006','%d/%m/%Y'), 'si', 7),
 (17269813, 1, STR_TO_DATE('08/01/2007','%d/%m/%Y'), STR_TO_DATE('15/01/2007','%d/%m/%Y'), 'si', 7);
-- comprobación:
SELECT a.cod_alquiler, s.nombre, p.titulo, a.fecha_alquiler, a.devuelta, a.precio
FROM ALQUILER a JOIN SOCIOS s ON a.cod_socio = s.cod_socio
                JOIN PELICULAS p ON a.cod_pelicula = p.cod_pelicula;

-- ---------------------------------------------------------------
-- Ejercicio 10.13: Modificar las columnas cod_tema de TEMAS y PELICULAS para que puedan almacenar cantidades de 4 dígitos.
-- ❌ (da ERROR 1833 a propósito)
-- ❌ ALTER TABLE TEMAS MODIFY cod_tema DECIMAL(4) NOT NULL;
-- ✅ 1) quitar la FK  2) modificar ambas columnas  3) volver a crear la FK
ALTER TABLE PELICULAS DROP FOREIGN KEY peliculas_tema_fk;
ALTER TABLE TEMAS     MODIFY cod_tema DECIMAL(4) NOT NULL;
ALTER TABLE PELICULAS MODIFY cod_tema DECIMAL(4);
ALTER TABLE PELICULAS ADD CONSTRAINT peliculas_tema_fk
  FOREIGN KEY (cod_tema) REFERENCES TEMAS (cod_tema);
-- comprobación:
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'videoclub' AND COLUMN_NAME = 'cod_tema';

-- ---------------------------------------------------------------
-- Ejercicio 10.14: Impedir que se den de alta más películas de la productora Warner Bros.
-- ❌ (da ERROR 3819 a propósito)
-- ❌ ALTER TABLE PELICULAS ADD CONSTRAINT peliculas_no_warner_ck CHECK (productora <> 'Warner Bros');
-- ✅ Un trigger impide solo las NUEVAS altas
DELIMITER //
CREATE TRIGGER peliculas_no_warner
BEFORE INSERT ON PELICULAS
FOR EACH ROW
BEGIN
  IF NEW.productora = 'Warner Bros' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se admiten más películas de Warner Bros';
  END IF;
END //
DELIMITER ;
-- ❌ (da ERROR 1644 a propósito)
-- ❌ INSERT INTO PELICULAS (cod_pelicula, titulo, productora, cod_tema) VALUES (4, 'Batman', 'Warner Bros', 1);
-- comprobación:
SELECT cod_pelicula, titulo, productora FROM PELICULAS;

-- ---------------------------------------------------------------
-- Ejercicio 10.15: Añadir a la tabla PELICULAS el comentario «Películas producidas a partir de la segunda mitad del siglo XX».
ALTER TABLE PELICULAS COMMENT = 'Películas producidas a partir de la segunda mitad del siglo XX';
-- comprobación:
SELECT TABLE_COMMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'videoclub' AND TABLE_NAME = 'PELICULAS';

-- ---------------------------------------------------------------
-- Ejercicio 10.16: Añadir al campo interprete_1 de PELICULAS el comentario 'actor principal'.
ALTER TABLE PELICULAS MODIFY interprete_1 VARCHAR(40) COMMENT 'actor principal';
-- comprobación:
SELECT COLUMN_NAME, COLUMN_COMMENT FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'videoclub' AND TABLE_NAME = 'PELICULAS' AND COLUMN_COMMENT <> '';

-- ---------------------------------------------------------------
-- Ejercicio 10.17: Crear un sinónimo llamado ALQ para la tabla ALQUILER.
CREATE VIEW ALQ AS SELECT * FROM ALQUILER;
-- comprobación:
SELECT * FROM ALQ;

-- ---------------------------------------------------------------
-- Ejercicio 10.18: Cambiar de nombre la tabla SOCIOS a SOCIOS_NUEVOS.
RENAME TABLE SOCIOS TO SOCIOS_NUEVOS;
-- comprobación:
SHOW CREATE TABLE ALQUILER;

-- ---------------------------------------------------------------
-- Ejercicio 10.19: Borrar la tabla PELICULAS.
-- ❌ (da ERROR 3730 a propósito)
-- ❌ DROP TABLE PELICULAS;
ALTER TABLE ALQUILER DROP FOREIGN KEY alquiler_pelicula_fk;
DROP TABLE PELICULAS;
-- comprobación:
SHOW TABLES;
