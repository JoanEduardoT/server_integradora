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
    imagen MEDIUMBLOB NULL,
    admicion BOOLEAN DEFAULT FALSE,
    estado_suscripcion BOOLEAN DEFAULT FALSE,
    estado BOOLEAN DEFAULT FALSE,
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
    contrasena VARCHAR(255) NOT NULL,
    permiso VARCHAR(255) DEFAULT NULL,
);

CREATE TABLE permisos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE resenas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa INT NOT NULL,
    usuario INT NOT NULL,
    servicio INT NOT NULL,
    puntuacion INT NOT NULL,
    texto VARCHAR(255)
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
CREATE PROCEDURE ObtenerEmpresasNoAdmitidas()
BEGIN
    SELECT * FROM empresas WHERE admicion = FALSE;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ObtenerEmpresasActivas()
BEGIN
    SELECT * FROM empresas WHERE estado = TRUE AND admicion = TRUE;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ModificarAdmicion(
    IN empresa_id INT, 
    IN nuevo_estado BOOLEAN
)
BEGIN
    UPDATE empresas SET admicion = nuevo_estado WHERE id = empresa_id;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ModificarSuscripcion(
    IN empresa_id INT, 
    IN nuevo_estado BOOLEAN
)
BEGIN
    UPDATE empresas SET estado_suscripcion = nuevo_estado WHERE id = empresa_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModificarEstadoEmpresa(
    IN empresa_id INT, 
    IN nuevo_estado BOOLEAN
)
BEGIN
    UPDATE empresas SET estado = nuevo_estado WHERE id = empresa_id;
END //
DELIMITER ;

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
	select id from usuarios where contrasena = p_contrasena and correo = p_correo;
END//
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
    IN p_telefono VARCHAR(20)
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
    IN p_telefono VARCHAR(20)
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

/* DELIMITER //
CREATE PROCEDURE ObtenerCitasEmpresa(IN p_empresa_id INT)
BEGIN
    SELECT c.id, c.empresa, c.usuario, c.servicio, c.fecha, c.hora, c.precio, c.cancelada
    FROM citas c
    WHERE c.empresa = p_empresa_id;
END //
DELIMITER ; */

DELIMITER //
CREATE PROCEDURE ObtenerCitasEmpresa(IN p_empresa_id INT)
BEGIN
    SELECT 
        c.id, 
        e.nombre AS empresa, 
        u.nombre AS usuario, 
        u.correo AS u_correo, 
        u.telefono AS u_telefono, 
        s.nombre AS servicio, 
        c.fecha, 
        c.hora, 
        c.precio, 
        c.cancelada
    FROM citas c
    JOIN empresas e ON c.empresa = e.id
    JOIN usuarios u ON c.usuario = u.id
    JOIN servicios s ON c.servicio = s.id
    WHERE c.empresa = p_empresa_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerCitasUsuario(IN p_usuario_id INT)
BEGIN
    SELECT c.id, e.nombre as empresa, s.nombre as servicio,c.fecha, c.hora, c.precio, c.cancelada
    FROM citas c
    JOIN empresas e ON c.empresa = e.id
    JOIN servicios s ON c.servicio = s.id
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

-- reseñas --------------------------------

DELIMITER //
CREATE PROCEDURE AgregarResena(
    IN p_empresa INT, 
    IN p_usuario INT, 
    IN p_puntuacion INT, 
    IN p_texto VARCHAR(255)
)
BEGIN
    DECLARE v_nombre_empresa VARCHAR(255);
    DECLARE v_nombre_usuario VARCHAR(255);

    SELECT nombre INTO v_nombre_empresa FROM empresas WHERE id = p_empresa;
    SELECT nombre INTO v_nombre_usuario FROM usuarios WHERE id = p_usuario;

    INSERT INTO resenas (empresa, nombre_empresa, usuario, nombre_usuario, puntuacion, texto) 
    VALUES (p_empresa, v_nombre_empresa, p_usuario, v_nombre_usuario, p_puntuacion, p_texto);
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE EditarResena(
    IN p_id INT, 
    IN p_puntuacion INT, 
    IN p_texto VARCHAR(255)
)
BEGIN
    UPDATE resenas 
    SET puntuacion = p_puntuacion, texto = p_texto 
    WHERE id = p_id;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE EliminarResena(IN p_id INT)
BEGIN
    DELETE FROM resenas WHERE id = p_id;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE LeerResenas()
BEGIN
    SELECT * FROM resenas;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE LeerResenasUsuario(IN p_usuario_id INT)
BEGIN
    SELECT * FROM resenas WHERE usuario = p_usuario_id;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE LeerResenasPorEmpresa(IN p_empresa_id INT)
BEGIN
    SELECT * FROM resenas WHERE empresa = p_empresa_id;
END //
DELIMITER;

-- permisos -------------------------

DELIMITER //
CREATE PROCEDURE CrearPermiso(IN p_nombre VARCHAR(100))
BEGIN
    INSERT INTO permisos (nombre) VALUES (p_nombre);
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE EditarPermiso(IN p_id INT, IN p_nombre VARCHAR(100))
BEGIN
    UPDATE permisos 
    SET nombre = p_nombre 
    WHERE id = p_id;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE LeerPermisos()
BEGIN
    SELECT * FROM permisos;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE EliminarPermiso(IN p_id INT)
BEGIN
    DELETE FROM permisos WHERE id = p_id;
END //
DELIMITER;

DELIMITER //
CREATE PROCEDURE AsignarPermisoUsuario(IN p_usuario_id INT, IN p_permiso_nombre VARCHAR(100))
BEGIN
    UPDATE usuarios 
    SET permiso = p_permiso_nombre 
    WHERE id = p_usuario_id;
END //
DELIMITER;