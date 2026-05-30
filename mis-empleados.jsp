<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login"); return;
    }
    com.turnos.modelo.Usuario u =
        (com.turnos.modelo.Usuario) session.getAttribute("usuario");
    if (!u.tieneRol("JefeArea")) {
        response.sendRedirect("dashboard"); return;
    }
    java.util.List<?> empList =
        (java.util.List<?>) request.getAttribute("usuarios");
    long totalEmp   = empList != null ? empList.size() : 0;
    long activosEmp = 0;
    if (empList != null) {
        activosEmp = empList.stream()
            .filter(e -> "Activo".equals(
                ((com.turnos.modelo.Usuario) e).getEstado()))
            .count();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Empleados | Sistema de Turnos</title>
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
            --radius:   4px;
        }

        /* ── BASE ───────────────────────────────── */
        *, *::before, *::after { box-sizing: border-box; }

        body {
            background: var(--white);
            color: var(--black);
            font-family: 'Barlow', sans-serif;
            font-size: 15px;
            margin: 0;
        }

        /* ── OVERRIDE main-content from menu.jsp ── */
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
            margin-bottom: 2.5rem;
            border-bottom: 4px solid var(--black);
            padding-bottom: 1.25rem;
        }
        .page-header-left {}
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
        .page-title span {
            color: var(--yellow);
        }

        /* ── SEARCH ─────────────────────────────── */
        .search-wrap {
            position: relative;
        }
        .search-wrap i {
            position: absolute;
            left: .85rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-md);
            font-size: .9rem;
            pointer-events: none;
        }
        .search-input {
            border: 2px solid var(--black);
            border-radius: var(--radius);
            background: var(--white);
            color: var(--black);
            padding: .6rem 1rem .6rem 2.4rem;
            font-family: 'Barlow', sans-serif;
            font-size: .88rem;
            width: 260px;
            transition: border-color .15s;
        }
        .search-input:focus {
            outline: none;
            border-color: var(--yellow);
            box-shadow: 3px 3px 0 var(--yellow);
        }
        .search-input::placeholder { color: #999; }

        /* ── STAT CARDS ─────────────────────────── */
        .stats-row {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .stat-card {
            flex: 1;
            min-width: 140px;
            max-width: 220px;
            border: 2px solid var(--black);
            border-radius: var(--radius);
            padding: 1.1rem 1.3rem;
            position: relative;
            overflow: hidden;
            background: var(--white);
            transition: transform .15s;
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card.yellow { background: var(--yellow); }
        .stat-card.black  { background: var(--black); color: var(--white); }

        .stat-card::after {
            content: '';
            position: absolute;
            bottom: -8px; right: -8px;
            width: 60px; height: 60px;
            border-radius: 50%;
            background: rgba(0,0,0,.06);
        }
        .stat-number {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 2.8rem;
            font-weight: 900;
            line-height: 1;
            margin-bottom: .2rem;
        }
        .stat-card.black .stat-number { color: var(--yellow); }
        .stat-label {
            font-size: .72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            opacity: .7;
        }
        .stat-card.black .stat-label { color: var(--gray-lt); opacity: .6; }

        /* ── TABLE SECTION ──────────────────────── */
        .section-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.1rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            color: var(--black);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: .5rem;
        }
        .section-title::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 1.1em;
            background: var(--yellow);
            border-radius: 2px;
        }

        .table-wrap {
            border: 2px solid var(--black);
            border-radius: var(--radius);
            overflow: hidden;
        }
        table.emp-table {
            width: 100%;
            border-collapse: collapse;
            font-size: .88rem;
        }
        table.emp-table thead tr {
            background: var(--black);
            color: var(--white);
        }
        table.emp-table thead th {
            padding: .75rem 1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            border: none;
        }
        table.emp-table thead th:first-child {
            color: var(--yellow);
        }
        table.emp-table tbody tr {
            border-bottom: 1px solid var(--gray-lt);
            transition: background .12s;
        }
        table.emp-table tbody tr:last-child {
            border-bottom: none;
        }
        table.emp-table tbody tr:hover {
            background: #fffbe6;
        }
        table.emp-table tbody td {
            padding: .85rem 1rem;
            color: var(--black);
            vertical-align: middle;
        }

        /* ── AVATAR ─────────────────────────────── */
        .avatar {
            width: 36px; height: 36px;
            border-radius: var(--radius);
            background: var(--black);
            color: var(--yellow);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem;
            font-weight: 900;
            flex-shrink: 0;
        }
        .emp-name {
            font-weight: 600;
            font-size: .9rem;
            color: var(--black);
            line-height: 1.2;
        }
        .emp-email {
            font-size: .72rem;
            color: var(--gray-md);
        }

        /* ── BADGES ─────────────────────────────── */
        .badge-st {
            display: inline-flex;
            align-items: center;
            gap: .3rem;
            padding: .2rem .65rem;
            border-radius: 2px;
            font-size: .7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .8px;
        }
        .badge-activo {
            background: #e8f5e9;
            color: var(--green);
            border: 1px solid #a5d6a7;
        }
        .badge-inactivo {
            background: #ffebee;
            color: var(--red);
            border: 1px solid #ef9a9a;
        }
        .badge-turno {
            background: var(--yellow);
            color: var(--black);
            border: 1px solid var(--yellow-d);
        }

        /* ── EMPTY STATE ────────────────────────── */
        .empty-state {
            text-align: center;
            padding: 3.5rem 1rem;
            color: var(--gray-md);
        }
        .empty-state i {
            font-size: 2.5rem;
            opacity: .25;
            display: block;
            margin-bottom: .75rem;
        }
        .empty-state p {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 0;
        }

        /* ── RESPONSIVE ─────────────────────────── */
        @media (max-width: 640px) {
            .page-title { font-size: 2.2rem; }
            .stat-card { max-width: 100%; }
            .main-content { padding: 1.5rem 1rem 2rem !important; }
        }
    </style>
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="main-content">

    <!-- HEADER -->
    <div class="page-header">
        <div class="page-header-left">
            <p class="page-eyebrow">Panel de Jefe de Área</p>
            <h1 class="page-title">Mis <span>Empleados</span></h1>
        </div>
        <div class="search-wrap">
            <i class="bi bi-search"></i>
            <input type="text" id="busqueda" class="search-input"
                   placeholder="Buscar empleado..."
                   onkeyup="filtrar()">
        </div>
    </div>

    <!-- STATS -->
    <div class="stats-row">
        <div class="stat-card black">
            <div class="stat-number"><%= totalEmp %></div>
            <div class="stat-label">Total en mi área</div>
        </div>
        <div class="stat-card yellow">
            <div class="stat-number"><%= activosEmp %></div>
            <div class="stat-label">Activos</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= totalEmp - activosEmp %></div>
            <div class="stat-label">Inactivos</div>
        </div>
    </div>

    <!-- TABLE -->
    <div class="section-title">
        <i class="bi bi-people-fill"></i>
        Listado de Empleados
    </div>

    <div class="table-wrap">
        <table class="emp-table" id="tablaEmpleados">
            <thead>
                <tr>
                    <th>Empleado</th>
                    <th>Usuario</th>
                    <th>Área</th>
                    <th>Turno</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="emp" items="${usuarios}">
                <tr>
                    <td>
                        <div style="display:flex;align-items:center;gap:.75rem;">
                            <div class="avatar">
                                ${emp.nombreCompleto.substring(0,1)}
                            </div>
                            <div>
                                <div class="emp-name">${emp.nombreCompleto}</div>
                                <div class="emp-email">${emp.email}</div>
                            </div>
                        </div>
                    </td>
                    <td style="color:var(--gray-md);font-weight:500;">
                        ${emp.username}
                    </td>
                    <td style="color:var(--gray-dk);">${emp.nombreArea}</td>
                    <td>
                        <span class="badge-st badge-turno">
                            <i class="bi bi-clock"></i>
                            ${emp.nombreTurno}
                        </span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${'Activo' eq emp.estado}">
                                <span class="badge-st badge-activo">
                                    ● Activo
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-st badge-inactivo">
                                    ○ Inactivo
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                </c:forEach>

                <c:if test="${empty usuarios}">
                <tr>
                    <td colspan="5">
                        <div class="empty-state">
                            <i class="bi bi-people"></i>
                            <p>No tiene empleados asignados aún</p>
                        </div>
                    </td>
                </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</div><!-- /main-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filtrar() {
    const q = document.getElementById('busqueda').value.toLowerCase();
    document.querySelectorAll('#tablaEmpleados tbody tr').forEach(tr => {
        tr.style.display =
            tr.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
