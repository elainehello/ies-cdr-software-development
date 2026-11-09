drop database if exists red_de_metro;
create database red_de_metro;
use red_de_metro;

create table COCHERA(
cod_cochera int,
direccion varchar(100),
constraint pk_cochera primary key (cod_cochera) 
);

create table LINEA(
cod_linea int,
nombre varchar(100),
color varchar(25),
constraint pk_linea primary key (cod_linea)
);

create table TREN(
cod_tren int not null,
cod_cochera int not null,
cod_linea int not null,
modelo varchar(100),
fecha_compra date,
constraint pk_tren primary key (cod_tren),
constraint fk_tren_cochera foreign key (cod_cochera) references COCHERA(cod_cochera),
constraint fk_tren_linea foreign key(cod_linea) references LINEA(cod_linea)
);

create table ESTACION(
cod_estacion int,
nombre varchar(100),
direccion varchar(100),
constraint pk_estacion primary key (cod_estacion)
);

create table PERTENECE(
num_orden int,
cod_linea int not null,
cod_estacion int not null,
constraint pk_pertenece primary key (cod_linea, cod_estacion),
constraint pk_pertenece_linea foreign key (cod_linea) references LINEA(cod_linea) on delete cascade,
constraint pk_pertenece_estacion foreign key (cod_estacion) references ESTACION(cod_estacion) on delete cascade
);