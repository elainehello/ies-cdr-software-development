-- =====================================================================
-- RA4_casos_ER.sql · Del diagrama E/R al script SQL (MySQL 8.0, comprobado)
-- Caso 1: carrera popular · Caso 2: mantenimiento de árboles
-- Sentencias que fallan a propósito: comentadas con  -- ❌
-- Pasos de la SESIÓN B (bloqueos, T.11): comentados con  -- [B]  -> ejecútalos en otra pestaña
-- =====================================================================

SET SQL_SAFE_UPDATES = 0;

-- #####################################################################
-- Caso E/R 1 · Carrera popular (jerarquía solapada, 1:N y N:M)
-- #####################################################################
DROP DATABASE IF EXISTS carrera;
CREATE DATABASE carrera;
USE carrera;

-- ---------------------------------------------------------------
-- C.1: Crear las tablas del modelo relacional con todas sus restricciones (padres primero).
CREATE TABLE PERSONA (
  cod           INT          NOT NULL,
  nombre        VARCHAR(30)  NOT NULL,
  apellidos     VARCHAR(40)  NOT NULL,
  direccion     VARCHAR(60),
  telefono      VARCHAR(15),
  es_voluntario BOOLEAN      NOT NULL DEFAULT FALSE,
  es_corredor   BOOLEAN      NOT NULL DEFAULT FALSE,
  CONSTRAINT persona_pk       PRIMARY KEY (cod),
  CONSTRAINT persona_total_ck CHECK (es_voluntario OR es_corredor)
);
CREATE TABLE CARRERA (
  cod         INT         NOT NULL,
  nombre      VARCHAR(40) NOT NULL,
  sexo        CHAR(1)     NOT NULL,
  categoria   VARCHAR(20) NOT NULL,
  hora_salida TIME        NOT NULL,
  CONSTRAINT carrera_pk      PRIMARY KEY (cod),
  CONSTRAINT carrera_sexo_ck CHECK (sexo IN ('M', 'F', 'X'))   -- X = mixta
);
CREATE TABLE CLUB (
  cod                 INT         NOT NULL,
  nombre              VARCHAR(40) NOT NULL,
  telefono            VARCHAR(15),
  persona_responsable VARCHAR(60),
  CONSTRAINT club_pk PRIMARY KEY (cod)
);
CREATE TABLE PUESTO (
  cod_puesto INT          NOT NULL AUTO_INCREMENT,
  nombre     VARCHAR(30)  NOT NULL,
  cometido   VARCHAR(100),
  CONSTRAINT puesto_pk        PRIMARY KEY (cod_puesto),
  CONSTRAINT puesto_nombre_uk UNIQUE (nombre)
);
CREATE TABLE VOLUNTARIO (
  cod INT NOT NULL,
  CONSTRAINT voluntario_pk PRIMARY KEY (cod),
  CONSTRAINT voluntario_persona_fk FOREIGN KEY (cod) REFERENCES PERSONA (cod)
    ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE CORREDOR (
  cod         INT  NOT NULL,
  dorsal      INT  NOT NULL,
  fecha_nac   DATE NOT NULL,
  cod_carrera INT  NOT NULL,              -- Participa (1,1)
  puesto      INT,                        -- atributo de Participa (NULL hasta que llegue a meta)
  cod_club    INT,                        -- Pertenece (0,1)
  CONSTRAINT corredor_pk         PRIMARY KEY (cod),
  CONSTRAINT corredor_dorsal_uk  UNIQUE (dorsal),
  CONSTRAINT corredor_puesto_uk  UNIQUE (cod_carrera, puesto),
  CONSTRAINT corredor_puesto_ck  CHECK (puesto > 0),
  CONSTRAINT corredor_persona_fk FOREIGN KEY (cod) REFERENCES PERSONA (cod)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT corredor_carrera_fk FOREIGN KEY (cod_carrera) REFERENCES CARRERA (cod),
  CONSTRAINT corredor_club_fk    FOREIGN KEY (cod_club) REFERENCES CLUB (cod)
    ON DELETE SET NULL
);
CREATE TABLE DESEMPENA (
  cod_voluntario INT NOT NULL,
  cod_puesto     INT NOT NULL,
  CONSTRAINT desempena_pk     PRIMARY KEY (cod_voluntario, cod_puesto),
  CONSTRAINT desempena_vol_fk FOREIGN KEY (cod_voluntario) REFERENCES VOLUNTARIO (cod)
    ON DELETE CASCADE,
  CONSTRAINT desempena_pue_fk FOREIGN KEY (cod_puesto) REFERENCES PUESTO (cod_puesto)
);
-- comprobación:
SHOW TABLES;

-- ---------------------------------------------------------------
-- C.2: Insertar datos de prueba en el orden correcto: personas → subtipos → carreras/clubs/puestos → relaciones.
INSERT INTO PERSONA (cod, nombre, apellidos, direccion, telefono, es_voluntario, es_corredor) VALUES
 (1, 'Lucía',  'Martín Gil',    'C/ Toledo 3',     '600111001', FALSE, TRUE),
 (2, 'Carlos', 'Ruiz Peña',     'C/ Atocha 12',    '600111002', FALSE, TRUE),
 (3, 'Marta',  'Sanz López',    'Av. Oporto 5',    '600111003', TRUE,  TRUE),   -- voluntaria Y corredora
 (4, 'Javier', 'Gómez Prieto',  'C/ Embajadores 8','600111004', FALSE, TRUE),
 (5, 'Ana',    'Díaz Moreno',   'C/ Bravo Murillo','600111005', FALSE, TRUE),
 (6, 'Pablo',  'Ortega Vidal',  'C/ Alcalá 200',   '600111006', FALSE, TRUE),
 (7, 'Elena',  'Navarro Rey',   'C/ Princesa 9',   '600111007', FALSE, TRUE),
 (8, 'Sergio', 'Molina Cano',   'C/ Getafe 1',     '600111008', TRUE,  FALSE),
 (9, 'Irene',  'Castro Vega',   'C/ Leganés 4',    '600111009', TRUE,  FALSE),
 (10,'Hugo',   'Romero Pardo',  'C/ Fuenlabrada 2','600111010', TRUE,  FALSE);
INSERT INTO CARRERA VALUES
 (1, '10K Masculina', 'M', 'Senior',   '09:00:00'),
 (2, '10K Femenina',  'F', 'Senior',   '09:30:00'),
 (3, 'Infantil 2K',   'X', 'Infantil', '11:00:00');
INSERT INTO CLUB VALUES
 (1, 'Club Atletismo Getafe', '916000001', 'Rosa Blanco'),
 (2, 'Running Madrid',        '915000002', 'Luis Prado');
INSERT INTO PUESTO (nombre, cometido) VALUES
 ('Avituallamiento', 'Repartir agua en el km 5'),
 ('Guardarropa',     'Custodiar mochilas'),
 ('Meta',            'Entregar medallas'),
 ('Cronometraje',    'Tomar tiempos'),
 ('Animación',       'Música en la salida');
INSERT INTO VOLUNTARIO (cod) VALUES (3), (8), (9), (10);
INSERT INTO CORREDOR (cod, dorsal, fecha_nac, cod_carrera, cod_club) VALUES
 (1, 101, '1995-04-12', 2, 1),
 (2, 102, '1990-11-30', 1, 2),
 (3, 103, '1988-02-14', 2, NULL),
 (4, 104, '1999-07-01', 1, 1),
 (5, 105, '2001-09-23', 2, 2),
 (6, 106, '1985-01-05', 1, NULL),
 (7, 107, '2014-06-18', 3, 1);
INSERT INTO DESEMPENA VALUES (3,1), (8,1), (8,2), (9,3), (10,4);
-- comprobación:
SELECT p.cod, p.nombre, c.dorsal, c.cod_carrera, c.cod_club,
       (v.cod IS NOT NULL) AS es_vol
FROM PERSONA p LEFT JOIN CORREDOR c ON c.cod = p.cod
               LEFT JOIN VOLUNTARIO v ON v.cod = p.cod
ORDER BY p.cod;

-- ---------------------------------------------------------------
-- C.3: Comprobar la integridad: cada sentencia debe ser rechazada por una restricción distinta.
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO PERSONA (cod, nombre, apellidos) VALUES (11, 'Nadie', 'Sin Rol');
-- ❌ (da ERROR 1048 a propósito)
-- ❌ INSERT INTO CORREDOR (cod, dorsal, fecha_nac, cod_carrera) VALUES (8, 108, '2000-01-01', NULL);
-- ❌ (da ERROR 1062 a propósito)
-- ❌ INSERT INTO CORREDOR (cod, dorsal, fecha_nac, cod_carrera) VALUES (8, 101, '2000-01-01', 1);
-- ❌ (da ERROR 1452 a propósito)
-- ❌ INSERT INTO CORREDOR (cod, dorsal, fecha_nac, cod_carrera) VALUES (8, 108, '2000-01-01', 99);
-- ❌ (da ERROR 1452 a propósito)
-- ❌ INSERT INTO DESEMPENA VALUES (1, 2);
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO CARRERA VALUES (4, 'Popular', 'Z', 'Libre', '12:00:00');
-- comprobación:
SELECT COUNT(*) AS personas, (SELECT COUNT(*) FROM CORREDOR) AS corredores FROM PERSONA;

-- ---------------------------------------------------------------
-- C.4: Inscribir un corredor nuevo (persona + corredor) como una única transacción: o se guardan las dos filas o ninguna.
-- Intento 1: el dorsal 105 ya existe -> hay que deshacerlo todo
START TRANSACTION;
INSERT INTO PERSONA (cod, nombre, apellidos, es_corredor) VALUES (12, 'Raúl', 'Iglesias Mora', TRUE);
-- ❌ (da ERROR 1062 a propósito)
-- ❌ INSERT INTO CORREDOR (cod, dorsal, fecha_nac, cod_carrera) VALUES (12, 105, '1997-03-03', 1);
ROLLBACK;
SELECT COUNT(*) AS existe_raul FROM PERSONA WHERE cod = 12;   -- 0: no quedó una persona «a medias»
-- Intento 2: dorsal correcto
START TRANSACTION;
INSERT INTO PERSONA (cod, nombre, apellidos, es_corredor) VALUES (12, 'Raúl', 'Iglesias Mora', TRUE);
INSERT INTO CORREDOR (cod, dorsal, fecha_nac, cod_carrera) VALUES (12, 112, '1997-03-03', 1);
COMMIT;
-- comprobación:
SELECT p.cod, p.nombre, c.dorsal FROM PERSONA p JOIN CORREDOR c ON c.cod = p.cod WHERE p.cod = 12;

-- ---------------------------------------------------------------
-- C.5: Registrar la clasificación de la carrera 1 y pasar al club «Running Madrid» a los corredores de esa carrera que no tienen club.
UPDATE CORREDOR SET puesto = 1 WHERE dorsal = 104;
UPDATE CORREDOR SET puesto = 2 WHERE dorsal = 102;
UPDATE CORREDOR SET puesto = 3 WHERE dorsal = 106;
UPDATE CORREDOR SET puesto = 4 WHERE dorsal = 112;
UPDATE CORREDOR
SET cod_club = (SELECT cod FROM CLUB WHERE nombre = 'Running Madrid')
WHERE cod_carrera = 1 AND cod_club IS NULL;
-- ❌ (da ERROR 1062 a propósito)
-- ❌ UPDATE CORREDOR SET puesto = 1 WHERE dorsal = 102;
-- comprobación:
SELECT dorsal, cod_carrera, puesto, cod_club FROM CORREDOR WHERE cod_carrera = 1 ORDER BY puesto;

-- ---------------------------------------------------------------
-- C.6: La carrera infantil se retrasa 30 minutos y la de 10K Femenina se adelanta 15.
UPDATE CARRERA
SET hora_salida = CASE cod
                    WHEN 3 THEN ADDTIME(hora_salida, '00:30:00')
                    WHEN 2 THEN SUBTIME(hora_salida, '00:15:00')
                  END
WHERE cod IN (2, 3);
-- comprobación:
SELECT cod, nombre, hora_salida FROM CARRERA;

-- ---------------------------------------------------------------
-- C.7: Crear la tabla PODIO con los 3 primeros de cada carrera (nombre de carrera, puesto, dorsal y nombre del corredor) a partir de una consulta.
CREATE TABLE PODIO AS
SELECT ca.nombre AS carrera, co.puesto, co.dorsal,
       CONCAT(p.nombre, ' ', p.apellidos) AS corredor
FROM CORREDOR co
  JOIN CARRERA ca ON ca.cod = co.cod_carrera
  JOIN PERSONA p  ON p.cod  = co.cod
WHERE co.puesto <= 3;
-- Más tarde llega la clasificación femenina: se AÑADE a la tabla existente
UPDATE CORREDOR SET puesto = 1 WHERE dorsal = 105;
UPDATE CORREDOR SET puesto = 2 WHERE dorsal = 101;
INSERT INTO PODIO (carrera, puesto, dorsal, corredor)
SELECT ca.nombre, co.puesto, co.dorsal, CONCAT(p.nombre, ' ', p.apellidos)
FROM CORREDOR co JOIN CARRERA ca ON ca.cod = co.cod_carrera
                 JOIN PERSONA p  ON p.cod  = co.cod
WHERE co.cod_carrera = 2 AND co.puesto <= 3;
-- comprobación:
SELECT * FROM PODIO ORDER BY carrera, puesto;

-- ---------------------------------------------------------------
-- C.8: Borrar los puestos que no desempeña ningún voluntario.
DELETE FROM PUESTO
WHERE cod_puesto NOT IN (SELECT cod_puesto FROM DESEMPENA);
-- comprobación:
SELECT * FROM PUESTO;

-- ---------------------------------------------------------------
-- C.9: El club «Running Madrid» se disuelve: borrarlo y comprobar qué les pasa a sus corredores.
SELECT dorsal, cod_club FROM CORREDOR WHERE cod_club = 2;   -- antes
DELETE FROM CLUB WHERE nombre = 'Running Madrid';
-- comprobación:
SELECT dorsal, cod_club FROM CORREDOR ORDER BY dorsal;

-- ---------------------------------------------------------------
-- C.10: Marta (persona 3) se da de baja de la organización: borrarla y comprobar el borrado en cascada.
DELETE FROM PERSONA WHERE cod = 3;
-- comprobación:
SELECT (SELECT COUNT(*) FROM VOLUNTARIO WHERE cod = 3) AS en_voluntario,
       (SELECT COUNT(*) FROM CORREDOR   WHERE cod = 3) AS en_corredor,
       (SELECT COUNT(*) FROM DESEMPENA  WHERE cod_voluntario = 3) AS en_desempena;

-- ---------------------------------------------------------------
-- C.11: Guion con SAVEPOINT: cambiar la categoría de la carrera infantil, borrar por error todos sus corredores y deshacer solo el borrado.
START TRANSACTION;
UPDATE CARRERA SET categoria = 'Infantil sub-12' WHERE cod = 3;
SAVEPOINT tras_categoria;
DELETE FROM CORREDOR WHERE cod_carrera = 3;   -- ¡error humano!
ROLLBACK TO tras_categoria;
COMMIT;
-- comprobación:
SELECT ca.categoria, COUNT(co.cod) AS corredores
FROM CARRERA ca LEFT JOIN CORREDOR co ON co.cod_carrera = ca.cod
WHERE ca.cod = 3 GROUP BY ca.categoria;

-- ---------------------------------------------------------------
-- C.12: Consultas de control: listado de inscritos con carrera y club (aunque no tengan club) y número de voluntarios por puesto.
SELECT co.dorsal, CONCAT(p.nombre,' ',p.apellidos) AS corredor, ca.nombre AS carrera,
       IFNULL(cl.nombre, '— sin club —') AS club, co.puesto
FROM CORREDOR co
  JOIN PERSONA p   ON p.cod = co.cod
  JOIN CARRERA ca  ON ca.cod = co.cod_carrera
  LEFT JOIN CLUB cl ON cl.cod = co.cod_club
ORDER BY ca.nombre, co.puesto IS NULL, co.puesto;
SELECT pu.nombre AS puesto, COUNT(d.cod_voluntario) AS voluntarios
FROM PUESTO pu LEFT JOIN DESEMPENA d ON d.cod_puesto = pu.cod_puesto
GROUP BY pu.nombre;

-- #####################################################################
-- Caso E/R 2 · Mantenimiento de árboles (entidad débil + jerarquía exclusiva)
-- #####################################################################
DROP DATABASE IF EXISTS arboles;
CREATE DATABASE arboles;
USE arboles;

-- ---------------------------------------------------------------
-- T.1: Crear las tablas: entidades fuertes → entidad débil (supertipo) → subtipos → relación N:M.
CREATE TABLE EJEMPLAR_ARBOL (
  cod         INT          NOT NULL,
  especie     VARCHAR(40)  NOT NULL,
  fotografia  VARCHAR(100),             -- ruta o URL de la foto
  descripcion VARCHAR(200),
  CONSTRAINT arbol_pk PRIMARY KEY (cod)
);
CREATE TABLE OPERARIO (
  dni    CHAR(9)     NOT NULL,
  nombre VARCHAR(40) NOT NULL,
  CONSTRAINT operario_pk PRIMARY KEY (dni)
);
CREATE TABLE ACTIVIDAD (
  cod_arbol INT         NOT NULL,
  fecha     DATE        NOT NULL,
  tipo      VARCHAR(10) NOT NULL,             -- discriminante (exclusiva y total)
  CONSTRAINT actividad_pk      PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT actividad_tipo_ck CHECK (tipo IN ('PODA', 'MEDICION', 'LIMPIEZA', 'PLAGA')),
  CONSTRAINT actividad_arbol_fk FOREIGN KEY (cod_arbol) REFERENCES EJEMPLAR_ARBOL (cod)
    ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE PODA (
  cod_arbol INT  NOT NULL,
  fecha     DATE NOT NULL,
  poda_tala   VARCHAR(4)   NOT NULL,
  foto        VARCHAR(100),
  comentarios VARCHAR(200),
  CONSTRAINT poda_tipo_ck CHECK (poda_tala IN ('poda', 'tala')),
  CONSTRAINT poda_pk PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT poda_act_fk FOREIGN KEY (cod_arbol, fecha)
    REFERENCES ACTIVIDAD (cod_arbol, fecha) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE MEDICION (
  cod_arbol INT  NOT NULL,
  fecha     DATE NOT NULL,
  altura   DECIMAL(5,2),           -- metros
  edad     SMALLINT,               -- años
  tam_copa DECIMAL(5,2),           -- diámetro en metros
  CONSTRAINT medicion_valores_ck CHECK (altura > 0 AND edad >= 0 AND tam_copa >= 0),
  CONSTRAINT medicion_pk PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT medicion_act_fk FOREIGN KEY (cod_arbol, fecha)
    REFERENCES ACTIVIDAD (cod_arbol, fecha) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE LIMPIEZA (
  cod_arbol INT  NOT NULL,
  fecha     DATE NOT NULL,
  descripcion VARCHAR(200),
  CONSTRAINT limpieza_pk PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT limpieza_act_fk FOREIGN KEY (cod_arbol, fecha)
    REFERENCES ACTIVIDAD (cod_arbol, fecha) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE PLAGA (
  cod_arbol INT  NOT NULL,
  fecha     DATE NOT NULL,
  especie     VARCHAR(40)  NOT NULL,   -- especie de la plaga
  tratamiento VARCHAR(100),
  CONSTRAINT plaga_pk PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT plaga_act_fk FOREIGN KEY (cod_arbol, fecha)
    REFERENCES ACTIVIDAD (cod_arbol, fecha) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE PARTICIPA (
  cod_arbol INT     NOT NULL,
  fecha     DATE    NOT NULL,
  dni       CHAR(9) NOT NULL,
  CONSTRAINT participa_pk     PRIMARY KEY (cod_arbol, fecha, dni),
  CONSTRAINT participa_act_fk FOREIGN KEY (cod_arbol, fecha)
    REFERENCES ACTIVIDAD (cod_arbol, fecha) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT participa_ope_fk FOREIGN KEY (dni) REFERENCES OPERARIO (dni)
);
-- comprobación:
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'arboles' AND CONSTRAINT_TYPE IN ('PRIMARY KEY','FOREIGN KEY')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE DESC;

-- ---------------------------------------------------------------
-- T.2: Insertar árboles, operarios y actividades de los cuatro tipos con sus operarios.
INSERT INTO EJEMPLAR_ARBOL VALUES
 (1, 'Plátano de sombra', 'fotos/a1.jpg', 'Paseo del Prado, alcorque 12'),
 (2, 'Pino piñonero',     'fotos/a2.jpg', 'Parque del Oeste, zona norte'),
 (3, 'Olmo',              NULL,           'Calle Atocha 40, inclinado'),
 (4, 'Encina',            'fotos/a4.jpg', 'Casa de Campo, lago');
INSERT INTO OPERARIO VALUES
 ('11111111A', 'Rosa Martín'),
 ('22222222B', 'Tomás Gil'),
 ('33333333C', 'Nuria León'),
 ('44444444D', 'Andrés Prieto');   -- todavía no ha trabajado
INSERT INTO ACTIVIDAD VALUES
 (1, '2026-03-10', 'PODA'),
 (1, '2026-05-02', 'MEDICION'),
 (2, '2026-04-15', 'PLAGA'),
 (2, '2026-10-01', 'MEDICION'),
 (3, '2026-06-20', 'LIMPIEZA'),
 (3, '2026-09-01', 'PODA');
INSERT INTO PODA     VALUES (1, '2026-03-10', 'poda', 'fotos/p1.jpg', 'Poda de formación'),
                            (3, '2026-09-01', 'tala', NULL, 'Riesgo de caída');
INSERT INTO MEDICION VALUES (1, '2026-05-02', 14.50, 35, 8.20),
                            (2, '2026-10-01', 11.00, 60, 9.75);
INSERT INTO LIMPIEZA VALUES (3, '2026-06-20', 'Retirada de hojas y basura del alcorque');
INSERT INTO PLAGA    VALUES (2, '2026-04-15', 'Procesionaria', 'Endoterapia');
INSERT INTO PARTICIPA VALUES
 (1, '2026-03-10', '11111111A'), (1, '2026-03-10', '22222222B'),
 (1, '2026-05-02', '33333333C'),
 (2, '2026-04-15', '11111111A'), (2, '2026-04-15', '33333333C'),
 (2, '2026-10-01', '22222222B'),
 (3, '2026-06-20', '22222222B'),
 (3, '2026-09-01', '11111111A'), (3, '2026-09-01', '22222222B');
-- comprobación:
SELECT a.cod_arbol, e.especie, a.fecha, a.tipo, COUNT(p.dni) AS operarios
FROM ACTIVIDAD a JOIN EJEMPLAR_ARBOL e ON e.cod = a.cod_arbol
                 LEFT JOIN PARTICIPA p ON p.cod_arbol = a.cod_arbol AND p.fecha = a.fecha
GROUP BY a.cod_arbol, e.especie, a.fecha, a.tipo
ORDER BY a.cod_arbol, a.fecha;

-- ---------------------------------------------------------------
-- T.3: Comprobar la integridad del modelo (todas deben fallar).
-- ❌ (da ERROR 1452 a propósito)
-- ❌ INSERT INTO ACTIVIDAD VALUES (9, '2026-01-01', 'PODA');
-- ❌ (da ERROR 1062 a propósito)
-- ❌ INSERT INTO ACTIVIDAD VALUES (1, '2026-03-10', 'LIMPIEZA');
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO ACTIVIDAD VALUES (4, '2026-02-02', 'RIEGO');
-- ❌ (da ERROR 1452 a propósito)
-- ❌ INSERT INTO LIMPIEZA VALUES (4, '2026-02-02', 'Sin actividad padre');
-- Valor de poda/tala no permitido
INSERT INTO ACTIVIDAD VALUES (4, '2026-02-02', 'PODA');
-- ❌ (da ERROR 3819 a propósito)
-- ❌ INSERT INTO PODA (cod_arbol, fecha, poda_tala) VALUES (4, '2026-02-02', 'rama');
DELETE FROM ACTIVIDAD WHERE cod_arbol = 4 AND fecha = '2026-02-02';   -- limpiamos la prueba
-- comprobación:
SELECT COUNT(*) AS actividades FROM ACTIVIDAD;

-- ---------------------------------------------------------------
-- T.4: Garantizar el máximo de 2 operarios por actividad (cardinalidad 1,2) con un trigger.
DELIMITER //
CREATE TRIGGER participa_max2
BEFORE INSERT ON PARTICIPA
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM PARTICIPA
      WHERE cod_arbol = NEW.cod_arbol AND fecha = NEW.fecha) >= 2 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Una actividad admite como máximo 2 operarios';
  END IF;
END //
DELIMITER ;
-- ❌ (da ERROR 1644 a propósito)
-- ❌ INSERT INTO PARTICIPA VALUES (1, '2026-03-10', '33333333C');
-- La medición del árbol 1 solo tiene 1: el segundo se acepta
INSERT INTO PARTICIPA VALUES (1, '2026-05-02', '11111111A');
-- comprobación:
SELECT cod_arbol, fecha, COUNT(*) AS operarios FROM PARTICIPA GROUP BY cod_arbol, fecha;

-- ---------------------------------------------------------------
-- T.5: Guion transaccional: registrar una actividad de plaga completa (actividad + plaga + operarios). Si algo falla, no debe quedar nada guardado.
-- Intento con 3 operarios: el trigger rechaza el tercero -> ROLLBACK de todo
START TRANSACTION;
INSERT INTO ACTIVIDAD VALUES (4, '2026-11-05', 'PLAGA');
INSERT INTO PLAGA     VALUES (4, '2026-11-05', 'Lagarta peluda', 'Bacillus thuringiensis');
INSERT INTO PARTICIPA VALUES (4, '2026-11-05', '11111111A');
INSERT INTO PARTICIPA VALUES (4, '2026-11-05', '22222222B');
-- ❌ (da ERROR 1644 a propósito)
-- ❌ INSERT INTO PARTICIPA VALUES (4, '2026-11-05', '33333333C');
ROLLBACK;
SELECT COUNT(*) AS quedo_algo FROM ACTIVIDAD WHERE cod_arbol = 4;   -- 0
-- Repetimos bien, con 2 operarios
START TRANSACTION;
INSERT INTO ACTIVIDAD VALUES (4, '2026-11-05', 'PLAGA');
INSERT INTO PLAGA     VALUES (4, '2026-11-05', 'Lagarta peluda', 'Bacillus thuringiensis');
INSERT INTO PARTICIPA VALUES (4, '2026-11-05', '11111111A'), (4, '2026-11-05', '22222222B');
COMMIT;
-- comprobación:
SELECT a.*, p.especie, COUNT(pa.dni) AS operarios
FROM ACTIVIDAD a JOIN PLAGA p USING (cod_arbol, fecha)
                 JOIN PARTICIPA pa USING (cod_arbol, fecha)
GROUP BY a.cod_arbol, a.fecha, a.tipo, p.especie;

-- ---------------------------------------------------------------
-- T.6: La medición del árbol 1 se registró con fecha equivocada: es del 2026-05-03, no del 2026-05-02. Corregirla.
UPDATE ACTIVIDAD
SET fecha = '2026-05-03'
WHERE cod_arbol = 1 AND fecha = '2026-05-02';
-- comprobación:
SELECT 'MEDICION' AS tabla, cod_arbol, fecha FROM MEDICION WHERE cod_arbol = 1
UNION ALL
SELECT 'PARTICIPA', cod_arbol, fecha FROM PARTICIPA WHERE cod_arbol = 1 AND fecha > '2026-04-01';

-- ---------------------------------------------------------------
-- T.7: Marcar en la descripción los árboles que han tenido alguna plaga añadiendo « [PLAGA]».
UPDATE EJEMPLAR_ARBOL
SET descripcion = CONCAT(IFNULL(descripcion, ''), ' [PLAGA]')
WHERE cod IN (SELECT cod_arbol FROM PLAGA);
-- comprobación:
SELECT cod, especie, descripcion FROM EJEMPLAR_ARBOL;

-- ---------------------------------------------------------------
-- T.8: Crear la tabla ULTIMA_MEDICION con la medición más reciente de cada árbol (especie, fecha, altura, copa).
CREATE TABLE ULTIMA_MEDICION AS
SELECT e.cod, e.especie, m.fecha, m.altura, m.tam_copa
FROM MEDICION m JOIN EJEMPLAR_ARBOL e ON e.cod = m.cod_arbol
WHERE m.fecha = (SELECT MAX(m2.fecha) FROM MEDICION m2 WHERE m2.cod_arbol = m.cod_arbol);
ALTER TABLE ULTIMA_MEDICION ADD CONSTRAINT ultima_pk PRIMARY KEY (cod);
-- comprobación:
SELECT * FROM ULTIMA_MEDICION;

-- ---------------------------------------------------------------
-- T.9: El olmo (árbol 3) se ha talado: borrarlo con todo su historial y comprobar la cascada.
SELECT (SELECT COUNT(*) FROM ACTIVIDAD WHERE cod_arbol = 3) AS actividades,
       (SELECT COUNT(*) FROM PODA      WHERE cod_arbol = 3) AS podas,
       (SELECT COUNT(*) FROM LIMPIEZA  WHERE cod_arbol = 3) AS limpiezas,
       (SELECT COUNT(*) FROM PARTICIPA WHERE cod_arbol = 3) AS participaciones;   -- antes
DELETE FROM EJEMPLAR_ARBOL WHERE cod = 3;
-- comprobación:
SELECT (SELECT COUNT(*) FROM ACTIVIDAD WHERE cod_arbol = 3) AS actividades,
       (SELECT COUNT(*) FROM PODA      WHERE cod_arbol = 3) AS podas,
       (SELECT COUNT(*) FROM LIMPIEZA  WHERE cod_arbol = 3) AS limpiezas,
       (SELECT COUNT(*) FROM PARTICIPA WHERE cod_arbol = 3) AS participaciones;

-- ---------------------------------------------------------------
-- T.10: Borrar los operarios que no han participado en ninguna actividad.
DELETE FROM OPERARIO
WHERE NOT EXISTS (SELECT 1 FROM PARTICIPA p WHERE p.dni = OPERARIO.dni);
-- comprobación:
SELECT * FROM OPERARIO;

-- ---------------------------------------------------------------
-- T.11: Políticas de bloqueo: dos sesiones intentan modificar la misma medición a la vez.
-- SESIÓN A (pestaña 1 de Workbench)
START TRANSACTION;
UPDATE MEDICION SET altura = 15.00 WHERE cod_arbol = 1;   -- A bloquea esa fila
-- [B] -- SESIÓN B (abre otra pestaña: File > New Query Tab, o una 2.ª terminal mysql)
-- [B] USE arboles;
-- [B] SET SESSION innodb_lock_wait_timeout = 3;   -- por defecto son 50 s
-- [B] SELECT altura FROM MEDICION WHERE cod_arbol = 1;   -- lectura consistente: ve 14.50, no espera
-- [B] UPDATE MEDICION SET altura = 16.00 WHERE cod_arbol = 1;   -- espera el bloqueo de A… y falla
-- SESIÓN A
COMMIT;   -- libera el bloqueo
-- [B] SELECT altura FROM MEDICION WHERE cod_arbol = 1;   -- ahora B ya ve 15.00
-- comprobación:
SELECT @@transaction_isolation AS aislamiento, @@innodb_lock_wait_timeout AS espera_s;

-- ---------------------------------------------------------------
-- T.12: Ampliación: garantizar la exclusividad de la jerarquía (una actividad PODA no puede tener fila en MEDICION) solo con restricciones.
DROP DATABASE IF EXISTS arboles_pro;
CREATE DATABASE arboles_pro;
USE arboles_pro;
CREATE TABLE ACTIVIDAD (
  cod_arbol INT NOT NULL, fecha DATE NOT NULL, tipo VARCHAR(10) NOT NULL,
  CONSTRAINT act_pk      PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT act_tipo_uk UNIQUE (cod_arbol, fecha, tipo),   -- necesario para referenciar el trío
  CONSTRAINT act_tipo_ck CHECK (tipo IN ('PODA','MEDICION','LIMPIEZA','PLAGA'))
);
CREATE TABLE MEDICION (
  cod_arbol INT NOT NULL, fecha DATE NOT NULL,
  tipo   VARCHAR(10) NOT NULL DEFAULT 'MEDICION',
  altura DECIMAL(5,2),
  CONSTRAINT med_pk      PRIMARY KEY (cod_arbol, fecha),
  CONSTRAINT med_tipo_ck CHECK (tipo = 'MEDICION'),
  CONSTRAINT med_act_fk  FOREIGN KEY (cod_arbol, fecha, tipo)
    REFERENCES ACTIVIDAD (cod_arbol, fecha, tipo) ON DELETE CASCADE
);
INSERT INTO ACTIVIDAD VALUES (1, '2026-03-10', 'PODA'), (1, '2026-05-02', 'MEDICION');
INSERT INTO MEDICION (cod_arbol, fecha, altura) VALUES (1, '2026-05-02', 14.5);   -- ✔ es una medición
-- ❌ (da ERROR 1452 a propósito)
-- ❌ INSERT INTO MEDICION (cod_arbol, fecha, altura) VALUES (1, '2026-03-10', 9.9);    -- ✖ es una poda
USE arboles;
