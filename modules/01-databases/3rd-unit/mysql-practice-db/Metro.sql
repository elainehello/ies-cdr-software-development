-- Ejercicio Red de Metro

drop database if exists red_de_metro;
create database red_de_metro;
use red_de_metro;

create table cochera(
cod_cochera int primary key,
direccion varchar(255)
);

create table linea(
cod_linea int primary key,
nombre varchar(100),
color varchar(100)
);

create table tren(
cod_tren int primary key,
modelo varchar(100),
fecha_compra date,
cod_cochera int not null,
cod_linea int not null,
constraint pk_tren_cochera foreign key (cod_cochera) references cochera(cod_cochera),
constraint pk_tren_linea foreign key (cod_linea) references linea(cod_linea)
);

create table estacion(
cod_estacion int primary key,
nombre varchar(100),
direccion varchar(255)
);

create table pertenece(
cod_linea int,
cod_estacion int,
num_order int,
constraint pk_pertenece primary key (cod_linea, cod_estacion),
constraint fk_pertenece_linea foreign key (cod_linea) references linea(cod_linea)
	on delete cascade on update cascade,
constraint fk_pertece_estacion foreign key (cod_estacion) references estacion(cod_estacion)
	on delete cascade on update cascade,
constraint ck_pertenece_num_order check (num_order > 0)
);