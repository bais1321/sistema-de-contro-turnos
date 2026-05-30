<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login"); return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Asignación de Turnos | Sistema de Turnos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800;900&family=Barlow:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --yellow:  #F5C518;
            --yellow-d:#D4A800;
            --black:   #111111;
            --gray-dk: #2a2a2a;
            --gray-md: #555555;
            --gray-lt: #e4e4e4;
            --white:   #FAFAFA;
            --red:     #E53935;
            --green:   #2E7D32;
        }
        *, *::before, *::after { box-sizing: border-box; }
        body { background: var(--white) !important; color: var(--black) !important; font-family: 'Barlow', sans-serif; }
        .main-content { background: var(--white) !important; color: var(--black) !important; }

        /* ── PAGE HEADER ── */
        .page-header {
            display: flex; align-items: flex-end;
            justify-content: space-between; flex-wrap: wrap;
            gap: 1rem; margin-bottom: 2rem;
            border-bottom: 4px solid var(--black);
            padding-bottom: 1.1rem;
        }
        .page-eyebrow {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .7rem; font-weight: 700;
            letter-spacing: 3px; text-transform: uppercase;
            color: var(--gray-md); margin-bottom: .3rem;
        }
        .page-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 3rem; font-weight: 900;
            text-transform: uppercase; line-height: 1;
            color: var(--black); margin: 0;
        }
        .page-title span { color: var(--yellow); }

        /* ── ALERTS ── */
        .alert-st {
            display: flex; align-items: center; gap: .65rem;
            padding: .8rem 1rem; border-radius: 3px;
            font-size: .88rem; font-weight: 500; margin-bottom: 1.5rem;
        }
        .alert-success { background:#e8f5e9; border:1.5px solid #a5d6a7; color:var(--green); }
        .alert-error   { background:#ffebee; border:1.5px solid #ef9a9a; color:var(--red); }

        /* ── LAYOUT ── */
        .layout-grid {
            display: grid;
            grid-template-columns: 340px 1fr;
            gap: 1.5rem;
            align-items: start;
        }
        @media (max-width: 992px) { .layout-grid { grid-template-columns: 1fr; } }

        /* ── FORM CARD ── */
        .form-card {
            border: 2px solid var(--black);
            border-radius: 4px;
            overflow: hidden;
        }
        .form-card-header {
            background: var(--black);
            padding: .9rem 1.25rem;
            display: flex; align-items: center; gap: .6rem;
        }
        .form-card-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .9rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: var(--yellow); margin: 0;
        }
        .form-card-body { padding: 1.25rem; background: var(--white); }

        /* ── FORM INPUTS ── */
        .f-group { margin-bottom: 1rem; }
        .f-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--gray-md); display: block; margin-bottom: .35rem;
        }
        .f-label .req { color: var(--red); }
        .f-input {
            width: 100%; border: 2px solid var(--gray-lt); border-radius: 3px;
            background: var(--white); color: var(--black);
            padding: .6rem .85rem; font-family: 'Barlow', sans-serif; font-size: .88rem;
            transition: border-color .15s;
        }
        .f-input:focus { outline: none; border-color: var(--yellow); box-shadow: 2px 2px 0 var(--yellow); }
        .f-input::placeholder { color: #bbb; }
        select.f-input option { background: var(--white); color: var(--black); }
        textarea.f-input { resize: vertical; }
        input[type="date"].f-input { color-scheme: light; }

        .btn-submit {
            width: 100%; padding: .8rem;
            background: var(--black); color: var(--yellow);
            border: 2px solid var(--black); border-radius: 3px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .95rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1.5px;
            cursor: pointer; transition: all .15s;
            display: flex; align-items: center;
            justify-content: center; gap: .5rem;
            margin-top: .5rem;
        }
        .btn-submit:hover { background: var(--yellow); color: var(--black); }

        /* ── TURNOS LIST ── */
        .turnos-list { margin-top: 1.25rem; }
        .turno-item {
            display: flex; align-items: center; gap: .85rem;
            padding: .85rem 1rem;
            border: 1.5px solid var(--gray-lt);
            border-radius: 3px; margin-bottom: .5rem;
            background: var(--white);
            transition: border-color .15s, background .15s;
        }
        .turno-item:hover { border-color: var(--yellow); background: #fffbe6; }
        .turno-item:last-child { margin-bottom: 0; }
        .turno-icon {
            width: 36px; height: 36px;
            background: var(--black); border-radius: 3px;
            display: flex; align-items: center; justify-content: center;
            color: var(--yellow); font-size: .9rem; flex-shrink: 0;
        }
        .turno-name {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .95rem; font-weight: 800;
            text-transform: uppercase; color: var(--black);
        }
        .turno-hours {
            font-size: .75rem; color: var(--gray-md);
            font-weight: 500; margin-top: .1rem;
        }

        /* ── RIGHT PANEL ── */
        .right-panel {}
        .section-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: var(--black); margin-bottom: 1rem;
            display: flex; align-items: center; gap: .5rem;
        }
        .section-title::before {
            content: '';
            display: inline-block; width: 4px; height: 1em;
            background: var(--yellow); border-radius: 2px; flex-shrink: 0;
        }

        /* ── TABLE ── */
        .table-wrap { border: 2px solid var(--black); border-radius: 3px; overflow: hidden; }
        table.at-table { width: 100%; border-collapse: collapse; font-size: .86rem; }
        table.at-table thead tr { background: var(--black); }
        table.at-table thead th {
            padding: .7rem .9rem; color: var(--white);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px; border: none;
        }
        table.at-table thead th:first-child { color: var(--yellow); }
        table.at-table tbody tr { border-bottom: 1px solid var(--gray-lt); }
        table.at-table tbody tr:last-child { border-bottom: none; }
        table.at-table tbody tr:hover { background: #fffbe6; }
        table.at-table tbody td { padding: .75rem .9rem; color: var(--black); border: none; vertical-align: middle; }

        .badge-st {
            display: inline-flex; align-items: center; gap: .25rem;
            padding: .18rem .6rem; border-radius: 2px;
            font-size: .68rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .6px;
            font-family: 'Barlow Condensed', sans-serif;
        }
        .b-turno  { background: var(--yellow); color: var(--black); border: 1px solid var(--yellow-d); }
        .b-activo { background:#e8f5e9; color:var(--green); border:1px solid #a5d6a7; }

        .empty-cell {
            text-align:center; padding:2.5rem !important;
            font-family:'Barlow Condensed',sans-serif;
            font-size:.95rem; font-weight:700;
            text-transform:uppercase; letter-spacing:1px;
            color:var(--gray-md) !important;
        }
    </style>
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="main-content">

    <!-- HEADER -->
    <div class="page-header">
        <div>
            <p class="page-eyebrow">Administración de Personal</p>
            <h1 class="page-title">Asignación de <span>Turnos</span></h1>
        </div>
    </div>

    <!-- ALERTS -->
    <% if ("asignado".equals(request.getParameter("msg"))) { %>
    <div class="alert-st alert-success">
        <i class="bi bi-check-circle-fill"></i> Turno asignado correctamente.
    </div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
    <div class="alert-st alert-error">
        <i class="bi bi-x-circle-fill"></i> Error al asignar el turno.
    </div>
    <% } %>

    <!-- LAYOUT -->
    <div class="layout-grid">

        <!-- COLUMNA IZQUIERDA -->
        <div>
            <!-- Formulario -->
            <div class="form-card">
                <div class="form-card-header">
                    <i class="bi bi-plus-circle" style="color:var(--yellow);"></i>
                    <h6 class="form-card-title">Nueva Asignación</h6>
                </div>
                <div class="form-card-body">
                    <form action="asignacion-turno" method="post">
                        <div class="f-group">
                            <label class="f-label">Empleado <span class="req">*</span></label>
                            <select name="idUsuario" class="f-input" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="emp" items="${usuarios}">
                                    <option value="${emp.idUsuario}">
                                        <c:out value="${emp.nombreCompleto}"/>
                                        (<c:out value="${emp.nombreArea}"/>)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Nuevo Turno <span class="req">*</span></label>
                            <select name="idTurno" class="f-input" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="t" items="${turnos}">
                                    <option value="${t.idTurno}">
                                        <c:out value="${t.nombreTurno}"/>
                                        (<c:out value="${t.horaInicio}"/> - <c:out value="${t.horaFin}"/>)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Fecha Inicio <span class="req">*</span></label>
                            <input type="date" name="fechaInicio" class="f-input" required>
                        </div>
                        <div class="f-group">
                            <label class="f-label">
                                Fecha Fin
                                <span style="font-weight:400;text-transform:none;font-size:.68rem;color:#bbb;">(opcional)</span>
                            </label>
                            <input type="date" name="fechaFin" class="f-input">
                        </div>
                        <div class="f-group">
                            <label class="f-label">Observaciones</label>
                            <textarea name="observaciones" class="f-input" rows="2"
                                      placeholder="Notas adicionales..."></textarea>
                        </div>
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-calendar-check"></i>
                            Asignar Turno
                        </button>
                    </form>
                </div>
            </div>

            <!-- Turnos disponibles -->
            <div class="turnos-list">
                <div class="section-title" style="margin-top:1.5rem;">
                    <i class="bi bi-clock"></i> Turnos Disponibles
                </div>
                <c:forEach var="t" items="${turnos}">
                    <div class="turno-item">
                        <div class="turno-icon">
                            <i class="bi bi-clock"></i>
                        </div>
                        <div>
                            <div class="turno-name"><c:out value="${t.nombreTurno}"/></div>
                            <div class="turno-hours">
                                <c:out value="${t.horaInicio}"/> — <c:out value="${t.horaFin}"/>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- COLUMNA DERECHA: historial -->
        <div class="right-panel">
            <div class="section-title">
                <i class="bi bi-clock-history"></i>
                Historial de Asignaciones
            </div>
            <div class="table-wrap">
                <table class="at-table">
                    <thead>
                        <tr>
                            <th>Empleado</th>
                            <th>Turno Asignado</th>
                            <th>Fecha Inicio</th>
                            <th>Fecha Fin</th>
                            <th>Estado</th>
                            <th>Observaciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${asignaciones}">
                        <tr>
                            <td style="font-weight:600;">
                                <c:out value="${a.nombre_completo}"/>
                            </td>
                            <td>
                                <span class="badge-st b-turno">
                                    <i class="bi bi-clock"></i>
                                    <c:out value="${a.nombre_turno}"/>
                                </span>
                            </td>
                            <td style="color:var(--gray-md);">
                                <c:out value="${a.fecha_inicio}"/>
                            </td>
                            <td style="color:var(--gray-md);">
                                <c:out value="${a.fecha_fin}"/>
                            </td>
                            <td>
                                <span class="badge-st b-activo">
                                    <c:out value="${a.estado}"/>
                                </span>
                            </td>
                            <td style="max-width:160px;overflow:hidden;
                                       text-overflow:ellipsis;white-space:nowrap;
                                       color:var(--gray-md);font-size:.8rem;"
                                title="${a.observaciones}">
                                <c:out value="${a.observaciones}"/>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty asignaciones}">
                        <tr>
                            <td colspan="6" class="empty-cell">
                                <i class="bi bi-calendar-x me-1"></i>
                                Sin asignaciones registradas
                            </td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
