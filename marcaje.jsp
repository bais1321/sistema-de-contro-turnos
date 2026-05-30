<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    com.turnos.modelo.Usuario u =
        (com.turnos.modelo.Usuario) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marcaje | Sistema de Turnos</title>
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
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 2rem;
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
            padding: .75rem 1rem; border-radius: 3px;
            font-size: .88rem; font-weight: 500; margin-bottom: 1.25rem;
        }
        .alert-success { background:#e8f5e9; border:1.5px solid #a5d6a7; color:var(--green); }
        .alert-error   { background:#ffebee; border:1.5px solid #ef9a9a; color:var(--red); }

        /* ── STATUS BANNER ── */
        .status-banner {
            border: 2px solid var(--black);
            border-radius: 4px;
            padding: 1rem 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            margin-bottom: 1.5rem;
            background: var(--white);
        }
        .status-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: var(--gray-md);
        }
        .status-value {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.1rem; font-weight: 900;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--black);
            background: var(--yellow);
            padding: .2rem .85rem;
            border-radius: 2px;
        }
        .status-value.sin-iniciar { background: var(--gray-lt); color: var(--gray-md); }

        /* ── MARCAJE BUTTONS GRID ── */
        .marcaje-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: .85rem;
            margin-bottom: 1.25rem;
        }
        @media (max-width: 480px) { .marcaje-grid { grid-template-columns: repeat(2,1fr); } }

        .btn-marcaje {
            border: 2px solid var(--black);
            border-radius: 4px;
            padding: 1.2rem .75rem;
            background: var(--white);
            color: var(--black);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .5rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .88rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .8px;
            cursor: pointer;
            transition: all .15s;
            width: 100%;
        }
        .btn-marcaje i { font-size: 1.5rem; }
        .btn-marcaje:hover:not(:disabled) {
            background: var(--black);
            color: var(--yellow);
            transform: translateY(-2px);
            box-shadow: 3px 3px 0 var(--yellow);
        }
        .btn-marcaje.entrada:hover:not(:disabled)  { background: #1b5e20; color: #fff; box-shadow: 3px 3px 0 #1b5e20; }
        .btn-marcaje.salida:hover:not(:disabled)   { background: var(--red); color: #fff; box-shadow: 3px 3px 0 var(--red); }
        .btn-marcaje.break:hover:not(:disabled)    { background: #e65100; color: #fff; box-shadow: 3px 3px 0 #e65100; }

        .btn-marcaje:disabled {
            opacity: .25;
            cursor: not-allowed;
            border-color: var(--gray-lt);
            color: var(--gray-md);
            background: #f5f5f5;
        }

        /* ── TIMER BOXES ── */
        .timer-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: .75rem;
            margin-top: 1rem;
        }
        .timer-box {
            border: 2px solid var(--black);
            border-radius: 4px;
            padding: .85rem 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--white);
        }
        .timer-box.yellow { background: var(--yellow); }
        .timer-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--gray-md);
        }
        .timer-box.yellow .timer-label { color: rgba(0,0,0,.5); }
        .timer-value {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.5rem; font-weight: 900;
            color: var(--black); line-height: 1;
        }

        /* ── BLOCKS ── */
        .block {
            border: 2px solid var(--black);
            border-radius: 4px;
            overflow: hidden;
            height: 100%;
        }
        .block-header {
            background: var(--black);
            padding: .85rem 1.25rem;
            display: flex;
            align-items: center;
            gap: .6rem;
        }
        .block-header-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .88rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1.5px;
            color: var(--yellow); margin: 0;
        }
        .block-body { padding: 1.25rem; background: var(--white); }

        /* ── TABLE ── */
        table.marc-table { width:100%; border-collapse:collapse; font-size:.88rem; }
        table.marc-table thead tr { background: var(--gray-lt); }
        table.marc-table thead th {
            padding: .6rem .9rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.2px;
            color: var(--gray-dk); border: none;
        }
        table.marc-table tbody tr { border-bottom: 1px solid var(--gray-lt); }
        table.marc-table tbody tr:last-child { border-bottom: none; }
        table.marc-table tbody tr:hover { background: #fffbe6; }
        table.marc-table tbody td { padding: .75rem .9rem; color: var(--black); border: none; vertical-align: middle; }
        .badge-st {
            display:inline-flex; align-items:center; gap:.25rem;
            padding:.18rem .6rem; border-radius:2px;
            font-size:.68rem; font-weight:700;
            text-transform:uppercase; letter-spacing:.6px;
        }
        .b-ok   { background:#e8f5e9; color:#2E7D32; border:1px solid #a5d6a7; }
        .b-late { background:#ffebee; color:#E53935; border:1px solid #ef9a9a; }
        .b-none { color:var(--gray-md); font-size:.78rem; }
        .empty-cell {
            text-align:center; padding:2rem !important;
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
            <p class="page-eyebrow">Asistencia del día</p>
            <h1 class="page-title">Control de <span>Marcaje</span></h1>
        </div>
    </div>

    <div class="row g-4">

        <!-- PANEL IZQUIERDO: Estación de marcaje -->
        <div class="col-12 col-xl-6">
            <div class="block">
                <div class="block-header">
                    <i class="bi bi-fingerprint" style="color:var(--yellow);font-size:1.1rem;"></i>
                    <h6 class="block-header-title">Estación de Marcaje Digital</h6>
                </div>
                <div class="block-body">

                    <!-- Alertas -->
                    <c:if test="${not empty error}">
                    <div class="alert-st alert-error">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        ${error}
                    </div>
                    </c:if>
                    <c:if test="${not empty mensaje}">
                    <div class="alert-st alert-success">
                        <i class="bi bi-check-circle-fill"></i>
                        ${mensaje}
                    </div>
                    </c:if>

                    <!-- Estado actual -->
                    <div class="status-banner">
                        <span class="status-label">Estado operacional de hoy</span>
                        <span class="status-value ${empty marcajeHoy ? 'sin-iniciar' : ''}">
                            <c:choose>
                                <c:when test="${empty marcajeHoy}">Sin Iniciar</c:when>
                                <c:otherwise>${marcajeHoy.estadoMarcaje}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- Botones de marcaje -->
                    <div class="marcaje-grid">

                        <form action="marcaje?action=entrada" method="POST" style="display:contents;">
                            <button type="submit" class="btn-marcaje entrada"
                                    ${not empty marcajeHoy ? 'disabled' : ''}>
                                <i class="bi bi-box-arrow-in-right"></i>
                                Entrada
                            </button>
                        </form>

                        <form action="marcaje?action=break" method="POST" style="display:contents;">
                            <button type="submit" class="btn-marcaje break"
                                    ${(empty marcajeHoy || marcajeHoy.estadoMarcaje ne 'ACTIVO') ? 'disabled' : ''}>
                                <i class="bi bi-cup-hot"></i>
                                Inicio Break
                            </button>
                        </form>

                        <form action="marcaje?action=finBreak" method="POST" style="display:contents;">
                            <button type="submit" class="btn-marcaje"
                                    ${(empty marcajeHoy || marcajeHoy.estadoMarcaje ne 'EN BREAK') ? 'disabled' : ''}>
                                <i class="bi bi-reply-all"></i>
                                Fin Break
                            </button>
                        </form>

                        <form action="marcaje?action=almuerzo" method="POST" style="display:contents;">
                            <button type="submit" class="btn-marcaje"
                                    ${(empty marcajeHoy || marcajeHoy.estadoMarcaje ne 'ACTIVO') ? 'disabled' : ''}>
                                <i class="bi bi-egg-fried"></i>
                                Almuerzo
                            </button>
                        </form>

                        <form action="marcaje?action=finAlmuerzo" method="POST" style="display:contents;">
                            <button type="submit" class="btn-marcaje"
                                    ${(empty marcajeHoy || marcajeHoy.estadoMarcaje ne 'EN ALMUERZO') ? 'disabled' : ''}>
                                <i class="bi bi-arrow-left-right"></i>
                                Fin Almuerzo
                            </button>
                        </form>

                        <form action="marcaje?action=salida" method="POST" style="display:contents;">
                            <button type="submit" class="btn-marcaje salida"
                                    ${(empty marcajeHoy || marcajeHoy.estadoMarcaje ne 'ACTIVO') ? 'disabled' : ''}>
                                <i class="bi bi-box-arrow-right"></i>
                                Salida
                            </button>
                        </form>

                    </div>

                    <!-- Contadores -->
                    <div class="timer-grid">
                        <div class="timer-box yellow">
                            <div>
                                <div class="timer-label">Almuerzo</div>
                                <div class="timer-value">${minutosLonch}<small style="font-size:.9rem;"> min</small></div>
                            </div>
                            <i class="bi bi-egg-fried" style="font-size:1.5rem;opacity:.4;"></i>
                        </div>
                        <div class="timer-box">
                            <div>
                                <div class="timer-label">Coffee Break</div>
                                <div class="timer-value">${minutosBreak}<small style="font-size:.9rem;"> min</small></div>
                            </div>
                            <i class="bi bi-cup-hot" style="font-size:1.5rem;opacity:.3;"></i>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- PANEL DERECHO: Monitoreo área (solo jefes/admin) -->
        <% if (u.isRolAdminRRHH() || u.isRolJefeArea()) { %>
        <div class="col-12 col-xl-6">
            <div class="block">
                <div class="block-header">
                    <i class="bi bi-shield-check" style="color:var(--yellow);font-size:1.1rem;"></i>
                    <h6 class="block-header-title">Monitoreo de Área — Tiempo Real</h6>
                </div>
                <div class="block-body" style="padding:0;">
                    <table class="marc-table">
                        <thead>
                            <tr>
                                <th>Empleado</th>
                                <th>Entrada</th>
                                <th>Estado</th>
                                <th style="text-align:right;">Retraso</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ma" items="${marcajesArea}">
                            <tr>
                                <td style="font-weight:600;">${ma.nombreCompleto}</td>
                                <td style="font-family:'Barlow Condensed',sans-serif;font-weight:700;font-size:.95rem;">
                                    ${ma.horaEntrada}
                                </td>
                                <td>
                                    <span class="badge-st b-ok">${ma.estadoMarcaje}</span>
                                </td>
                                <td style="text-align:right;">
                                    <c:choose>
                                        <c:when test="${ma.entradaTarde}">
                                            <span class="badge-st b-late">
                                                <i class="bi bi-exclamation-triangle-fill"></i>Tarde
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="b-none">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                            <c:if test="${empty marcajesArea}">
                            <tr>
                                <td colspan="4" class="empty-cell">
                                    <i class="bi bi-people me-1"></i>
                                    Ningún empleado ha marcado hoy
                                </td>
                            </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <% } %>

    </div>

</div><!-- /main-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
