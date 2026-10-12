create database if not exists metro;
use metro;

create table linea(
num_linea int primary key,
color varchar(50),
constraint ck_linea_num check (num_linea > 0)
);

create table cochera(
cod_cochera varchar(50) primary key,
ubicacion varchar(50)
);


create table tren(
cod_tren varchar(50) primary key,
marca varchar(50),
modelo varchar(50),
num_linea int not null,
cod_cochera varchar(50) not null,
constraint fk_tren_linea foreign key (num_linea) references linea(num_linea),
constraint fk_tren_cochera foreign key (cod_cochera) references cochera(cod_cochera)
);

create table estacion(
num_estacion int,
num_linea int,
constraint pk_estacion primary key (num_estacion, num_linea),
constraint fk_estacion_linea foreign key (num_linea) references linea(num_linea)
	on delete cascade on update cascade,
constraint ck_estacion_num check (num_estacion > 0)
);