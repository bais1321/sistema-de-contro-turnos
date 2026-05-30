package com.turnos.servlet;

import com.turnos.dao.*;
import com.turnos.modelo.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final UsuarioDAO   usuarioDAO   = new UsuarioDAO();
    private final MarcajeDAO   marcajeDAO   = new MarcajeDAO();
    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
    private final BitacoraDAO  bitacoraDAO  = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
       

        Marcaje marcajeHoy = marcajeDAO.obtenerHoy(usuario.getIdUsuario());
        req.setAttribute("marcajeHoy", marcajeHoy);

        // ── AdminRRHH ─────────────────────────────────────────
        if (usuario.tieneRol("AdminRRHH")) {
            List<Usuario>   todos       = usuarioDAO.listarTodos();
            List<Marcaje>   marcajesHoy = marcajeDAO.listarMarcajesHoy();
            List<Solicitud> pendRRHH    = solicitudDAO.listarPendientesRRHH();
            List<Bitacora>  bitacora    = bitacoraDAO.listar(10);

            long activos = todos.stream()
                    .filter(u -> "Activo".equals(u.getEstado()))
                    .count();

            req.setAttribute("totalUsuarios",  todos.size());
            req.setAttribute("totalActivos",   activos);
            req.setAttribute("marcajesHoy",    marcajesHoy);
            req.setAttribute("pendientesRRHH", pendRRHH.size());
            req.setAttribute("bitacora",       bitacora);

        // ── JefeArea ──────────────────────────────────────────
        } else if (usuario.tieneRol("JefeArea") || usuario.isEsJefeArea()) {

            List<Usuario>   misEmpleados =
                usuarioDAO.listarPorJefe(usuario.getIdUsuario());
            List<Solicitud> pendJefe     =
                solicitudDAO.listarPendientesParaJefe(usuario.getIdUsuario());
            List<Marcaje>   marcajesArea =
                marcajeDAO.listarPorArea(usuario.getIdUsuario());

            req.setAttribute("misEmpleados",   misEmpleados.size());
            req.setAttribute("pendientesJefe", pendJefe.size());
            req.setAttribute("marcajesArea",   marcajesArea);

        // ── Empleado ──────────────────────────────────────────
        } else {
            List<Solicitud> misSolicitudes =
                solicitudDAO.listarPorUsuario(usuario.getIdUsuario());
            List<Usuario> misJefes =
                usuarioDAO.listarJefesPorAreaYTurno(
                    usuario.getIdArea(),
                    usuario.getIdTurnoActual());

            req.setAttribute("misSolicitudes", misSolicitudes);
            req.setAttribute("misJefes",       misJefes);
        }

        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }
}