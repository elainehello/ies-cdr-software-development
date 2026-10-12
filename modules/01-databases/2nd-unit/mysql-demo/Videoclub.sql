Create Database if not exists videoclub;
Use videoclub;

create table director(
nombre varchar(50) primary key,
nacionalidad varchar(50)
);

create table pelicula(
titulo varchar(70),
fecha date,
nacionalidad varchar(50),
productora varchar(60),
nom_direc varchar(50),
CONSTRAINT pk_pelicula PRIMARY KEY (titulo, fecha),
constraint fk_peli_direc foreign key (nom_direc) references director(nombre)
);

create table ejemplar(
numero INT,
titulo varchar(70),
fecha date,
conserva varchar(50),
constraint pk_ejemplar primary key (numero, titulo, fecha),
constraint fk_ejemplar_peli foreign key (titulo, fecha) references pelicula(titulo, fecha)
	on delete cascade on update cascade,
constraint ck_ejemplar_num check (numero > 0)
);

create table socio(
dni varchar(20) primary key,
nombre varchar(50),
direccion varchar(70),
telefono varchar(15),
dni_avala varchar(20),
constraint fk_socio_socio foreign key (dni_avala) references socio(dni),
constraint ck_socio_avala check (dni_avala <> dni)
);

create table alquilado(
numero int,
titulo varchar(70),
fecha date,
dni varchar(20),
fecha_alq date,
fecha_dev date,
constraint pk_alquilado primary key (numero, titulo, fecha, dni, fecha_alq),
constraint fk_alq_ejemplar foreign key (numero, titulo, fecha) references ejemplar(numero, titulo, fecha),
constraint fk_alq_socio foreign key (dni) references socio(dni),
constraint ck_alq_fechas check (fecha_dev is null or fecha_dev >= fecha_alq)
);

create table actor(
nombre varchar(75) primary key,
nacionalidad varchar(50),
sexo varchar(20)
);

create table participa(
titulo varchar(70),
fecha date,
nom_actor varchar(75),
tipo_part varchar(20),
constraint pk_participa PRIMARY KEY (titulo, fecha, nom_actor),
constraint fk_part_peli foreign key (titulo, fecha) references pelicula(titulo, fecha),
constraint fk_part_actor foreign key (nom_actor) references actor(nombre),
constraint ck_part_tipo check (tipo_part in ('principal', 'secundario', 'reparto'))
);