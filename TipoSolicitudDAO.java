package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.TipoSolicitud;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TipoSolicitudDAO {

    public List<TipoSolicitud> listarTodos() {
        List<TipoSolicitud> lista = new ArrayList<>();
        String sql = "SELECT * FROM tipos_solicitud ORDER BY nombre_tipo";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public TipoSolicitud obtenerPorId(int id) {
        String sql = "SELECT * FROM tipos_solicitud WHERE id_tipo_solicitud = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertar(TipoSolicitud ts) {
        String sql = "INSERT INTO tipos_solicitud " +
                     "(nombre_tipo, descripcion, requiere_aprobacion_rrhh, dias_maximos) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, ts.getNombreTipo());
            ps.setString(2, ts.getDescripcion());
            ps.setInt(3, ts.getRequiereAprobacionRrhh());
            ps.setInt(4, ts.getDiasMaximos());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean actualizar(TipoSolicitud ts) {
        String sql = "UPDATE tipos_solicitud SET " +
                     "nombre_tipo=?, descripcion=?, " +
                     "requiere_aprobacion_rrhh=?, dias_maximos=? " +
                     "WHERE id_tipo_solicitud=?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, ts.getNombreTipo());
            ps.setString(2, ts.getDescripcion());
            ps.setInt(3, ts.getRequiereAprobacionRrhh());
            ps.setInt(4, ts.getDiasMaximos());
            ps.setInt(5, ts.getIdTipoSolicitud());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM tipos_solicitud WHERE id_tipo_solicitud = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existeNombre(String nombre) {
        String sql = "SELECT COUNT(*) FROM tipos_solicitud WHERE nombre_tipo = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private TipoSolicitud mapear(ResultSet rs) throws SQLException {
        TipoSolicitud ts = new TipoSolicitud();
        ts.setIdTipoSolicitud(rs.getInt("id_tipo_solicitud"));
        ts.setNombreTipo(rs.getString("nombre_tipo"));
        ts.setDescripcion(rs.getString("descripcion"));
        ts.setRequiereAprobacionRrhh(rs.getInt("requiere_aprobacion_rrhh"));
        ts.setDiasMaximos(rs.getInt("dias_maximos"));
        return ts;
    }
}