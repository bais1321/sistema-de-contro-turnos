// ============================================================
// AreaDAO.java
// package com.turnos.dao
// ============================================================
package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.Area;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AreaDAO {

    public List<Area> listarTodos() {
        List<Area> lista = new ArrayList<>();
        String sql = "SELECT a.*, ap.nombre_area AS nombre_area_padre " +
                     "FROM areas a " +
                     "LEFT JOIN areas ap ON a.id_area_padre = ap.id_area " +
                     "WHERE a.estado = 1 ORDER BY a.nombre_area";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Area obtenerPorId(int id) {
        String sql = "SELECT a.*, ap.nombre_area AS nombre_area_padre " +
                     "FROM areas a LEFT JOIN areas ap ON a.id_area_padre = ap.id_area " +
                     "WHERE a.id_area = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertar(Area a) {
        String sql = "INSERT INTO areas (nombre_area, descripcion, id_area_padre, es_jefatura, estado) " +
                     "VALUES (?, ?, ?, ?, 1)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.getNombreArea());
            ps.setString(2, a.getDescripcion());
            if (a.getIdAreaPadre() > 0) ps.setInt(3, a.getIdAreaPadre());
            else ps.setNull(3, Types.INTEGER);
            ps.setBoolean(4, a.isEsJefatura());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Area mapear(ResultSet rs) throws SQLException {
        Area a = new Area();
        a.setIdArea(rs.getInt("id_area"));
        a.setNombreArea(rs.getString("nombre_area"));
        a.setDescripcion(rs.getString("descripcion"));
        a.setIdAreaPadre(rs.getInt("id_area_padre"));
        a.setEsJefatura(rs.getBoolean("es_jefatura"));
        a.setEstado(rs.getInt("estado"));
        try { a.setNombreAreaPadre(rs.getString("nombre_area_padre")); } catch (SQLException ignored) {}
        return a;
    }
}