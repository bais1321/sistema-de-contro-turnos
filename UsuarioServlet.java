package com.turnos.servlet;

import com.turnos.dao.*;
import com.turnos.modelo.*;
import com.turnos.util.EmailUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/usuarios")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO   usuarioDAO   = new UsuarioDAO();
    private final AreaDAO      areaDAO      = new AreaDAO();
    private final TurnoDAO     turnoDAO     = new TurnoDAO();
    private final BitacoraDAO  bitacoraDAO  = new BitacoraDAO();
    private final HistorialDAO historialDAO = new HistorialDAO();

    // ================================================================
    // GET
    // ================================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario admin = (Usuario) session.getAttribute("usuario");

        // ---- ENDPOINT AJAX: ?action=getJefes&idArea=X&idTurno=Y ----
        if ("getJefes".equals(req.getParameter("action"))) {
            String idAreaStr  = req.getParameter("idArea");
            String idTurnoStr = req.getParameter("idTurno");
            if (idAreaStr != null && idTurnoStr != null
                    && !idAreaStr.isEmpty() && !idTurnoStr.isEmpty()) {
                int idArea  = Integer.parseInt(idAreaStr);
                int idTurno = Integer.parseInt(idTurnoStr);
                List<Usuario> jefes = usuarioDAO.listarJefesPorAreaYTurno(idArea, idTurno);
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < jefes.size(); i++) {
                    Usuario j = jefes.get(i);
                    json.append("{\"id\":").append(j.getIdUsuario())
                        .append(",\"nombre\":\"")
                        .append(j.getNombreCompleto().replace("\"", "\\\""))
                        .append("\"}");
                    if (i < jefes.size() - 1) json.append(",");
                }
                json.append("]");
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write(json.toString());
            } else {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("[]");
            }
            return;
        }

        // ---- ENDPOINT AJAX: ?action=getDatosEmpleado&idUsuario=X ----
        // Devuelve turno e id_jefe_area actual del empleado (para el modal cambiar jefe)
        if ("getDatosEmpleado".equals(req.getParameter("action"))) {
            String idUsuarioStr = req.getParameter("idUsuario");
            if (idUsuarioStr != null && !idUsuarioStr.isEmpty()) {
                int idUsuario = Integer.parseInt(idUsuarioStr);
                Usuario u = usuarioDAO.obtenerPorId(idUsuario);
                if (u != null) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write(
                        "{\"idArea\":" + u.getIdArea() +
                        ",\"idTurno\":" + u.getIdTurnoActual() +
                        ",\"idJefe\":" + u.getIdJefeArea() +
                        ",\"nombreTurno\":\"" + (u.getNombreTurno() != null ? u.getNombreTurno() : "") + "\"}"
                    );
                } else {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write("{}");
                }
            }
            return;
        }

        // ---- VISTAS NORMALES ----
        if (admin.tieneRol("AdminRRHH")) {
            req.setAttribute("usuarios", usuarioDAO.listarTodos());
            req.setAttribute("areas",    areaDAO.listarTodos());
            req.setAttribute("turnos",   turnoDAO.listarTodos());
            req.getRequestDispatcher("mantenimiento-usuarios.jsp").forward(req, resp);
            return;
        }

        if (admin.tieneRol("AdminArea")) {
            req.setAttribute("usuarios", usuarioDAO.listarTodos());
            req.setAttribute("areas",    areaDAO.listarTodos());
            req.setAttribute("turnos",   turnoDAO.listarTodos());
            req.getRequestDispatcher("mantenimiento-usuarios.jsp").forward(req, resp);
            return;
        }

        if (admin.tieneRol("JefeArea") || admin.isEsJefeArea()) {
            req.setAttribute("usuarios",
                    usuarioDAO.listarPorJefe(admin.getIdUsuario()));
            req.getRequestDispatcher("mis-empleados.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect("dashboard");
    }

    // ================================================================
    // POST
    // ================================================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("login"); return;
        }
        Usuario admin = (Usuario) session.getAttribute("usuario");
        if (!admin.tieneRol("AdminRRHH") && !admin.tieneRol("AdminArea")) {
            resp.sendRedirect("dashboard"); return;
        }

        String action = req.getParameter("action");
        String ip     = req.getRemoteAddr();

        switch (action != null ? action : "") {
            case "guardar":        guardar(req, resp, admin, ip);       break;
            case "actualizar":     actualizar(req, resp, admin, ip);    break;
            case "asignarRol":     asignarRol(req, resp, admin, ip);    break;
            case "eliminarRol":    eliminarRol(req, resp, admin, ip);   break;
            case "cambiarJefe":    cambiarJefe(req, resp, admin, ip);   break;
            default:               resp.sendRedirect("usuarios");
        }
    }

    // ================================================================
    // GUARDAR NUEVO USUARIO
    // El rol se asigna AUTOMÁTICAMENTE según el área seleccionada:
    //   área con es_jefatura=1  →  es_jefe_area=true  →  rol JefeArea (id=4)
    //   área con es_jefatura=0  →  es_jefe_area=false →  rol Empleado (id=3)
    // ================================================================
    private void guardar(HttpServletRequest req, HttpServletResponse resp,
                         Usuario admin, String ip)
            throws IOException, ServletException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String dpi      = req.getParameter("dpi");
        String email    = req.getParameter("email");

        if (usuarioDAO.existeUsername(username)) {
            req.setAttribute("error", "El nombre de usuario ya existe.");
            doGet(req, resp); return;
        }
        if (usuarioDAO.existeDpi(dpi)) {
            req.setAttribute("error", "El DPI ya esta registrado.");
            doGet(req, resp); return;
        }

        int idArea  = Integer.parseInt(req.getParameter("idArea"));
        int idTurno = Integer.parseInt(req.getParameter("idTurno"));

        // ---- Determinar si es jefe por el tipo de área ----
        boolean esJefe = usuarioDAO.esAreaDeJefatura(idArea);

        Usuario u = new Usuario();
        u.setDpi(dpi);
        u.setNombreCompleto(req.getParameter("nombreCompleto"));
        u.setUsername(username);
        u.setPassword(password);
        u.setEmail(email);
        u.setIdArea(idArea);
        u.setIdTurnoActual(idTurno);
        u.setEsJefeArea(esJefe);
        u.setEstado("Activo");

        if (!esJefe) {
            // Empleado: buscar jefe disponible en ese área+turno
            int idJefe = usuarioDAO.obtenerJefePorAreaYTurno(idArea, idTurno);
            u.setIdJefeArea(idJefe); // puede ser 0 si no hay jefe → irá directo a RRHH
        } else {
            u.setIdJefeArea(0); // los jefes no tienen jefe asignado
        }

        int nuevoId = usuarioDAO.insertarYObtenerID(u);

        if (nuevoId > 0) {
            // ---- Asignar rol automáticamente ----
            if (esJefe) {
                usuarioDAO.asignarRol(nuevoId, 4); // JefeArea
            } else {
                usuarioDAO.asignarRol(nuevoId, 3); // Empleado
            }

            if (email != null && !email.isEmpty()) {
                EmailUtil.enviar(email,
                    "Cuenta creada - Sistema de Turnos",
                    templateBienvenida(req.getParameter("nombreCompleto"),
                                       username, password));
            }

            bitacoraDAO.registrar(
                admin.getIdUsuario(), admin.getUsername(),
                admin.getNombreCompleto(),
                "Crear", "Usuarios", "Creo usuario: " + username, ip);

            historialDAO.registrar(
                "usuarios", nuevoId, "INSERT", null,
                "username=" + username + ", area=" + idArea + ", esJefe=" + esJefe,
                admin.getIdUsuario(), admin.getNombreCompleto(),
                ip, "Creacion de usuario " + username);

            resp.sendRedirect("usuarios?msg=creado");
        } else {
            req.setAttribute("error", "Error al crear el usuario.");
            doGet(req, resp);
        }
    }

    // ================================================================
    // ACTUALIZAR USUARIO EXISTENTE
    // Si cambia de área, el rol se reasigna automáticamente.
    // Si cambia de turno, el jefe también se reasigna.
    // ================================================================
    private void actualizar(HttpServletRequest req, HttpServletResponse resp,
                             Usuario admin, String ip)
            throws IOException, ServletException {

        int idUsuario = Integer.parseInt(req.getParameter("idUsuario"));
        Usuario anterior = usuarioDAO.obtenerPorId(idUsuario);

        int idArea  = Integer.parseInt(req.getParameter("idArea"));
        int idTurno = Integer.parseInt(req.getParameter("idTurno"));

        // ---- Determinar si es jefe por el tipo de área ----
        boolean esJefe = usuarioDAO.esAreaDeJefatura(idArea);

        Usuario u = new Usuario();
        u.setIdUsuario(idUsuario);
        u.setDpi(req.getParameter("dpi"));
        u.setNombreCompleto(req.getParameter("nombreCompleto"));
        u.setEmail(req.getParameter("email"));
        u.setIdArea(idArea);
        u.setIdTurnoActual(idTurno);
        u.setEsJefeArea(esJefe);
        u.setEstado(req.getParameter("estado"));
        u.setMotivoInactivacion(req.getParameter("motivoInactivacion"));

        if (!esJefe) {
            int idJefe = usuarioDAO.obtenerJefePorAreaYTurno(idArea, idTurno);
            u.setIdJefeArea(idJefe);
        } else {
            u.setIdJefeArea(0);
        }

        if (usuarioDAO.actualizar(u)) {

            // ---- Reasignar rol si cambió el tipo de área ----
            boolean eraJefeAntes = anterior != null && anterior.isEsJefeArea();
            if (eraJefeAntes != esJefe) {
                // Limpiar roles anteriores de jefe/empleado y asignar el nuevo
                if (eraJefeAntes) {
                    usuarioDAO.eliminarRol(idUsuario, 4); // quitar JefeArea
                } else {
                    usuarioDAO.eliminarRol(idUsuario, 3); // quitar Empleado
                }
                if (esJefe) {
                    usuarioDAO.asignarRol(idUsuario, 4); // asignar JefeArea
                } else {
                    usuarioDAO.asignarRol(idUsuario, 3); // asignar Empleado
                }
            }

            String datosAnt  = anterior != null
                ? "estado=" + anterior.getEstado() + ", area=" + anterior.getIdArea()
                : "N/A";
            String datosNuev = "estado=" + u.getEstado() + ", area=" + u.getIdArea();

            historialDAO.registrar(
                "usuarios", idUsuario, "UPDATE", datosAnt, datosNuev,
                admin.getIdUsuario(), admin.getNombreCompleto(),
                ip, "Actualizacion de usuario ID " + idUsuario);

            bitacoraDAO.registrar(
                admin.getIdUsuario(), admin.getUsername(),
                admin.getNombreCompleto(),
                "Actualizar", "Usuarios",
                "Actualizo usuario ID: " + idUsuario, ip);

            resp.sendRedirect("usuarios?msg=actualizado");
        } else {
            req.setAttribute("error", "Error al actualizar.");
            doGet(req, resp);
        }
    }

    // ================================================================
    // CAMBIAR JEFE (acción dedicada)
    // Permite reasignar el jefe de un empleado sin cambiar más datos.
    // ================================================================
    private void cambiarJefe(HttpServletRequest req, HttpServletResponse resp,
                              Usuario admin, String ip)
            throws IOException {

        int idEmpleado = Integer.parseInt(req.getParameter("idEmpleado"));
        int idJefe     = Integer.parseInt(req.getParameter("idJefe"));

        Usuario empleado = usuarioDAO.obtenerPorId(idEmpleado);
        int jefeAnterior = empleado != null ? empleado.getIdJefeArea() : 0;

        String sql = "UPDATE usuarios SET id_jefe_area = ? WHERE id_usuario = ? AND es_jefe_area = 0";
        try (java.sql.Connection c = com.turnos.conexion.Conexion.getConexion();
             java.sql.PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idJefe);
            ps.setInt(2, idEmpleado);
            ps.executeUpdate();
        } catch (java.sql.SQLException e) { e.printStackTrace(); }

        historialDAO.registrar(
            "usuarios", idEmpleado, "CAMBIO_JEFE",
            "id_jefe=" + jefeAnterior,
            "id_jefe=" + idJefe,
            admin.getIdUsuario(), admin.getNombreCompleto(),
            ip, "Cambio de jefe para empleado ID " + idEmpleado);

        bitacoraDAO.registrar(
            admin.getIdUsuario(), admin.getUsername(),
            admin.getNombreCompleto(),
            "Actualizar", "Usuarios",
            "Cambio jefe del empleado ID " + idEmpleado + " al jefe ID " + idJefe, ip);

        resp.sendRedirect("usuarios?msg=jefe_actualizado");
    }

    // ================================================================
    // ROLES MANUALES (para el modal de roles extra)
    // ================================================================
    private void asignarRol(HttpServletRequest req, HttpServletResponse resp,
                             Usuario admin, String ip) throws IOException {
        int idU = Integer.parseInt(req.getParameter("idUsuario"));
        int idR = Integer.parseInt(req.getParameter("idRol"));
        usuarioDAO.asignarRol(idU, idR);
        bitacoraDAO.registrar(
            admin.getIdUsuario(), admin.getUsername(),
            admin.getNombreCompleto(),
            "Crear", "Roles",
            "Asigno rol " + idR + " a usuario " + idU, ip);
        resp.sendRedirect("usuarios?msg=rol_asignado");
    }

    private void eliminarRol(HttpServletRequest req, HttpServletResponse resp,
                              Usuario admin, String ip) throws IOException {
        int idU = Integer.parseInt(req.getParameter("idUsuario"));
        int idR = Integer.parseInt(req.getParameter("idRol"));
        usuarioDAO.eliminarRol(idU, idR);
        bitacoraDAO.registrar(
            admin.getIdUsuario(), admin.getUsername(),
            admin.getNombreCompleto(),
            "Eliminar", "Roles",
            "Elimino rol " + idR + " de usuario " + idU, ip);
        resp.sendRedirect("usuarios?msg=rol_eliminado");
    }

    // ================================================================
    // TEMPLATE EMAIL
    // ================================================================
    private String templateBienvenida(String nombre, String username, String password) {
        return "<html><body style='font-family:Arial,sans-serif;'>"
             + "<h2>Bienvenido al Sistema de Turnos</h2>"
             + "<p>Estimado/a <strong>" + nombre + "</strong>,</p>"
             + "<p>Tu cuenta ha sido creada exitosamente.</p>"
             + "<table>"
             + "<tr><td><b>Usuario:</b></td><td>" + username + "</td></tr>"
             + "<tr><td><b>Contrasena:</b></td><td>" + password + "</td></tr>"
             + "</table>"
             + "<p><i>Cambia tu contrasena al iniciar sesion.</i></p>"
             + "</body></html>";
    }
}