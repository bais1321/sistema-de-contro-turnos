-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3308
-- Tiempo de generación: 30-05-2026 a las 22:51:07
-- Versión del servidor: 8.0.18
-- Versión de PHP: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_turnos2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

DROP TABLE IF EXISTS `areas`;
CREATE TABLE IF NOT EXISTS `areas` (
  `id_area` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_area` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `id_area_padre` int(11) DEFAULT NULL,
  `es_jefatura` tinyint(1) DEFAULT '0',
  `estado` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_area`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id_area`, `nombre_area`, `descripcion`, `id_area_padre`, `es_jefatura`, `estado`, `created_at`) VALUES
(3, 'Recursos Humanos', 'Gestión de personal y nóminas', NULL, 1, 1, '2026-05-10 07:04:02'),
(4, 'Tecnología', 'Soporte técnico y desarrollo', NULL, 1, 1, '2026-05-10 07:04:02'),
(5, 'Operaciones', 'Producción y logística', NULL, 1, 1, '2026-05-10 07:04:02'),
(6, 'Ventas', 'Atención al cliente y comercial', NULL, 1, 1, '2026-05-10 07:04:02'),
(7, 'Finanzas', 'Contabilidad y presupuestos', NULL, 1, 1, '2026-05-10 07:04:02'),
(8, 'Contabilidad', 'Jefatura Contabilidad', NULL, 1, 1, '2026-05-16 03:27:18'),
(9, 'Logistica', 'Jefatura Logistica', NULL, 1, 1, '2026-05-16 03:27:18'),
(10, 'Contabilidad Empleado', 'Empleados Contabilidad', 8, 0, 1, '2026-05-16 03:27:18'),
(11, 'Logistica Empleado', 'Empleados Logistica', 9, 0, 1, '2026-05-16 03:27:18'),
(16, 'Finanzas Empleado', 'Empleados de Finanzas', 7, 0, 1, '2026-05-16 21:49:17'),
(17, 'Ventas Empleado', 'Empleados de Ventas', 6, 0, 1, '2026-05-16 21:49:17'),
(18, 'Operaciones Empleado', 'Empleados de Operaciones', 5, 0, 1, '2026-05-16 21:49:17'),
(19, 'Tecnologia Empleado', 'Empleados de Tecnologia', 4, 0, 1, '2026-05-16 21:49:18'),
(20, 'Recursos Humanos Empleado', 'Empleados de Recursos Humanos', 3, 0, 1, '2026-05-16 21:49:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciones_turno`
--

DROP TABLE IF EXISTS `asignaciones_turno`;
CREATE TABLE IF NOT EXISTS `asignaciones_turno` (
  `id_asignacion` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_turno` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` enum('Activo','Inactivo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Activo',
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_asignacion`),
  KEY `fk_asig_usuario` (`id_usuario`),
  KEY `fk_asig_turno` (`id_turno`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `asignaciones_turno`
--

INSERT INTO `asignaciones_turno` (`id_asignacion`, `id_usuario`, `id_turno`, `fecha_inicio`, `fecha_fin`, `estado`, `observaciones`, `created_at`) VALUES
(4, 8, 2, '2026-05-23', '2026-06-06', 'Activo', '                        ', '2026-05-23 22:28:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE IF NOT EXISTS `bitacora` (
  `id_bitacora` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre_completo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_operacion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modulo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bitacora`),
  KEY `fk_bitacora_usuario` (`id_usuario`)
) ENGINE=MyISAM AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `bitacora`
--

INSERT INTO `bitacora` (`id_bitacora`, `id_usuario`, `username`, `nombre_completo`, `tipo_operacion`, `modulo`, `descripcion`, `ip_address`, `fecha_hora`) VALUES
(1, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 03:12:50'),
(2, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 03:30:28'),
(3, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 03:35:58'),
(4, 1, 'byron', 'Byron Sequen', 'Crear', 'Usuarios', 'Creo usuario: mario', '0:0:0:0:0:0:0:1', '2026-05-23 03:37:37'),
(5, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 4 a usuario 2', '0:0:0:0:0:0:0:1', '2026-05-23 03:37:51'),
(6, 1, 'byron', 'Byron Sequen', 'Crear', 'Usuarios', 'Creo usuario: diaz', '0:0:0:0:0:0:0:1', '2026-05-23 03:39:00'),
(7, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 4 a usuario 3', '0:0:0:0:0:0:0:1', '2026-05-23 03:39:09'),
(8, 1, 'byron', 'Byron Sequen', 'Crear', 'Usuarios', 'Creo usuario: jose', '0:0:0:0:0:0:0:1', '2026-05-23 03:40:54'),
(9, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 4 a usuario 4', '0:0:0:0:0:0:0:1', '2026-05-23 03:41:02'),
(10, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 03:47:26'),
(11, 5, 'maria', 'maria gomez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 03:47:41'),
(12, 5, 'maria', 'maria gomez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 03:48:09'),
(13, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 03:48:22'),
(14, 4, 'jose', 'jose lopez', 'Crear', 'Solicitudes', 'Creo solicitud de permiso', '0:0:0:0:0:0:0:1', '2026-05-23 03:48:54'),
(15, 4, 'jose', 'jose lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 03:49:01'),
(16, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 03:49:12'),
(17, 1, 'byron', 'Byron Sequen', 'Crear', 'Usuarios', 'Creo usuario: marlon', '0:0:0:0:0:0:0:1', '2026-05-23 03:56:06'),
(18, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 1 a usuario 6', '0:0:0:0:0:0:0:1', '2026-05-23 03:56:15'),
(19, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 03:56:44'),
(20, 6, 'marlon', 'marlon quiñones', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 03:56:53'),
(21, 6, 'marlon', 'marlon quiñones', 'Marcaje', 'Marcaje', 'Marco entrada', '0:0:0:0:0:0:0:1', '2026-05-23 03:57:31'),
(22, 6, 'marlon', 'marlon quiñones', 'Marcaje', 'Marcaje', 'Inicio break', '0:0:0:0:0:0:0:1', '2026-05-23 03:59:52'),
(23, 6, 'marlon', 'marlon quiñones', 'Marcaje', 'Marcaje', 'Fin break', '0:0:0:0:0:0:0:1', '2026-05-23 04:17:15'),
(24, 6, 'marlon', 'marlon quiñones', 'Marcaje', 'Marcaje', 'Inicio lonch', '0:0:0:0:0:0:0:1', '2026-05-23 04:17:24'),
(25, 6, 'marlon', 'marlon quiñones', 'Marcaje', 'Marcaje', 'Fin lonch', '0:0:0:0:0:0:0:1', '2026-05-23 04:17:31'),
(26, 6, 'marlon', 'marlon quiñones', 'Marcaje', 'Marcaje', 'Marco salida', '0:0:0:0:0:0:0:1', '2026-05-23 04:17:40'),
(27, 6, 'marlon', 'marlon quiñones', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 04:26:31'),
(28, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 21:49:44'),
(29, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 21:51:08'),
(30, 7, 'perez', 'maritza perez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:11:35'),
(31, 7, 'perez', 'maritza perez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:11:50'),
(32, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:12:03'),
(33, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:14:50'),
(34, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:15:15'),
(35, 4, 'jose', 'jose lopez', 'Crear', 'Solicitudes', 'Creo solicitud de permiso', '0:0:0:0:0:0:0:1', '2026-05-23 22:15:52'),
(36, 4, 'jose', 'jose lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:16:00'),
(37, 6, 'marlon', 'marlon quiñones', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:16:44'),
(38, 6, 'marlon', 'marlon quiñones', 'Aprobar', 'Solicitudes', 'Autorizo (RRHH) solicitud #8', '0:0:0:0:0:0:0:1', '2026-05-23 22:17:01'),
(39, 6, 'marlon', 'marlon quiñones', 'Aprobar', 'Solicitudes', 'Autorizo (RRHH) solicitud #9', '0:0:0:0:0:0:0:1', '2026-05-23 22:17:11'),
(40, 6, 'marlon', 'marlon quiñones', 'Crear', 'Usuarios', 'Creo usuario: sergio', '0:0:0:0:0:0:0:1', '2026-05-23 22:18:37'),
(41, 6, 'marlon', 'marlon quiñones', 'Crear', 'Roles', 'Asigno rol 3 a usuario 8', '0:0:0:0:0:0:0:1', '2026-05-23 22:18:51'),
(42, 6, 'marlon', 'marlon quiñones', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:23:19'),
(43, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:23:28'),
(44, 4, 'jose', 'jose lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:23:34'),
(45, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:23:44'),
(46, 8, 'sergio', 'sergio lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:24:30'),
(47, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:24:47'),
(48, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 2 a usuario 4', '0:0:0:0:0:0:0:1', '2026-05-23 22:25:09'),
(49, 1, 'byron', 'Byron Sequen', 'Eliminar', 'Roles', 'Elimino rol 4 de usuario 4', '0:0:0:0:0:0:0:1', '2026-05-23 22:25:19'),
(50, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:25:25'),
(51, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:25:32'),
(52, 8, 'sergio', 'sergio lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:26:42'),
(53, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:27:01'),
(54, 4, 'jose', 'jose lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:27:28'),
(55, 3, 'diaz', 'jhonatan diaz', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:27:42'),
(56, 3, 'diaz', 'jhonatan diaz', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:27:51'),
(57, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:28:01'),
(58, 1, 'byron', 'Byron Sequen', 'Actualizar', 'AsignacionTurno', 'Asignó turno 2 al usuario 8', '0:0:0:0:0:0:0:1', '2026-05-23 22:28:29'),
(59, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:28:36'),
(60, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:29:00'),
(61, 8, 'sergio', 'sergio lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:29:06'),
(62, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:29:13'),
(63, 1, 'byron', 'Byron Sequen', 'Crear', 'Usuarios', 'Creo usuario: edy', '0:0:0:0:0:0:0:1', '2026-05-23 22:30:06'),
(64, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 3 a usuario 9', '0:0:0:0:0:0:0:1', '2026-05-23 22:30:13'),
(65, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:30:17'),
(66, 9, 'edy', 'edy montes', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:30:26'),
(67, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:41:57'),
(68, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:48:23'),
(69, 8, 'sergio', 'sergio lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:48:49'),
(70, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:48:56'),
(71, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:54:52'),
(72, 8, 'sergio', 'sergio lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:54:58'),
(73, 3, 'diaz', 'jhonatan diaz', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:55:07'),
(74, 3, 'diaz', 'jhonatan diaz', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:57:17'),
(75, 3, 'diaz', 'jhonatan diaz', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:57:48'),
(76, 3, 'diaz', 'jhonatan diaz', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:57:57'),
(77, 9, 'edy', 'edy montes', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:58:05'),
(78, 9, 'edy', 'edy montes', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:58:41'),
(79, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:58:51'),
(80, 4, 'jose', 'jose lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:58:57'),
(81, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:59:04'),
(82, 1, 'byron', 'Byron Sequen', 'Crear', 'Roles', 'Asigno rol 4 a usuario 4', '0:0:0:0:0:0:0:1', '2026-05-23 22:59:31'),
(83, 1, 'byron', 'Byron Sequen', 'Eliminar', 'Roles', 'Elimino rol 2 de usuario 4', '0:0:0:0:0:0:0:1', '2026-05-23 22:59:39'),
(84, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:59:42'),
(85, 4, 'jose', 'jose lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 22:59:53'),
(86, 4, 'jose', 'jose lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 22:59:56'),
(87, 8, 'sergio', 'sergio lopez', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:00:06'),
(88, 8, 'sergio', 'sergio lopez', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:06:53'),
(89, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:07:03'),
(90, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Usuarios', 'Creo usuario: jefe1', '0:0:0:0:0:0:0:1', '2026-05-23 23:08:25'),
(91, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Roles', 'Asigno rol 4 a usuario 13', '0:0:0:0:0:0:0:1', '2026-05-23 23:08:33'),
(92, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Usuarios', 'Creo usuario: jefe2', '0:0:0:0:0:0:0:1', '2026-05-23 23:09:37'),
(93, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Roles', 'Asigno rol 4 a usuario 14', '0:0:0:0:0:0:0:1', '2026-05-23 23:09:44'),
(94, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Usuarios', 'Creo usuario: jefe3', '0:0:0:0:0:0:0:1', '2026-05-23 23:10:35'),
(95, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Roles', 'Asigno rol 4 a usuario 15', '0:0:0:0:0:0:0:1', '2026-05-23 23:10:41'),
(96, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Usuarios', 'Creo usuario: emoleado1', '0:0:0:0:0:0:0:1', '2026-05-23 23:11:27'),
(97, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Roles', 'Asigno rol 3 a usuario 16', '0:0:0:0:0:0:0:1', '2026-05-23 23:11:35'),
(98, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Usuarios', 'Creo usuario: emoleado2', '0:0:0:0:0:0:0:1', '2026-05-23 23:12:17'),
(99, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Roles', 'Asigno rol 3 a usuario 17', '0:0:0:0:0:0:0:1', '2026-05-23 23:12:24'),
(100, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Usuarios', 'Creo usuario: emoleado3', '0:0:0:0:0:0:0:1', '2026-05-23 23:13:11'),
(101, 10, 'rrhh1', 'RRHH 1', 'Crear', 'Roles', 'Asigno rol 3 a usuario 18', '0:0:0:0:0:0:0:1', '2026-05-23 23:13:23'),
(102, 10, 'rrhh1', 'RRHH 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:13:27'),
(103, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:15:55'),
(104, 10, 'rrhh1', 'RRHH 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:17:03'),
(105, 16, 'emoleado1', 'empleado1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:17:27'),
(106, 16, 'emoleado1', 'empleado1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:17:46'),
(107, 17, 'emoleado2', 'empleado 2', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:18:32'),
(108, 18, 'emoleado3', 'empleado 3', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:18:53'),
(109, 18, 'emoleado3', 'empleado 3', 'Crear', 'Solicitudes', 'Creo solicitud de permiso', '0:0:0:0:0:0:0:1', '2026-05-23 23:19:33'),
(110, 18, 'emoleado3', 'empleado 3', 'Crear', 'Solicitudes', 'Creo solicitud de permiso', '0:0:0:0:0:0:0:1', '2026-05-23 23:20:24'),
(111, 16, 'emoleado1', 'empleado1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:22:08'),
(112, 18, 'emoleado3', 'empleado 3', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:22:47'),
(113, 17, 'emoleado2', 'empleado 2', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:23:10'),
(114, 17, 'emoleado2', 'empleado 2', 'Crear', 'Solicitudes', 'Creo solicitud de permiso', '0:0:0:0:0:0:0:1', '2026-05-23 23:23:48'),
(115, 17, 'emoleado2', 'empleado 2', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:23:55'),
(116, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:24:05'),
(117, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:24:05'),
(118, 10, 'rrhh1', 'RRHH 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:24:18'),
(119, 13, 'jefe1', 'jefe 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:24:26'),
(120, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:31:19'),
(121, 13, 'jefe1', 'jefe 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:34:35'),
(122, 16, 'emoleado1', 'empleado1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:35:13'),
(123, 16, 'emoleado1', 'empleado1', 'Crear', 'Solicitudes', 'Creo solicitud de permiso', '0:0:0:0:0:0:0:1', '2026-05-23 23:35:41'),
(124, 13, 'jefe1', 'jefe 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:36:58'),
(125, 11, 'rrhh2', 'RRHH 2', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:37:09'),
(126, 16, 'emoleado1', 'empleado1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:38:12'),
(127, 11, 'rrhh2', 'RRHH 2', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:38:23'),
(128, 11, 'rrhh2', 'RRHH 2', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:38:34'),
(129, 13, 'jefe1', 'jefe 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:38:47'),
(130, 13, 'jefe1', 'jefe 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:39:45'),
(131, 15, 'jefe3', 'jefe 3', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:40:01'),
(132, 15, 'jefe3', 'jefe 3', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:40:16'),
(133, 16, 'emoleado1', 'empleado1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:40:33'),
(134, 16, 'emoleado1', 'empleado1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:40:49'),
(135, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:41:19'),
(136, 1, 'byron', 'Byron Sequen', 'Eliminar', 'Roles', 'Elimino rol 4 de usuario 16', '0:0:0:0:0:0:0:1', '2026-05-23 23:41:39'),
(137, 1, 'byron', 'Byron Sequen', 'Actualizar', 'Usuarios', 'Actualizo usuario ID: 16', '0:0:0:0:0:0:0:1', '2026-05-23 23:42:39'),
(138, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:42:45'),
(139, 14, 'jefe2', 'jefe 2', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:43:03'),
(140, 14, 'jefe2', 'jefe 2', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:43:16'),
(141, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:43:27'),
(142, 10, 'rrhh1', 'RRHH 1', 'Rechazar', 'Solicitudes', 'Rechazo (RRHH) solicitud #13', '0:0:0:0:0:0:0:1', '2026-05-23 23:43:50'),
(143, 10, 'rrhh1', 'RRHH 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-23 23:43:54'),
(144, 11, 'rrhh2', 'RRHH 2', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-23 23:44:47'),
(145, 11, 'rrhh2', 'RRHH 2', 'Actualizar', 'Usuarios', 'Actualizo usuario ID: 16', '0:0:0:0:0:0:0:1', '2026-05-23 23:45:16'),
(146, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-26 23:38:24'),
(147, 1, 'byron', 'Byron Sequen', 'Crear', 'Usuarios', 'Creo usuario: lucia', '0:0:0:0:0:0:0:1', '2026-05-26 23:40:52'),
(148, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-27 02:19:54'),
(149, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-27 02:27:00'),
(150, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-27 02:31:48'),
(151, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-27 03:24:00'),
(152, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-27 03:28:52'),
(153, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-27 03:44:33'),
(154, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-28 03:48:05'),
(155, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-28 23:41:39'),
(156, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-29 04:47:04'),
(157, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-29 05:06:56'),
(158, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-29 23:29:17'),
(159, 1, 'byron', 'Byron Sequen', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-29 23:29:46'),
(160, 13, 'jefe1', 'jefe 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-29 23:29:58'),
(161, 13, 'jefe1', 'jefe 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-29 23:30:14'),
(162, 10, 'rrhh1', 'RRHH 1', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-29 23:30:24'),
(163, 10, 'rrhh1', 'RRHH 1', 'Logout', 'Autenticacion', 'Cierre de sesión', '0:0:0:0:0:0:0:1', '2026-05-29 23:30:34'),
(164, 1, 'byron', 'Byron Sequen', 'Login', 'Autenticacion', 'Inicio de sesión exitoso', '0:0:0:0:0:0:0:1', '2026-05-29 23:47:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_cambios`
--

DROP TABLE IF EXISTS `historial_cambios`;
CREATE TABLE IF NOT EXISTS `historial_cambios` (
  `id_historial` int(11) NOT NULL AUTO_INCREMENT,
  `tabla` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_registro` int(11) DEFAULT NULL,
  `tipo_cambio` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_nuevo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `id_usuario_cambio` int(11) DEFAULT NULL,
  `nombre_usuario_cambio` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historial`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcajes`
--

DROP TABLE IF EXISTS `marcajes`;
CREATE TABLE IF NOT EXISTS `marcajes` (
  `id_marcaje` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora_entrada` time DEFAULT NULL,
  `hora_inicio_break` time DEFAULT NULL,
  `hora_fin_break` time DEFAULT NULL,
  `hora_inicio_lonch` time DEFAULT NULL,
  `hora_fin_lonch` time DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `entrada_tarde` tinyint(1) DEFAULT '0',
  `ip_marcaje` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dispositivo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_marcaje`),
  UNIQUE KEY `uq_marcaje_dia` (`id_usuario`,`fecha`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `marcajes`
--

INSERT INTO `marcajes` (`id_marcaje`, `id_usuario`, `fecha`, `hora_entrada`, `hora_inicio_break`, `hora_fin_break`, `hora_inicio_lonch`, `hora_fin_lonch`, `hora_salida`, `entrada_tarde`, `ip_marcaje`, `dispositivo`, `created_at`) VALUES
(5, 6, '2026-05-22', '21:57:31', '21:59:52', '22:17:15', '22:17:24', '22:17:30', '22:17:40', 0, '0:0:0:0:0:0:0:1', NULL, '2026-05-23 03:57:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`, `descripcion`, `created_at`) VALUES
(1, 'AdminRRHH', 'Administrador de Recursos Humanos', '2026-05-07 03:10:30'),
(2, 'AdminArea', 'Administrador de área', '2026-05-07 03:10:30'),
(3, 'Empleado', 'Empleado general', '2026-05-07 03:10:30'),
(4, 'JefeArea', 'Jefe de área', '2026-05-07 03:10:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

DROP TABLE IF EXISTS `solicitudes`;
CREATE TABLE IF NOT EXISTS `solicitudes` (
  `id_solicitud` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario_solicitante` int(11) NOT NULL,
  `id_tipo_solicitud` int(11) NOT NULL,
  `motivo` varchar(255) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `justificacion` text,
  `estado_aprobacion` enum('PendienteJefe','PendienteRRHH','AprobadaJefe','RechazadaJefe','AprobadaRRHH','RechazadaRRHH') DEFAULT 'PendienteJefe',
  `fecha_solicitud` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_jefe_area` int(11) DEFAULT NULL,
  `comentario_jefe` text,
  `fecha_aprobacion_jefe` datetime DEFAULT NULL,
  `id_admin_rrhh_aprobador` int(11) DEFAULT NULL,
  `comentario_aprobacion_rrhh` text,
  `fecha_aprobacion_rrhh` datetime DEFAULT NULL,
  PRIMARY KEY (`id_solicitud`),
  KEY `fk_sol_usuario` (`id_usuario_solicitante`),
  KEY `fk_sol_tipo` (`id_tipo_solicitud`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`id_solicitud`, `id_usuario_solicitante`, `id_tipo_solicitud`, `motivo`, `fecha_inicio`, `fecha_fin`, `justificacion`, `estado_aprobacion`, `fecha_solicitud`, `id_jefe_area`, `comentario_jefe`, `fecha_aprobacion_jefe`, `id_admin_rrhh_aprobador`, `comentario_aprobacion_rrhh`, `fecha_aprobacion_rrhh`) VALUES
(1, 1, 1, 'Prueba de sistema', '2026-05-15', '2026-05-20', NULL, 'AprobadaRRHH', '2026-05-11 17:32:05', NULL, NULL, NULL, 1, ' ', '2026-05-16 11:59:58'),
(3, 1, 6, 'cumplo 27', '2026-05-15', '2026-05-15', ' ', 'RechazadaRRHH', '2026-05-13 19:14:08', NULL, NULL, NULL, 1, ' ', '2026-05-13 19:14:23'),
(8, 4, 3, '                        me siento mal', '2026-05-23', '2026-05-23', '                        ', 'AprobadaRRHH', '2026-05-22 21:48:54', NULL, NULL, NULL, 6, '                        ', '2026-05-23 16:16:56'),
(9, 4, 3, '                        me siento muy mal', '2026-05-24', '2026-05-24', '                        ', 'AprobadaRRHH', '2026-05-23 16:15:52', NULL, NULL, NULL, 6, '                        ', '2026-05-23 16:17:09'),
(10, 18, 3, '                        cita medica', '2026-05-26', '2026-05-26', '                        ', 'PendienteJefe', '2026-05-23 17:19:33', 16, NULL, NULL, NULL, NULL, NULL),
(11, 18, 2, '                        vaciones por cancancio', '2026-05-25', '2026-05-31', '                        ', 'PendienteJefe', '2026-05-23 17:20:24', 16, NULL, NULL, NULL, NULL, NULL),
(12, 17, 6, '                        cumplo23', '2026-05-27', '2026-05-27', '                        ', 'PendienteJefe', '2026-05-23 17:23:48', 16, NULL, NULL, NULL, NULL, NULL),
(13, 16, 6, '                        cumplo22', '2026-05-26', '2026-05-26', '                        ', 'RechazadaRRHH', '2026-05-23 17:35:41', NULL, NULL, NULL, 10, '                        ', '2026-05-23 17:43:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_solicitud`
--

DROP TABLE IF EXISTS `tipos_solicitud`;
CREATE TABLE IF NOT EXISTS `tipos_solicitud` (
  `id_tipo_solicitud` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_tipo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requiere_aprobacion_rrhh` tinyint(1) DEFAULT '1',
  `dias_maximos` int(11) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_solicitud`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `tipos_solicitud`
--

INSERT INTO `tipos_solicitud` (`id_tipo_solicitud`, `nombre_tipo`, `descripcion`, `requiere_aprobacion_rrhh`, `dias_maximos`, `created_at`) VALUES
(1, 'Permiso Personal', 'Permiso por asunto personal', 1, 3, '2026-05-07 03:10:30'),
(2, 'Vacaciones', 'Período de vacaciones', 1, 15, '2026-05-07 03:10:30'),
(3, 'Citas IGSS', 'Citas médicas IGSS', 1, 1, '2026-05-07 03:10:30'),
(4, 'Cambio de Turno', 'Solicitud cambio de turno', 1, 0, '2026-05-07 03:10:30'),
(5, 'Cambio de Área', 'Solicitud cambio de área', 1, 0, '2026-05-07 03:10:30'),
(6, 'Licencia Cumpleaños', 'Día libre por cumpleaños', 0, 1, '2026-05-07 03:10:30'),
(7, 'Permiso Maternidad', 'Licencia por maternidad', 1, 84, '2026-05-07 03:10:30'),
(8, 'Permiso Paternidad', 'Licencia por paternidad', 1, 2, '2026-05-07 03:10:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turnos`
--

DROP TABLE IF EXISTS `turnos`;
CREATE TABLE IF NOT EXISTS `turnos` (
  `id_turno` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_turno` varchar(100) NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_turno`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `turnos`
--

INSERT INTO `turnos` (`id_turno`, `nombre_turno`, `hora_inicio`, `hora_fin`, `descripcion`, `estado`, `created_at`) VALUES
(1, 'Matutino', '07:00:00', '15:00:00', 'Turno de manana 7:00am - 3:00pm', 1, '2026-05-10 06:16:49'),
(2, 'Vespertino', '15:00:00', '23:00:00', 'Turno de tarde 3:00pm - 11:00pm', 1, '2026-05-10 06:16:49'),
(3, 'Nocturno', '23:00:00', '07:00:00', 'Turno de noche 11:00pm - 7:00am', 1, '2026-05-16 03:27:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `dpi` varchar(13) NOT NULL,
  `nombre_completo` varchar(150) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `id_area` int(11) DEFAULT NULL,
  `id_turno_actual` int(11) DEFAULT NULL,
  `id_jefe_area` int(11) DEFAULT NULL,
  `es_jefe_area` tinyint(1) DEFAULT '0',
  `estado` enum('Activo','Inactivo') DEFAULT 'Activo',
  `motivo_inactivacion` varchar(255) DEFAULT NULL,
  `fecha_inactivacion` datetime DEFAULT NULL,
  `intentos_fallidos` int(11) DEFAULT '0',
  `ultimo_acceso` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `dpi` (`dpi`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_usuario_area` (`id_area`),
  KEY `fk_usuario_turno` (`id_turno_actual`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `dpi`, `nombre_completo`, `username`, `password`, `email`, `id_area`, `id_turno_actual`, `id_jefe_area`, `es_jefe_area`, `estado`, `motivo_inactivacion`, `fecha_inactivacion`, `intentos_fallidos`, `ultimo_acceso`, `created_at`) VALUES
(1, '1234567890123', 'Byron Sequen', 'byron', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 3, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-29 17:47:12', '2026-05-10 06:50:08'),
(2, '1456651566511', 'mario garcia', 'mario', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 8, 1, NULL, 0, 'Activo', NULL, NULL, 0, NULL, '2026-05-23 03:37:32'),
(3, '1234567891011', 'jhonatan diaz', 'diaz', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 8, 2, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 16:57:48', '2026-05-23 03:38:58'),
(4, '9876543210999', 'jose lopez', 'jose', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 8, 3, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 16:59:52', '2026-05-23 03:40:52'),
(5, '1111111111111', 'maria gomez', 'maria', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com.com', 3, 2, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-22 21:47:41', '2026-05-23 03:47:20'),
(6, '2222222222222', 'marlon quiñones', 'marlon', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 3, 3, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 16:16:44', '2026-05-23 03:56:03'),
(7, '3333333333333', 'maritza perez', 'perez', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 9, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 16:11:35', '2026-05-23 04:24:54'),
(8, '8888888888888', 'sergio lopez', 'sergio', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 10, 2, NULL, 0, 'Activo', NULL, NULL, 0, '2026-05-23 17:00:05', '2026-05-23 22:18:32'),
(9, '7897897897897', 'edy montes', 'edy', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 10, 2, NULL, 0, 'Activo', NULL, NULL, 0, '2026-05-23 16:58:05', '2026-05-23 22:30:03'),
(10, '111111111223', 'RRHH 1', 'rrhh1', '3f8d8407cee19572a8b3b17fb0779a19', 'esenio22@gmail.com', 3, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-29 17:30:24', '2026-05-23 23:06:45'),
(11, '1122222222222', 'RRHH 2', 'rrhh2', '3f8d8407cee19572a8b3b17fb0779a19', 'edy.ramirezc@gmail.com', 3, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 17:44:47', '2026-05-23 23:06:45'),
(12, '4171471470147', 'RRHH 1', 'rrhh3', '46d46a91d3e07f2015aa35fe8bb1c7c7', 'eramirezc30@miumg.edu.gt\r\n', 3, 1, NULL, 1, 'Activo', NULL, NULL, 0, NULL, '2026-05-23 23:06:46'),
(13, '852085208520', 'jefe 1', 'jefe1', '3f8d8407cee19572a8b3b17fb0779a19', 'eramirezc30@miumg.edu.gt', 4, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-29 17:29:58', '2026-05-23 23:08:22'),
(14, '9630963096309', 'jefe 2', 'jefe2', '3f8d8407cee19572a8b3b17fb0779a19', 'edy.ramirezc@gmail.com', 4, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 17:43:03', '2026-05-23 23:09:35'),
(15, '7894567894567', 'jefe 3', 'jefe3', '3f8d8407cee19572a8b3b17fb0779a19', 'esenio22@gmail.com', 4, 1, NULL, 1, 'Activo', NULL, NULL, 0, '2026-05-23 17:40:01', '2026-05-23 23:10:27'),
(16, '1234561230123', 'empleado 1', 'emoleado1', '3f8d8407cee19572a8b3b17fb0779a19', 'esenio22@gmail.com', 19, 1, NULL, 0, 'Activo', '', NULL, 0, '2026-05-23 17:40:33', '2026-05-23 23:11:24'),
(17, '7419630741963', 'empleado 2', 'emoleado2', '3f8d8407cee19572a8b3b17fb0779a19', 'esenio22@gmail.com', 19, 1, 16, 0, 'Activo', NULL, NULL, 0, '2026-05-23 17:23:10', '2026-05-23 23:12:14'),
(18, '0000000000123', 'empleado 3', 'emoleado3', '3f8d8407cee19572a8b3b17fb0779a19', 'eramirezc30@miumg.edu.gt', 19, 1, 16, 0, 'Activo', NULL, NULL, 0, '2026-05-23 17:22:47', '2026-05-23 23:13:09'),
(19, '1230000000123', 'lucia mendez', 'lucia', '3f8d8407cee19572a8b3b17fb0779a19', 'albertosequeb@gmail.com', 19, 1, 13, 0, 'Activo', NULL, NULL, 0, NULL, '2026-05-26 23:40:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_roles`
--

DROP TABLE IF EXISTS `usuario_roles`;
CREATE TABLE IF NOT EXISTS `usuario_roles` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_rol`),
  KEY `fk_ur_rol` (`id_rol`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario_roles`
--

INSERT INTO `usuario_roles` (`id_usuario`, `id_rol`) VALUES
(1, 1),
(2, 4),
(3, 4),
(4, 4),
(5, 1),
(6, 1),
(7, 4),
(8, 3),
(9, 3),
(10, 1),
(11, 1),
(12, 1),
(13, 4),
(14, 4),
(15, 4),
(16, 3),
(17, 3),
(18, 3),
(19, 3);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`),
  ADD CONSTRAINT `fk_usuario_turno` FOREIGN KEY (`id_turno_actual`) REFERENCES `turnos` (`id_turno`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
