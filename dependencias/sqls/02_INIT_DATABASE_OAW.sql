INSERT INTO `tguidelines` (`cod_guideline`, `des_guideline`) VALUES(4, 'observatorio-inteco-1-0.xml');
INSERT INTO `tguidelines` (`cod_guideline`, `des_guideline`) VALUES(7, 'observatorio-une-2012.xml');
INSERT INTO `tguidelines` (`cod_guideline`, `des_guideline`) VALUES(8, 'observatorio-une-2012-b.xml');

INSERT INTO `cartucho` (`id_cartucho`, `nombre`, `instalado`, `aplicacion`, `numrastreos`, `numhilos`, `id_guideline`) VALUES(3, 'es.inteco.accesibilidad.CartuchoAccesibilidad', 1, 'UNE-2004', 15, 50, 4);
INSERT INTO `cartucho` (`id_cartucho`, `nombre`, `instalado`, `aplicacion`, `numrastreos`, `numhilos`, `id_guideline`) VALUES(7, 'es.inteco.accesibilidad.CartuchoAccesibilidad', 1, 'UNE-2012', 15, 50, 7);
INSERT INTO `cartucho` (`id_cartucho`, `nombre`, `instalado`, `aplicacion`, `numrastreos`, `numhilos`, `id_guideline`) VALUES(8,
'es.inteco.accesibilidad.CartuchoAccesibilidad', 1, 'UNE-2012-Beta', 15, 50, 8);

INSERT INTO `languages` (`id_language`, `key_name`, `codice`) VALUES(1, 'idioma.espanol', 'es');
INSERT INTO `languages` (`id_language`, `key_name`, `codice`) VALUES(2, 'idioma.ingles', 'en');

INSERT INTO `observatorio_tipo` (`id_tipo`, `name`) VALUES(1, 'AGE');
INSERT INTO `observatorio_tipo` (`id_tipo`, `name`) VALUES(2, 'CCAA');
INSERT INTO `observatorio_tipo` (`id_tipo`, `name`) VALUES(3, 'EELL');


INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(1, 'Diario', 1, NULL);
INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(2, 'Semanal', 7, NULL);
INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(3, 'Quincenal', 15, NULL);
INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(4, 'Mensual', NULL, '0 min hour daymonth month/1 ? year/1');
INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(5, 'Trimestral', NULL, '0 min hour daymonth month/3 ? year/1');
INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(6, 'Semestral', NULL, '0 min hour daymonth month/6 ? year/1');
INSERT INTO `periodicidad` (`id_periodicidad`, `nombre`, `dias`, `cronExpression`) VALUES(7, 'Anual', NULL, '0 min hour daymonth month ? year/1');

INSERT INTO `tipo_rol` (`id_tipo`, `nombre`) VALUES(1, 'Normal');
INSERT INTO `tipo_rol` (`id_tipo`, `nombre`) VALUES(2, 'Cliente');
INSERT INTO `tipo_rol` (`id_tipo`, `nombre`) VALUES(3, 'Observatorio');


INSERT INTO `roles` (`id_rol`, `rol`, `id_tipo`) VALUES(1, 'Administrador', 1);
INSERT INTO `roles` (`id_rol`, `rol`, `id_tipo`) VALUES(2, 'Configurador', 1);
INSERT INTO `roles` (`id_rol`, `rol`, `id_tipo`) VALUES(3, 'Visualizador', 1);
INSERT INTO `roles` (`id_rol`, `rol`, `id_tipo`) VALUES(4, 'Responsable cliente', 2);
INSERT INTO `roles` (`id_rol`, `rol`, `id_tipo`) VALUES(5, 'Visualizador cliente', 2);
INSERT INTO `roles` (`id_rol`, `rol`, `id_tipo`) VALUES(6, 'Observatorio', 3);

INSERT INTO `usuario` (`id_usuario`, `usuario`, `password`, `nombre`, `apellidos`, `departamento`, `email`) VALUES(1, 'username', 'password-md5', 'Nombre', 'Apellidos', 'Departamento', 'email@mail.com');
INSERT INTO `usuario` (`id_usuario`, `usuario`, `password`, `nombre`, `apellidos`, `departamento`, `email`) VALUES(2, 'Programado', '21232f297a57a5a743894a0e4a801fc3', '', '', 'CTIC', 'alvaro.pelaez@fundacionctic.org');

INSERT INTO `usuario_cartucho` (`id_usuario`, `id_cartucho`) VALUES(1, 4);
INSERT INTO `usuario_cartucho` (`id_usuario`, `id_cartucho`) VALUES(1, 7);
INSERT INTO `usuario_cartucho` (`id_usuario`, `id_cartucho`) VALUES(1, 8);


INSERT INTO `usuario_cartucho` (`id_usuario`, `id_cartucho`) VALUES(2, 4);
INSERT INTO `usuario_cartucho` (`id_usuario`, `id_cartucho`) VALUES(2, 7);
INSERT INTO `usuario_cartucho` (`id_usuario`, `id_cartucho`) VALUES(2, 8);

INSERT INTO `usuario_rol` (`usuario`, `id_rol`) VALUES(1, 1);
INSERT INTO `usuario_rol` (`usuario`, `id_rol`) VALUES(2, 1);

-- Actualizar los códigos fuente de base de datos a base 64
UPDATE tanalisis SET cod_fuente = TO_BASE64(cod_fuente);
UPDATE tanalisis_css SET codigo = TO_BASE64(codigo)
