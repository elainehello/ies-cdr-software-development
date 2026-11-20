-- =====================================================================
-- RA4_consultas_SELECT.sql · Temas 2, 4, 6, 7 y 8 en MySQL 8.0 (comprobado)
-- Ejecuta antes ej_MYSQL.sql (BD limpia). Las sentencias que fallan a propósito van con  -- ❌
-- =====================================================================

USE Empleados;
SET lc_time_names = 'es_ES';

-- #####################################################################
-- Tema 2 · Consultas: SELECT, alias, WHERE, ORDER BY
-- #####################################################################

-- 2.E1: Ejemplo · Seleccionar código, apellido, puesto, fecha de entrada y salario de todos los empleados.
SELECT EMPLOYEE_ID, LAST_NAME, JOB_ID, HIRE_DATE, SALARY
FROM EMPLOYEE;

-- 2.E2: Ejemplo · Todas las columnas de la tabla de departamentos.
SELECT * FROM DEPARTMENT;

-- 2.A1: Alias de columna · Apellido, salario mensual y salario anual (14 pagas) con cabeceras en español.
SELECT LAST_NAME        AS apellido,
       SALARY           AS "salario mensual",
       SALARY * 14      AS anual
FROM EMPLOYEE;

-- 2.A2: Alias de tabla · Apellido y salario de los empleados del departamento 20, usando un alias corto para la tabla.
SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEE AS e
WHERE e.DEPARTMENT_ID = 20;

-- 2.A3: Trampa · Usar el alias de columna en el WHERE.
-- ❌ (da ERROR 1054 a propósito)
-- ❌ SELECT LAST_NAME, SALARY * 14 AS anual
-- ❌ FROM EMPLOYEE
-- ❌ WHERE anual > 40000;
-- ✅ Solución: repetir la expresión
SELECT LAST_NAME, SALARY * 14 AS anual
FROM EMPLOYEE
WHERE SALARY * 14 > 40000;

-- 2.A4: El alias sí funciona en ORDER BY · Empleados ordenados por salario anual de mayor a menor.
SELECT LAST_NAME, SALARY * 14 AS anual
FROM EMPLOYEE
ORDER BY anual DESC;

-- 2.E3: Ejemplo DISTINCT · Los distintos departamentos que aparecen en la tabla de empleados.
SELECT DISTINCT DEPARTMENT_ID
FROM EMPLOYEE;

-- 2.E4: Ejemplo DISTINCT con dos columnas · Los distintos puestos que hay en cada departamento.
SELECT DISTINCT DEPARTMENT_ID, JOB_ID
FROM EMPLOYEE
ORDER BY DEPARTMENT_ID, JOB_ID;

-- 2.E5: Ejemplo WHERE · Vendedores (puesto 670 = SALESPERSON).
SELECT LAST_NAME, JOB_ID, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE JOB_ID = 670;

-- 2.E6: Ejemplo · Empleados que no trabajan en el departamento 30.
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEE
WHERE DEPARTMENT_ID <> 30;

-- 2.E7: Ejemplo · Empleados que entraron antes del 1 de enero de 1985.
SELECT LAST_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE < '1985-01-01';

-- 2.E8: Ejemplo AND · Vendedores que ganan más de 1500.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE JOB_ID = 670 AND SALARY > 1500;

-- 2.E9: Ejemplo OR · Empleados que son CLERK (667) o trabajan en el departamento 10.
SELECT LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM EMPLOYEE
WHERE JOB_ID = 667 OR DEPARTMENT_ID = 10;

-- 2.E10: Ejemplo IN / NOT IN · Empleados que se apellidan SMITH, ALLEN, SCOTT o MILLER, y los que no.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE LAST_NAME IN ('SMITH', 'ALLEN', 'SCOTT', 'MILLER');
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE LAST_NAME NOT IN ('SMITH', 'ALLEN', 'SCOTT', 'MILLER');

-- 2.E11: Ejemplo prioridad · Empleados del departamento 20 que sean CLERK o MANAGER, con y sin paréntesis.
-- Con paréntesis: (20) Y (CLERK o MANAGER)
SELECT LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20 AND (JOB_ID = 667 OR JOB_ID = 671);
-- Sin paréntesis: (20 y CLERK) O (MANAGER de cualquier departamento)
SELECT LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20 AND JOB_ID = 667 OR JOB_ID = 671;

-- 2.E12: Ejemplo BETWEEN · Comisión entre 200 y 600; salario fuera del rango 1000–2000; contratados en 1985.
SELECT LAST_NAME, SALARY, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION BETWEEN 200 AND 600;
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 1000 AND 2000;
SELECT LAST_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '1985-01-01' AND '1985-12-31';

-- 2.E13: Ejemplo NULL · Empleados con comisión y empleados sin comisión.
SELECT LAST_NAME, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION IS NOT NULL;
SELECT LAST_NAME, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION IS NULL;
-- ❌ Trampa: no da error, pero devuelve 0 filas
SELECT LAST_NAME, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION = NULL;

-- 2.E14: Ejemplo LIKE · Apellido que empieza por A · segunda letra D · una T que no sea ni la primera ni la última letra.
SELECT LAST_NAME FROM EMPLOYEE WHERE LAST_NAME LIKE 'A%';
SELECT LAST_NAME FROM EMPLOYEE WHERE LAST_NAME LIKE '_D%';
SELECT LAST_NAME FROM EMPLOYEE WHERE LAST_NAME LIKE '_%T%_';

-- 2.E15: Ejemplo ORDER BY · Los que ganan más de 1500 ordenados por puesto; los del 20 por salario descendente; los sin comisión por departamento y salario descendente.
SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEE
WHERE SALARY > 1500
ORDER BY JOB_ID;
SELECT *
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20
ORDER BY SALARY DESC;
SELECT *
FROM EMPLOYEE
WHERE COMMISSION IS NULL
ORDER BY DEPARTMENT_ID, SALARY DESC;

-- 2.1: Mostrar todos los empleados cuyo código de empleado es mayor que 100.
SELECT *
FROM EMPLOYEE
WHERE EMPLOYEE_ID > 100;

-- 2.2: Mostrar nombre y salario de los que cobran 3000.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = 3000;

-- 2.3: Mostrar los datos de los empleados que se llamen ALICE.
SELECT *
FROM EMPLOYEE
WHERE FIRST_NAME = 'ALICE';

-- 2.4: Mostrar nombre, salario y comisión de aquellos cuyo apellido empieza por M.
SELECT FIRST_NAME, LAST_NAME, SALARY, COMMISSION
FROM EMPLOYEE
WHERE LAST_NAME LIKE 'M%';

-- 2.5: Empleados cuyo salario esté entre 1000 y 3000.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 1000 AND 3000;

-- 2.6: Empleados cuyo salario no esté entre 1000 y 3000.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 1000 AND 3000;

-- 2.7: Todos los trabajadores que, trabajando en el 20, cobren más de 1000, más todos los del 30.
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEE
WHERE (DEPARTMENT_ID = 20 AND SALARY > 1000)
   OR DEPARTMENT_ID = 30;

-- 2.8: Nombre y apellido de los trabajadores que no cobran comisión, ordenados alfabéticamente.
SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE COMMISSION IS NULL OR COMMISSION = 0
ORDER BY LAST_NAME, FIRST_NAME;

-- 2.9: Nombre de los empleados cuya comisión sea superior al 10 % de su salario.
SELECT FIRST_NAME, LAST_NAME, SALARY, COMMISSION
FROM EMPLOYEE
WHERE COMMISSION > SALARY * 0.10;

-- 2.10: Visualizar toda la información de los empleados cuyo apellido comienza por D.
SELECT *
FROM EMPLOYEE
WHERE LAST_NAME LIKE 'D%';

-- 2.11: Nombre de los empleados con un salario anual (sin comisión) menor a 12 000.
SELECT FIRST_NAME, LAST_NAME, SALARY, SALARY * 12 AS salario_anual
FROM EMPLOYEE
WHERE SALARY * 12 < 12000;

-- 2.12: Mostrar ordenados alfabéticamente los distintos nombres de los departamentos.
SELECT DISTINCT NAME
FROM DEPARTMENT
ORDER BY NAME;

-- 2.13: Información de los empleados de los departamentos 20 y 30 que cobran comisión.
SELECT *
FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (20, 30)
  AND COMMISSION > 0;

-- 2.14: Información de todos los empleados del departamento 20 y de los empleados del departamento 30 que cobran comisión.
SELECT *
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20
   OR (DEPARTMENT_ID = 30 AND COMMISSION > 0);

-- 2.15: ¿Cuánto cobraría cada empleado si incrementamos su salario (sin comisión) un 20 %?
SELECT FIRST_NAME, LAST_NAME, SALARY, SALARY * 1.20 AS salario_con_subida
FROM EMPLOYEE;

-- 2.16: De los empleados de los departamentos 30 y 13: nombre, salario actual, salario con un 10 % más y con un 5 % menos.
SELECT FIRST_NAME, LAST_NAME, SALARY,
       SALARY * 1.10 AS mas_10,
       SALARY * 0.95 AS menos_5
FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (30, 13);

-- 2.17: Mostrar el código del departamento donde trabaja el jefe (el que no tiene jefe).
SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 2.18: ¿Qué empleados tienen como jefe al empleado con código 7788?
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE MANAGER_ID = 7788;

-- 2.19: Seleccionar de la tabla de precios los precios que se aplican actualmente.
SELECT PRODUCT_ID, LIST_PRICE, MIN_PRICE, START_DATE
FROM PRICE
WHERE END_DATE IS NULL;

-- #####################################################################
-- Tema 4 · Funciones de una fila
-- #####################################################################

-- 4.E1: Ejemplo · Salario anual (15 pagas) de cada empleado, y solo los que superan 25 000 al año.
SELECT LAST_NAME, SALARY, SALARY * 15 AS anual, JOB_ID
FROM EMPLOYEE;
SELECT LAST_NAME, SALARY, SALARY * 15 AS anual
FROM EMPLOYEE
WHERE SALARY * 15 > 25000;

-- 4.E2: Ejemplo IFNULL · Total mensual (salario + comisión) de cada empleado.
-- ❌ Problema: SALARY + NULL = NULL
SELECT LAST_NAME, SALARY, COMMISSION, SALARY + COMMISSION AS total
FROM EMPLOYEE;
-- ✅ Con IFNULL
SELECT LAST_NAME, SALARY, COMMISSION, SALARY + IFNULL(COMMISSION, 0) AS total
FROM EMPLOYEE;

-- 4.E3: Ejemplo · Funciones numéricas sobre el salario diario (salario / 30).
SELECT LAST_NAME, SALARY,
       SALARY / 30            AS diario,
       CEIL(SALARY / 30)      AS techo,
       FLOOR(SALARY / 30)     AS suelo,
       ROUND(SALARY / 30)     AS redondeo,
       ROUND(SALARY / 30, 2)  AS redondeo_2,
       TRUNCATE(SALARY / 30, 2) AS truncado_2,
       MOD(SALARY, 30)        AS resto
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20;

-- 4.E4: Ejemplo · ABS, SIGN, POWER y SQRT respecto a 1500.
SELECT LAST_NAME, SALARY,
       ABS(SALARY - 1500)  AS distancia_a_1500,
       SIGN(SALARY - 1500) AS signo,
       POWER(SALARY, 2)    AS cuadrado,
       SQRT(SALARY)        AS raiz
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 30;

-- 4.E5: Trampa · TRUNCATE con un solo argumento (como el TRUNC de Oracle).
-- ❌ (da ERROR 1064 a propósito)
-- ❌ SELECT TRUNCATE(SALARY / 30), LAST_NAME FROM EMPLOYEE;
SELECT TRUNCATE(SALARY / 30, 0) AS truncado, LAST_NAME FROM EMPLOYEE;

-- 4.E6: Ejemplo · Funciones de texto sobre el apellido.
SELECT LAST_NAME,
       LENGTH(LAST_NAME)          AS longitud,
       LOWER(LAST_NAME)           AS minusculas,
       ASCII(LAST_NAME)           AS ascii_1a_letra,
       INSTR(LAST_NAME, 'A')      AS posicion_A,
       SUBSTRING(LAST_NAME, 2, 3) AS desde_2_tres_letras,
       LEFT(LAST_NAME, 2)         AS izq2,
       RIGHT(LAST_NAME, 2)        AS der2
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 30;

-- 4.E7: Ejemplo · TRIM, LPAD, RPAD, REPLACE y CONCAT.
SELECT CONCAT('[', TRIM('   Hola   '), ']')  AS con_trim,
       CONCAT('[', LTRIM('   Hola'), ']')     AS con_ltrim,
       CONCAT('[', RTRIM('Hola   '), ']')     AS con_rtrim,
       LPAD('MANAGER', 12, '.')              AS lpad,
       RPAD('MANAGER', 12, '.')              AS rpad,
       REPLACE('MANAGER', 'M', 'SA')          AS replace_;

-- 4.E8: Trampa · LPAD con dos argumentos (como en Oracle) y concatenar con ||.
-- ❌ (da ERROR 1582 a propósito)
-- ❌ SELECT LPAD(LAST_NAME, 12) FROM EMPLOYEE;
SELECT LPAD(LAST_NAME, 12, ' ') AS alineado,
       CONCAT(LAST_NAME, ', ', FIRST_NAME) AS nombre_completo
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 10;

-- 4.E9: Ejemplo · GREATEST y LEAST, y qué pasa con NULL.
SELECT LAST_NAME, SALARY, COMMISSION,
       LEAST(SALARY, COMMISSION)            AS menor,
       LEAST(SALARY, IFNULL(COMMISSION, 0)) AS menor_sin_null,
       GREATEST('rosa', 'rosae', 'rosarum', 'rosi') AS mayor_alfabetico
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 30;

-- 4.1: Mostrar el nombre y lo que cobra cada empleado (salario + comisión + 10 % del salario).
SELECT FIRST_NAME, LAST_NAME,
       SALARY + IFNULL(COMMISSION, 0) + SALARY * 0.10 AS cobra
FROM EMPLOYEE;

-- 4.2: Nombre de los empleados que perderían dinero si en lugar de la comisión les diéramos un 15 % de salario adicional.
SELECT FIRST_NAME, LAST_NAME, SALARY, COMMISSION, SALARY * 0.15 AS quince_por_ciento
FROM EMPLOYEE
WHERE COMMISSION > SALARY * 0.15;

-- 4.3: Si la paga es mensual, ¿cuánto cobraría cada trabajador con 14 pagas anuales incluida la comisión?
SELECT FIRST_NAME, LAST_NAME,
       (SALARY + IFNULL(COMMISSION, 0)) * 14 AS anual
FROM EMPLOYEE;

-- 4.4: Potencia de 5 elevado a 3.
SELECT POWER(5, 3) AS potencia;

-- 4.5: Raíz cuadrada de 81.
SELECT SQRT(81) AS raiz;

-- 4.6: Visualizar los códigos de departamento de todos los empleados, sin que se repitan.
SELECT DISTINCT DEPARTMENT_ID
FROM EMPLOYEE
ORDER BY DEPARTMENT_ID;

-- 4.7: Código ASCII de la letra M.
SELECT ASCII('M') AS codigo;

-- 4.8: Carácter que corresponde al código ASCII 65.
SELECT CHAR(65 USING utf8mb4) AS caracter;

-- 4.9: Generar la salida «Hoy Esta Nublado» con la cabecera «El tiempo».
SELECT 'Hoy Esta Nublado' AS "El tiempo";

-- 4.10: ¿Qué longitud tiene la cadena «Hoy esta Nublado»?
SELECT LENGTH('Hoy esta Nublado') AS longitud;

-- 4.11: Seleccionar los que se apellidan MILLER, escrito en mayúsculas.
SELECT *
FROM EMPLOYEE
WHERE UPPER(LAST_NAME) = 'MILLER';

-- 4.12: Quitar la primera A de los nombres de los empleados.
SELECT FIRST_NAME,
       CONCAT(LEFT(FIRST_NAME, INSTR(FIRST_NAME, 'A') - 1),
              SUBSTRING(FIRST_NAME, INSTR(FIRST_NAME, 'A') + 1)) AS sin_primera_A
FROM EMPLOYEE;

-- 4.13: Visualizar los salarios con longitud 10, rellenando con $ por la izquierda.
SELECT FIRST_NAME, LPAD(ROUND(SALARY), 10, '$') AS salario
FROM EMPLOYEE;

-- 4.14: Extraer los caracteres 3º y 4º de los nombres.
SELECT FIRST_NAME, SUBSTRING(FIRST_NAME, 3, 2) AS letras_3_y_4
FROM EMPLOYEE;

-- 4.15: Cambiar las B por J en los nombres.
SELECT FIRST_NAME, REPLACE(FIRST_NAME, 'B', 'J') AS cambiado
FROM EMPLOYEE;

-- 4.16: Según la inicial del segundo nombre (MIDDLE_INITIAL): A → «Alto», M → «Mediano» y cualquier otra → «Otros».
SELECT FIRST_NAME, LAST_NAME, MIDDLE_INITIAL,
       CASE MIDDLE_INITIAL
            WHEN 'A' THEN 'Alto'
            WHEN 'M' THEN 'Mediano'
            ELSE 'Otros'
       END AS categoria
FROM EMPLOYEE;

-- 4.17: Empleados cuyas iniciales de nombre y apellido son consecutivas en el alfabeto.
SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE ABS(ASCII(FIRST_NAME) - ASCII(LAST_NAME)) = 1;
-- Comprobación con la inicial del segundo nombre
SELECT FIRST_NAME, MIDDLE_INITIAL, LAST_NAME
FROM EMPLOYEE
WHERE ABS(ASCII(FIRST_NAME) - ASCII(MIDDLE_INITIAL)) = 1;

-- 4.18: Mostrar la última letra del nombre de los empleados.
SELECT FIRST_NAME, RIGHT(FIRST_NAME, 1) AS ultima
FROM EMPLOYEE;

-- 4.19: Listado: « cobra anualmente ».
SELECT CONCAT(FIRST_NAME, ' cobra anualmente ', SALARY * 12) AS frase
FROM EMPLOYEE;

-- 4.20: Nombre, salario y número de estrellas (una por cada 1000 de salario: 0–999 → 0, 1000–1999 → 1…).
SELECT FIRST_NAME, SALARY,
       TRUNCATE(SALARY / 1000, 0)          AS "numero de estrellas",
       REPEAT('*', TRUNCATE(SALARY / 1000, 0)) AS estrellas
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- #####################################################################
-- Tema 6 · Funciones de fecha y de grupo
-- #####################################################################

-- 6.E1: Ejemplo · Fecha y hora actuales.
SELECT NOW() AS ahora, CURDATE() AS hoy, CURTIME() AS hora;

-- 6.E2: Ejemplo · Fecha de contratación del departamento 20 con el formato «día de mes de año».
SELECT LAST_NAME, DATE_FORMAT(HIRE_DATE, '%d de %M de %Y') AS entrada
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20;

-- 6.E3: Trampa · Usar STR_TO_CHAR como en el PDF.
-- ❌ (da ERROR 1305 a propósito)
-- ❌ SELECT LAST_NAME, STR_TO_CHAR(HIRE_DATE, '%d DE %M DE %Y') FROM EMPLOYEE;

-- 6.E4: Ejemplo · Vendedores con su fecha de entrada como «nombre del día, día de mes de año».
SELECT LAST_NAME, DATE_FORMAT(HIRE_DATE, '%W, %d de %M de %Y') AS entrada
FROM EMPLOYEE
WHERE JOB_ID = 670;

-- 6.E5: Ejemplo STR_TO_DATE · Convertir textos con formato europeo en fechas.
SELECT STR_TO_DATE('25/10/2026', '%d/%m/%Y')                   AS fecha,
       STR_TO_DATE('25/10/2026 14:30:00', '%d/%m/%Y %H:%i:%s') AS fecha_hora;

-- 6.E6: Ejemplo · Sumar y restar días, semanas, meses y años.
SELECT DATE_ADD('2026-10-11', INTERVAL 7 DAY)   AS mas_7_dias,
       '2026-10-11' + INTERVAL 7 DAY             AS igual_con_mas,
       DATE_ADD('2026-10-11', INTERVAL 3 MONTH) AS mas_3_meses,
       DATE_ADD('2026-10-11', INTERVAL 2 YEAR)  AS mas_2_anios,
       DATE_ADD('2026-10-11', INTERVAL 2 WEEK)  AS mas_2_semanas,
       DATE_SUB('2026-10-11', INTERVAL 10 DAY)  AS menos_10_dias,
       DATE_SUB('2026-10-11', INTERVAL 2 MONTH) AS menos_2_meses;

-- 6.E7: Ejemplo · Fecha de vencimiento de cada pedido: 30 días después de su fecha.
SELECT ORDER_ID, ORDER_DATE,
       DATE_ADD(ORDER_DATE, INTERVAL 30 DAY) AS vencimiento
FROM SALES_ORDER
WHERE CUSTOMER_ID = 100;

-- 6.E8: Ejemplo · Partes de una fecha y diferencias.
SELECT LAST_NAME, HIRE_DATE,
       YEAR(HIRE_DATE) AS anio, MONTH(HIRE_DATE) AS mes, DAY(HIRE_DATE) AS dia,
       QUARTER(HIRE_DATE) AS trimestre, MONTHNAME(HIRE_DATE) AS nombre_mes,
       DAYNAME(HIRE_DATE) AS nombre_dia, LAST_DAY(HIRE_DATE) AS fin_de_mes
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 30;

-- 6.1: Sumar 15 horas a la fecha de hoy.
SELECT NOW() AS ahora, NOW() + INTERVAL 15 HOUR AS dentro_de_15_horas;

-- 6.2: Mostrar el nombre del día de la semana en que naciste.
-- Cambia la fecha por la tuya
SELECT DAYNAME('2000-05-17') AS dia_nacimiento,
       DATE_FORMAT('2000-05-17', '%W, %d de %M de %Y') AS completo;

-- 6.3: ¿Qué día de la semana caerá el primer día del próximo año?
SELECT MAKEDATE(YEAR(CURDATE()) + 1, 1) AS uno_de_enero,
       DAYNAME(MAKEDATE(YEAR(CURDATE()) + 1, 1)) AS dia;

-- 6.4: ¿Cuántos días tiene el mes de febrero del año que viene?
SELECT DAY(LAST_DAY(MAKEDATE(YEAR(CURDATE()) + 1, 32))) AS dias_febrero;

-- 6.5: De cada empleado, su nombre y el nombre del mes en que llegó a la empresa.
SELECT FIRST_NAME, LAST_NAME, MONTHNAME(HIRE_DATE) AS mes_llegada
FROM EMPLOYEE;

-- 6.6: Nombre de cada mes y número de empleados contratados en ese mes.
SELECT MONTH(HIRE_DATE) AS num_mes, MONTHNAME(HIRE_DATE) AS mes, COUNT(*) AS contratados
FROM EMPLOYEE
GROUP BY MONTH(HIRE_DATE), MONTHNAME(HIRE_DATE)
ORDER BY num_mes;
-- ❌ (da ERROR 1055 a propósito)
-- ❌ SELECT MONTHNAME(HIRE_DATE) AS mes, LAST_NAME, COUNT(*)
-- ❌ FROM EMPLOYEE
-- ❌ GROUP BY MONTHNAME(HIRE_DATE);

-- 6.7: ¿Cuántos empleados se contrataron en el mes con más contrataciones?
SELECT MAX(contratados) AS maximo
FROM (SELECT COUNT(*) AS contratados
      FROM EMPLOYEE
      GROUP BY MONTH(HIRE_DATE)) AS t;
-- ❌ (da ERROR 1111 a propósito)
-- ❌ SELECT MAX(COUNT(*)) FROM EMPLOYEE GROUP BY MONTH(HIRE_DATE);

-- 6.8: Nombre de cada empleado y número de meses (sin decimales) que lleva trabajando en la empresa.
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE,
       TIMESTAMPDIFF(MONTH, HIRE_DATE, CURDATE()) AS meses
FROM EMPLOYEE;

-- 6.9: ¿Cuántos meses lleva trabajando el empleado que más tiempo lleva?
SELECT MAX(TIMESTAMPDIFF(MONTH, HIRE_DATE, CURDATE())) AS meses_maximo
FROM EMPLOYEE;

-- 6.10: ¿Cuántos empleados han sido contratados durante el segundo trimestre de cualquier año?
SELECT COUNT(*) AS contratados_2T
FROM EMPLOYEE
WHERE QUARTER(HIRE_DATE) = 2;

-- 6.11: ¿Cuántos pedidos (SALES_ORDER) se han hecho en julio y agosto desde que la empresa funciona?
SELECT COUNT(*) AS pedidos_jul_ago
FROM SALES_ORDER
WHERE MONTH(ORDER_DATE) IN (7, 8);

-- 6.12: De cada mes del año, su nombre y el número de pedidos realizados (todos los años).
SELECT MONTH(ORDER_DATE) AS num_mes, MONTHNAME(ORDER_DATE) AS mes, COUNT(*) AS pedidos
FROM SALES_ORDER
GROUP BY MONTH(ORDER_DATE), MONTHNAME(ORDER_DATE)
ORDER BY num_mes;

-- 6.13: ¿En qué meses de 1989 se hicieron al menos 2 pedidos?
SELECT MONTHNAME(ORDER_DATE) AS mes, COUNT(*) AS pedidos
FROM SALES_ORDER
WHERE YEAR(ORDER_DATE) = 1989
GROUP BY MONTH(ORDER_DATE), MONTHNAME(ORDER_DATE)
HAVING COUNT(*) >= 2
ORDER BY MONTH(ORDER_DATE);

-- 6.14: ¿Cuántos pedidos han tardado más de 6 días en servirse?
SELECT COUNT(*) AS pedidos_lentos
FROM SALES_ORDER
WHERE DATEDIFF(SHIP_DATE, ORDER_DATE) > 6;

-- 6.15: Código de departamento y media salarial de los departamentos con más de dos empleados contratados en abril (de cualquier año).
SELECT DEPARTMENT_ID, AVG(SALARY) AS media, COUNT(*) AS contratados_abril
FROM EMPLOYEE
WHERE MONTH(HIRE_DATE) = 4
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) > 2;

-- 6.16: Número de empleados cuyo apellido empieza por S y fueron contratados en el segundo trimestre.
SELECT COUNT(*) AS total
FROM EMPLOYEE
WHERE LAST_NAME LIKE 'S%'
  AND QUARTER(HIRE_DATE) = 2;

-- 6.17: De cada departamento: código, media salarial y nº de empleados en la media, contando solo a los que llevan más de 250 meses en la empresa.
SELECT DEPARTMENT_ID, AVG(SALARY) AS media, COUNT(*) AS empleados
FROM EMPLOYEE
WHERE TIMESTAMPDIFF(MONTH, HIRE_DATE, CURDATE()) > 250
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

-- 6.18: Número de empleados contratados en meses de 30 días.
SELECT COUNT(*) AS total
FROM EMPLOYEE
WHERE DAY(LAST_DAY(HIRE_DATE)) = 30;

-- 6.19: Media del salario de los empleados contratados en 1986.
SELECT AVG(SALARY) AS media_1986
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1986;

-- 6.20: Por departamento, media del salario de los contratados en 1985.
SELECT DEPARTMENT_ID, AVG(SALARY) AS media_1985
FROM EMPLOYEE
WHERE YEAR(HIRE_DATE) = 1985
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

-- 6.21: Código de los productos que dejaron de comercializarse (fin de precio) en 1989, con su precio máximo y mínimo.
SELECT PRODUCT_ID, MAX(LIST_PRICE) AS precio_max, MIN(LIST_PRICE) AS precio_min
FROM PRICE
WHERE YEAR(END_DATE) = 1989
GROUP BY PRODUCT_ID;

-- #####################################################################
-- Tema 7 · Subconsultas
-- #####################################################################

-- 7.E1: Ejemplo · Empleados que trabajan en el mismo departamento que CLARK.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM EMPLOYEE
                       WHERE LAST_NAME = 'CLARK');

-- 7.E2: Ejemplo · Empleados cuyo salario es superior al de ADAMS.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE LAST_NAME = 'ADAMS');

-- 7.E3: Ejemplo · Nombre y fecha de entrada del empleado que más tiempo lleva en la empresa.
SELECT LAST_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE);

-- 7.E4: Ejemplo · Empleados que trabajan en CHICAGO (dos niveles de subconsulta).
SELECT LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENT
                        WHERE LOCATION_ID = (SELECT LOCATION_ID
                                             FROM LOCATION
                                             WHERE REGIONAL_GROUP = 'CHICAGO'));

-- 7.E5: Trampa · Usar = cuando la subconsulta devuelve varias filas.
-- ❌ (da ERROR 1242 a propósito)
-- ❌ SELECT LAST_NAME
-- ❌ FROM EMPLOYEE
-- ❌ WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME = 'RESEARCH');
SELECT LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME = 'RESEARCH');

-- 7.E6: Ejemplo IN · Empleados con el mismo puesto que alguno del departamento 20.
SELECT LAST_NAME, JOB_ID
FROM EMPLOYEE
WHERE JOB_ID IN (SELECT JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 20)
ORDER BY JOB_ID;

-- 7.E7: Ejemplo AND/OR · Salario mayor que el de ADAMS o del departamento de SCOTT.
SELECT LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE LAST_NAME = 'ADAMS')
   OR DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEE WHERE LAST_NAME = 'SCOTT');

-- 7.E8: Ejemplo varias columnas · El que más tiempo lleva en cada departamento.
SELECT LAST_NAME, DEPARTMENT_ID, HIRE_DATE
FROM EMPLOYEE
WHERE (HIRE_DATE, DEPARTMENT_ID) IN (SELECT MIN(HIRE_DATE), DEPARTMENT_ID
                                     FROM EMPLOYEE
                                     GROUP BY DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID;

-- 7.E9: Ejemplo ALL / ANY · Empleados que ganan más que todos los vendedores, y más que alguno.
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEE WHERE JOB_ID = 670);
SELECT LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEE WHERE JOB_ID = 670);

-- 7.E10: Trampa · NOT IN con una subconsulta que devuelve algún NULL: empleados que no son jefes de nadie.
-- ❌ 0 filas: KING tiene MANAGER_ID NULL y la lista contiene un NULL
SELECT LAST_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_ID NOT IN (SELECT MANAGER_ID FROM EMPLOYEE);
-- ✅ Quitando los NULL de la subconsulta
SELECT LAST_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_ID NOT IN (SELECT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL);

-- 7.1: Nombre del empleado que más cobra en la empresa, sin contar la comisión.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

-- 7.2: Nombre de los empleados que trabajan en el departamento RESEARCH.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENT
                        WHERE NAME = 'RESEARCH');

-- 7.3: Nombre de los empleados que trabajan en el mismo departamento que Daniel y cobran lo mismo que él.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEE
WHERE (DEPARTMENT_ID, SALARY) = (SELECT DEPARTMENT_ID, SALARY
                                FROM EMPLOYEE
                                WHERE FIRST_NAME = 'DANIEL')
  AND FIRST_NAME <> 'DANIEL';

-- 7.4: Nombre del empleado más antiguo de la empresa.
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE) FROM EMPLOYEE);

-- 7.5: Nombre de los empleados cuyo responsable directo es Doyle (apellido).
SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE MANAGER_ID = (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE LAST_NAME = 'DOYLE');

-- 7.6: Empleados del departamento 20 que cobran más que alguno de los del departamento 13.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20
  AND SALARY > ANY (SELECT SALARY FROM EMPLOYEE WHERE DEPARTMENT_ID = 13);

-- 7.7: Mostrar si algún empleado del 20 cobra más que todos los del 13.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20
  AND SALARY > ALL (SELECT SALARY FROM EMPLOYEE WHERE DEPARTMENT_ID = 13);

-- 7.8: ¿Cuánto dinero (salario + comisión) cobran al mes en total los empleados de los departamentos de operaciones (OPERATIONS)?
SELECT SUM(SALARY + IFNULL(COMMISSION, 0)) AS total_operaciones
FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME = 'OPERATIONS');

-- 7.9: Nombre de los empleados cuyo salario está por debajo de la media salarial de la empresa.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 7.10: Empleados del departamento 20 con un salario superior a la media de su propio departamento.
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE DEPARTMENT_ID = 20
  AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPARTMENT_ID = 20);

-- 7.11: Nombre de los clientes atendidos por vendedores que trabajan en el departamento de ventas de Boston.
SELECT NAME
FROM CUSTOMER
WHERE SALESPERSON_ID IN (
      SELECT EMPLOYEE_ID FROM EMPLOYEE
      WHERE DEPARTMENT_ID IN (
            SELECT DEPARTMENT_ID FROM DEPARTMENT
            WHERE NAME = 'SALES'
              AND LOCATION_ID = (SELECT LOCATION_ID FROM LOCATION
                                 WHERE REGIONAL_GROUP = 'BOSTON')));

-- 7.12: Nombre de los productos que aparecen en líneas de pedido de más de 10 unidades.
SELECT DESCRIPTION
FROM PRODUCT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM ITEM WHERE QUANTITY > 10);

-- 7.13: Nombre y código de los departamentos con más de 4 empleados.
SELECT DEPARTMENT_ID, NAME
FROM DEPARTMENT
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM EMPLOYEE
                        GROUP BY DEPARTMENT_ID
                        HAVING COUNT(*) > 4);

-- 7.14: Ciudad del departamento que mejor paga a sus empleados (mayor salario medio).
SELECT REGIONAL_GROUP
FROM LOCATION
WHERE LOCATION_ID IN (
      SELECT LOCATION_ID FROM DEPARTMENT
      WHERE DEPARTMENT_ID IN (
            SELECT DEPARTMENT_ID FROM EMPLOYEE
            GROUP BY DEPARTMENT_ID
            HAVING AVG(SALARY) >= ALL (SELECT AVG(SALARY) FROM EMPLOYEE
                                       GROUP BY DEPARTMENT_ID)));

-- 7.15: Nombre de los productos que nunca se han vendido.
SELECT PRODUCT_ID, DESCRIPTION
FROM PRODUCT
WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ITEM WHERE PRODUCT_ID IS NOT NULL);

-- 7.16: Nombre del producto del que se han vendido más unidades.
SELECT DESCRIPTION
FROM PRODUCT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID
                     FROM ITEM
                     GROUP BY PRODUCT_ID
                     HAVING SUM(QUANTITY) >= ALL (SELECT SUM(QUANTITY)
                                                  FROM ITEM
                                                  GROUP BY PRODUCT_ID));

-- 7.17: Nombre del cliente que menos ha gastado (entre los que han comprado).
SELECT NAME
FROM CUSTOMER
WHERE CUSTOMER_ID IN (SELECT CUSTOMER_ID
                      FROM SALES_ORDER
                      GROUP BY CUSTOMER_ID
                      HAVING SUM(TOTAL) <= ALL (SELECT SUM(TOTAL)
                                                FROM SALES_ORDER
                                                GROUP BY CUSTOMER_ID));

-- 7.18: ¿Cuántos vendedores (SALESPERSON) tiene el departamento que más vendedores tiene?
SELECT MAX(n) AS vendedores
FROM (SELECT DEPARTMENT_ID, COUNT(*) AS n
      FROM EMPLOYEE
      WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE FUNCTIONS = 'SALESPERSON')
      GROUP BY DEPARTMENT_ID) AS t;

-- 7.19: Nombre del departamento donde trabaja el empleado con el menor sueldo.
SELECT DEPARTMENT_ID, NAME
FROM DEPARTMENT
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM EMPLOYEE
                        WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE));

-- 7.20: Nombre, apellido, función y departamento de los empleados con el salario mínimo de su función.
SELECT e.FIRST_NAME, e.LAST_NAME,
       (SELECT j.FUNCTIONS FROM JOB AS j WHERE j.JOB_ID = e.JOB_ID) AS funcion,
       e.DEPARTMENT_ID, e.SALARY
FROM EMPLOYEE AS e
WHERE e.SALARY = (SELECT MIN(e2.SALARY)
                  FROM EMPLOYEE AS e2
                  WHERE e2.JOB_ID = e.JOB_ID)
ORDER BY funcion;

-- 7.21: Nombre, apellido y salario de los empleados con el salario máximo de su departamento.
SELECT FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEE
WHERE (DEPARTMENT_ID, SALARY) IN (SELECT DEPARTMENT_ID, MAX(SALARY)
                                  FROM EMPLOYEE
                                  GROUP BY DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID;

-- 7.22: Nombre, apellido y fecha de contratación de los contratados en el mes con menos contrataciones.
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE MONTH(HIRE_DATE) IN (
      SELECT m
      FROM (SELECT MONTH(HIRE_DATE) AS m, COUNT(*) AS n
            FROM EMPLOYEE
            GROUP BY MONTH(HIRE_DATE)) AS por_mes
      WHERE n = (SELECT MIN(n) FROM (SELECT COUNT(*) AS n
                                     FROM EMPLOYEE
                                     GROUP BY MONTH(HIRE_DATE)) AS t));

-- 7.23: Nombre, ciudad y estado de los clientes cuyo pedido medio supera los 500 $.
SELECT NAME, CITY, STATE
FROM CUSTOMER
WHERE CUSTOMER_ID IN (SELECT CUSTOMER_ID
                      FROM SALES_ORDER
                      GROUP BY CUSTOMER_ID
                      HAVING AVG(TOTAL) > 500);

-- 7.24: Límite de crédito mínimo de los clientes que representa el vendedor de apellido TURNER.
SELECT MIN(CREDIT_LIMIT) AS credito_minimo
FROM CUSTOMER
WHERE SALESPERSON_ID = (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE LAST_NAME = 'TURNER');

-- 7.25: Nombre de los empleados cuya función es vendedor (SALESPERSON).
SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE JOB_ID = (SELECT JOB_ID FROM JOB WHERE FUNCTIONS = 'SALESPERSON');

-- #####################################################################
-- Tema 8 · Combinaciones (JOIN)
-- #####################################################################

-- 8.E1: Ejemplo · Apellido, puesto, departamento, nombre del departamento y salario de cada empleado (estilo clásico y estilo ANSI).
-- Estilo clásico (el del PDF)
SELECT e.LAST_NAME, e.JOB_ID, e.DEPARTMENT_ID, d.NAME, e.SALARY
FROM EMPLOYEE e, DEPARTMENT d
WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID;
-- Estilo ANSI (recomendado)
SELECT e.LAST_NAME, e.JOB_ID, e.DEPARTMENT_ID, d.NAME, e.SALARY
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID;

-- 8.E2: Trampa · Producto cartesiano: olvidar la condición de combinación.
SELECT COUNT(*) AS filas
FROM EMPLOYEE, DEPARTMENT;

-- 8.E3: Trampa · Columna ambigua.
-- ❌ (da ERROR 1052 a propósito)
-- ❌ SELECT LAST_NAME, DEPARTMENT_ID, NAME
-- ❌ FROM EMPLOYEE JOIN DEPARTMENT ON EMPLOYEE.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID;
SELECT e.LAST_NAME, e.DEPARTMENT_ID, d.NAME
FROM EMPLOYEE AS e JOIN DEPARTMENT AS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.DEPARTMENT_ID = 20;

-- 8.E4: Ejemplo combinación no común · Salario, apellido, grado y puesto de cada empleado (el grado según el rango de SALARY_GRADE).
SELECT e.SALARY, e.LAST_NAME, g.GRADE_ID, e.JOB_ID
FROM EMPLOYEE AS e
JOIN SALARY_GRADE AS g ON e.SALARY BETWEEN g.LOWER_BOUND AND g.UPPER_BOUND
ORDER BY g.GRADE_ID;

-- 8.E5: Ejemplo tres tablas · Salario, apellido, grado, puesto y ciudad de cada empleado, ordenado por grado.
SELECT e.SALARY, e.LAST_NAME, g.GRADE_ID, e.JOB_ID, l.REGIONAL_GROUP AS ciudad
FROM EMPLOYEE AS e
JOIN SALARY_GRADE AS g ON e.SALARY BETWEEN g.LOWER_BOUND AND g.UPPER_BOUND
JOIN DEPARTMENT   AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
JOIN LOCATION     AS l ON l.LOCATION_ID = d.LOCATION_ID
ORDER BY g.GRADE_ID;

-- 8.E6: Ejemplo autocombinación · Para cada empleado: apellido, código de su jefe, departamento y apellido del jefe.
SELECT emp.LAST_NAME AS empleado, emp.MANAGER_ID, emp.DEPARTMENT_ID, jefe.LAST_NAME AS jefe
FROM EMPLOYEE AS emp
JOIN EMPLOYEE AS jefe ON emp.MANAGER_ID = jefe.EMPLOYEE_ID;

-- 8.E7: Ejemplo combinación exterior · Empleados con su departamento, incluido el departamento que no tiene empleados.
SELECT e.LAST_NAME, e.JOB_ID, d.DEPARTMENT_ID, d.NAME, e.SALARY
FROM DEPARTMENT AS d
LEFT JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;
-- ❌ (da ERROR 1064 a propósito)
-- ❌ SELECT e.LAST_NAME, d.DEPARTMENT_ID
-- ❌ FROM EMPLOYEE e, DEPARTMENT d
-- ❌ WHERE d.DEPARTMENT_ID = e.DEPARTMENT_ID(+);

-- 8.E8: Ejemplo · Departamentos sin empleados (LEFT JOIN + IS NULL).
SELECT d.DEPARTMENT_ID, d.NAME
FROM DEPARTMENT AS d
LEFT JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.EMPLOYEE_ID IS NULL;

-- 8.E9: Ejemplo UNION · Apellido, salario y puesto de los empleados de los departamentos 10 o 20.
SELECT LAST_NAME, SALARY, JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 10
UNION
SELECT LAST_NAME, SALARY, JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 20
ORDER BY LAST_NAME;

-- 8.E10: Ejemplo INTERSECT · Vendedores que además trabajan en el departamento 30.
SELECT LAST_NAME, SALARY, JOB_ID FROM EMPLOYEE WHERE JOB_ID = 670
INTERSECT
SELECT LAST_NAME, SALARY, JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 30;

-- 8.E11: Ejemplo EXCEPT (MINUS) · Empleados con un puesto que existe en el departamento 10 pero no en el 20.
SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEE
WHERE JOB_ID IN (SELECT JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 10
                 EXCEPT
                 SELECT JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 20);
-- ❌ (da ERROR 1064 a propósito)
-- ❌ SELECT JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 10
-- ❌ MINUS
-- ❌ SELECT JOB_ID FROM EMPLOYEE WHERE DEPARTMENT_ID = 20;

-- 8.1: Unidades vendidas de cada producto: código de producto y total de unidades.
SELECT PRODUCT_ID, SUM(QUANTITY) AS unidades
FROM ITEM
GROUP BY PRODUCT_ID
ORDER BY PRODUCT_ID;

-- 8.2: Lo mismo, pero mostrando el nombre de cada producto.
SELECT p.DESCRIPTION, SUM(i.QUANTITY) AS unidades
FROM ITEM AS i
JOIN PRODUCT AS p ON p.PRODUCT_ID = i.PRODUCT_ID
GROUP BY p.PRODUCT_ID, p.DESCRIPTION
ORDER BY p.DESCRIPTION;

-- 8.3: Nombre de los empleados y nombre del departamento donde trabajan, de los que cobran comisión.
SELECT e.FIRST_NAME, e.LAST_NAME, d.NAME AS departamento
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE e.COMMISSION > 0;

-- 8.4: ¿Cuántos empleados hay en los departamentos de ventas (SALES)?
SELECT COUNT(*) AS empleados_ventas
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE d.NAME = 'SALES';

-- 8.5: De cada empleado, su nombre y el nombre de la función que realiza.
SELECT e.FIRST_NAME, e.LAST_NAME, j.FUNCTIONS
FROM EMPLOYEE AS e
JOIN JOB AS j ON j.JOB_ID = e.JOB_ID;

-- 8.6: Código y nombre de los departamentos donde trabaja algún empleado (puede haber departamentos sin empleados).
SELECT DISTINCT d.DEPARTMENT_ID, d.NAME
FROM DEPARTMENT AS d
JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
ORDER BY d.DEPARTMENT_ID;

-- 8.7: De cada departamento, su nombre y número de empleados; los departamentos con el mismo nombre en distintas ciudades cuentan como uno solo.
SELECT d.NAME, COUNT(*) AS empleados
FROM DEPARTMENT AS d
JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.NAME;

-- 8.8: Nombre de los clientes junto al nombre del empleado que es su representante de ventas.
SELECT c.NAME AS cliente, e.FIRST_NAME, e.LAST_NAME AS vendedor
FROM CUSTOMER AS c
JOIN EMPLOYEE AS e ON e.EMPLOYEE_ID = c.SALESPERSON_ID;

-- 8.9: Nombre de los clientes cuyo representante de ventas es WARD.
SELECT c.NAME
FROM CUSTOMER AS c
JOIN EMPLOYEE AS e ON e.EMPLOYEE_ID = c.SALESPERSON_ID
WHERE e.LAST_NAME = 'WARD';

-- 8.10: Nombre de los empleados que son vendedores (SALESPERSON).
SELECT e.FIRST_NAME, e.LAST_NAME
FROM EMPLOYEE AS e
JOIN JOB AS j ON j.JOB_ID = e.JOB_ID
WHERE j.FUNCTIONS = 'SALESPERSON';

-- 8.11: ¿Cuántos empleados son vendedores?
SELECT COUNT(*) AS vendedores
FROM EMPLOYEE AS e
JOIN JOB AS j ON j.JOB_ID = e.JOB_ID
WHERE j.FUNCTIONS = 'SALESPERSON';

-- 8.12: De cada producto, su nombre y el precio (LIST_PRICE) que se le aplica actualmente.
SELECT p.DESCRIPTION, pr.LIST_PRICE
FROM PRODUCT AS p
JOIN PRICE AS pr ON pr.PRODUCT_ID = p.PRODUCT_ID
WHERE pr.END_DATE IS NULL;

-- 8.13: De cada cliente y sin repetidos, los códigos de los productos que ha pedido.
SELECT DISTINCT c.NAME, i.PRODUCT_ID
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN ITEM AS i        ON i.ORDER_ID = o.ORDER_ID
ORDER BY c.NAME, i.PRODUCT_ID;

-- 8.14: ¿Cuál es el valor del pedido de mayor valor que ha hecho el cliente JOCKSPORTS?
SELECT MAX(o.TOTAL) AS pedido_mayor
FROM SALES_ORDER AS o
JOIN CUSTOMER AS c ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE c.NAME = 'JOCKSPORTS';

-- 8.15: De cada cliente, su nombre y el valor de su pedido de mayor valor.
SELECT c.NAME, MAX(o.TOTAL) AS pedido_mayor
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.NAME
ORDER BY c.NAME;

-- 8.16: De cada cliente, su nombre y la suma de los totales de todos sus pedidos.
SELECT c.NAME, SUM(o.TOTAL) AS total_gastado
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.NAME
ORDER BY total_gastado DESC;

-- 8.17: Nombre de cada empleado y el grado salarial que le corresponde.
SELECT e.FIRST_NAME, e.LAST_NAME, e.SALARY, g.GRADE_ID
FROM EMPLOYEE AS e
JOIN SALARY_GRADE AS g ON e.SALARY BETWEEN g.LOWER_BOUND AND g.UPPER_BOUND;

-- 8.18: Nombre de cada empleado y, al lado, el nombre de su jefe.
SELECT emp.FIRST_NAME, emp.LAST_NAME, jefe.FIRST_NAME AS nombre_jefe, jefe.LAST_NAME AS apellido_jefe
FROM EMPLOYEE AS emp
JOIN EMPLOYEE AS jefe ON jefe.EMPLOYEE_ID = emp.MANAGER_ID;

-- 8.19: Lo mismo, pero si no tiene jefe que aparezca «No tiene jefe».
SELECT emp.FIRST_NAME, emp.LAST_NAME,
       IFNULL(jefe.LAST_NAME, 'No tiene jefe') AS jefe
FROM EMPLOYEE AS emp
LEFT JOIN EMPLOYEE AS jefe ON jefe.EMPLOYEE_ID = emp.MANAGER_ID;

-- 8.20: De cada departamento: código, nombre y nº de empleados, con 0 si no tiene.
SELECT d.DEPARTMENT_ID, d.NAME, COUNT(e.EMPLOYEE_ID) AS empleados
FROM DEPARTMENT AS d
LEFT JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_ID, d.NAME
ORDER BY d.DEPARTMENT_ID;

-- 8.21: Nombre de cada empleado y el nombre de la ciudad donde trabaja.
SELECT e.FIRST_NAME, e.LAST_NAME, l.REGIONAL_GROUP AS ciudad
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
JOIN LOCATION   AS l ON l.LOCATION_ID = d.LOCATION_ID;

-- 8.22: De cada cliente y sin repetidos, los nombres de los productos que ha pedido.
SELECT DISTINCT c.NAME AS cliente, p.DESCRIPTION AS producto
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN ITEM AS i        ON i.ORDER_ID = o.ORDER_ID
JOIN PRODUCT AS p     ON p.PRODUCT_ID = i.PRODUCT_ID
ORDER BY cliente, producto;

-- 8.23: ¿Cuántos empleados trabajan en el departamento de ventas (SALES) de CHICAGO?
SELECT COUNT(*) AS empleados
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
JOIN LOCATION   AS l ON l.LOCATION_ID = d.LOCATION_ID
WHERE d.NAME = 'SALES' AND l.REGIONAL_GROUP = 'CHICAGO';

-- 8.24: De cada departamento y ciudad, cuántos trabajadores tiene: ciudad, nombre del departamento y nº de empleados.
SELECT l.REGIONAL_GROUP AS ciudad, d.NAME AS departamento, COUNT(e.EMPLOYEE_ID) AS empleados
FROM DEPARTMENT AS d
JOIN LOCATION AS l       ON l.LOCATION_ID = d.LOCATION_ID
LEFT JOIN EMPLOYEE AS e  ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY l.REGIONAL_GROUP, d.NAME
ORDER BY ciudad, departamento;

-- 8.25: Nombre del vendedor con más clientes.
SELECT e.FIRST_NAME, e.LAST_NAME, COUNT(*) AS clientes
FROM EMPLOYEE AS e
JOIN CUSTOMER AS c ON c.SALESPERSON_ID = e.EMPLOYEE_ID
GROUP BY e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM CUSTOMER GROUP BY SALESPERSON_ID);

-- 8.26: Nombre del departamento cuya suma de salarios es la mayor de todas.
SELECT d.DEPARTMENT_ID, d.NAME, SUM(e.SALARY) AS suma
FROM DEPARTMENT AS d
JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_ID, d.NAME
HAVING SUM(e.SALARY) >= ALL (SELECT SUM(SALARY) FROM EMPLOYEE GROUP BY DEPARTMENT_ID);

-- 8.27: Nombre del cliente que ha hecho más pedidos.
SELECT c.NAME, COUNT(*) AS pedidos
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.NAME
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM SALES_ORDER GROUP BY CUSTOMER_ID);

-- 8.28: Nombre del cliente que hizo el pedido de mayor valor.
SELECT c.NAME, o.ORDER_ID, o.TOTAL
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE o.TOTAL = (SELECT MAX(TOTAL) FROM SALES_ORDER);

-- 8.29: Nombre del producto más caro (precio vigente).
SELECT p.DESCRIPTION, pr.LIST_PRICE
FROM PRODUCT AS p
JOIN PRICE AS pr ON pr.PRODUCT_ID = p.PRODUCT_ID
WHERE pr.END_DATE IS NULL
  AND pr.LIST_PRICE = (SELECT MAX(LIST_PRICE) FROM PRICE WHERE END_DATE IS NULL);

-- 8.30: Nombre del producto más vendido (en unidades).
SELECT p.DESCRIPTION, SUM(i.QUANTITY) AS unidades
FROM PRODUCT AS p
JOIN ITEM AS i ON i.PRODUCT_ID = p.PRODUCT_ID
GROUP BY p.PRODUCT_ID, p.DESCRIPTION
HAVING SUM(i.QUANTITY) >= ALL (SELECT SUM(QUANTITY) FROM ITEM GROUP BY PRODUCT_ID);

-- 8.31: Nombre de los vendedores y la comisión que obtendrían si cobraran el 25 % del total facturado a sus clientes.
SELECT e.FIRST_NAME, e.LAST_NAME, SUM(o.TOTAL) * 0.25 AS comision
FROM EMPLOYEE AS e
JOIN CUSTOMER AS c    ON c.SALESPERSON_ID = e.EMPLOYEE_ID
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME
ORDER BY comision DESC;

-- 8.32: Lo mismo, pero los vendedores que no han vendido deben salir con comisión 0.
SELECT e.FIRST_NAME, e.LAST_NAME, IFNULL(SUM(o.TOTAL), 0) * 0.25 AS comision
FROM EMPLOYEE AS e
JOIN JOB AS j              ON j.JOB_ID = e.JOB_ID
LEFT JOIN CUSTOMER AS c    ON c.SALESPERSON_ID = e.EMPLOYEE_ID
LEFT JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE j.FUNCTIONS = 'SALESPERSON'
GROUP BY e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME
ORDER BY comision DESC;

-- 8.33: Nombre del cliente que ha comprado más de 100 unidades del producto «ACE TENNIS RACKET II».
SELECT c.NAME, SUM(i.QUANTITY) AS unidades
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN ITEM AS i        ON i.ORDER_ID = o.ORDER_ID
JOIN PRODUCT AS p     ON p.PRODUCT_ID = i.PRODUCT_ID
WHERE p.DESCRIPTION = 'ACE TENNIS RACKET II'
GROUP BY c.CUSTOMER_ID, c.NAME
HAVING SUM(i.QUANTITY) > 100;

-- 8.34: ¿Cuántos clientes han hecho un solo pedido?
SELECT COUNT(*) AS clientes_un_pedido
FROM (SELECT CUSTOMER_ID
      FROM SALES_ORDER
      GROUP BY CUSTOMER_ID
      HAVING COUNT(*) = 1) AS t;

-- 8.35: ¿Cuánto dinero se ha recaudado con la venta de «ACE TENNIS RACKET I»?
SELECT SUM(i.TOTAL) AS recaudado
FROM ITEM AS i
JOIN PRODUCT AS p ON p.PRODUCT_ID = i.PRODUCT_ID
WHERE p.DESCRIPTION = 'ACE TENNIS RACKET I';

-- 8.36: ¿Qué cliente o clientes hicieron el primer pedido a la empresa?
SELECT c.NAME, o.ORDER_DATE
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE o.ORDER_DATE = (SELECT MIN(ORDER_DATE) FROM SALES_ORDER);

-- 8.37: Nombre de cada cliente y el código del pedido (ORDER_ID) más caro de los suyos.
SELECT c.NAME, o.ORDER_ID, o.TOTAL
FROM CUSTOMER AS c
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE o.TOTAL = (SELECT MAX(o2.TOTAL)
                 FROM SALES_ORDER AS o2
                 WHERE o2.CUSTOMER_ID = o.CUSTOMER_ID)
ORDER BY c.NAME;

-- 8.38: De cada departamento: código, nombre, ciudad y nombre del empleado más antiguo.
SELECT d.DEPARTMENT_ID, d.NAME, l.REGIONAL_GROUP AS ciudad, e.LAST_NAME, e.HIRE_DATE
FROM DEPARTMENT AS d
JOIN LOCATION AS l ON l.LOCATION_ID = d.LOCATION_ID
JOIN EMPLOYEE AS e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.HIRE_DATE = (SELECT MIN(e2.HIRE_DATE)
                     FROM EMPLOYEE AS e2
                     WHERE e2.DEPARTMENT_ID = d.DEPARTMENT_ID)
ORDER BY d.DEPARTMENT_ID;

-- 8.39: De cada producto, su descripción y el cliente que más unidades ha comprado de él.
SELECT p.DESCRIPTION, c.NAME, SUM(i.QUANTITY) AS unidades
FROM PRODUCT AS p
JOIN ITEM AS i        ON i.PRODUCT_ID = p.PRODUCT_ID
JOIN SALES_ORDER AS o ON o.ORDER_ID = i.ORDER_ID
JOIN CUSTOMER AS c    ON c.CUSTOMER_ID = o.CUSTOMER_ID
GROUP BY p.PRODUCT_ID, p.DESCRIPTION, c.CUSTOMER_ID, c.NAME
HAVING SUM(i.QUANTITY) >= ALL (SELECT SUM(i2.QUANTITY)
                               FROM ITEM AS i2
                               JOIN SALES_ORDER AS o2 ON o2.ORDER_ID = i2.ORDER_ID
                               WHERE i2.PRODUCT_ID = p.PRODUCT_ID
                               GROUP BY o2.CUSTOMER_ID)
ORDER BY p.DESCRIPTION;

-- 8.40: Nombre de cada vendedor junto al cliente, de los que representa, que más ha gastado.
SELECT e.LAST_NAME AS vendedor, c.NAME AS cliente, SUM(o.TOTAL) AS gastado
FROM EMPLOYEE AS e
JOIN CUSTOMER AS c    ON c.SALESPERSON_ID = e.EMPLOYEE_ID
JOIN SALES_ORDER AS o ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY e.EMPLOYEE_ID, e.LAST_NAME, c.CUSTOMER_ID, c.NAME
HAVING SUM(o.TOTAL) >= ALL (SELECT SUM(o2.TOTAL)
                            FROM CUSTOMER AS c2
                            JOIN SALES_ORDER AS o2 ON o2.CUSTOMER_ID = c2.CUSTOMER_ID
                            WHERE c2.SALESPERSON_ID = e.EMPLOYEE_ID
                            GROUP BY c2.CUSTOMER_ID)
ORDER BY vendedor;

-- 8.41: De cada ciudad, su nombre y el empleado que más cobra (salario + comisión) de los que trabajan allí.
SELECT l.REGIONAL_GROUP AS ciudad, e.LAST_NAME,
       e.SALARY + IFNULL(e.COMMISSION, 0) AS cobra
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
JOIN LOCATION AS l   ON l.LOCATION_ID = d.LOCATION_ID
WHERE e.SALARY + IFNULL(e.COMMISSION, 0) =
      (SELECT MAX(e2.SALARY + IFNULL(e2.COMMISSION, 0))
       FROM EMPLOYEE AS e2
       JOIN DEPARTMENT AS d2 ON d2.DEPARTMENT_ID = e2.DEPARTMENT_ID
       WHERE d2.LOCATION_ID = d.LOCATION_ID)
ORDER BY ciudad;

-- 8.42: Para cada empleado: nombre, número, número de su jefe, departamento y nombre del jefe.
SELECT emp.FIRST_NAME, emp.EMPLOYEE_ID, emp.MANAGER_ID, d.NAME AS departamento,
       jefe.FIRST_NAME AS nombre_jefe, jefe.LAST_NAME AS apellido_jefe
FROM EMPLOYEE AS emp
JOIN EMPLOYEE AS jefe  ON jefe.EMPLOYEE_ID = emp.MANAGER_ID
JOIN DEPARTMENT AS d   ON d.DEPARTMENT_ID = emp.DEPARTMENT_ID
ORDER BY emp.EMPLOYEE_ID;
