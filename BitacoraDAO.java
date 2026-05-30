// ============================================================
// BitacoraDAO.java
// package com.turnos.dao
// ============================================================
package com.turnos.dao;

import com.turnos.conexion.Conexion;
import com.turnos.modelo.Bitacora;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BitacoraDAO {

    public void registrar(int idUsuario, String username, String nombreCompleto,
                          String tipoOperacion, String modulo, String descripcion, String ip) {
        String sql = "INSERT INTO bitacora " +
                     "(id_usuario, username, nombre_completo, tipo_operacion, modulo, descripcion, ip_address) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, username);
            ps.setString(3, nombreCompleto);
            ps.setString(4, tipoOperacion);
            ps.setString(5, modulo);
            ps.setString(6, descripcion);
            ps.setString(7, ip);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<Bitacora> listar(int limite) {
        List<Bitacora> lista = new ArrayList<>();
        String sql = "SELECT * FROM bitacora ORDER BY fecha_hora DESC LIMIT ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bitacora b = new Bitacora();
                b.setIdBitacora(rs.getInt("id_bitacora"));
                b.setIdUsuario(rs.getInt("id_usuario"));
                b.setUsername(rs.getString("username"));
                b.setNombreCompleto(rs.getString("nombre_completo"));
                b.setTipoOperacion(rs.getString("tipo_operacion"));
                b.setModulo(rs.getString("modulo"));
                b.setDescripcion(rs.getString("descripcion"));
                b.setIpAddress(rs.getString("ip_address"));
                b.setFechaHora(rs.getString("fecha_hora"));
                lista.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
}