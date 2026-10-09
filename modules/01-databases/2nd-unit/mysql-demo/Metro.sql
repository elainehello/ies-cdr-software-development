create database metro;
use metro;

create table linea(
num_linea int (50) primary key,
color varchar(50)
);

create table cochera(
cod_cochera varchar(50) primary key,
ubicacion varchar(50)
);


create table tren(
cod_tren varchar(50) primary key,
marca varchar(50),
modelo varchar(50),
num_linea int (50),
cod_cochera varchar(50),
constraint fk_tren_linea foreign key (num_linea) references linea(num_linea),
constraint fk_tren_cochera foreign key (cod_cochera) references cochera(cod_cochera)
);

create table estacion(
num_estacion int (50),
num_linea varchar(50),
constraint fk_estacion_linea foreign key(num_linea) references linea(num_linea),
constraint pk_estacion primary key (num_estacion, num_linea)
);