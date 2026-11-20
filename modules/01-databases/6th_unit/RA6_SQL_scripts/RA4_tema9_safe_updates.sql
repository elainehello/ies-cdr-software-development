-- =====================================================================
-- RA4_tema9_safe_updates.sql · Tema 9 con SAFE UPDATES ACTIVADO (Workbench por defecto)
-- Todos los UPDATE/DELETE localizan las filas por CLAVE PRIMARIA. Comprobado en MySQL 8.0:
-- deja la BD exactamente igual que RA4_soluciones.sql. Ejecuta antes ej_MYSQL.sql.
-- =====================================================================

SET SQL_SAFE_UPDATES = 1;
USE Empleados;

-- ---------------------------------------------------------------
-- Ejercicio 9.1: Insertar un nuevo departamento ALUMNOS con el código 44 sin localidad.
INSERT INTO DEPARTMENT (DEPARTMENT_ID, NAME)
VALUES (44, 'ALUMNOS');

-- ---------------------------------------------------------------
-- Ejercicio 9.2: Insertar un empleado nuevo llamado JUAN GARCIA que va a trabajar en las mismas condiciones que ALICE y cuyo código será el de ALICE + 1.
INSERT INTO EMPLOYEE (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, MIDDLE_INITIAL, JOB_ID,
                      MANAGER_ID, HIRE_DATE, SALARY, COMMISSION, DEPARTMENT_ID)
SELECT EMPLOYEE_ID + 1, 'GARCIA', 'JUAN', MIDDLE_INITIAL, JOB_ID,
       MANAGER_ID, HIRE_DATE, SALARY, COMMISSION, DEPARTMENT_ID
FROM EMPLOYEE
WHERE FIRST_NAME = 'ALICE';

-- ---------------------------------------------------------------
-- Ejercicio 9.3: Al final no se incorpora JUAN GARCIA, sino PEPE PEREZ con las mismas condiciones. Modificar el registro.
-- 🔐 versión por clave primaria
-- Paso 1 · Consulta primero: ¿qué clave primaria tiene la fila que quiero cambiar?
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE FIRST_NAME = 'JUAN' AND LAST_NAME = 'GARCIA';
-- Paso 2 · Modifica usando la clave primaria que has visto (7951)
UPDATE EMPLOYEE
SET FIRST_NAME = 'PEPE', LAST_NAME = 'PEREZ'
WHERE EMPLOYEE_ID = 7951;

-- ---------------------------------------------------------------
-- Ejercicio 9.4: Subir el sueldo un 10% a los empleados del departamento 20 y un 5% al resto.
-- 🔐 versión por clave primaria
-- Se quiere cambiar TODA la tabla: se dice explícitamente con un rango sobre la PK
UPDATE EMPLOYEE
SET SALARY = CASE WHEN DEPARTMENT_ID = 20 THEN SALARY * 1.10
                  ELSE SALARY * 1.05
             END
WHERE EMPLOYEE_ID > 0;

-- ---------------------------------------------------------------
-- Ejercicio 9.5: Poner una comisión del 10% del salario a los empleados cuya función sea analista.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.10
WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE FUNCTIONS = 'ANALYST');

-- ---------------------------------------------------------------
-- Ejercicio 9.6: Poner a SHAPE UP con el máximo crédito.
-- 🔐 versión por clave primaria
-- Paso 1 · Clave primaria del cliente
SELECT CUSTOMER_ID, NAME, CREDIT_LIMIT FROM CUSTOMER WHERE NAME = 'SHAPE UP';
-- Paso 2 · UPDATE por clave primaria (106). El truco de la tabla derivada sigue siendo necesario
UPDATE CUSTOMER
SET CREDIT_LIMIT = (SELECT maximo FROM (SELECT MAX(CREDIT_LIMIT) AS maximo FROM CUSTOMER) AS t)
WHERE CUSTOMER_ID = 106;

-- ---------------------------------------------------------------
-- Ejercicio 9.7: Modificar el nombre de todos los departamentos anteponiendo su código de departamento, un guion y el resto del nombre.
-- 🔐 versión por clave primaria
UPDATE DEPARTMENT
SET NAME = CONCAT(DEPARTMENT_ID, '-', NAME)
WHERE DEPARTMENT_ID > 0;

-- ---------------------------------------------------------------
-- Ejercicio 9.8: Borrar todos los productos cuya fecha de comienzo sea enero de 1989.
-- 🔐 versión por clave primaria
-- Paso 1 · ¿Qué filas voy a borrar? (fíjate en su PK: PRODUCT_ID + START_DATE)
SELECT PRODUCT_ID, START_DATE, LIST_PRICE
FROM PRICE
WHERE START_DATE >= '1989-01-01' AND START_DATE < '1989-02-01';
-- Paso 2 · Borrado usando la clave primaria COMPUESTA completa
DELETE FROM PRICE
WHERE (PRODUCT_ID, START_DATE) IN (SELECT p, s FROM (SELECT PRODUCT_ID AS p, START_DATE AS s
                                                     FROM PRICE
                                                     WHERE START_DATE >= '1989-01-01'
                                                       AND START_DATE < '1989-02-01') AS t);

-- ---------------------------------------------------------------
-- Ejercicio 9.9: Poner una comisión del 10% del salario a los empleados del departamento 20 que no tienen comisión.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.10
WHERE DEPARTMENT_ID = 20 AND COMMISSION IS NULL;

-- ---------------------------------------------------------------
-- Ejercicio 9.10: Del departamento 20, a los empleados que tienen el sueldo máximo, ponerles como comisión el 50% del salario.
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.50
WHERE DEPARTMENT_ID = 20
  AND SALARY = (SELECT m FROM (SELECT MAX(SALARY) AS m
                               FROM EMPLOYEE WHERE DEPARTMENT_ID = 20) AS t);

-- ---------------------------------------------------------------
-- Ejercicio 9.11: Poner una comisión del 20% del salario al empleado que tenga mayor comisión.
-- 🔐 versión por clave primaria
-- Paso 1 · ¿Quién tiene la mayor comisión? Anota su EMPLOYEE_ID
SELECT EMPLOYEE_ID, LAST_NAME, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION = (SELECT MAX(COMMISSION) FROM EMPLOYEE);
-- Paso 2 · Salen DOS (empate: 7788 y 7902), así que se usa IN con las dos claves
UPDATE EMPLOYEE
SET COMMISSION = SALARY * 0.20
WHERE EMPLOYEE_ID IN (7788, 7902);

-- ---------------------------------------------------------------
-- Ejercicio 9.12: Aumentar el salario un 10% más la comisión a los empleados del departamento 30 que tengan un salario inferior a la media de su departamento y cuya función sea analista.
UPDATE EMPLOYEE
SET SALARY = SALARY * 1.10 + IFNULL(COMMISSION, 0)
WHERE DEPARTMENT_ID = 30
  AND JOB_ID = (SELECT JOB_ID FROM JOB WHERE FUNCTIONS = 'ANALYST')
  AND SALARY < (SELECT media FROM (SELECT AVG(SALARY) AS media
                                   FROM EMPLOYEE WHERE DEPARTMENT_ID = 30) AS t);

-- ---------------------------------------------------------------
-- Ejercicio 9.13: El producto que menos se ha vendido ha de pasar a llamarse Patatas fritas.
UPDATE PRODUCT
SET DESCRIPTION = 'PATATAS FRITAS'
WHERE PRODUCT_ID = (SELECT PRODUCT_ID
                    FROM ITEM
                    GROUP BY PRODUCT_ID
                    ORDER BY SUM(QUANTITY) ASC
                    LIMIT 1);

-- ---------------------------------------------------------------
-- Ejercicio 9.14: Dar de alta dos clientes cuyo vendedor asociado sea el 7499 y tengan como crédito límite 6000.
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, SALESPERSON_ID, CREDIT_LIMIT)
VALUES (300, 'CLIENTE NUEVO UNO', 7499, 6000),
       (301, 'CLIENTE NUEVO DOS', 7499, 6000);

-- ---------------------------------------------------------------
-- Ejercicio 9.15: A los empleados con menos antigüedad (todos los que entraron el último año en que se contrató) ponerles como fecha de entrada 01/01/2006, el salario de DOYLE y como jefe a JOHN.
-- 🔐 versión por clave primaria
-- Paso 1 · ¿Quiénes entraron el último año en que se contrató? Anota sus claves
SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = (SELECT MAX(YEAR(HIRE_DATE)) FROM EMPLOYEE);
-- Paso 2 · UPDATE con la lista de claves primarias
UPDATE EMPLOYEE
SET HIRE_DATE  = STR_TO_DATE('01/01/2006', '%d/%m/%Y'),
    SALARY     = (SELECT s  FROM (SELECT SALARY AS s FROM EMPLOYEE WHERE LAST_NAME = 'DOYLE') AS t1),
    MANAGER_ID = (SELECT id FROM (SELECT EMPLOYEE_ID AS id FROM EMPLOYEE WHERE FIRST_NAME = 'JOHN') AS t2)
WHERE EMPLOYEE_ID IN (7876, 7916, 7919, 7950, 7951, 7954);

-- ---------------------------------------------------------------
-- Ejercicio 9.16: Insertar un empleado de apellido Fernández con nº de identificación 6000. La fecha de alta será la de hoy, el salario el de GREGORY más un 20% y el resto de datos los mismos que GREGORY.
INSERT INTO EMPLOYEE (EMPLOYEE_ID, LAST_NAME, FIRST_NAME, MIDDLE_INITIAL, JOB_ID,
                      MANAGER_ID, HIRE_DATE, SALARY, COMMISSION, DEPARTMENT_ID)
SELECT 6000, 'FERNANDEZ', FIRST_NAME, MIDDLE_INITIAL, JOB_ID,
       MANAGER_ID, CURDATE(), SALARY * 1.20, COMMISSION, DEPARTMENT_ID
FROM EMPLOYEE
WHERE FIRST_NAME = 'GREGORY';

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

-- ---------------------------------------------------------------
-- Ejercicio 9.18: Borrar todos los departamentos para los cuales no existen empleados.
-- 🔐 versión por clave primaria
-- Paso 1 · ¿Qué departamentos no tienen empleados? Anota sus claves
SELECT DEPARTMENT_ID, NAME
FROM DEPARTMENT
WHERE DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID FROM EMPLOYEE WHERE DEPARTMENT_ID IS NOT NULL);
-- Paso 2 · Transacción (para el ejercicio 22) y borrado por clave primaria
START TRANSACTION;
SAVEPOINT antes_borrados;
DELETE FROM DEPARTMENT
WHERE DEPARTMENT_ID IN (40, 44);

-- ---------------------------------------------------------------
-- Ejercicio 9.19: Borrar aquellos clientes que no han realizado compras.
-- 🔐 versión por clave primaria
-- Paso 1 · Clientes sin pedidos
SELECT CUSTOMER_ID, NAME
FROM CUSTOMER
WHERE CUSTOMER_ID NOT IN (SELECT CUSTOMER_ID FROM SALES_ORDER);
-- Paso 2 · Borrado por clave primaria
DELETE FROM CUSTOMER
WHERE CUSTOMER_ID IN (211, 212, 213, 214, 215, 216, 217, 218, 300, 301);

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

-- ---------------------------------------------------------------
-- Ejercicio 9.21: Borrar el departamento 43.
DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID = 43;

-- ---------------------------------------------------------------
-- Ejercicio 9.22: Hacer ROLLBACK. Insertar a María Camacho (8000, función 669, jefe 7820, hoy, 1300, comisión 50, dept. 20, inicial Q) y a Bernabé González (9000, función 670, jefe 7820, hoy, 6000, comisión 600, dept. 43, inicial S). Comprobar si el ejercicio anterior sigue siendo válido.
ROLLBACK TO antes_borrados;
COMMIT;  -- cerramos la transacción (los ejercicios 18-21 quedan deshechos)
INSERT INTO EMPLOYEE VALUES
 (8000, 'CAMACHO',  'MARIA',   'Q', 669, 7820, CURDATE(), 1300,  50, 20),
 (9000, 'GONZALEZ', 'BERNABE', 'S', 670, 7820, CURDATE(), 6000, 600, 43);
-- ❌ (da ERROR 1451 a propósito)
-- ❌ DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID = 43;
