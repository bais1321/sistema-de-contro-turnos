package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.Solicitud;
import com.turnos.modelo.TipoSolicitud;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SolicitudDAO {

    // ── INSERTAR ──────────────────────────────────────────────────────────────

    public boolean insertar(Solicitud s) {
        // Lógica: si el solicitante es jefe de área (no tiene id_jefe_area)
        // va directo a RRHH. Si es empleado normal, va primero al jefe.
        String estadoInicial = (s.getIdJefeArea() <= 0)
                ? "PendienteRRHH"   // jefe sin jefe → va directo a RRHH
                : "PendienteJefe";  // empleado normal → va al jefe primero

        String sql = "INSERT INTO solicitudes " +
                     "(id_usuario_solicitante, id_tipo_solicitud, motivo, " +
                     "fecha_inicio, fecha_fin, justificacion, estado_aprobacion, id_jefe_area) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, s.getIdUsuarioSolicitante());
            ps.setInt(2, s.getIdTipoSolicitud());
            ps.setString(3, s.getMotivo());
            ps.setString(4, s.getFechaInicio());
            ps.setString(5, s.getFechaFin());
            ps.setString(6, s.getJustificacion());
            ps.setString(7, estadoInicial);
            if (s.getIdJefeArea() > 0)
                ps.setInt(8, s.getIdJefeArea());
            else
                ps.setNull(8, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── LISTAR ────────────────────────────────────────────────────────────────

    /** Mis solicitudes (empleado ve las propias) */
    public List<Solicitud> listarPorUsuario(int idUsuario) {
        String sql = BASE_SQL() +
                     "WHERE s.id_usuario_solicitante = ? " +
                     "ORDER BY s.fecha_solicitud DESC";
        return ejecutar(sql, ps -> ps.setInt(1, idUsuario));
    }

    /** Pendientes para el jefe:
     *  solicitudes de empleados que tienen este jefe asignado */
    /**
 * Lista solicitudes pendientes para el jefe.
 * Busca por área y turno del jefe para que todos los jefes
 * del mismo área/turno vean las mismas solicitudes.
 */
public List<Solicitud> listarPendientesParaJefe(int idJefe) {
    // Obtener área y turno del jefe
    int idArea  = 0;
    int idTurno = 0;
    String sqlJefe = "SELECT id_area, id_turno_actual " +
                     "FROM usuarios WHERE id_usuario = ?";
    try (Connection c = Conexion.getConexion();
         PreparedStatement ps = c.prepareStatement(sqlJefe)) {
        ps.setInt(1, idJefe);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            idArea  = rs.getInt("id_area");
            idTurno = rs.getInt("id_turno_actual");
        }
    } catch (SQLException e) { e.printStackTrace(); }

    if (idArea == 0) return new ArrayList<>();

    // Solicitudes pendientes de empleados del mismo área y turno
    String sql = BASE_SQL() +
             "WHERE s.estado_aprobacion = 'PendienteJefe' " +
             "AND a.id_area_padre = ? " +
             "AND u.id_turno_actual = ? " +
             "AND u.es_jefe_area = 0 " +
             "ORDER BY s.fecha_solicitud ASC";
final int areaFinal  = idArea;
final int turnoFinal = idTurno;
return ejecutar(sql, ps -> {
    ps.setInt(1, areaFinal);
    ps.setInt(2, turnoFinal);
});
}

    /** Pendientes para RRHH:
     *  AprobadaJefe O PendienteRRHH (jefes sin jefe que van directo) */
    public List<Solicitud> listarPendientesRRHH() {
        String sql = BASE_SQL() +
                     "WHERE s.estado_aprobacion IN ('AprobadaJefe','PendienteRRHH') " +
                     "ORDER BY s.fecha_solicitud ASC";
        return ejecutar(sql, ps -> {});
    }

    /** Todas las solicitudes (vista admin) */
    public List<Solicitud> listarTodas() {
        String sql = BASE_SQL() + "ORDER BY s.fecha_solicitud DESC";
        return ejecutar(sql, ps -> {});
    }

    public Solicitud obtenerPorId(int id) {
        List<Solicitud> r = ejecutar(BASE_SQL() + "WHERE s.id_solicitud = ?",
                ps -> ps.setInt(1, id));
        return r.isEmpty() ? null : r.get(0);
    }

    public String obtenerEmailSolicitante(int idSolicitud) {
        String sql = "SELECT u.email FROM solicitudes s " +
                     "INNER JOIN usuarios u ON s.id_usuario_solicitante = u.id_usuario " +
                     "WHERE s.id_solicitud = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idSolicitud);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ── APROBAR / RECHAZAR JEFE ───────────────────────────────────────────────

    public boolean aprobarJefe(int idSolicitud, int idJefe, String comentario) {
        String sql = "UPDATE solicitudes " +
                     "SET estado_aprobacion='AprobadaJefe', " +
                     "id_jefe_area=?, fecha_aprobacion_jefe=NOW(), comentario_jefe=? " +
                     "WHERE id_solicitud=? AND estado_aprobacion='PendienteJefe'";
        return update(sql, ps -> {
            ps.setInt(1, idJefe);
            ps.setString(2, comentario);
            ps.setInt(3, idSolicitud);
        });
    }

    public boolean rechazarJefe(int idSolicitud, int idJefe, String comentario) {
        String sql = "UPDATE solicitudes " +
                     "SET estado_aprobacion='RechazadaJefe', " +
                     "id_jefe_area=?, fecha_aprobacion_jefe=NOW(), comentario_jefe=? " +
                     "WHERE id_solicitud=? AND estado_aprobacion='PendienteJefe'";
        return update(sql, ps -> {
            ps.setInt(1, idJefe);
            ps.setString(2, comentario);
            ps.setInt(3, idSolicitud);
        });
    }

    // ── APROBAR / RECHAZAR RRHH ───────────────────────────────────────────────

    public boolean aprobarRRHH(int idSolicitud, int idRrhh, String comentario) {
        String sql = "UPDATE solicitudes " +
                     "SET estado_aprobacion='AprobadaRRHH', " +
                     "id_admin_rrhh_aprobador=?, " +
                     "fecha_aprobacion_rrhh=NOW(), " +
                     "comentario_aprobacion_rrhh=? " +
                     "WHERE id_solicitud=? " +
                     "AND estado_aprobacion IN ('AprobadaJefe','PendienteRRHH')";
        return update(sql, ps -> {
            ps.setInt(1, idRrhh);
            ps.setString(2, comentario);
            ps.setInt(3, idSolicitud);
        });
    }

    public boolean rechazarRRHH(int idSolicitud, int idRrhh, String comentario) {
        String sql = "UPDATE solicitudes " +
                     "SET estado_aprobacion='RechazadaRRHH', " +
                     "id_admin_rrhh_aprobador=?, " +
                     "fecha_aprobacion_rrhh=NOW(), " +
                     "comentario_aprobacion_rrhh=? " +
                     "WHERE id_solicitud=? " +
                     "AND estado_aprobacion IN ('AprobadaJefe','PendienteRRHH')";
        return update(sql, ps -> {
            ps.setInt(1, idRrhh);
            ps.setString(2, comentario);
            ps.setInt(3, idSolicitud);
        });
    }

    // ── TIPOS ─────────────────────────────────────────────────────────────────

    public List<TipoSolicitud> listarTipos() {
    List<TipoSolicitud> lista = new ArrayList<>();
    String sql = "SELECT * FROM tipos_solicitud ORDER BY nombre_tipo";
    try (Connection c = Conexion.getConexion();
         PreparedStatement ps = c.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            TipoSolicitud t = new TipoSolicitud();
            t.setIdTipoSolicitud(rs.getInt("id_tipo_solicitud"));
            t.setNombreTipo(rs.getString("nombre_tipo"));
            t.setDiasMaximos(rs.getInt("dias_maximos"));
            lista.add(t);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return lista;
}

    // ── HELPERS ───────────────────────────────────────────────────────────────

    private String BASE_SQL() {
        return "SELECT s.*, " +
               "u.nombre_completo, u.email AS email_solicitante, u.username, " +
               "u.id_jefe_area AS id_jefe_del_usuario, " +
               "a.nombre_area, t.nombre_turno, " +
               "ts.nombre_tipo, " +
               "uj.nombre_completo AS nombre_jefe, " +
               "ur.nombre_completo AS nombre_rrhh, " +
               "DATEDIFF(s.fecha_fin, s.fecha_inicio)+1 AS dias_solicitados " +
               "FROM solicitudes s " +
               "INNER JOIN usuarios u  ON s.id_usuario_solicitante = u.id_usuario " +
               "LEFT JOIN  areas a     ON u.id_area = a.id_area " +
               "LEFT JOIN  turnos t    ON u.id_turno_actual = t.id_turno " +
               "LEFT JOIN  tipos_solicitud ts ON s.id_tipo_solicitud = ts.id_tipo_solicitud " +
               "LEFT JOIN  usuarios uj ON s.id_jefe_area = uj.id_usuario " +
               "LEFT JOIN  usuarios ur ON s.id_admin_rrhh_aprobador = ur.id_usuario ";
    }

    @FunctionalInterface
    interface Setter { void set(PreparedStatement ps) throws SQLException; }

    private List<Solicitud> ejecutar(String sql, Setter setter) {
        List<Solicitud> lista = new ArrayList<>();
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setter.set(ps);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    private boolean update(String sql, Setter setter) {
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            setter.set(ps);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Solicitud mapear(ResultSet rs) throws SQLException {
        Solicitud s = new Solicitud();
        s.setIdSolicitud(rs.getInt("id_solicitud"));
        s.setIdUsuarioSolicitante(rs.getInt("id_usuario_solicitante"));
        s.setIdTipoSolicitud(rs.getInt("id_tipo_solicitud"));
        s.setMotivo(rs.getString("motivo"));
        s.setFechaInicio(rs.getString("fecha_inicio"));
        s.setFechaFin(rs.getString("fecha_fin"));
        s.setJustificacion(rs.getString("justificacion"));
        s.setEstadoAprobacion(rs.getString("estado_aprobacion"));
        s.setFechaSolicitud(rs.getString("fecha_solicitud"));
        s.setIdJefeArea(rs.getInt("id_jefe_area"));
        s.setComentarioJefe(rs.getString("comentario_jefe"));
        s.setFechaAprobacionJefe(rs.getString("fecha_aprobacion_jefe"));
        s.setIdAdminRrhhAprobador(rs.getInt("id_admin_rrhh_aprobador"));
        s.setComentarioAprobacionRrhh(rs.getString("comentario_aprobacion_rrhh"));
        s.setFechaAprobacionRrhh(rs.getString("fecha_aprobacion_rrhh"));
        s.setNombreSolicitante(rs.getString("nombre_completo"));
        s.setEmailSolicitante(rs.getString("email_solicitante"));
        s.setUsernameSolicitante(rs.getString("username"));
        s.setAreaSolicitante(rs.getString("nombre_area"));
        s.setTurnoSolicitante(rs.getString("nombre_turno"));
        s.setNombreTipoSolicitud(rs.getString("nombre_tipo"));
        s.setNombreJefeArea(rs.getString("nombre_jefe"));
        s.setNombreAdminRrhh(rs.getString("nombre_rrhh"));
        try { s.setDiasSolicitados(rs.getInt("dias_solicitados")); }
        catch (SQLException ignored) {}
        return s;
    }
}