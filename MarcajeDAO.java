package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.Marcaje;
import com.turnos.modelo.Turno;

import java.sql.*;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class MarcajeDAO {

    private static final int MAX_BREAK_MIN = 15;
    private static final int MAX_LONCH_MIN = 60;

    // ── OBTENER HOY ──────────────────────────────────────────────
    public Marcaje obtenerHoy(int idUsuario) {
        String sql = BASE_SQL() +
                     "WHERE m.id_usuario = ? AND m.fecha = CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ── YA MARCADO HOY ───────────────────────────────────────────
    public boolean yaMarcadoHoy(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM marcajes " +
                     "WHERE id_usuario=? AND fecha=CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── MARCAR ENTRADA ───────────────────────────────────────────
    public boolean marcarEntrada(int idUsuario, String ip) {
        // Verificar si llego tarde
        boolean tarde = false;
        String sqlTurno = "SELECT t.hora_inicio FROM turnos t " +
                          "INNER JOIN usuarios u ON u.id_turno_actual=t.id_turno " +
                          "WHERE u.id_usuario=?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sqlTurno)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                LocalTime horaInicio = rs.getTime(1).toLocalTime();
                tarde = LocalTime.now().isAfter(horaInicio);
            }
        } catch (Exception e) { e.printStackTrace(); }

        String sql = "INSERT INTO marcajes (id_usuario, fecha, " +
                     "hora_entrada, entrada_tarde, ip_marcaje) " +
                     "VALUES (?, CURDATE(), NOW(), ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setBoolean(2, tarde);
            ps.setString(3, ip);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ── INICIO BREAK ─────────────────────────────────────────────
    public String marcarInicioBreak(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraEntrada() == null)
            return "ERROR:Primero registra tu entrada.";
        if (m.getHoraInicioBreak() != null)
            return "ERROR:Ya registraste el inicio de break hoy.";

        String sql = "UPDATE marcajes SET hora_inicio_break=NOW() " +
                     "WHERE id_usuario=? AND fecha=CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            return "OK:Break iniciado. Tienes " + MAX_BREAK_MIN + " minutos.";
        } catch (SQLException e) { e.printStackTrace(); }
        return "ERROR:No se pudo registrar.";
    }

    // ── FIN BREAK ────────────────────────────────────────────────
    public String marcarFinBreak(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraInicioBreak() == null)
            return "ERROR:Primero registra el inicio de break.";
        if (m.getHoraFinBreak() != null)
            return "ERROR:Ya registraste el fin de break hoy.";

        // Calcular minutos transcurridos
        LocalTime inicio = LocalTime.parse(m.getHoraInicioBreak().substring(0, 8));
        long minutos = ChronoUnit.MINUTES.between(inicio, LocalTime.now());

        String sql = "UPDATE marcajes SET hora_fin_break=NOW() " +
                     "WHERE id_usuario=? AND fecha=CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); return "ERROR:No se pudo registrar."; }

        if (minutos < MAX_BREAK_MIN) {
            return "WARN:Marcaste fin de break antes de tiempo. " +
                   "Solo tomaste " + minutos + " de " + MAX_BREAK_MIN + " minutos.";
        } else if (minutos > MAX_BREAK_MIN) {
            return "WARN:Te excediste " + (minutos - MAX_BREAK_MIN) +
                   " minutos en el break.";
        }
        return "OK:Fin de break registrado correctamente.";
    }

    // ── INICIO LONCH ─────────────────────────────────────────────
    public String marcarInicioLonch(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraFinBreak() == null)
            return "ERROR:Primero registra el fin de break.";
        if (m.getHoraInicioLonch() != null)
            return "ERROR:Ya registraste el inicio de lonch hoy.";

        String sql = "UPDATE marcajes SET hora_inicio_lonch=NOW() " +
                     "WHERE id_usuario=? AND fecha=CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            return "OK:Lonch iniciado. Tienes " + MAX_LONCH_MIN + " minutos (1 hora).";
        } catch (SQLException e) { e.printStackTrace(); }
        return "ERROR:No se pudo registrar.";
    }

    // ── FIN LONCH ────────────────────────────────────────────────
    public String marcarFinLonch(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraInicioLonch() == null)
            return "ERROR:Primero registra el inicio de lonch.";
        if (m.getHoraFinLonch() != null)
            return "ERROR:Ya registraste el fin de lonch hoy.";

        LocalTime inicio = LocalTime.parse(m.getHoraInicioLonch().substring(0, 8));
        long minutos = ChronoUnit.MINUTES.between(inicio, LocalTime.now());

        String sql = "UPDATE marcajes SET hora_fin_lonch=NOW() " +
                     "WHERE id_usuario=? AND fecha=CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); return "ERROR:No se pudo registrar."; }

        if (minutos < MAX_LONCH_MIN) {
            return "WARN:Marcaste fin de lonch antes de tiempo. " +
                   "Solo tomaste " + minutos + " de " + MAX_LONCH_MIN + " minutos.";
        } else if (minutos > MAX_LONCH_MIN) {
            return "WARN:Te excediste " + (minutos - MAX_LONCH_MIN) +
                   " minutos en el lonch.";
        }
        return "OK:Fin de lonch registrado correctamente.";
    }

    // ── MARCAR SALIDA ────────────────────────────────────────────
    public String marcarSalida(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraFinLonch() == null)
            return "ERROR:Primero registra el fin de lonch.";
        if (m.getHoraSalida() != null)
            return "ERROR:Ya registraste tu salida hoy.";

        String sql = "UPDATE marcajes SET hora_salida=NOW() " +
                     "WHERE id_usuario=? AND fecha=CURDATE()";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            return "OK:Salida registrada. Hasta manana!";
        } catch (SQLException e) { e.printStackTrace(); }
        return "ERROR:No se pudo registrar.";
    }

    // ── CALCULAR MINUTOS EN CURSO ────────────────────────────────
    public long calcularMinutosBreakActual(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraInicioBreak() == null
                      || m.getHoraFinBreak() != null) return 0;
        LocalTime inicio = LocalTime.parse(m.getHoraInicioBreak().substring(0, 8));
        return ChronoUnit.MINUTES.between(inicio, LocalTime.now());
    }

    public long calcularMinutosLonchActual(int idUsuario) {
        Marcaje m = obtenerHoy(idUsuario);
        if (m == null || m.getHoraInicioLonch() == null
                      || m.getHoraFinLonch() != null) return 0;
        LocalTime inicio = LocalTime.parse(m.getHoraInicioLonch().substring(0, 8));
        return ChronoUnit.MINUTES.between(inicio, LocalTime.now());
    }

    // ── LISTAR ───────────────────────────────────────────────────
    public List<Marcaje> listarPorUsuario(int idUsuario) {
        String sql = BASE_SQL() +
                     "WHERE m.id_usuario = ? " +
                     "ORDER BY m.fecha DESC LIMIT 30";
        List<Marcaje> lista = new ArrayList<>();
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Marcaje> listarMarcajesHoy() {
        String sql = BASE_SQL() + "WHERE m.fecha = CURDATE() " +
                     "ORDER BY m.hora_entrada";
        List<Marcaje> lista = new ArrayList<>();
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Marcaje> listarPorArea(int idJefe) {
        String sql = BASE_SQL() +
                     "WHERE m.fecha = CURDATE() " +
                     "AND u.id_area = (SELECT id_area FROM usuarios WHERE id_usuario=?) " +
                     "AND u.id_turno_actual = " +
                     "    (SELECT id_turno_actual FROM usuarios WHERE id_usuario=?) " +
                     "ORDER BY m.hora_entrada";
        List<Marcaje> lista = new ArrayList<>();
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idJefe);
            ps.setInt(2, idJefe);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // ── HELPERS ──────────────────────────────────────────────────
    private String BASE_SQL() {
        return "SELECT m.*, " +
               "u.nombre_completo, u.username, " +
               "a.nombre_area, t.nombre_turno " +
               "FROM marcajes m " +
               "INNER JOIN usuarios u ON m.id_usuario = u.id_usuario " +
               "LEFT JOIN  areas a   ON u.id_area = a.id_area " +
               "LEFT JOIN  turnos t  ON u.id_turno_actual = t.id_turno ";
    }

    private Marcaje mapear(ResultSet rs) throws SQLException {
        Marcaje m = new Marcaje();
        m.setIdMarcaje(rs.getInt("id_marcaje"));
        m.setIdUsuario(rs.getInt("id_usuario"));
        m.setFecha(rs.getString("fecha"));
        m.setHoraEntrada(rs.getString("hora_entrada"));
        m.setHoraInicioBreak(rs.getString("hora_inicio_break"));
        m.setHoraFinBreak(rs.getString("hora_fin_break"));
        m.setHoraInicioLonch(rs.getString("hora_inicio_lonch"));
        m.setHoraFinLonch(rs.getString("hora_fin_lonch"));
        m.setHoraSalida(rs.getString("hora_salida"));
        m.setEntradaTarde(rs.getInt("entrada_tarde") == 1);
        try { m.setIpMarcaje(rs.getString("ip_marcaje")); }
        catch (SQLException ignored) {}
        try { m.setNombreCompleto(rs.getString("nombre_completo")); }
        catch (SQLException ignored) {}
        try { m.setNombreArea(rs.getString("nombre_area")); }
        catch (SQLException ignored) {}
        try { m.setNombreTurno(rs.getString("nombre_turno")); }
        catch (SQLException ignored) {}

        // Calcular estado
        if      (m.getHoraSalida()      != null) m.setEstadoMarcaje("Completo");
        else if (m.getHoraInicioLonch() != null) m.setEstadoMarcaje("En lonch");
        else if (m.getHoraFinBreak()    != null) m.setEstadoMarcaje("En turno");
        else if (m.getHoraInicioBreak() != null) m.setEstadoMarcaje("En break");
        else if (m.getHoraEntrada()     != null) m.setEstadoMarcaje("En turno");
        else                                     m.setEstadoMarcaje("Sin marcar");

        return m;
    }
}