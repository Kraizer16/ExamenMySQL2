-- Elimina la base de datos si ya existe
DROP DATABASE IF EXISTS sakilaCampus;
-- Crea la base de datos si no existe y define su codificación
CREATE DATABASE IF NOT EXISTS sakilaCampus CHARACTER SET utf8mb4;
-- Usa la base de datos recién creada
USE sakilaCampus;

drop table if exists film_text;
create table if not exists film_text(
	film_id smallint primary key auto_increment,
	title varchar(255),
	dscription text 
);

drop table if exists actor;
create table if not exists actor(
	id_actor smallint unsigned primary key auto_increment,
	nombre varchar(45),
	apellidos varchar(45),
	ultima_actualizacion timestamp
);

drop table if exists categoria;
create table if not exists categoria(
	id_categoria tinyint unsigned primary key auto_increment,
	nombre varchar(25),
	ultima_actualizacion timestamp 
);

drop table if exists pais;
create table if not exists pais(
	id_pais smallint unsigned primary key auto_increment,
	nombre varchar(50),
	ultima_actualizacion timestamp 
);

drop table if exists ciudad;
create table if not exists ciudad(
	id_ciudad smallint unsigned primary key auto_increment,
	nombre varchar(50),
	id_pais smallint unsigned,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_pais) REFERENCES pais(id_pais) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists direccion;
create table if not exists direccion(
	id_direccion smallint unsigned primary key auto_increment,
	direccion varchar(50),
	direccion2 varchar(50),
	distrito varchar(20),
	id_ciudad smallint unsigned,
	codigo_postal varchar(10),
	telefono varchar(20),
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists idioma;
create table if not exists idioma(
	id_idioma tinyint unsigned primary key auto_increment,
	nombre char(20),
	ultima_actualizacion timestamp 
);

drop table if exists pelicula;
create table if not exists pelicula(
	id_pelicula smallint unsigned primary key,
	titulo varchar(255),
	descripcion text,
	anyo_lanzamiento year,
	id_idioma tinyint unsigned,
	id_idioma_original tinyint unsigned,
	duracion_alquiler tinyint unsigned,
	rental_rate decimal(4,2),
	duracion smallint unsigned,
	replacement_cost decimal(5,2),
	clasificacion enum('G','PG','PG-13','R','NC-17'),
	caracteristicas_especiales set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_idioma_original) REFERENCES idioma(id_idioma) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists pelicula_actor;
create table if not exists pelicula_actor(
	id_actor smallint unsigned,
	id_pelicula smallint unsigned,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_actor) REFERENCES actor(id_actor) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    primary key(id_actor, id_pelicula)
);

drop table if exists pelicula_categoria;
create table if not exists pelicula_categoria(
	id_pelicula smallint unsigned,
	id_categoria tinyint unsigned,
	ultima_actualizacion timestamp,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    primary key(id_pelicula, id_categoria)
);

drop table if exists empleado;
create table if not exists empleado(
	id_empleado tinyint unsigned primary key,
	nombre varchar(45),
	apellidos varchar(45),
	id_direccion smallint unsigned,
	imagen blob,
	email varchar(50),
	FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    -- Para el resto de las columnas se utilizo "alter table",
    -- Para poder agregar la llave foranea de la tabla almacen,
    -- y añadir el resto de columnas.
);

drop table if exists almacen;
create table if not exists almacen(
	id_almacen tinyint unsigned primary key,
	id_empleado_jefe tinyint unsigned,
	id_direccion smallint unsigned,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_empleado_jefe) REFERENCES empleado(id_empleado) 
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists inventario;
create table if not exists inventario(
	id_inventario mediumint unsigned primary key,
	id_pelicula smallint unsigned,
	id_almacen tinyint unsigned,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) 
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists cliente;
create table if not exists cliente(
	id_cliente smallint unsigned primary key,
	id_almacen tinyint unsigned,
	nombre varchar(45),
	apellidos varchar(45),
	email varchar(50),
	id_direccion smallint unsigned,
	activo tinyint(1),
	fecha_creacion datetime,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen) 
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists alquiler;
create table if not exists alquiler(
	id_alquiler int primary key,
	fecha_alquiler datetime,
	id_inventario mediumint unsigned,
	id_cliente smallint unsigned,
	fecha_devolucion datetime,
	id_empleado tinyint unsigned,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario) 
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

drop table if exists pago;
create table if not exists pago(
	id_pago smallint unsigned primary key,
	id_cliente smallint unsigned,
	id_empleado tinyint unsigned,
	id_alquiler int,
	total decimal(5,2),
	fecha_pago datetime,
	ultima_actualizacion timestamp,
	FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) 
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_alquiler) REFERENCES alquiler(id_alquiler) 
    ON DELETE CASCADE ON UPDATE CASCADE
);
















































































