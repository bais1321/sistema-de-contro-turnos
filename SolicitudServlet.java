package com.turnos.servlet;

import com.turnos.dao.*;
import com.turnos.modelo.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/solicitudes")
public class SolicitudServlet extends HttpServlet {

    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
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

        Usuario user = (Usuario) session.getAttribute("usuario");

        // Datos comunes para todos
        req.setAttribute("tipos",          solicitudDAO.listarTipos());
        req.setAttribute("turnos",         turnoDAO.listarTodos());
        req.setAttribute("misSolicitudes", solicitudDAO.listarPorUsuario(
                user.getIdUsuario()));

        // Extra para JefeArea
        if (user.tieneRol("JefeArea") || user.isEsJefeArea()) {
            req.setAttribute("solicitudesJefe",
                    solicitudDAO.listarPendientesParaJefe(user.getIdUsuario()));
        }

        // Extra para AdminRRHH
        if (user.tieneRol("AdminRRHH")) {
            req.setAttribute("pendientesRRHH",
                    solicitudDAO.listarPendientesRRHH());
        }

        req.getRequestDispatcher("solicitudes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }

        Usuario user   = (Usuario) session.getAttribute("usuario");
        String  action = req.getParameter("action");
        String  ip     = req.getRemoteAddr();

        try {
            if ("guardar".equals(action)) {
                guardar(req, resp, user, ip);
            } else {
                resp.sendRedirect("solicitudes");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private void guardar(HttpServletRequest req, HttpServletResponse resp,
                         Usuario user, String ip)
            throws IOException, ServletException {

        Solicitud sol = new Solicitud();
        sol.setIdUsuarioSolicitante(user.getIdUsuario());
        sol.setIdTipoSolicitud(
                Integer.parseInt(req.getParameter("idTipoSolicitud")));
        sol.setMotivo(req.getParameter("motivo"));
        sol.setFechaInicio(req.getParameter("fechaInicio"));
        sol.setFechaFin(req.getParameter("fechaFin"));
        sol.setJustificacion(req.getParameter("justificacion"));

        // Si el usuario no tiene jefe asignado va directo a RRHH
        sol.setIdJefeArea(user.getIdJefeArea());

        if (solicitudDAO.insertar(sol)) {
            bitacoraDAO.registrar(
                user.getIdUsuario(), user.getUsername(),
                user.getNombreCompleto(),
                "Crear", "Solicitudes",
                "Creo solicitud de permiso", ip);
            resp.sendRedirect("solicitudes?msg=enviada");
        } else {
            req.setAttribute("error", "Error al guardar la solicitud.");
            doGet(req, resp);
        }
    }
}