import mysql from "mysql2";
import dotenv from "dotenv";

dotenv.config();

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
}).promise();


async function query(sql, params = []) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

// Procedimientos para Empresas
async function loginEmpresa(correo, contrasena) {
  const sql = `CALL LoginEmpresa(?, ?)`;
  const result = await query(sql, [correo, contrasena]);
  return result[0] || null;
}

async function agregarEmpresa(datos) {
  const { nombre, rfc, direccion, correo, correo_admin, telefono, contrasena, imagen } = datos;
  const sql = `CALL AgregarEmpresa(?, ?, ?, ?, ?, ?, ?, ?)`;
  return await query(sql, [nombre, rfc, direccion, correo, correo_admin, telefono, contrasena, imagen]);
}

async function obtenerEmpresas() {
  const sql = `CALL ObtenerEmpresas()`;
  return await query(sql);
}

async function verEmpresaUnica(id) {
  const sql = `CALL VerEmpresaUnica(?)`;
  return await query(sql, [id]);
}

async function actualizarEmpresa(datos) {
  const { id, nombre, rfc, direccion, correo, correo_admin, telefono, contrasena, imagen } = datos;
  const sql = `CALL ActualizarEmpresa(?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  return await query(sql, [id, nombre, rfc, direccion, correo, correo_admin, telefono, contrasena, imagen]);
}

async function eliminarEmpresa(id) {
  const sql = `CALL EliminarEmpresa(?)`;
  return await query(sql, [id]);
}

// Procedimientos para Servicios
async function agregarServicio(datos) {
  const { empresa, nombre, descripcion, precio } = datos;
  const sql = `CALL AgregarServicio(?, ?, ?, ?)`;
  return await query(sql, [empresa, nombre, descripcion, precio]);
}

async function obtenerServicios() {
  const sql = `CALL ObtenerServicios()`;
  return await query(sql);
}

async function obtenerServiciosEmpresa(empresa_id) {
  const sql = `CALL ObtenerServiciosEmpresa(?)`;
  return await query(sql, [empresa_id]);
}

async function obtenerServicioEspecifico(servicio_id) {
  const sql = `CALL ObtenerServicioEspecifico(?)`;
  return await query(sql, [servicio_id]);
}

async function actualizarServicio(datos) {
  const { id, empresa, nombre, descripcion, precio } = datos;
  const sql = `CALL ActualizarServicio(?, ?, ?, ?, ?)`;
  return await query(sql, [id, empresa, nombre, descripcion, precio]);
}

async function eliminarServicio(id) {
  const sql = `CALL EliminarServicio(?)`;
  return await query(sql, [id]);
}

// Procedimientos para Usuarios
async function loginUsuario(correo, contrasena) {
  const sql = `CALL LoginUsuario(?, ?)`;
  const result = await query(sql, [correo, contrasena]);
  return result[0] || null;
}

async function crearUsuario(datos) {
  const { nombre, apellidos, correo, telefono, contrasena } = datos;
  const sql = `CALL CrearUsuario(?, ?, ?, ?, ?)`;
  return await query(sql, [nombre, apellidos, correo, telefono, contrasena]);
}

async function obtenerUsuarios() {
  const sql = `CALL ObtenerUsuarios()`;
  return await query(sql);
}

async function obtenerUsuarioUnico(id) {
  const sql = `CALL ObtenerUsuarioUnico(?)`;
  return await query(sql, [id]);
}

async function actualizarUsuario(datos) {
  const { id, nombre, apellidos, correo, telefono, contrasena } = datos;
  const sql = `CALL ActualizarUsuario(?, ?, ?, ?, ?, ?)`;
  return await query(sql, [id, nombre, apellidos, correo, telefono, contrasena]);
}

async function eliminarUsuario(id) {
  const sql = `CALL EliminarUsuario(?)`;
  return await query(sql, [id]);
}

// Procedimientos para Citas
async function crearCita(datos) {
  const { empresa, usuario, servicio, fecha, hora } = datos;
  const sql = `CALL CrearCita(?, ?, ?, ?, ?)`;
  return await query(sql, [empresa, usuario, servicio, fecha, hora]);
}

async function obtenerCitasEmpresa(empresa_id) {
  const sql = `CALL ObtenerCitasEmpresa(?)`;
  return await query(sql, [empresa_id]);
}

async function obtenerCitasUsuario(usuario_id) {
  const sql = `CALL ObtenerCitasUsuario(?)`;
  return await query(sql, [usuario_id]);
}

async function obtenerCitaUnica(cita_id) {
  const sql = `CALL ObtenerCitaUnica(?)`;
  return await query(sql, [cita_id]);
}

async function cancelarCita(id) {
  const sql = `CALL CancelarCita(?)`;
  return await query(sql, [id]);
}

export {
  loginEmpresa,
  agregarEmpresa,
  obtenerEmpresas,
  verEmpresaUnica,
  actualizarEmpresa,
  eliminarEmpresa,
  agregarServicio,
  obtenerServicios,
  obtenerServiciosEmpresa,
  obtenerServicioEspecifico,
  actualizarServicio,
  eliminarServicio,
  loginUsuario,
  crearUsuario,
  obtenerUsuarios,
  obtenerUsuarioUnico,
  actualizarUsuario,
  eliminarUsuario,
  crearCita,
  obtenerCitasEmpresa,
  obtenerCitasUsuario,
  obtenerCitaUnica,
  cancelarCita
};
