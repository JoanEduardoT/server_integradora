CREATE DATABASE integradora_db;
USE integradora_db;

CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    rfc VARCHAR(13) UNIQUE NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    correo_admin VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    imagen MEDIUMBLOB NULL
);

CREATE TABLE servicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
--    horas_disponibles JSON NOT NULL, -- arrays para horas y fechas, por si se llegan a utilizar
--    fechas_disponibles JSON NOT NULL, 
    precio DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (empresa) REFERENCES empresas(id)
);

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    contrasena VARCHAR(255) NOT NULL
);

CREATE TABLE permisos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
)

CREATE TABLE citas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa INT NOT NULL,
    usuario INT NOT NULL,
    servicio INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    cancelada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (empresa) REFERENCES empresas(id),
    FOREIGN KEY (usuario) REFERENCES usuarios(id),
    FOREIGN KEY (servicio) REFERENCES servicios(id)
);


-- Empresas -------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE LoginEmpresa(
    IN p_correo VARCHAR(255),
    IN p_contrasena VARCHAR(255)
)
BEGIN
    DECLARE v_id INT;
    
    SELECT id INTO v_id 
    FROM empresas 
    WHERE correo = p_correo AND contrasena = p_contrasena;
    
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE VerEmpresaUnica(IN p_id INT)
BEGIN
    SELECT id, nombre, rfc, direccion, correo, correo_admin, telefono, imagen
    FROM empresas
    WHERE id = p_id;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE AgregarEmpresa(
    IN p_nombre VARCHAR(255),
    IN p_rfc VARCHAR(13),
    IN p_direccion VARCHAR(255),
    IN p_correo VARCHAR(255),
    IN p_correo_admin VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_contrasena VARCHAR(255),
    IN p_imagen MEDIUMBLOB
)
BEGIN
    INSERT INTO empresas (nombre, rfc, direccion, correo, correo_admin, telefono, contrasena, imagen)
    VALUES (p_nombre, p_rfc, p_direccion, p_correo, p_correo_admin, p_telefono, p_contrasena, p_imagen);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ObtenerEmpresas()
BEGIN
    SELECT id, nombre, rfc, direccion, correo, correo_admin, telefono, imagen
    FROM empresas;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE ActualizarEmpresa(
    IN p_id INT,
    IN p_nombre VARCHAR(255),
    IN p_rfc VARCHAR(13),
    IN p_direccion VARCHAR(255),
    IN p_correo VARCHAR(255),
    IN p_correo_admin VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_contrasena VARCHAR(255),
    IN p_imagen MEDIUMBLOB
)
BEGIN
    UPDATE empresas 
    SET nombre = p_nombre, rfc = p_rfc, direccion = p_direccion, 
        correo = p_correo, correo_admin = p_correo_admin, 
        telefono = p_telefono, contrasena = p_contrasena, imagen = p_imagen
    WHERE id = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarEmpresa(IN p_id INT)
BEGIN
    DELETE FROM empresas WHERE id = p_id;
END //
DELIMITER ;


-- SERVICIOS -------------------------------------

DELIMITER //
CREATE PROCEDURE AgregarServicio(
    IN p_empresa INT,
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    -- IN p_horas_disponibles JSON,
    -- IN p_fechas_disponibles JSON,
    IN p_precio DECIMAL(10,2)
)
BEGIN
    INSERT INTO servicios (empresa, nombre, descripcion, 
    -- horas_disponibles, fechas_disponibles,
    precio)
    VALUES (p_empresa, p_nombre, p_descripcion, 
    -- p_horas_disponibles, p_fechas_disponibles,
    p_precio);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ObtenerServicios()
BEGIN
    SELECT * FROM servicios;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerServiciosEmpresa(IN p_empresa_id INT)
BEGIN
    SELECT * FROM servicios
    WHERE empresa = p_empresa_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerServicioEspecifico(IN p_servicio_id INT)
BEGIN
    SELECT * FROM servicios
    WHERE id = p_servicio_id;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ActualizarServicio(
    IN p_id INT,
    IN p_empresa INT,
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    -- IN p_horas_disponibles JSON,
    -- IN p_fechas_disponibles JSON,
    IN p_precio DECIMAL(10,2)
)
BEGIN
    UPDATE servicios 
    SET empresa = p_empresa, nombre = p_nombre, descripcion = p_descripcion,
   --     horas_disponibles = p_horas_disponibles, fechas_disponibles = p_fechas_disponibles,
        precio = p_precio
    WHERE id = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarServicio(IN p_id INT)
BEGIN
    DELETE FROM servicios WHERE id = p_id;
END //
DELIMITER ;

-- USUARIOS------------------------------------------------------

DELIMITER //
CREATE PROCEDURE LoginUsuario(
    IN p_correo VARCHAR(255),
    IN p_contrasena VARCHAR(255)
)
BEGIN
    DECLARE v_id INT;
    
    SELECT id INTO v_id 
    FROM usuarios 
    WHERE correo = p_correo AND contrasena = p_contrasena;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerUsuarioUnico(IN p_usuario_id INT)
BEGIN
    SELECT id, nombre, apellidos, correo, telefono
    FROM usuarios
    WHERE id = p_usuario_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CrearUsuario(
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(255),
    IN p_contrasena VARCHAR(255),
    IN p_telefono VARCHAR(20),
)
BEGIN
    INSERT INTO usuarios (nombre, apellidos, correo, telefono, contrasena)
    VALUES (p_nombre, p_apellidos, p_correo, p_telefono, p_contrasena);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ObtenerUsuarios()
BEGIN
    SELECT id, nombre, apellidos, correo, telefono FROM usuarios;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ActualizarUsuario(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(255),
    IN p_contrasena VARCHAR(255),
    IN p_telefono VARCHAR(20),
)
BEGIN
    UPDATE usuarios 
    SET nombre = p_nombre, apellidos = p_apellidos, correo = p_correo, telefono = p_telefono, contrasena = p_contrasena
    WHERE id = p_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EliminarUsuario(IN p_id INT)
BEGIN
    DELETE FROM usuarios WHERE id = p_id;
END //
DELIMITER ;

-- CITAS -------------------------------------
DELIMITER //
CREATE PROCEDURE CrearCita(
    IN p_empresa INT,
    IN p_usuario INT,
    IN p_servicio INT,
    IN p_fecha DATE,
    IN p_hora TIME
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    
    SELECT precio INTO v_precio FROM servicios WHERE id = p_servicio;
    
    INSERT INTO citas (empresa, usuario, servicio, fecha, hora, precio, cancelada)
    VALUES (p_empresa, p_usuario, p_servicio, p_fecha, p_hora, v_precio, FALSE);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerCitasEmpresa(IN p_empresa_id INT)
BEGIN
    SELECT c.id, c.empresa, c.usuario, c.servicio, c.fecha, c.hora, c.precio, c.cancelada
    FROM citas c
    WHERE c.empresa = p_empresa_id;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ObtenerCitasUsuario(IN p_usuario_id INT)
BEGIN
    SELECT c.id, c.empresa, c.usuario, c.servicio, c.fecha, c.hora, c.precio, c.cancelada
    FROM citas c
    WHERE c.usuario = p_usuario_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerCitaUnica(IN p_cita_id INT)
BEGIN
    SELECT c.id, c.empresa, c.usuario, c.servicio, c.fecha, c.hora, c.precio, c.cancelada
    FROM citas c
    WHERE c.id = p_cita_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CancelarCita(IN p_id INT)
BEGIN
    UPDATE citas SET cancelada = TRUE WHERE id = p_id;
END //
DELIMITER ;
