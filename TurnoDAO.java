// ============================================================
// TurnoDAO.java
// package com.turnos.dao
// ============================================================
package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.Turno;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TurnoDAO {

    public List<Turno> listarTodos() {
        List<Turno> lista = new ArrayList<>();
        String sql = "SELECT * FROM turnos WHERE estado = 1 ORDER BY hora_inicio";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Turno obtenerPorId(int id) {
        String sql = "SELECT * FROM turnos WHERE id_turno = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Turno mapear(ResultSet rs) throws SQLException {
        Turno t = new Turno();
        t.setIdTurno(rs.getInt("id_turno"));
        t.setNombreTurno(rs.getString("nombre_turno"));
        t.setHoraInicio(rs.getString("hora_inicio"));
        t.setHoraFin(rs.getString("hora_fin"));
        t.setDescripcion(rs.getString("descripcion"));
        t.setEstado(rs.getInt("estado"));
        return t;
    }
}