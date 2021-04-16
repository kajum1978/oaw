INSERT INTO tguidelines (cod_guideline, des_guideline) VALUES (9, 'observatorio-une-en2019.xml');
INSERT INTO tguidelines (cod_guideline, des_guideline) VALUES (10, 'observatorio-accesibilidad.xml');
INSERT INTO cartucho (id_cartucho, nombre, instalado, aplicacion, numrastreos, numhilos, id_guideline) VALUES (9, 'es.inteco.accesibilidad.CartuchoAccesibilidad', 1, 'UNE-EN301549:2019 (beta)', 15, 50, 9);
INSERT INTO cartucho (id_cartucho, nombre, instalado, aplicacion, numrastreos, numhilos, id_guideline) VALUES (10, 'es.inteco.accesibilidad.CartuchoAccesibilidad', 1, 'Accesibilidad', 15, 50, 10);
INSERT INTO usuario_cartucho (id_usuario, id_cartucho) VALUES(1, 9);
INSERT INTO usuario_cartucho (id_usuario, id_cartucho) VALUES(1, 10);
INSERT INTO observatorio_tipo (id_tipo, name) VALUES ('4', 'OTROS');
ALTER TABLE lista ADD eliminar BIGINT(20) NOT NULL DEFAULT '0';
CREATE TABLE ambitos_lista (
	id_ambito BIGINT(20) NOT NULL AUTO_INCREMENT , 
	nombre VARCHAR(50)  NOT NULL , 
	PRIMARY KEY (id_ambito)
) ;
INSERT INTO ambitos_lista (id_ambito, nombre) VALUES ('1', 'AGE'), ('2', 'CCAA'), ('3', 'EELL'), ('4', 'Otros');
CREATE TABLE observatorio_ambito ( 
	id_observatorio BIGINT(20) NOT NULL , 
	id_ambito BIGINT(20) NOT NULL 
);
ALTER TABLE observatorio ADD id_ambito BIGINT(20);
CREATE TABLE complejidades_lista ( 
	id_complejidad BIGINT(20) NOT NULL AUTO_INCREMENT , 
	nombre VARCHAR(50) NOT NULL , 
	profundidad BIGINT(20) NOT NULL , 
	amplitud BIGINT(20) NOT NULL , 
	PRIMARY KEY (id_complejidad)
);
INSERT INTO complejidades_lista (id_complejidad, nombre, profundidad, amplitud) VALUES(1, 'Baja', 2, 2);
INSERT INTO complejidades_lista (id_complejidad, nombre, profundidad, amplitud) VALUES(2, 'Media', 4, 8);
INSERT INTO complejidades_lista (id_complejidad, nombre, profundidad, amplitud) VALUES(3, 'Alta', 4, 11);
CREATE TABLE observatorio_complejidad ( id_observatorio BIGINT(20) NOT NULL , id_complejidad INT(20) NOT NULL ) ;
ALTER TABLE lista ADD id_complejidad BIGINT(20);
ALTER TABLE lista ADD id_ambito BIGINT(20) NULL DEFAULT NULL;
ALTER TABLE lista ADD KEY id_ambito (id_ambito);
UPDATE lista SET id_complejidad=2;
CREATE TABLE etiqueta (
	id_etiqueta BIGINT(20) NOT NULL AUTO_INCREMENT , 
	nombre VARCHAR(50) NOT NULL , 
	id_clasificacion BIGINT(20) NOT NULL , 
	PRIMARY KEY (id_etiqueta)
);
CREATE TABLE clasificacion_etiqueta (
	id_clasificacion BIGINT(20) NOT NULL AUTO_INCREMENT , 
	nombre VARCHAR(50) NOT NULL , 
	PRIMARY KEY (id_clasificacion)
);
INSERT INTO clasificacion_etiqueta (id_clasificacion, nombre) VALUES ('1', 'Temática'), ('2', 'Distribución'), ('3', 'Recurrencia');
CREATE TABLE semilla_etiqueta (
  id_lista bigint(20) NOT NULL DEFAULT 0,
  id_etiqueta bigint(20) NOT NULL DEFAULT 0
);
ALTER TABLE semilla_etiqueta ADD PRIMARY KEY (id_lista,id_etiqueta), ADD KEY semilla_etiqueta_ibfk_1 (id_etiqueta);
ALTER TABLE semilla_etiqueta ADD CONSTRAINT semilla_etiqueta_ibfk_1 FOREIGN KEY (id_etiqueta) REFERENCES etiqueta (id_etiqueta) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE rastreos_realizados ADD level VARCHAR(128),  ADD score VARCHAR(32) ;
CREATE TABLE observatorio_plantillas (
  id_plantilla int(11)  NOT NULL AUTO_INCREMENT,
  nombre varchar(1024) NOT NULL,
  documento LONGBLOB NOT NULL,
  PRIMARY KEY (id_plantilla)
);
ALTER TABLE basic_service ADD complexity VARCHAR(128) NULL;
ALTER TABLE observatorio ADD tags VARCHAR(1024) NULL;
CREATE TABLE tanalisis_accesibilidad ( 
	id INT NOT NULL AUTO_INCREMENT , 
	id_analisis INT NOT NULL , 
	urls VARCHAR(2048) NOT NULL , 
	PRIMARY KEY (id)
);
ALTER TABLE basic_service ADD filename VARCHAR(1024) NULL;
ALTER TABLE etiqueta ADD UNIQUE(nombre);
ALTER TABLE categoria CHANGE categoria categoria VARCHAR(256);
INSERT INTO clasificacion_etiqueta (id_clasificacion, nombre) VALUES ('4', 'Otros');
ALTER TABLE ambitos_lista ADD descripcion VARCHAR(1024) NULL;
UPDATE ambitos_lista SET descripcion = 'Administración General del Estado' WHERE id_ambito = 1;
UPDATE ambitos_lista SET descripcion = 'Comunidades Autónomas' WHERE id_ambito = 2;
UPDATE ambitos_lista SET descripcion = 'Entidades Locales' WHERE id_ambito = 3;
UPDATE ambitos_lista SET descripcion = 'Otros' WHERE id_ambito = 4;
CREATE INDEX tanalisis_cod_rastreo ON tanalisis (cod_rastreo);
ALTER TABLE categorias_lista ADD clave VARCHAR(1024) NULL;
ALTER TABLE lista ADD observaciones VARCHAR(1024) NULL;
ALTER table export_site ADD COLUMN compliance VARCHAR(32) NULL;

TRUNCATE tanalisis_accesibilidad;
ALTER TABLE tanalisis_accesibilidad CHANGE COLUMN urls url VARCHAR(256) NULL DEFAULT NULL ;
ALTER TABLE tanalisis_accesibilidad ADD UNIQUE INDEX id_analisis_UNIQUE (id_analisis,url);
ALTER TABLE tanalisis_accesibilidad ADD COLUMN checks_ok INT NULL DEFAULT 0;
