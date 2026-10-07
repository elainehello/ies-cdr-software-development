Create Database videoclub;
Use videoclub;

create table director(
nombre varchar(50) primary key,
nacionalidad varchar(50)
);

create table pelicula(
titulo varchar(70),
fecha date,
CONSTRAINT pk_pelicula PRIMARY KEY (titulo, fecha),
nacionalidad varchar(50),
productora varchar(60),
nom_direc varchar(50),
constraint fk_peli_direc foreign key (nom_direc) references director(nombre)
);

create table ejemplar(
numero int(20),
conserva varchar(50),
titulo varchar(70),
fecha date,
constraint fk_ejemplar_peli foreign key (titulo, fecha) references pelicula(titulo, fecha)
);

create table socio(
dni varchar(20) primary key,
nombre varchar(50),
direccion varchar(70),
telefono int(20),
dni_avala varchar(20),
constraint fk_socio_socio foreign key (dni_avala) references socio(dni_avala)
);

create table alquilado(
numero int(20),
titulo varchar(70),

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