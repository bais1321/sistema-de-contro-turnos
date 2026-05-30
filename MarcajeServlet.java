package com.turnos.servlet;

import com.turnos.dao.*;
import com.turnos.modelo.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/marcaje")
public class MarcajeServlet extends HttpServlet {

    private final MarcajeDAO  marcajeDAO  = new MarcajeDAO();
    private final BitacoraDAO bitacoraDAO = new BitacoraDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        Marcaje marcajeHoy = marcajeDAO.obtenerHoy(usuario.getIdUsuario());
        req.setAttribute("marcajeHoy", marcajeHoy);

        if (marcajeHoy != null) {
            req.setAttribute("minutosBreak",
                marcajeDAO.calcularMinutosBreakActual(usuario.getIdUsuario()));
            req.setAttribute("minutosLonch",
                marcajeDAO.calcularMinutosLonchActual(usuario.getIdUsuario()));
        }

        if (usuario.tieneRol("AdminRRHH"))
            req.setAttribute("marcajesHoy", marcajeDAO.listarMarcajesHoy());
        if (usuario.tieneRol("JefeArea") || usuario.isEsJefeArea())
            req.setAttribute("marcajesArea", marcajeDAO.listarPorArea(
                    usuario.getIdUsuario()));

        req.setAttribute("historialMarcajes",
            marcajeDAO.listarPorUsuario(usuario.getIdUsuario()));

        req.getRequestDispatcher("marcaje.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String  accion  = req.getParameter("accion");
        String  ip      = req.getRemoteAddr();
        String  resultado;

        switch (accion != null ? accion : "") {
            case "entrada":
                if (marcajeDAO.yaMarcadoHoy(usuario.getIdUsuario())) {
                    resultado = "ERROR:Ya registraste tu entrada hoy.";
                } else {
                    boolean ok = marcajeDAO.marcarEntrada(
                            usuario.getIdUsuario(), ip);
                    if (ok) {
                        Marcaje m = marcajeDAO.obtenerHoy(usuario.getIdUsuario());
                        boolean tarde = m != null && m.isEntradaTarde();
                        bitacoraDAO.registrar(
                            usuario.getIdUsuario(), usuario.getUsername(),
                            usuario.getNombreCompleto(), "Marcaje", "Marcaje",
                            "Marco entrada" + (tarde ? " (TARDE)" : ""), ip);
                        resultado = tarde
                            ? "WARN:Entrada registrada. AVISO: llegaste tarde."
                            : "OK:Entrada registrada correctamente.";
                    } else {
                        resultado = "ERROR:No se pudo registrar la entrada.";
                    }
                }
                break;

            case "inicioBreak":
                resultado = marcajeDAO.marcarInicioBreak(usuario.getIdUsuario());
                if (resultado.startsWith("OK"))
                    bitacoraDAO.registrar(
                        usuario.getIdUsuario(), usuario.getUsername(),
                        usuario.getNombreCompleto(), "Marcaje", "Marcaje",
                        "Inicio break", ip);
                break;

            case "finBreak":
                resultado = marcajeDAO.marcarFinBreak(usuario.getIdUsuario());
                if (!resultado.startsWith("ERROR"))
                    bitacoraDAO.registrar(
                        usuario.getIdUsuario(), usuario.getUsername(),
                        usuario.getNombreCompleto(), "Marcaje", "Marcaje",
                        "Fin break", ip);
                break;

            case "inicioLonch":
                resultado = marcajeDAO.marcarInicioLonch(usuario.getIdUsuario());
                if (resultado.startsWith("OK"))
                    bitacoraDAO.registrar(
                        usuario.getIdUsuario(), usuario.getUsername(),
                        usuario.getNombreCompleto(), "Marcaje", "Marcaje",
                        "Inicio lonch", ip);
                break;

            case "finLonch":
                resultado = marcajeDAO.marcarFinLonch(usuario.getIdUsuario());
                if (!resultado.startsWith("ERROR"))
                    bitacoraDAO.registrar(
                        usuario.getIdUsuario(), usuario.getUsername(),
                        usuario.getNombreCompleto(), "Marcaje", "Marcaje",
                        "Fin lonch", ip);
                break;

            case "salida":
                resultado = marcajeDAO.marcarSalida(usuario.getIdUsuario());
                if (!resultado.startsWith("ERROR"))
                    bitacoraDAO.registrar(
                        usuario.getIdUsuario(), usuario.getUsername(),
                        usuario.getNombreCompleto(), "Marcaje", "Marcaje",
                        "Marco salida", ip);
                break;

            default:
                resultado = "ERROR:Accion no reconocida.";
        }

        // resultado = "OK:mensaje" o "WARN:mensaje" o "ERROR:mensaje"
        String[] partes = resultado.split(":", 2);
        String tipo = partes[0].toLowerCase();
        String msg  = partes.length > 1 ? partes[1] : resultado;

        resp.sendRedirect("marcaje?msg=" +
            java.net.URLEncoder.encode(msg, "UTF-8") + "&tipo=" + tipo);
    }
}