<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login"); return;
    }
    com.turnos.modelo.Usuario u =
        (com.turnos.modelo.Usuario) session.getAttribute("usuario");
    boolean tieneJefe = u != null && u.getIdJefeArea() > 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitudes | Sistema de Turnos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800;900&family=Barlow:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* ── TOKENS ─────────────────────────────── */
        :root {
            --yellow:   #F5C518;
            --yellow-d: #D4A800;
            --black:    #111111;
            --gray-dk:  #2a2a2a;
            --gray-md:  #555555;
            --gray-lt:  #e8e8e8;
            --white:    #FAFAFA;
            --red:      #E53935;
            --green:    #2E7D32;
            --blue:     #1565C0;
            --radius:   4px;
        }

        *, *::before, *::after { box-sizing: border-box; }

        body {
            background: var(--white);
            color: var(--black);
            font-family: 'Barlow', sans-serif;
            font-size: 15px;
            margin: 0;
        }

        .main-content {
            background: var(--white) !important;
            color: var(--black) !important;
            min-height: 100vh;
            padding: 2.5rem 2rem 3rem !important;
        }

        /* ── PAGE HEADER ────────────────────────── */
        .page-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1.25rem;
            margin-bottom: 2rem;
            border-bottom: 4px solid var(--black);
            padding-bottom: 1.25rem;
        }
        .page-eyebrow {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .7rem;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: var(--gray-md);
            margin-bottom: .3rem;
        }
        .page-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 3rem;
            font-weight: 900;
            line-height: 1;
            text-transform: uppercase;
            color: var(--black);
            margin: 0;
        }
        .page-title span { color: var(--yellow); }

        /* ── BUTTON ─────────────────────────────── */
        .btn-primary-st {
            background: var(--black);
            color: var(--yellow);
            border: 2px solid var(--black);
            border-radius: var(--radius);
            padding: .6rem 1.4rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .9rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all .15s;
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            text-decoration: none;
        }
        .btn-primary-st:hover {
            background: var(--yellow);
            color: var(--black);
        }
        .btn-outline-st {
            background: transparent;
            color: var(--black);
            border: 2px solid var(--black);
            border-radius: var(--radius);
            padding: .5rem 1.2rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .85rem;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            transition: all .15s;
        }
        .btn-outline-st:hover {
            background: var(--black);
            color: var(--white);
        }
        .btn-approve {
            background: #e8f5e9;
            color: var(--green);
            border: 1.5px solid #a5d6a7;
            border-radius: var(--radius);
            padding: .3rem .9rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .78rem;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            transition: all .15s;
        }
        .btn-approve:hover { background: #c8e6c9; }
        .btn-reject {
            background: #ffebee;
            color: var(--red);
            border: 1.5px solid #ef9a9a;
            border-radius: var(--radius);
            padding: .3rem .9rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .78rem;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            transition: all .15s;
        }
        .btn-reject:hover { background: #ffcdd2; }
        .btn-confirm-green {
            background: var(--green);
            color: #fff;
            border: 2px solid var(--green);
            border-radius: var(--radius);
            padding: .55rem 1.3rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .88rem;
            font-weight: 800;
            text-transform: uppercase;
            cursor: pointer;
            transition: all .15s;
        }
        .btn-confirm-green:hover { opacity: .88; }
        .btn-confirm-red {
            background: var(--red);
            color: #fff;
            border: 2px solid var(--red);
            border-radius: var(--radius);
            padding: .55rem 1.3rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .88rem;
            font-weight: 800;
            text-transform: uppercase;
            cursor: pointer;
            transition: all .15s;
        }
        .btn-confirm-red:hover { opacity: .88; }

        /* ── ALERTS ─────────────────────────────── */
        .alert-st {
            display: flex;
            align-items: center;
            gap: .75rem;
            padding: .85rem 1.1rem;
            border-radius: var(--radius);
            font-size: .88rem;
            margin-bottom: 1.25rem;
            font-weight: 500;
        }
        .alert-success {
            background: #e8f5e9;
            border: 1.5px solid #a5d6a7;
            color: var(--green);
        }
        .alert-error {
            background: #ffebee;
            border: 1.5px solid #ef9a9a;
            color: var(--red);
        }

        /* ── FLUJO DE APROBACIÓN ─────────────────── */
        .flow-bar {
            display: flex;
            align-items: center;
            gap: 0;
            background: var(--black);
            border-radius: var(--radius);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .flow-step {
            flex: 1;
            display: flex;
            align-items: center;
            gap: .55rem;
            padding: .85rem 1rem;
            color: rgba(255,255,255,.45);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
        }
        .flow-step + .flow-step::before {
            content: '›';
            position: absolute;
            left: 0;
            color: rgba(255,255,255,.15);
            font-size: 1.4rem;
        }
        .flow-step .step-num {
            width: 24px; height: 24px;
            border-radius: 2px;
            background: rgba(255,255,255,.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: .78rem;
            font-weight: 900;
            flex-shrink: 0;
        }
        .flow-step.active {
            color: var(--black);
            background: var(--yellow);
        }
        .flow-step.active .step-num {
            background: var(--black);
            color: var(--yellow);
        }
        .flow-step.done { color: rgba(255,255,255,.7); }
        .flow-step.done .step-num {
            background: rgba(255,255,255,.15);
            color: #fff;
        }

        /* ── SECTION ─────────────────────────────── */
        .section-block {
            margin-bottom: 2rem;
        }
        .section-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.05rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--black);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: .5rem;
            padding-bottom: .5rem;
            border-bottom: 2px solid var(--gray-lt);
        }
        .section-title .accent-bar {
            width: 4px;
            height: 1em;
            background: var(--yellow);
            border-radius: 2px;
            flex-shrink: 0;
        }
        .section-title.red-accent .accent-bar { background: var(--red); }

        /* ── TABLE ──────────────────────────────── */
        .table-wrap {
            border: 2px solid var(--black);
            border-radius: var(--radius);
            overflow: hidden;
        }
        table.sol-table {
            width: 100%;
            border-collapse: collapse;
            font-size: .88rem;
        }
        table.sol-table thead tr {
            background: var(--black);
        }
        table.sol-table thead th {
            padding: .7rem 1rem;
            color: var(--white);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            border: none;
        }
        table.sol-table thead th:first-child { color: var(--yellow); }
        table.sol-table tbody tr {
            border-bottom: 1px solid var(--gray-lt);
            transition: background .1s;
        }
        table.sol-table tbody tr:last-child { border-bottom: none; }
        table.sol-table tbody tr:hover { background: #fffbe6; }
        table.sol-table tbody td {
            padding: .8rem 1rem;
            vertical-align: middle;
            color: var(--black);
        }

        /* ── BADGES ─────────────────────────────── */
        .badge-st {
            display: inline-flex;
            align-items: center;
            gap: .25rem;
            padding: .18rem .6rem;
            border-radius: 2px;
            font-size: .68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .6px;
        }
        .b-aprobada   { background:#e8f5e9; color:var(--green); border:1px solid #a5d6a7; }
        .b-rechazada  { background:#ffebee; color:var(--red);   border:1px solid #ef9a9a; }
        .b-pendiente  { background:#fff8e1; color:#bf8600;      border:1px solid var(--yellow); }
        .b-jefe       { background:#e3f2fd; color:var(--blue);  border:1px solid #90caf9; }
        .b-tipo       { background:var(--yellow); color:var(--black); border:1px solid var(--yellow-d); }

        /* ── EMPTY ──────────────────────────────── */
        .empty-row td {
            text-align: center;
            padding: 2.5rem !important;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--gray-md) !important;
        }

        /* ── MODALES ────────────────────────────── */
        .modal { z-index: 9999 !important; }
        .modal-backdrop { z-index: 9998 !important; }
        .modal-content {
            background: var(--white) !important;
            border: 2px solid var(--black) !important;
            border-radius: var(--radius) !important;
            color: var(--black) !important;
            box-shadow: 6px 6px 0 var(--black) !important;
        }
        .modal-header {
            border-bottom: 2px solid var(--black) !important;
            padding: 1rem 1.25rem !important;
            background: var(--black) !important;
        }
        .modal-title {
            font-family: 'Barlow Condensed', sans-serif !important;
            font-size: 1.1rem !important;
            font-weight: 800 !important;
            text-transform: uppercase !important;
            letter-spacing: 1px !important;
            color: var(--yellow) !important;
        }
        .modal-body { padding: 1.25rem !important; background: var(--white) !important; }
        .modal-footer {
            border-top: 1.5px solid var(--gray-lt) !important;
            padding: .85rem 1.25rem !important;
            background: var(--white) !important;
        }
        .btn-close { filter: invert(1) opacity(.7) !important; }

        /* ── FORM INPUTS ────────────────────────── */
        .f-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--gray-md);
            display: block;
            margin-bottom: .35rem;
        }
        .f-label .req { color: var(--red); }
        .f-input {
            width: 100%;
            border: 2px solid var(--gray-lt);
            border-radius: var(--radius);
            background: var(--white);
            color: var(--black);
            padding: .6rem .85rem;
            font-family: 'Barlow', sans-serif;
            font-size: .88rem;
            transition: border-color .15s;
        }
        .f-input:focus {
            outline: none;
            border-color: var(--yellow);
            box-shadow: 2px 2px 0 var(--yellow);
        }
        select.f-input option { background: var(--white); color: var(--black); }
        textarea.f-input { resize: vertical; }
        input[type="date"].f-input { color-scheme: light; }

        /* ── ROUTE INFO ─────────────────────────── */
        .route-info {
            display: flex;
            align-items: center;
            gap: .7rem;
            padding: .75rem 1rem;
            border-radius: var(--radius);
            font-size: .82rem;
            font-weight: 500;
            margin-top: .5rem;
        }
        .route-rrhh {
            background: #e3f2fd;
            border: 1.5px solid #90caf9;
            color: var(--blue);
        }
        .route-jefe {
            background: #fff8e1;
            border: 1.5px solid var(--yellow);
            color: #7a5000;
        }

        @media (max-width: 640px) {
            .page-title { font-size: 2.2rem; }
            .flow-bar { flex-direction: column; }
            .flow-step + .flow-step::before { display: none; }
            .main-content { padding: 1.5rem 1rem 2rem !important; }
        }
    </style>
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="main-content">

    <!-- HEADER -->
    <div class="page-header">
        <div>
            <p class="page-eyebrow">Gestión de Permisos</p>
            <h1 class="page-title">Solicitudes <span>de Permiso</span></h1>
        </div>
        <button class="btn-primary-st"
                data-bs-toggle="modal"
                data-bs-target="#modalNueva">
            <i class="bi bi-plus-lg"></i>
            Nueva Solicitud
        </button>
    </div>

    <!-- ALERTAS -->
    <% if ("enviada".equals(request.getParameter("msg"))) { %>
    <div class="alert-st alert-success">
        <i class="bi bi-check-circle-fill"></i>
        Solicitud enviada correctamente.
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert-st alert-error">
        <i class="bi bi-x-circle-fill"></i>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <!-- FLUJO DE APROBACIÓN -->
    <div class="flow-bar">
        <div class="flow-step active">
            <div class="step-num">1</div>
            <span>Empleado Solicita</span>
        </div>
        <div class="flow-step">
            <div class="step-num">2</div>
            <span>Jefe Aprueba</span>
        </div>
        <div class="flow-step">
            <div class="step-num">3</div>
            <span>RRHH Autoriza</span>
        </div>
        <div class="flow-step">
            <div class="step-num">4</div>
            <span>Notificación</span>
        </div>
    </div>

    <!-- SOLICITUDES PENDIENTES PARA JEFE DE ÁREA -->
    <% if ((u.tieneRol("JefeArea") || u.isEsJefeArea())
           && request.getAttribute("solicitudesJefe") != null) { %>
    <div class="section-block">
        <div class="section-title red-accent">
            <span class="accent-bar"></span>
            <i class="bi bi-people-fill"></i>
            Solicitudes Pendientes de mi Área
        </div>
        <div class="table-wrap">
            <table class="sol-table">
                <thead>
                    <tr>
                        <th>Empleado</th>
                        <th>Tipo</th>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Motivo</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${solicitudesJefe}">
                    <tr>
                        <td style="font-weight:600;">${s.nombreSolicitante}</td>
                        <td>
                            <span class="badge-st b-tipo">
                                ${s.nombreTipoSolicitud}
                            </span>
                        </td>
                        <td style="color:var(--gray-md);">${s.fechaInicio}</td>
                        <td style="color:var(--gray-md);">${s.fechaFin}</td>
                        <td style="max-width:140px;overflow:hidden;
                                   text-overflow:ellipsis;white-space:nowrap;
                                   color:var(--gray-md);">${s.motivo}</td>
                        <td>
                            <div style="display:flex;gap:.4rem;">
                                <button class="btn-approve"
                                        data-bs-toggle="modal"
                                        data-bs-target="#apJ${s.idSolicitud}">
                                    <i class="bi bi-check2"></i> Aprobar
                                </button>
                                <button class="btn-reject"
                                        data-bs-toggle="modal"
                                        data-bs-target="#reJ${s.idSolicitud}">
                                    <i class="bi bi-x"></i> Rechazar
                                </button>
                            </div>
                        </td>
                    </tr>
                    </c:forEach>
                    <c:if test="${empty solicitudesJefe}">
                    <tr class="empty-row">
                        <td colspan="6">No hay solicitudes pendientes en tu área</td>
                    </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <!-- MIS SOLICITUDES -->
    <div class="section-block">
        <div class="section-title">
            <span class="accent-bar"></span>
            <i class="bi bi-file-earmark-text"></i>
            Mis Solicitudes
        </div>
        <div class="table-wrap">
            <table class="sol-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tipo</th>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Días</th>
                        <th>Estado</th>
                        <th>Comentario</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${misSolicitudes}">
                    <tr>
                        <td style="color:var(--gray-md);font-size:.8rem;">
                            #${s.idSolicitud}
                        </td>
                        <td style="font-weight:600;">${s.nombreTipoSolicitud}</td>
                        <td style="color:var(--gray-md);">${s.fechaInicio}</td>
                        <td style="color:var(--gray-md);">${s.fechaFin}</td>
                        <td style="text-align:center;font-weight:700;">
                            ${s.diasSolicitados}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${'AprobadaRRHH' eq s.estadoAprobacion}">
                                    <span class="badge-st b-aprobada">
                                        <i class="bi bi-check-circle-fill"></i>
                                        Aprobada
                                    </span>
                                </c:when>
                                <c:when test="${'RechazadaJefe' eq s.estadoAprobacion or 'RechazadaRRHH' eq s.estadoAprobacion}">
                                    <span class="badge-st b-rechazada">
                                        <i class="bi bi-x-circle-fill"></i>
                                        ${s.estadoAprobacion}
                                    </span>
                                </c:when>
                                <c:when test="${'AprobadaJefe' eq s.estadoAprobacion}">
                                    <span class="badge-st b-jefe">
                                        <i class="bi bi-person-check"></i>
                                        Aprobada Jefe
                                    </span>
                                </c:when>
                                <c:when test="${'PendienteRRHH' eq s.estadoAprobacion}">
                                    <span class="badge-st b-jefe">
                                        <i class="bi bi-hourglass-split"></i>
                                        Pendiente RRHH
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-st b-pendiente">
                                        <i class="bi bi-hourglass"></i>
                                        Pendiente
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="max-width:160px;overflow:hidden;
                                   text-overflow:ellipsis;white-space:nowrap;
                                   color:var(--gray-md);font-size:.8rem;"
                            title="${s.comentarioJefe} ${s.comentarioAprobacionRrhh}">
                            <c:if test="${not empty s.comentarioJefe}">
                                ${s.comentarioJefe}
                            </c:if>
                            <c:if test="${not empty s.comentarioAprobacionRrhh}">
                                | ${s.comentarioAprobacionRrhh}
                            </c:if>
                        </td>
                    </tr>
                    </c:forEach>
                    <c:if test="${empty misSolicitudes}">
                    <tr class="empty-row">
                        <td colspan="7">No tiene solicitudes registradas aún</td>
                    </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div><!-- /main-content -->

<!-- ================================================================
     MODAL: NUEVA SOLICITUD
     ================================================================ -->
<div class="modal fade" id="modalNueva" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:500px;">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">
                    <i class="bi bi-file-earmark-plus me-2"></i>
                    Nueva Solicitud
                </h6>
                <button type="button" class="btn-close"
                        data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <form action="solicitudes" method="post">
                <input type="hidden" name="action" value="guardar">
                <div class="modal-body">
                    <div style="display:flex;flex-direction:column;gap:.85rem;">

                        <div>
                            <label class="f-label">
                                Tipo de Solicitud <span class="req">*</span>
                            </label>
                            <select name="idTipoSolicitud" class="f-input" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="t" items="${tipos}">
                                <option value="${t.idTipoSolicitud}">
                                    ${t.nombreTipo}
                                    <c:if test="${t.diasMaximos > 0}">
                                        (máx. ${t.diasMaximos} días)
                                    </c:if>
                                </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:.75rem;">
                            <div>
                                <label class="f-label">
                                    Fecha Inicio <span class="req">*</span>
                                </label>
                                <input type="date" name="fechaInicio"
                                       class="f-input" required
                                       min="<%= java.time.LocalDate.now() %>">
                            </div>
                            <div>
                                <label class="f-label">
                                    Fecha Fin <span class="req">*</span>
                                </label>
                                <input type="date" name="fechaFin"
                                       class="f-input" required
                                       min="<%= java.time.LocalDate.now() %>">
                            </div>
                        </div>

                        <div>
                            <label class="f-label">
                                Motivo <span class="req">*</span>
                            </label>
                            <textarea name="motivo" class="f-input"
                                      rows="3" required
                                      placeholder="Describa el motivo..."></textarea>
                        </div>

                        <div>
                            <label class="f-label">
                                Justificación
                                <span style="font-weight:400;text-transform:none;
                                             font-size:.68rem;color:#999;">(opcional)</span>
                            </label>
                            <textarea name="justificacion" class="f-input"
                                      rows="2"
                                      placeholder="Información adicional..."></textarea>
                        </div>

                        <!-- Ruta de la solicitud -->
                        <% if (!tieneJefe) { %>
                        <div class="route-info route-rrhh">
                            <i class="bi bi-arrow-right-circle-fill" style="flex-shrink:0;"></i>
                            <span>Tu solicitud irá directamente a <strong>RRHH</strong>.</span>
                        </div>
                        <% } else { %>
                        <div class="route-info route-jefe">
                            <i class="bi bi-diagram-3-fill" style="flex-shrink:0;"></i>
                            <span>Tu solicitud irá primero a tu <strong>Jefe de Área</strong> y luego a <strong>RRHH</strong>.</span>
                        </div>
                        <% } %>

                    </div>
                </div>
                <div class="modal-footer" style="display:flex;justify-content:flex-end;gap:.6rem;">
                    <button type="button" class="btn-outline-st"
                            data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn-primary-st">
                        <i class="bi bi-send"></i>
                        Enviar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ================================================================
     MODALES: APROBAR / RECHAZAR POR JEFE
     ================================================================ -->
<c:forEach var="s" items="${solicitudesJefe}">

    <!-- Aprobar -->
    <div class="modal fade" id="apJ${s.idSolicitud}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" style="color:#6ee7b7 !important;">
                        <i class="bi bi-check-circle me-2"></i>
                        Aprobar Solicitud
                    </h6>
                    <button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <form action="aprobaciones" method="post">
                    <input type="hidden" name="action" value="aprobarJefe">
                    <input type="hidden" name="idSolicitud" value="${s.idSolicitud}">
                    <div class="modal-body">
                        <p style="font-size:.88rem;color:var(--gray-md);margin-bottom:1rem;">
                            Aprobar solicitud de
                            <strong style="color:var(--black);">${s.nombreSolicitante}</strong>.
                            Pasará a RRHH para autorización final.
                        </p>
                        <label class="f-label">Comentario <span style="font-weight:400;text-transform:none;font-size:.68rem;color:#999;">(opcional)</span></label>
                        <textarea name="comentario" class="f-input" rows="2"
                                  placeholder="Comentario..."></textarea>
                    </div>
                    <div class="modal-footer" style="display:flex;justify-content:flex-end;gap:.6rem;">
                        <button type="button" class="btn-outline-st"
                                data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn-confirm-green">
                            <i class="bi bi-check2 me-1"></i> Confirmar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Rechazar -->
    <div class="modal fade" id="reJ${s.idSolicitud}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" style="color:#fca5a5 !important;">
                        <i class="bi bi-x-circle me-2"></i>
                        Rechazar Solicitud
                    </h6>
                    <button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <form action="aprobaciones" method="post">
                    <input type="hidden" name="action" value="rechazarJefe">
                    <input type="hidden" name="idSolicitud" value="${s.idSolicitud}">
                    <div class="modal-body">
                        <p style="font-size:.88rem;color:var(--gray-md);margin-bottom:1rem;">
                            Rechazar solicitud de
                            <strong style="color:var(--black);">${s.nombreSolicitante}</strong>.
                            El empleado será notificado.
                        </p>
                        <label class="f-label">
                            Motivo del Rechazo <span class="req">*</span>
                        </label>
                        <textarea name="comentario" class="f-input" rows="2"
                                  required placeholder="Indique el motivo..."></textarea>
                    </div>
                    <div class="modal-footer" style="display:flex;justify-content:flex-end;gap:.6rem;">
                        <button type="button" class="btn-outline-st"
                                data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn-confirm-red">
                            <i class="bi bi-x me-1"></i> Confirmar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
