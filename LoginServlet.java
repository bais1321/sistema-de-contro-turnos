package com.turnos.servlet;

import com.turnos.dao.BitacoraDAO;
import com.turnos.dao.UsuarioDAO;
import com.turnos.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO  usuarioDAO  = new UsuarioDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();
    private static final int  MAX_INTENTOS = 3;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            resp.sendRedirect("dashboard");
            return;
        }
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String ip       = req.getRemoteAddr();

        int intentos = usuarioDAO.obtenerIntentos(username);
        if (intentos >= MAX_INTENTOS) {
            req.setAttribute("error", "Cuenta bloqueada. Contacte a RRHH.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        Usuario usuario = usuarioDAO.autenticar(username, password);
        if (usuario == null) {
            usuarioDAO.incrementarIntentos(username);
            int restantes = MAX_INTENTOS - (intentos + 1);
            req.setAttribute("error",
                "Credenciales incorrectas. Intentos restantes: " + restantes);
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("usuario", usuario);
        session.setAttribute("roles",   usuario.getRoles());
        session.setMaxInactiveInterval(3600);

        bitacoraDAO.registrar(
            usuario.getIdUsuario(), usuario.getUsername(),
            usuario.getNombreCompleto(),
            "Login", "Autenticacion", "Inicio de sesión exitoso", ip
        );

        // TODOS van al dashboard — el dashboard muestra lo que corresponde por rol
        resp.sendRedirect("dashboard");
    }
}