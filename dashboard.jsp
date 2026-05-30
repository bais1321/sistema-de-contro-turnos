<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Dashboard | Sistema de Turnos</title>
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
            --blue:    #1565C0;
        }
        *, *::before, *::after { box-sizing: border-box; }
        body {
            background: var(--white) !important;
            color: var(--black) !important;
            font-family: 'Barlow', sans-serif;
        }
        .main-content {
            background: var(--white) !important;
            color: var(--black) !important;
        }

        /* ── WELCOME BANNER ── */
        .welcome-banner {
            background: var(--black);
            border-radius: 4px;
            padding: 1.75rem 2rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            position: relative;
            overflow: hidden;
        }
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-image: radial-gradient(circle, rgba(255,255,255,.05) 1px, transparent 1px);
            background-size: 22px 22px;
            pointer-events: none;
        }
        .welcome-banner::after {
            content: '';
            position: absolute;
            right: -60px; top: -60px;
            width: 200px; height: 200px;
            background: var(--yellow);
            border-radius: 50%;
            opacity: .1;
        }
        .welcome-eyebrow {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .7rem;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: rgba(255,255,255,.4);
            margin-bottom: .3rem;
            position: relative; z-index:1;
        }
        .welcome-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 2rem;
            font-weight: 900;
            text-transform: uppercase;
            color: var(--white);
            line-height: 1;
            margin: 0;
            position: relative; z-index:1;
        }
        .welcome-title span { color: var(--yellow); }
        .welcome-sub {
            font-size: .82rem;
            color: rgba(255,255,255,.4);
            margin-top: .35rem;
            position: relative; z-index:1;
        }
        .clock-box { text-align: right; position: relative; z-index:1; }
        #dashClock {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 2rem;
            font-weight: 900;
            color: var(--yellow);
            line-height: 1;
            display: block;
        }
        #dashDate {
            font-size: .72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255,255,255,.35);
        }

        /* ── KPI CARDS ── */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }
        @media (max-width: 1024px) { .kpi-grid { grid-template-columns: repeat(2,1fr); } }
        @media (max-width: 576px)  { .kpi-grid { grid-template-columns: 1fr; } }

        .kpi-card {
            border: 2px solid var(--black);
            border-radius: 4px;
            padding: 1.25rem 1.4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--white);
            transition: transform .15s, box-shadow .15s;
            position: relative;
            overflow: hidden;
        }
        .kpi-card:hover {
            transform: translateY(-3px);
            box-shadow: 4px 4px 0 var(--black);
        }
        .kpi-card.yellow { background: var(--yellow); }
        .kpi-card.black  { background: var(--black); }

        .kpi-value {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 2.5rem;
            font-weight: 900;
            line-height: 1;
            color: var(--black);
        }
        .kpi-card.black .kpi-value { color: var(--yellow); }
        .kpi-label {
            font-size: .7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--gray-md);
            margin-top: .2rem;
        }
        .kpi-card.black .kpi-label { color: rgba(255,255,255,.45); }
        .kpi-card.yellow .kpi-label { color: rgba(0,0,0,.5); }

        .kpi-icon {
            width: 48px; height: 48px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }
        .kpi-card.yellow .kpi-icon { background: rgba(0,0,0,.12); color: var(--black); }
        .kpi-card.black  .kpi-icon { background: rgba(255,255,255,.1); color: var(--yellow); }
        .kpi-card:not(.yellow):not(.black) .kpi-icon {
            background: var(--black);
            color: var(--yellow);
        }

        /* ── BOTTOM GRID ── */
        .bottom-grid {
            display: grid;
            grid-template-columns: 5fr 7fr;
            gap: 1.5rem;
        }
        @media (max-width: 992px) { .bottom-grid { grid-template-columns: 1fr; } }

        .block {
            border: 2px solid var(--black);
            border-radius: 4px;
            overflow: hidden;
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
            font-size: .88rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--yellow);
            margin: 0;
        }
        .block-body { padding: 1.25rem; background: var(--white); }

        /* Turnos */
        .turno-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: .85rem 1rem;
            border: 1.5px solid var(--gray-lt);
            border-radius: 3px;
            margin-bottom: .6rem;
            background: var(--white);
            transition: border-color .15s, background .15s;
        }
        .turno-row:last-child { margin-bottom: 0; }
        .turno-row:hover { border-color: var(--yellow); background: #fffbe6; }
        .turno-name {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem;
            font-weight: 800;
            text-transform: uppercase;
            color: var(--black);
            letter-spacing: .5px;
        }
        .turno-desc { font-size: .72rem; color: var(--gray-md); margin-top: .1rem; }
        .turno-hours {
            background: var(--yellow);
            color: var(--black);
            border: 1.5px solid var(--yellow-d);
            border-radius: 2px;
            padding: .2rem .65rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .78rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .5px;
            white-space: nowrap;
        }
        .turno-hours.vespertino { background: var(--black); color: var(--yellow); border-color: var(--black); }
        .turno-hours.nocturno   { background: var(--gray-dk); color: var(--white); border-color: var(--gray-dk); }

        /* Tabla solicitudes */
        table.sol-mini { width:100%; border-collapse:collapse; font-size:.85rem; }
        table.sol-mini thead tr { background: var(--gray-lt); }
        table.sol-mini thead th {
            padding: .55rem .85rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: var(--gray-dk);
            border: none;
        }
        table.sol-mini tbody tr { border-bottom: 1px solid var(--gray-lt); }
        table.sol-mini tbody tr:last-child { border-bottom: none; }
        table.sol-mini tbody tr:hover { background: #fffbe6; }
        table.sol-mini tbody td {
            padding: .75rem .85rem;
            color: var(--black);
            border: none;
            vertical-align: middle;
        }
        .badge-st {
            display: inline-flex;
            align-items: center;
            gap: .25rem;
            padding: .18rem .55rem;
            border-radius: 2px;
            font-size: .65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .6px;
        }
        .b-ok  { background:#e8f5e9; color:#2E7D32; border:1px solid #a5d6a7; }
        .b-pend{ background:#fff8e1; color:#bf8600; border:1px solid var(--yellow); }
        .b-no  { background:#ffebee; color:#E53935; border:1px solid #ef9a9a; }

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

    <!-- WELCOME BANNER -->
    <div class="welcome-banner">
        <div>
            <p class="welcome-eyebrow">Panel de Control</p>
            <h2 class="welcome-title">
                Hola, <span>${u.nombreCompleto}</span>
            </h2>
            <p class="welcome-sub">
                Estado operacional del sistema — hoy
            </p>
        </div>
        <div class="clock-box">
            <span id="dashClock">00:00:00</span>
            <span id="dashDate">Cargando...</span>
        </div>
    </div>

    <!-- KPI CARDS -->
    <div class="kpi-grid">
        <div class="kpi-card black">
            <div>
                <div class="kpi-value">${cantUsuarios}</div>
                <div class="kpi-label">Empleados Totales</div>
            </div>
            <div class="kpi-icon"><i class="bi bi-people-fill"></i></div>
        </div>
        <div class="kpi-card yellow">
            <div>
                <div class="kpi-value">${cantTurnosActivos}</div>
                <div class="kpi-label">Turnos Activos</div>
            </div>
            <div class="kpi-icon"><i class="bi bi-calendar-check-fill"></i></div>
        </div>
        <div class="kpi-card">
            <div>
                <div class="kpi-value">${solicitudesPendientes}</div>
                <div class="kpi-label">Por Aprobar</div>
            </div>
            <div class="kpi-icon"><i class="bi bi-clock-history"></i></div>
        </div>
        <div class="kpi-card">
            <div>
                <div class="kpi-value">${asistenciasHoy}</div>
                <div class="kpi-label">Marcajes Hoy</div>
            </div>
            <div class="kpi-icon"><i class="bi bi-fingerprint"></i></div>
        </div>
    </div>

    <!-- BOTTOM GRID -->
    <div class="bottom-grid">

        <!-- Turnos -->
        <div class="block">
            <div class="block-header">
                <i class="bi bi-shield-lock-fill" style="color:var(--yellow);"></i>
                <h6 class="block-header-title">Configuración de Turnos</h6>
            </div>
            <div class="block-body">
                <div class="turno-row">
                    <div>
                        <div class="turno-name">Matutino</div>
                        <div class="turno-desc">Operación Diaria Completa</div>
                    </div>
                    <span class="turno-hours">07:00 – 15:00</span>
                </div>
                <div class="turno-row">
                    <div>
                        <div class="turno-name">Vespertino</div>
                        <div class="turno-desc">Operación Tarde / Noche</div>
                    </div>
                    <span class="turno-hours vespertino">15:00 – 23:00</span>
                </div>
                <div class="turno-row">
                    <div>
                        <div class="turno-name">Nocturno</div>
                        <div class="turno-desc">Seguridad y Soporte Continuo</div>
                    </div>
                    <span class="turno-hours nocturno">23:00 – 07:00</span>
                </div>
            </div>
        </div>

        <!-- Solicitudes recientes -->
        <div class="block">
            <div class="block-header">
                <i class="bi bi-clipboard2-data-fill" style="color:var(--yellow);"></i>
                <h6 class="block-header-title">Solicitudes Recientes</h6>
            </div>
            <div class="block-body" style="padding:0;">
                <table class="sol-mini">
                    <thead>
                        <tr>
                            <th>Tipo de Permiso</th>
                            <th>Fecha</th>
                            <th style="text-align:right;">Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sol" items="${misSolicitudes}">
                        <tr>
                            <td style="font-weight:600;">
                                <i class="bi bi-file-earmark-text me-1"
                                   style="color:var(--gray-md);"></i>
                                ${sol.tipoPermiso}
                            </td>
                            <td style="color:var(--gray-md);">${sol.fechaCreacion}</td>
                            <td style="text-align:right;">
                                <c:choose>
                                    <c:when test="${'Aprobado' eq sol.estado}">
                                        <span class="badge-st b-ok">● Aprobado</span>
                                    </c:when>
                                    <c:when test="${'Pendiente' eq sol.estado}">
                                        <span class="badge-st b-pend">● Pendiente</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-st b-no">● Rechazado</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty misSolicitudes}">
                        <tr>
                            <td colspan="3" class="empty-cell">
                                <i class="bi bi-inbox me-2"></i>
                                Sin solicitudes registradas
                            </td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</div><!-- /main-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    const dias  = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];
    const meses = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
    function tick() {
        const now = new Date();
        const ce = document.getElementById('dashClock');
        const de = document.getElementById('dashDate');
        if (ce) ce.textContent = now.toLocaleTimeString('es-GT');
        if (de) de.textContent = dias[now.getDay()] + ', ' + now.getDate() + ' de ' + meses[now.getMonth()] + ' ' + now.getFullYear();
    }
    tick();
    setInterval(tick, 1000);
})();
</script>
</body>
</html>
