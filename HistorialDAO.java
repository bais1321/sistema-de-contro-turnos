// ============================================================
// HistorialDAO.java
// package com.turnos.dao
// ============================================================
package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.HistorialCambio;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorialDAO {

    public void registrar(String tabla, int idRegistro, String tipoOp,
                          String datosAnt, String datosNuev,
                          int idAdmin, String nombreAdmin, String ip, String descripcion) {
        String sql = "INSERT INTO historial_cambios " +
                     "(tabla_afectada, id_registro, tipo_operacion, datos_anteriores, datos_nuevos, " +
                     "id_usuario_admin, nombre_admin, ip_address, descripcion) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tabla);
            ps.setInt(2, idRegistro);
            ps.setString(3, tipoOp);
            ps.setString(4, datosAnt);
            ps.setString(5, datosNuev);
            ps.setInt(6, idAdmin);
            ps.setString(7, nombreAdmin);
            ps.setString(8, ip);
            ps.setString(9, descripcion);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<HistorialCambio> listarTodos() {
        List<HistorialCambio> lista = new ArrayList<>();
        String sql = "SELECT * FROM historial_cambios ORDER BY fecha_hora DESC";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<HistorialCambio> listarPorTabla(String tabla) {
        List<HistorialCambio> lista = new ArrayList<>();
        String sql = "SELECT * FROM historial_cambios WHERE tabla_afectada = ? ORDER BY fecha_hora DESC";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, tabla);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    private HistorialCambio mapear(ResultSet rs) throws SQLException {
        HistorialCambio h = new HistorialCambio();
        h.setIdHistorial(rs.getInt("id_historial"));
        h.setTablaAfectada(rs.getString("tabla_afectada"));
        h.setIdRegistro(rs.getInt("id_registro"));
        h.setTipoOperacion(rs.getString("tipo_operacion"));
        h.setDatosAnteriores(rs.getString("datos_anteriores"));
        h.setDatosNuevos(rs.getString("datos_nuevos"));
        h.setIdUsuarioAdmin(rs.getInt("id_usuario_admin"));
        h.setNombreAdmin(rs.getString("nombre_admin"));
        h.setFechaHora(rs.getString("fecha_hora"));
        h.setIpAddress(rs.getString("ip_address"));
        h.setDescripcion(rs.getString("descripcion"));
        return h;
    }
}