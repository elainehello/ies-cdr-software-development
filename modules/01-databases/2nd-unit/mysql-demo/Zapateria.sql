drop database if exists zapateria;
create database zapateria;
use zapateria;

create table tiendas (
	nif varchar(10) NOT NULL primary key,
    nombre varchar(20),
    direccion varchar(20),
    poblacion varchar(20),
    provincia varchar(20),
    cod_postal int(5),
    constraint ck_tiendas_provincia check (provincia = upper(provincia)),
    constraint ck_tiendas_nombre check(nombre = upper(nombre))
);

create table fabricantes (
	cod_fabricante int(3) NOT NULL primary key,
    nombre varchar(15),
    pais varchar(15),
    constraint ck_fabricantes_nombre check (nombre = upper(nombre)),
    constraint ck_fabricantes_pais check (pais = upper(pais))
);

create table articulos (
	articulo varchar(20) not null,
    cod_fabricante int(3) not null,
    peso int(3) not null,
    categoria varchar(10) not null,
    precio_venta int(4),
    precio_costo int(4),
    existencias int(5),
    constraint pk_articulos primary key (articulo, cod_fabricante, peso, categoria),
    constraint fk_articulos_fabricante foreign key (cod_fabricante) references fabricantes(cod_fabricante),
    constraint ck_articulos_precios check (precio_venta > 0 AND precio_costo > 0 AND peso > 0),
    constraint ck_categoria_articulo check (categoria in ('primera', 'segunda', 'tercera'))
);

create table pedidos (
	nif varchar(10) not null,
    articulo varchar(20) not null,
    cod_fabricante int(3) not null,
    peso int(3) not null,
    categoria varchar(10) not null,
    fecha_pedido date not null,
    unidades_pedidas int(4) not null,
    constraint pk_pedidos primary key (nif, articulo, cod_fabricante, peso, categoria, fecha_pedido),
    constraint fk_pedidos_fabricantes foreign key (cod_fabricante) references fabricantes(cod_fabricante),
    constraint fk_pedidos_articulos foreign key (articulo, cod_fabricante, peso, categoria) references articulos(articulo, cod_fabricante, peso, categoria)
    on delete cascade,
    constraint ft_pedidos_tiendas foreign key (nif) references tiendas(nif),
    constraint ck_pedidos_unidades check (unidades_pedidas > 0),
    constraint ck_pedidos_categoria check (categoria in ('primera', 'segunda', 'tercera'))    
);

create table ventas(
	nif varchar(10) not null,
    articulo varchar(20) not null,
    cod_fabricante int(3) not null,
    peso int(3) not null,
    categoria varchar(10) not null,
    fecha_venta date not null,
    unidades_vendidas int(6),
    constraint pk_ventas primary key (nif, articulo, cod_fabricante, peso, categoria, fecha_venta),
    constraint fk_ventas_fabricantes foreign key (cod_fabricante) references fabricantes(cod_fabricante),
    constraint fk_ventas_articulos foreign key (articulo, cod_fabricante, peso, categoria) references articulos(articulo, cod_fabricante, peso, categoria)
    on delete cascade,
    constraint fk_ventas_tiendas foreign key (nif) references tiendas(nif),
    constraint ck_ventas_unidades check (unidades_vendidas > 0),
    constraint ck_ventas_categoria check (categoria in ('primera', 'segunda', 'tercera'))
);

SELECT *
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'zapateria';

alter table pedidos
modify unidades_pedidas int(6);

describe pedidos;