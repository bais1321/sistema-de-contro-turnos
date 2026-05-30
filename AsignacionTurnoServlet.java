package com.turnos.servlet;

import com.turnos.conexion.Conexion;
import com.turnos.dao.*;
import com.turnos.modelo.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/asignacion-turno")
public class AsignacionTurnoServlet extends HttpServlet {

    private final UsuarioDAO   usuarioDAO   = new UsuarioDAO();
    private final TurnoDAO     turnoDAO     = new TurnoDAO();
    private final BitacoraDAO  bitacoraDAO  = new BitacoraDAO();
    private final HistorialDAO historialDAO = new HistorialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario admin = (Usuario) session.getAttribute("usuario");
        if (!admin.tieneRol("AdminRRHH")) {
            resp.sendRedirect("dashboard"); return;
        }

        req.setAttribute("usuarios",     usuarioDAO.listarActivos());
        req.setAttribute("turnos",       turnoDAO.listarTodos());
        req.setAttribute("asignaciones", listarAsignaciones());
        req.getRequestDispatcher("asignacion-turnos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario admin = (Usuario) session.getAttribute("usuario");
        if (!admin.tieneRol("AdminRRHH")) {
            resp.sendRedirect("dashboard"); return;
        }

        int    idUsuario = Integer.parseInt(req.getParameter("idUsuario"));
        int    idTurno   = Integer.parseInt(req.getParameter("idTurno"));
        String fechaI    = req.getParameter("fechaInicio");
        String fechaF    = req.getParameter("fechaFin");
        String obs       = req.getParameter("observaciones");
        String ip        = req.getRemoteAddr();

        Usuario u = usuarioDAO.obtenerPorId(idUsuario);
        int turnoAnterior = u != null ? u.getIdTurnoActual() : 0;

        boolean ok = actualizarTurnoUsuario(idUsuario, idTurno);
        insertarAsignacion(idUsuario, idTurno, fechaI, fechaF, obs);

        if (ok) {
            historialDAO.registrar(
                "usuarios", idUsuario, "CAMBIO_TURNO",
                "id_turno=" + turnoAnterior,
                "id_turno=" + idTurno + ", inicio=" + fechaI + ", fin=" + fechaF,
                admin.getIdUsuario(), admin.getNombreCompleto(), ip,
                "Asignación de turno a " + (u != null ? u.getNombreCompleto() : idUsuario)
            );
            bitacoraDAO.registrar(
                admin.getIdUsuario(), admin.getUsername(), admin.getNombreCompleto(),
                "Actualizar", "AsignacionTurno",
                "Asignó turno " + idTurno + " al usuario " + idUsuario, ip
            );
            resp.sendRedirect("asignacion-turno?msg=asignado");
        } else {
            resp.sendRedirect("asignacion-turno?error=1");
        }
    }

    private boolean actualizarTurnoUsuario(int idUsuario, int idTurno) {
        String sql = "UPDATE usuarios SET id_turno_actual = ? WHERE id_usuario = ?";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idTurno);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private void insertarAsignacion(int idUsuario, int idTurno,
                                    String fi, String ff, String obs) {
        String sql = "INSERT INTO asignaciones_turno " +
                     "(id_usuario, id_turno, fecha_inicio, fecha_fin, observaciones) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idTurno);
            ps.setString(3, fi);
            ps.setString(4, ff);
            ps.setString(5, obs);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private List<Map<String, String>> listarAsignaciones() {
        List<Map<String, String>> lista = new ArrayList<>();
        String sql = "SELECT at.*, u.nombre_completo, t.nombre_turno " +
                     "FROM asignaciones_turno at " +
                     "INNER JOIN usuarios u ON at.id_usuario = u.id_usuario " +
                     "INNER JOIN turnos   t ON at.id_turno   = t.id_turno " +
                     "ORDER BY at.created_at DESC LIMIT 50";
        try (Connection c = Conexion.getConexion();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                row.put("nombre_completo", rs.getString("nombre_completo"));
                row.put("nombre_turno",    rs.getString("nombre_turno"));
                row.put("fecha_inicio",    rs.getString("fecha_inicio"));
                row.put("fecha_fin",       rs.getString("fecha_fin"));
                row.put("estado",          rs.getString("estado"));
                row.put("observaciones",   rs.getString("observaciones"));
                lista.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
}