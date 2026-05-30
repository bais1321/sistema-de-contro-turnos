package com.turnos.servlet;

import com.turnos.dao.BitacoraDAO;
import com.turnos.modelo.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        cerrarSesion(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        cerrarSesion(req, resp);
    }

    private void cerrarSesion(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session != null) {
            try {
                Usuario u = (Usuario) session.getAttribute("usuario");
                if (u != null) {
                    bitacoraDAO.registrar(
                        u.getIdUsuario(),
                        u.getUsername(),
                        u.getNombreCompleto(),
                        "Logout",
                        "Autenticacion",
                        "Cierre de sesión",
                        req.getRemoteAddr()
                    );
                }
            } catch (Exception ignored) {}

            session.invalidate();
        }

        // Evitar que el navegador cachee páginas protegidas
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        resp.sendRedirect(req.getContextPath() + "/login");
    }
}