package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // ================================================================
    // AUTENTICACIÓN
    // ================================================================

    public Usuario autenticar(String username, String password) {
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "WHERE u.username = ? AND u.password = MD5(?) AND u.estado = 'Activo'";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario u = mapear(rs);
                u.setRoles(obtenerRoles(u.getIdUsuario()));
                resetIntentos(u.getIdUsuario());
                return u;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void incrementarIntentos(String username) {
        String sql = "UPDATE usuarios SET intentos_fallidos = intentos_fallidos + 1 WHERE username = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void resetIntentos(int idUsuario) {
        String sql = "UPDATE usuarios SET intentos_fallidos = 0, ultimo_acceso = NOW() WHERE id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int obtenerIntentos(String username) {
        String sql = "SELECT intentos_fallidos FROM usuarios WHERE username = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ================================================================
    // LISTAR
    // ================================================================

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "ORDER BY u.nombre_completo";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = mapear(rs);
                u.setRoles(obtenerRoles(u.getIdUsuario()));
                lista.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Usuario> listarActivos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "WHERE u.estado = 'Activo' ORDER BY u.nombre_completo";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { lista.add(mapear(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Usuario> listarPorArea(int idArea) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "WHERE u.id_area = ? AND u.estado = 'Activo' " +
                     "ORDER BY u.nombre_completo";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idArea);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { lista.add(mapear(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    /**
     * Lista los empleados asignados a un jefe específico.
     * Relación 1 a 1: un empleado tiene exactamente un jefe (id_jefe_area).
     */
    public List<Usuario> listarPorJefe(int idJefe) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "WHERE u.id_jefe_area = ? " +
                     "AND u.es_jefe_area = 0 " +
                     "AND u.estado = 'Activo' " +
                     "ORDER BY u.nombre_completo";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idJefe);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = mapear(rs);
                u.setRoles(obtenerRoles(u.getIdUsuario()));
                lista.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // ================================================================
    // CRUD
    // ================================================================

    public Usuario obtenerPorId(int id) {
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "WHERE u.id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario u = mapear(rs);
                u.setRoles(obtenerRoles(u.getIdUsuario()));
                return u;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Inserta el usuario y devuelve el ID generado (o -1 si falla).
     */
    public int insertarYObtenerID(Usuario u) {
        String sql = "INSERT INTO usuarios " +
                     "(dpi, nombre_completo, username, password, email, " +
                     "id_area, id_turno_actual, id_jefe_area, es_jefe_area, estado) " +
                     "VALUES (?, ?, ?, MD5(?), ?, ?, ?, ?, ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getDpi());
            ps.setString(2, u.getNombreCompleto());
            ps.setString(3, u.getUsername());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getEmail());
            ps.setInt(6, u.getIdArea());
            ps.setInt(7, u.getIdTurnoActual());
            if (!u.isEsJefeArea() && u.getIdJefeArea() > 0) {
                ps.setInt(8, u.getIdJefeArea());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            ps.setBoolean(9, u.isEsJefeArea());
            ps.setString(10, u.getEstado() != null ? u.getEstado() : "Activo");
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    // Mantener insertar() por compatibilidad con código existente
    public boolean insertar(Usuario u) {
        return insertarYObtenerID(u) > 0;
    }

    public boolean actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET " +
                     "dpi=?, nombre_completo=?, email=?, id_area=?, " +
                     "id_turno_actual=?, id_jefe_area=?, es_jefe_area=?, " +
                     "estado=?, motivo_inactivacion=? " +
                     "WHERE id_usuario=?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getDpi());
            ps.setString(2, u.getNombreCompleto());
            ps.setString(3, u.getEmail());
            ps.setInt(4, u.getIdArea());
            ps.setInt(5, u.getIdTurnoActual());
            if (!u.isEsJefeArea() && u.getIdJefeArea() > 0) {
                ps.setInt(6, u.getIdJefeArea());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setBoolean(7, u.isEsJefeArea());
            ps.setString(8, u.getEstado());
            ps.setString(9, u.getMotivoInactivacion());
            ps.setInt(10, u.getIdUsuario());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean cambiarPassword(int idUsuario, String nuevaPassword) {
        String sql = "UPDATE usuarios SET password = MD5(?) WHERE id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, nuevaPassword);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ================================================================
    // ROLES
    // ================================================================

    public List<String> obtenerRoles(int idUsuario) {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT r.nombre_rol FROM roles r " +
                     "INNER JOIN usuario_roles ur ON r.id_rol = ur.id_rol " +
                     "WHERE ur.id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) roles.add(rs.getString(1));
        } catch (SQLException e) { e.printStackTrace(); }
        return roles;
    }

    public boolean asignarRol(int idUsuario, int idRol) {
        String sql = "INSERT IGNORE INTO usuario_roles (id_usuario, id_rol) VALUES (?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idRol);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean eliminarRol(int idUsuario, int idRol) {
        String sql = "DELETE FROM usuario_roles WHERE id_usuario=? AND id_rol=?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idRol);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Elimina todos los roles del usuario para reasignar desde cero.
     */
    public void limpiarRoles(int idUsuario) {
        String sql = "DELETE FROM usuario_roles WHERE id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // ================================================================
    // LÓGICA DE ÁREAS Y JEFES
    // ================================================================

    /**
     * Determina si un área es de jefatura (es_jefatura = 1).
     * Contabilidad → es_jefatura=1 → jefe
     * Contabilidad Empleado → es_jefatura=0 → empleado
     */
    public boolean esAreaDeJefatura(int idArea) {
        String sql = "SELECT es_jefatura FROM areas WHERE id_area = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idArea);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 1;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Devuelve el id del primer jefe activo del área padre del área dada,
     * en el turno indicado. Si el área ya es de jefatura, busca en ella misma.
     */
    public int obtenerJefePorAreaYTurno(int idArea, int idTurno) {
        String sql = "SELECT u.id_usuario FROM usuarios u " +
                     "JOIN areas a ON u.id_area = a.id_area " +
                     "WHERE u.es_jefe_area = 1 " +
                     "AND u.estado = 'Activo' " +
                     "AND u.id_turno_actual = ? " +
                     "AND ( " +
                     "    u.id_area = (SELECT id_area_padre FROM areas WHERE id_area = ?) " +
                     "    OR u.id_area = ? " +
                     ") " +
                     "LIMIT 1";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idTurno);
            ps.setInt(2, idArea);
            ps.setInt(3, idArea);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Lista todos los jefes disponibles para un empleado de cierta área y turno.
     * Busca jefes cuyo id_area sea el área padre del área del empleado,
     * en el mismo turno. Usado para el dropdown dinámico en el JSP.
     */
    public List<Usuario> listarJefesPorAreaYTurno(int idArea, int idTurno) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios u " +
                     "LEFT JOIN areas a ON u.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON u.id_turno_actual = t.id_turno " +
                     "WHERE u.es_jefe_area = 1 " +
                     "AND u.estado = 'Activo' " +
                     "AND u.id_turno_actual = ? " +
                     "AND ( " +
                     "    u.id_area = (SELECT id_area_padre FROM areas WHERE id_area = ?) " +
                     "    OR u.id_area = ? " +
                     ") " +
                     "ORDER BY u.nombre_completo";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idTurno);
            ps.setInt(2, idArea);
            ps.setInt(3, idArea);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    /**
     * Obtiene el jefe actual de un empleado (para mostrarlo en su menú/dashboard).
     */
    public Usuario obtenerJefeDeEmpleado(int idEmpleado) {
        String sql = "SELECT j.*, a.nombre_area, t.nombre_turno " +
                     "FROM usuarios e " +
                     "JOIN usuarios j ON e.id_jefe_area = j.id_usuario " +
                     "LEFT JOIN areas a ON j.id_area = a.id_area " +
                     "LEFT JOIN turnos t ON j.id_turno_actual = t.id_turno " +
                     "WHERE e.id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idEmpleado);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ================================================================
    // VERIFICACIONES
    // ================================================================

    public boolean existeUsername(String username) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE username = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existeDpi(String dpi) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE dpi = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, dpi);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean esJefeArea(int idUsuario) {
        String sql = "SELECT es_jefe_area FROM usuarios WHERE id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 1;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean tieneRol(int idUsuario, String nombreRol) {
        String sql = "SELECT COUNT(*) FROM usuario_roles ur " +
                     "INNER JOIN roles r ON ur.id_rol = r.id_rol " +
                     "WHERE ur.id_usuario = ? AND r.nombre_rol = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, nombreRol);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ================================================================
    // MAPEO
    // ================================================================

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setDpi(rs.getString("dpi"));
        u.setNombreCompleto(rs.getString("nombre_completo"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setIdArea(rs.getInt("id_area"));
        u.setIdTurnoActual(rs.getInt("id_turno_actual"));
        u.setIdJefeArea(rs.getInt("id_jefe_area"));
        u.setEsJefeArea(rs.getInt("es_jefe_area") == 1);
        u.setEstado(rs.getString("estado"));
        u.setMotivoInactivacion(rs.getString("motivo_inactivacion"));
        u.setIntentosFallidos(rs.getInt("intentos_fallidos"));
        try { u.setNombreArea(rs.getString("nombre_area")); }
        catch (SQLException ignored) {}
        try { u.setNombreTurno(rs.getString("nombre_turno")); }
        catch (SQLException ignored) {}
        return u;
    }
}