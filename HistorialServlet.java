package com.turnos.servlet;

import com.turnos.dao.*;
import com.turnos.modelo.*;
import com.turnos.util.ExcelUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/historial")
public class HistorialServlet extends HttpServlet {

    private final HistorialDAO historialDAO = new HistorialDAO();
    private final BitacoraDAO  bitacoraDAO  = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!usuario.tieneRol("AdminRRHH")) {
            resp.sendRedirect("dashboard"); return;
        }

        String exportar    = req.getParameter("exportar");
        String tipo        = req.getParameter("tipo");
        String tablaFiltro = req.getParameter("tabla");

        // ---- Exportar a Excel ----
        if ("excel".equals(exportar)) {
            if ("bitacora".equals(tipo)) {
                List<Bitacora> lista = bitacoraDAO.listar(5000);
                ExcelUtil.exportarBitacora(lista, resp);
            } else {
                List<HistorialCambio> lista = historialDAO.listarTodos();
                ExcelUtil.exportarHistorial(lista, resp);
            }
            return;
        }

        // ---- Vista normal ----
        List<HistorialCambio> historial = (tablaFiltro != null && !tablaFiltro.isEmpty())
                ? historialDAO.listarPorTabla(tablaFiltro)
                : historialDAO.listarTodos();

        List<Bitacora> bitacora = bitacoraDAO.listar(200);

        req.setAttribute("historial",    historial);
        req.setAttribute("bitacora",     bitacora);
        req.setAttribute("tablaFiltro",  tablaFiltro);

        req.getRequestDispatcher("historial.jsp").forward(req, resp);
    }
}