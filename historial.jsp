<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login"); return;
    }
    String tablaFiltro = request.getParameter("tabla");
    if (tablaFiltro == null) tablaFiltro = "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial | Sistema de Turnos</title>
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

        /* ── EXPORT BUTTONS ── */
        .btn-export {
            display: inline-flex; align-items: center; gap: .4rem;
            padding: .5rem 1rem;
            background: #e8f5e9; border: 1.5px solid #a5d6a7;
            border-radius: 3px; color: var(--green);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .82rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .8px;
            text-decoration: none; transition: all .15s;
        }
        .btn-export:hover { background: #c8e6c9; color: var(--green); }

        /* ── TABS ── */
        .tabs-row {
            display: flex; gap: .5rem;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid var(--gray-lt);
            padding-bottom: 0;
        }
        .tab-btn {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .82rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1px;
            padding: .6rem 1.25rem;
            background: transparent; border: none;
            color: var(--gray-md); cursor: pointer;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            transition: all .15s;
        }
        .tab-btn:hover { color: var(--black); }
        .tab-btn.active {
            color: var(--black);
            border-bottom-color: var(--yellow);
        }

        /* ── FILTER CHIPS ── */
        .filter-row {
            display: flex; gap: .5rem;
            flex-wrap: wrap; align-items: center;
            margin-bottom: 1rem;
        }
        .filter-chip {
            padding: .28rem .85rem;
            border: 1.5px solid var(--gray-lt);
            border-radius: 2px; background: var(--white);
            color: var(--gray-md);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .75rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .8px;
            text-decoration: none; transition: all .15s;
        }
        .filter-chip:hover { border-color: var(--black); color: var(--black); }
        .filter-chip.active {
            background: var(--black); color: var(--yellow);
            border-color: var(--black);
        }

        /* ── SEARCH ── */
        .search-wrap { position: relative; margin-left: auto; }
        .search-wrap i {
            position: absolute; left: .8rem; top: 50%;
            transform: translateY(-50%);
            color: var(--gray-md); font-size: .85rem;
            pointer-events: none;
        }
        .search-input {
            border: 2px solid var(--gray-lt); border-radius: 3px;
            background: var(--white); color: var(--black);
            padding: .5rem 1rem .5rem 2.3rem;
            font-family: 'Barlow', sans-serif; font-size: .85rem;
            width: 220px; transition: border-color .15s;
        }
        .search-input:focus { outline: none; border-color: var(--yellow); box-shadow: 2px 2px 0 var(--yellow); }
        .search-input::placeholder { color: #bbb; }

        /* ── TABLE ── */
        .table-wrap { border: 2px solid var(--black); border-radius: 3px; overflow: hidden; }
        table.h-table { width: 100%; border-collapse: collapse; font-size: .85rem; }
        table.h-table thead tr { background: var(--black); }
        table.h-table thead th {
            padding: .7rem .9rem;
            color: var(--white);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            border: none;
        }
        table.h-table thead th:first-child { color: var(--yellow); }
        table.h-table tbody tr { border-bottom: 1px solid var(--gray-lt); }
        table.h-table tbody tr:last-child { border-bottom: none; }
        table.h-table tbody tr:hover { background: #fffbe6; }
        table.h-table tbody td { padding: .75rem .9rem; color: var(--black); border: none; vertical-align: middle; }

        /* ── OP TAGS ── */
        .op-tag {
            display: inline-block; padding: .18rem .6rem;
            border-radius: 2px; font-size: .68rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-weight: 700; text-transform: uppercase; letter-spacing: .6px;
        }
        .op-insert   { background:#e8f5e9; color:#2E7D32; border:1px solid #a5d6a7; }
        .op-update   { background:#e3f2fd; color:#1565C0; border:1px solid #90caf9; }
        .op-delete   { background:#ffebee; color:#E53935; border:1px solid #ef9a9a; }
        .op-other    { background:#ede7f6; color:#4527a0; border:1px solid #b39ddb; }
        .op-login    { background:#e8f5e9; color:#2E7D32; border:1px solid #a5d6a7; }
        .op-crear    { background:#e3f2fd; color:#1565C0; border:1px solid #90caf9; }
        .op-eliminar { background:#ffebee; color:#E53935; border:1px solid #ef9a9a; }
        .op-aprobar  { background:#fff8e1; color:#bf8600; border:1px solid var(--yellow); }

        .tabla-chip {
            background: var(--gray-lt); color: var(--gray-dk);
            border-radius: 2px; padding: .15rem .55rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .6px;
        }

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
            <p class="page-eyebrow">Registro del Sistema</p>
            <h1 class="page-title">Historial y <span>Bitácora</span></h1>
        </div>
        <div style="display:flex;gap:.6rem;flex-wrap:wrap;">
            <a href="historial?exportar=excel&tipo=historial" class="btn-export">
                <i class="bi bi-file-earmark-excel"></i> Historial Excel
            </a>
            <a href="historial?exportar=excel&tipo=bitacora" class="btn-export">
                <i class="bi bi-file-earmark-excel"></i> Bitácora Excel
            </a>
        </div>
    </div>

    <!-- TABS -->
    <div class="tabs-row">
        <button class="tab-btn active" id="tabH" onclick="showTab('historial')">
            <i class="bi bi-clock-history me-1"></i> Historial de Cambios
        </button>
        <button class="tab-btn" id="tabB" onclick="showTab('bitacora')">
            <i class="bi bi-journal me-1"></i> Bitácora del Sistema
        </button>
    </div>

    <!-- PANEL HISTORIAL -->
    <div id="panelHistorial">
        <div class="filter-row">
            <a href="historial"                               class="filter-chip <%= tablaFiltro.isEmpty()              ? "active" : "" %>">Todos</a>
            <a href="historial?tabla=usuarios"                class="filter-chip <%= "usuarios".equals(tablaFiltro)         ? "active" : "" %>">Usuarios</a>
            <a href="historial?tabla=solicitudes"             class="filter-chip <%= "solicitudes".equals(tablaFiltro)      ? "active" : "" %>">Solicitudes</a>
            <a href="historial?tabla=marcajes"                class="filter-chip <%= "marcajes".equals(tablaFiltro)         ? "active" : "" %>">Marcajes</a>
            <a href="historial?tabla=asignaciones_turno"      class="filter-chip <%= "asignaciones_turno".equals(tablaFiltro) ? "active" : "" %>">Turnos</a>
            <div class="search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" id="busqH" class="search-input"
                       placeholder="Buscar..." onkeyup="filtrarT('tablaH','busqH')">
            </div>
        </div>

        <div class="table-wrap">
            <table class="h-table" id="tablaH">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tabla</th>
                        <th>Operación</th>
                        <th>Administrador</th>
                        <th>Descripción</th>
                        <th>IP</th>
                        <th>Fecha y Hora</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="h" items="${historial}">
                    <tr>
                        <td style="color:var(--gray-md);font-size:.8rem;"><c:out value="${h.idHistorial}"/></td>
                        <td><span class="tabla-chip"><c:out value="${h.tablaAfectada}"/></span></td>
                        <td>
                            <c:choose>
                                <c:when test="${'INSERT' eq h.tipoOperacion}"><span class="op-tag op-insert"><c:out value="${h.tipoOperacion}"/></span></c:when>
                                <c:when test="${'UPDATE' eq h.tipoOperacion}"><span class="op-tag op-update"><c:out value="${h.tipoOperacion}"/></span></c:when>
                                <c:when test="${'DELETE' eq h.tipoOperacion}"><span class="op-tag op-delete"><c:out value="${h.tipoOperacion}"/></span></c:when>
                                <c:otherwise><span class="op-tag op-other"><c:out value="${h.tipoOperacion}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-weight:600;"><c:out value="${h.nombreAdmin}"/></td>
                        <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:var(--gray-md);" title="${h.descripcion}">
                            <c:out value="${h.descripcion}"/>
                        </td>
                        <td style="color:var(--gray-md);font-size:.78rem;font-family:'Barlow Condensed',sans-serif;"><c:out value="${h.ipAddress}"/></td>
                        <td style="color:var(--gray-md);white-space:nowrap;font-size:.78rem;"><c:out value="${h.fechaHora}"/></td>
                    </tr>
                    </c:forEach>
                    <c:if test="${empty historial}">
                    <tr><td colspan="7" class="empty-cell"><i class="bi bi-inbox me-2"></i>Sin registros en el historial</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- PANEL BITÁCORA -->
    <div id="panelBitacora" style="display:none;">
        <div class="filter-row">
            <div class="search-wrap" style="margin-left:0;">
                <i class="bi bi-search"></i>
                <input type="text" id="busqB" class="search-input"
                       placeholder="Buscar..." onkeyup="filtrarT('tablaB','busqB')">
            </div>
        </div>

        <div class="table-wrap">
            <table class="h-table" id="tablaB">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Usuario</th>
                        <th>Operación</th>
                        <th>Módulo</th>
                        <th>Descripción</th>
                        <th>IP</th>
                        <th>Fecha y Hora</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bitacora}">
                    <tr>
                        <td style="color:var(--gray-md);font-size:.8rem;"><c:out value="${b.idBitacora}"/></td>
                        <td>
                            <div style="font-weight:600;font-size:.88rem;"><c:out value="${b.username}"/></div>
                            <div style="font-size:.72rem;color:var(--gray-md);"><c:out value="${b.nombreCompleto}"/></div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${'Login'    eq b.tipoOperacion}"><span class="op-tag op-login"><c:out value="${b.tipoOperacion}"/></span></c:when>
                                <c:when test="${'Crear'    eq b.tipoOperacion}"><span class="op-tag op-crear"><c:out value="${b.tipoOperacion}"/></span></c:when>
                                <c:when test="${'Eliminar' eq b.tipoOperacion}"><span class="op-tag op-eliminar"><c:out value="${b.tipoOperacion}"/></span></c:when>
                                <c:when test="${'Aprobar'  eq b.tipoOperacion}"><span class="op-tag op-aprobar"><c:out value="${b.tipoOperacion}"/></span></c:when>
                                <c:otherwise><span class="op-tag op-other"><c:out value="${b.tipoOperacion}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="tabla-chip"><c:out value="${b.modulo}"/></span></td>
                        <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:var(--gray-md);" title="${b.descripcion}">
                            <c:out value="${b.descripcion}"/>
                        </td>
                        <td style="color:var(--gray-md);font-size:.78rem;font-family:'Barlow Condensed',sans-serif;"><c:out value="${b.ipAddress}"/></td>
                        <td style="color:var(--gray-md);white-space:nowrap;font-size:.78rem;"><c:out value="${b.fechaHora}"/></td>
                    </tr>
                    </c:forEach>
                    <c:if test="${empty bitacora}">
                    <tr><td colspan="7" class="empty-cell"><i class="bi bi-inbox me-2"></i>Sin registros en la bitácora</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div><!-- /main-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function showTab(tab) {
    document.getElementById('panelHistorial').style.display = tab === 'historial' ? 'block' : 'none';
    document.getElementById('panelBitacora').style.display  = tab === 'bitacora'  ? 'block' : 'none';
    document.getElementById('tabH').classList.toggle('active', tab === 'historial');
    document.getElementById('tabB').classList.toggle('active', tab === 'bitacora');
}
function filtrarT(tablaId, inputId) {
    const q = document.getElementById(inputId).value.toLowerCase();
    document.querySelectorAll('#' + tablaId + ' tbody tr').forEach(tr => {
        if (tr.querySelector('td'))
            tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
