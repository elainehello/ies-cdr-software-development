DROP DATABASE IF EXISTS ej01_red_de_metro;
CREATE DATABASE ej01_red_de_metro;
USE ej01_red_de_metro;

-- cochera: entidad
create table cochera (
cod_cochera int not null,
direccion varchar(255),
constraint pk_cochera primary key (cod_cochera)
);

-- linea: entidad
create table linea (
cod_linea int not null,
nombre varchar(100),
color varchar(100),
constraint pk_linea primary key (cod_linea)
);

-- tren: entidad
create table tren (
cod_tren int not null,
model varchar(255),
fecha_compra date,
cod_cochera int not null,
cod_linea int not null,
constraint pk_tren primary key (cod_tren),
constraint fk_tren_cochera foreign key (cod_cochera) references cochera(cod_cochera),
constraint fk_tren_linea foreign key (cod_linea) references linea(cod_linea)
);

-- estacion: entidad
create table estacion (
cod_estacion int not null,
nombre varchar(100),
direccion varchar(100),
constraint pk_estacion primary key (cod_estacion)
);

-- pertenece: interrelacion N:M Pertenece
create table pertenece (
cod_estacion int not null,
cod_linea int not null,
num_order int,
constraint pk_pertenece primary key (cod_estacion, cod_linea),
constraint fk_pertenece_linea foreign key (cod_linea) references linea(cod_linea) on delete cascade on update cascade,
constraint fk_pertenece_estacion foreign key (cod_estacion) references estacion(cod_estacion) on delete cascade on update cascade,
constraint ck_pertenece_1 check (num_order > 0)
);

-- datos de prueba . Ejercicio 1
use ej01_red_de_metro;

-- inserta 4 valores en la tabla cochera
insert into cochera (cod_cochera, direccion) values
(1, 'C/ Martin 51'),
(2, 'C/ Garcia 10'),
(3, 'C/ Navarro 13'),
(4, 'C/ Ortega 8');

select * from cochera;

-- inserta 4 valores en la tabla linea

insert into linea(cod_linea, nombre, color) values
(1, 'Linea1', 'naranja'),
(2, 'Liena2', 'rojo'),
(3, 'Linea3', 'amarillo'),
(4, 'Linea4', 'rojo');

select * from linea;

-- inserta 4 valores en la tabla tren
insert into tren(cod_tren, model, fecha_compra, cod_cochera, cod_linea) values
(1, 'modelo 1', '2017-09-12', 1, 4),
(2, 'modelo 2', '2015-08-31', 1, 2),
(3, 'modelo 3', '2022-01-27', 1, 4),
(4, 'modelo 4', '2015-07-23', 2, 1);

select * from tren;

-- inserta 4 valores en la tabla estacion
insert into estacion(cod_estacion, nombre, direccion) values
(1, 'Estacion 1', 'C/ Martin 38'),
(2, 'Estacion 2', 'C/ Martin 70'),
(3, 'Estacion 3', 'C/ Ortega 40'),
(4, 'Estacion 4', 'C/ Castro 24');

select * from estacion;

-- inserta 5 valores en la tabla pertenece
insert into pertenece(cod_estacion, cod_linea, num_order) values
(2, 3, 7),
(1, 1, 40),
(4, 4, 50),
(2, 2, 45),
(2, 1, 37);

select * from pertenece;

-- dar de alta un registro nuevo en cochera y otro en tren que dependa de el
select * from cochera;
insert into cochera(cod_cochera, direccion) values
(5, 'C/ Serrano 5');

select * from tren;
insert into tren(cod_tren, model, fecha_compra, cod_cochera, cod_linea) values
(5, 'modelo 5', '2026-11-08', 5, 3);

-- delete the value inserted
delete from tren where model='modelo 5' and cod_tren=5;

select * from tren;

-- prueba el resultado de lo añadido
select * from tren where cod_cochera=5;

-- modifica el campo direccion de cochera que acabas de crear
update cochera
set direccion = 'C/ Diaz 22'
where cod_cochera=5;

select * from cochera;

select * from tren;
-- comprobar la integridad refencial: inserta en tren un registo cuyo
-- cochera no existe.
insert into tren(cod_tren, model, fecha_compra, cod_cochera, cod_linea) values
(6, 'modelo 6', '2026-10-08', 6, 1);

select * from cochera;
select * from tren;

-- borrar el cochera creado, que tiene un tren asociado
delete from cochera
where cod_cochera=5;

-- solucion borrar primero los hijos y despues el padre (no huerfanos)
delete from tren
where cod_tren=5;

select * from tren;

-- comprueba el resultado y cuenta los hijos
select count(*) as hijos_restantes from tren where cod_tren=5;

