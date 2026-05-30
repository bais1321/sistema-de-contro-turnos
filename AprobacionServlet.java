package com.turnos.servlet;

import com.turnos.dao.*;
import com.turnos.modelo.*;
import com.turnos.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/aprobaciones")
public class AprobacionServlet extends HttpServlet {

    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
    private final BitacoraDAO  bitacoraDAO  = new BitacoraDAO();
    private final HistorialDAO historialDAO = new HistorialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");

        if (u.tieneRol("JefeArea") || u.isEsJefeArea()) {
            req.setAttribute("pendientesJefe",
                    solicitudDAO.listarPendientesParaJefe(u.getIdUsuario()));
        }
        if (u.tieneRol("AdminRRHH")) {
            req.setAttribute("pendientesRRHH",
                    solicitudDAO.listarPendientesRRHH());
        }

        req.getRequestDispatcher("aprobaciones.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }

        Usuario admin     = (Usuario) session.getAttribute("usuario");
        String  action    = req.getParameter("action");
        int     idSol     = Integer.parseInt(req.getParameter("idSolicitud"));
        String  comentario = req.getParameter("comentario");
        if (comentario == null) comentario = "";
        String ip = req.getRemoteAddr();

        Solicitud sol = solicitudDAO.obtenerPorId(idSol);
        if (sol == null) { resp.sendRedirect("aprobaciones?error=notfound"); return; }

        String  email       = solicitudDAO.obtenerEmailSolicitante(idSol);
        String  msgRedirect = "ok";
        boolean ok          = false;

        switch (action != null ? action : "") {

            case "aprobarJefe":
                ok = solicitudDAO.aprobarJefe(idSol, admin.getIdUsuario(), comentario);
                if (ok) {
                    if (email != null)
                        EmailUtil.enviar(email,
                            "Solicitud aprobada por Jefe de Area",
                            EmailUtil.templateAprobacionJefe(
                                sol.getNombreSolicitante(),
                                sol.getNombreTipoSolicitud(),
                                sol.getFechaInicio(), sol.getFechaFin(),
                                comentario, admin.getNombreCompleto()));
                    bitacoraDAO.registrar(
                        admin.getIdUsuario(), admin.getUsername(),
                        admin.getNombreCompleto(),
                        "Aprobar", "Solicitudes",
                        "Aprobo (Jefe) solicitud #" + idSol, ip);
                    historialDAO.registrar(
                        "solicitudes", idSol, "UPDATE",
                        "estado=PendienteJefe",
                        "estado=AprobadaJefe, jefe=" + admin.getNombreCompleto(),
                        admin.getIdUsuario(), admin.getNombreCompleto(),
                        ip, "Aprobacion jefe de area");
                }
                break;

            case "rechazarJefe":
                ok = solicitudDAO.rechazarJefe(idSol, admin.getIdUsuario(), comentario);
                if (ok) {
                    if (email != null)
                        EmailUtil.enviar(email,
                            "Solicitud rechazada por Jefe de Area",
                            EmailUtil.templateRechazoJefe(
                                sol.getNombreSolicitante(),
                                sol.getNombreTipoSolicitud(),
                                sol.getFechaInicio(), sol.getFechaFin(),
                                comentario, admin.getNombreCompleto()));
                    bitacoraDAO.registrar(
                        admin.getIdUsuario(), admin.getUsername(),
                        admin.getNombreCompleto(),
                        "Rechazar", "Solicitudes",
                        "Rechazo (Jefe) solicitud #" + idSol, ip);
                    historialDAO.registrar(
                        "solicitudes", idSol, "UPDATE",
                        "estado=PendienteJefe",
                        "estado=RechazadaJefe, motivo=" + comentario,
                        admin.getIdUsuario(), admin.getNombreCompleto(),
                        ip, "Rechazo jefe de area");
                }
                break;

            case "aprobarRRHH":
                ok = solicitudDAO.aprobarRRHH(idSol, admin.getIdUsuario(), comentario);
                if (ok) {
                    if (email != null)
                        EmailUtil.enviar(email,
                            "Permiso autorizado por RRHH",
                            EmailUtil.templateAprobacionRRHH(
                                sol.getNombreSolicitante(),
                                sol.getNombreTipoSolicitud(),
                                sol.getFechaInicio(), sol.getFechaFin(),
                                comentario));
                    bitacoraDAO.registrar(
                        admin.getIdUsuario(), admin.getUsername(),
                        admin.getNombreCompleto(),
                        "Aprobar", "Solicitudes",
                        "Autorizo (RRHH) solicitud #" + idSol, ip);
                    historialDAO.registrar(
                        "solicitudes", idSol, "UPDATE",
                        "estado=AprobadaJefe",
                        "estado=AprobadaRRHH, rrhh=" + admin.getNombreCompleto(),
                        admin.getIdUsuario(), admin.getNombreCompleto(),
                        ip, "Autorizacion RRHH");
                }
                break;

            case "rechazarRRHH":
                ok = solicitudDAO.rechazarRRHH(idSol, admin.getIdUsuario(), comentario);
                if (ok) {
                    if (email != null)
                        EmailUtil.enviar(email,
                            "Solicitud no autorizada por RRHH",
                            EmailUtil.templateRechazoRRHH(
                                sol.getNombreSolicitante(),
                                sol.getNombreTipoSolicitud(),
                                sol.getFechaInicio(), sol.getFechaFin(),
                                comentario));
                    bitacoraDAO.registrar(
                        admin.getIdUsuario(), admin.getUsername(),
                        admin.getNombreCompleto(),
                        "Rechazar", "Solicitudes",
                        "Rechazo (RRHH) solicitud #" + idSol, ip);
                    historialDAO.registrar(
                        "solicitudes", idSol, "UPDATE",
                        "estado=AprobadaJefe",
                        "estado=RechazadaRRHH, motivo=" + comentario,
                        admin.getIdUsuario(), admin.getNombreCompleto(),
                        ip, "Rechazo RRHH");
                }
                break;

            default:
                resp.sendRedirect("aprobaciones"); return;
        }

        resp.sendRedirect("aprobaciones?msg=" + msgRedirect);
    }
}