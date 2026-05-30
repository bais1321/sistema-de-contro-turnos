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
    <title>Usuarios | Sistema de Turnos</title>
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

        .header-actions { display: flex; gap: .75rem; align-items: center; flex-wrap: wrap; }
        .search-wrap { position: relative; }
        .search-wrap i {
            position: absolute; left: .85rem; top: 50%;
            transform: translateY(-50%);
            color: var(--gray-md); font-size: .9rem; pointer-events: none;
        }
        .search-input {
            border: 2px solid var(--gray-lt); border-radius: 3px;
            background: var(--white); color: var(--black);
            padding: .6rem 1rem .6rem 2.5rem;
            font-family: 'Barlow', sans-serif; font-size: .88rem;
            width: 240px; transition: border-color .15s;
        }
        .search-input:focus { outline: none; border-color: var(--yellow); box-shadow: 2px 2px 0 var(--yellow); }
        .search-input::placeholder { color: #bbb; }

        .btn-primary-st {
            background: var(--black); color: var(--yellow);
            border: 2px solid var(--black); border-radius: 3px;
            padding: .6rem 1.3rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .88rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: 1px;
            cursor: pointer; transition: all .15s;
            display: inline-flex; align-items: center; gap: .4rem;
        }
        .btn-primary-st:hover { background: var(--yellow); color: var(--black); }

        .alert-st {
            display: flex; align-items: center; gap: .65rem;
            padding: .8rem 1rem; border-radius: 3px;
            font-size: .88rem; font-weight: 500; margin-bottom: 1.25rem;
        }
        .alert-success { background:#e8f5e9; border:1.5px solid #a5d6a7; color:var(--green); }
        .alert-error   { background:#ffebee; border:1.5px solid #ef9a9a; color:var(--red); }

        .table-wrap { border: 2px solid var(--black); border-radius: 3px; overflow: hidden; }
        table.u-table { width: 100%; border-collapse: collapse; font-size: .86rem; }
        table.u-table thead tr { background: var(--black); }
        table.u-table thead th {
            padding: .7rem .9rem; color: var(--white);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1.5px;
            border: none; white-space: nowrap;
        }
        table.u-table thead th:first-child { color: var(--yellow); }
        table.u-table tbody tr { border-bottom: 1px solid var(--gray-lt); }
        table.u-table tbody tr:last-child { border-bottom: none; }
        table.u-table tbody tr:hover { background: #fffbe6; }
        table.u-table tbody td { padding: .75rem .9rem; color: var(--black); border: none; vertical-align: middle; }

        .avatar {
            width: 34px; height: 34px; border-radius: 3px;
            background: var(--black); color: var(--yellow);
            display: flex; align-items: center; justify-content: center;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem; font-weight: 900; flex-shrink: 0;
        }
        .emp-name { font-weight: 600; font-size: .88rem; line-height: 1.2; }
        .emp-email { font-size: .72rem; color: var(--gray-md); }

        .badge-st {
            display: inline-flex; align-items: center; gap: .25rem;
            padding: .18rem .6rem; border-radius: 2px;
            font-size: .68rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .6px;
            font-family: 'Barlow Condensed', sans-serif;
        }
        .b-jefe     { background:#fff8e1; color:#7a5000; border:1px solid var(--yellow); }
        .b-empleado { background:#e8f5e9; color:var(--green); border:1px solid #a5d6a7; }
        .b-activo   { background:#e8f5e9; color:var(--green); border:1px solid #a5d6a7; }
        .b-inactivo { background:#ffebee; color:var(--red);   border:1px solid #ef9a9a; }
        .b-admin    { background:#ede7f6; color:#4527a0; border:1px solid #b39ddb; }
        .b-rol      { background:var(--gray-lt); color:var(--gray-dk); border:1px solid #ccc; }
        .b-jefe-rol { background:#fff8e1; color:#7a5000; border:1px solid var(--yellow); }

        .btn-action {
            width: 30px; height: 30px; border-radius: 3px;
            display: flex; align-items: center; justify-content: center;
            font-size: .82rem; cursor: pointer;
            border: 1.5px solid var(--gray-lt);
            background: var(--white); color: var(--gray-md);
            transition: all .15s;
        }
        .btn-action:hover { border-color: var(--black); background: var(--black); color: var(--yellow); }

        .empty-cell {
            text-align:center; padding:3rem !important;
            font-family:'Barlow Condensed',sans-serif;
            font-size:.95rem; font-weight:700;
            text-transform:uppercase; letter-spacing:1px;
            color:var(--gray-md) !important;
        }

        /* MODALES */
        .modal { z-index: 9999 !important; }
        .modal-backdrop { z-index: 9998 !important; }
        .modal-content {
            background: var(--white) !important;
            border: 2px solid var(--black) !important;
            border-radius: 3px !important;
            color: var(--black) !important;
            box-shadow: 6px 6px 0 var(--black) !important;
        }
        .modal-header {
            border-bottom: 2px solid var(--black) !important;
            padding: .95rem 1.25rem !important;
            background: var(--black) !important;
        }
        .modal-title {
            font-family: 'Barlow Condensed', sans-serif !important;
            font-size: 1rem !important; font-weight: 800 !important;
            text-transform: uppercase !important; letter-spacing: 1px !important;
            color: var(--yellow) !important;
        }
        .modal-body { padding: 1.25rem !important; background: var(--white) !important; }
        .modal-footer {
            border-top: 1.5px solid var(--gray-lt) !important;
            padding: .85rem 1.25rem !important;
            background: var(--white) !important;
            display: flex !important; justify-content: flex-end !important; gap: .6rem !important;
        }
        .btn-close { filter: invert(1) opacity(.7) !important; }

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

        .info-box {
            display: flex; align-items: flex-start; gap: .6rem;
            padding: .7rem .95rem; border-radius: 3px;
            font-size: .82rem; font-weight: 500;
        }
        .info-yellow { background:#fff8e1; border:1.5px solid var(--yellow); color:#7a5000; }
        .info-green  { background:#e8f5e9; border:1.5px solid #a5d6a7; color:var(--green); }
        .info-blue   { background:#e3f2fd; border:1.5px solid #90caf9; color:var(--blue); }
        .warn-box {
            background:#fff3e0; border:1.5px solid #ffcc80; color:#e65100;
            display:flex; align-items:flex-start; gap:.6rem;
            padding:.7rem .95rem; border-radius:3px; font-size:.82rem;
        }

        .spinner-sm {
            display: inline-block; width:13px; height:13px;
            border: 2px solid rgba(0,0,0,.1); border-top-color: var(--black);
            border-radius: 50%; animation: spin .6s linear infinite;
            margin-left: .4rem; vertical-align: middle;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .btn-modal-primary {
            background: var(--black); color: var(--yellow);
            border: 2px solid var(--black); border-radius: 3px;
            padding: .55rem 1.2rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .85rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: .8px;
            cursor: pointer; transition: all .15s;
            display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-modal-primary:hover { background: var(--yellow); color: var(--black); }
        .btn-modal-outline {
            background: transparent; color: var(--black);
            border: 2px solid var(--gray-lt); border-radius: 3px;
            padding: .5rem 1.1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .83rem; font-weight: 700;
            text-transform: uppercase; cursor: pointer; transition: all .15s;
        }
        .btn-modal-outline:hover { border-color: var(--black); }
        .btn-modal-red {
            background: #ffebee; color: var(--red);
            border: 1.5px solid #ef9a9a; border-radius: 3px;
            padding: .5rem 1.1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .83rem; font-weight: 700; text-transform: uppercase;
            cursor: pointer; transition: all .15s;
            display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-modal-red:hover { background: #ffcdd2; }
        .btn-modal-green {
            background: #e8f5e9; color: var(--green);
            border: 1.5px solid #a5d6a7; border-radius: 3px;
            padding: .5rem 1.1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .83rem; font-weight: 700; text-transform: uppercase;
            cursor: pointer; transition: all .15s;
            display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-modal-green:hover { background: #c8e6c9; }
    </style>
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="main-content">

    <div class="page-header">
        <div>
            <p class="page-eyebrow">Administración del Sistema</p>
            <h1 class="page-title">Gestión de <span>Usuarios</span></h1>
        </div>
        <div class="header-actions">
            <div class="search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" id="busqueda" class="search-input"
                       placeholder="Buscar usuario..." onkeyup="filtrar()">
            </div>
            <button class="btn-primary-st"
                    data-bs-toggle="modal" data-bs-target="#modalNuevo">
                <i class="bi bi-person-plus"></i> Nuevo Usuario
            </button>
        </div>
    </div>

    <% if (request.getParameter("msg") != null) {
        String m = request.getParameter("msg");
        String text = "Operación realizada.";
        if ("creado".equals(m))           text = "Usuario registrado correctamente.";
        if ("actualizado".equals(m))      text = "Información del usuario actualizada.";
        if ("jefe_actualizado".equals(m)) text = "Jefe de área asignado correctamente.";
        if ("rol_asignado".equals(m))     text = "Rol concedido al usuario.";
        if ("rol_eliminado".equals(m))    text = "Rol revocado del usuario.";
    %>
    <div class="alert-st alert-success">
        <i class="bi bi-check-circle-fill"></i> <%= text %>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert-st alert-error">
        <i class="bi bi-x-circle-fill"></i> <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="table-wrap">
        <table class="u-table" id="tablaUsuarios">
            <thead>
                <tr>
                    <th>Empleado</th>
                    <th>Usuario</th>
                    <th>DPI</th>
                    <th>Área</th>
                    <th>Turno</th>
                    <th>Tipo</th>
                    <th>Roles</th>
                    <th>Estado</th>
                    <th style="text-align:right;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="emp" items="${usuarios}">
                <tr>
                    <td>
                        <div style="display:flex;align-items:center;gap:.7rem;">
                            <div class="avatar">${emp.nombreCompleto.substring(0,1)}</div>
                            <div>
                                <div class="emp-name"><c:out value="${emp.nombreCompleto}"/></div>
                                <div class="emp-email"><c:out value="${emp.email}"/></div>
                            </div>
                        </div>
                    </td>
                    <td style="font-weight:500;color:var(--gray-dk);">
                        <c:out value="${emp.username}"/>
                    </td>
                    <td style="font-family:'Barlow Condensed',sans-serif;color:var(--gray-md);font-size:.8rem;">
                        <c:out value="${emp.dpi}"/>
                    </td>
                    <td><c:out value="${emp.nombreArea}"/></td>
                    <td>
                        <span class="badge-st b-rol">
                            <i class="bi bi-clock"></i>
                            <c:out value="${emp.nombreTurno}"/>
                        </span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${emp.esJefeArea}">
                                <span class="badge-st b-jefe">
                                    <i class="bi bi-person-badge"></i>Jefe
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-st b-empleado">
                                    <i class="bi bi-person"></i>Empleado
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="display:flex;gap:.25rem;flex-wrap:wrap;max-width:200px;">
                            <c:forEach var="rol" items="${emp.roles}">
                                <span class="badge-st
                                    <c:choose>
                                        <c:when test="${'AdminRRHH' eq rol}">b-admin</c:when>
                                        <c:when test="${'JefeArea'  eq rol}">b-jefe-rol</c:when>
                                        <c:otherwise>b-rol</c:otherwise>
                                    </c:choose>">
                                    <c:out value="${rol}"/>
                                </span>
                            </c:forEach>
                        </div>
                    </td>
                    <td>
                        <span class="badge-st ${'Activo' eq emp.estado ? 'b-activo' : 'b-inactivo'}">
                            <c:choose>
                                <c:when test="${'Activo' eq emp.estado}">● Activo</c:when>
                                <c:otherwise>○ Inactivo</c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                    <td style="text-align:right;">
                        <div style="display:flex;gap:.35rem;justify-content:flex-end;">
                            <button class="btn-action" title="Editar"
                                    onclick="abrirEditar('${emp.idUsuario}','${emp.dpi}','${emp.nombreCompleto}','${emp.email}','${emp.idArea}','${emp.idTurnoActual}','${emp.estado}',${emp.esJefeArea})">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <c:if test="${!emp.esJefeArea}">
                            <button class="btn-action" title="Cambiar Jefe"
                                    onclick="abrirCambiarJefe('${emp.idUsuario}','${emp.nombreCompleto}','${emp.idArea}','${emp.idTurnoActual}','${emp.idJefeArea}')">
                                <i class="bi bi-people"></i>
                            </button>
                            </c:if>
                            <button class="btn-action" title="Roles"
                                    onclick="abrirRoles('${emp.idUsuario}','${emp.nombreCompleto}')">
                                <i class="bi bi-shield"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty usuarios}">
                <tr>
                    <td colspan="9" class="empty-cell">
                        <i class="bi bi-people d-block mb-2" style="font-size:2rem;opacity:.3;"></i>
                        No hay usuarios registrados
                    </td>
                </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</div>

<!-- MODAL NUEVO -->
<div class="modal fade" id="modalNuevo" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title"><i class="bi bi-person-plus me-2"></i>Registrar Nuevo Colaborador</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="usuarios" method="post">
                <input type="hidden" name="action" value="guardar">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="f-label">Nombre Completo <span class="req">*</span></label>
                            <input type="text" name="nombreCompleto" class="f-input" required placeholder="Juan Carlos Pérez">
                        </div>
                        <div class="col-md-6">
                            <label class="f-label">DPI <span class="req">*</span></label>
                            <input type="text" name="dpi" class="f-input" maxlength="13" required placeholder="13 dígitos">
                        </div>
                        <div class="col-md-6">
                            <label class="f-label">Usuario <span class="req">*</span></label>
                            <input type="text" name="username" class="f-input" required placeholder="juan.perez">
                        </div>
                        <div class="col-md-6">
                            <label class="f-label">Contraseña Inicial <span class="req">*</span></label>
                            <input type="text" name="password" class="f-input" required placeholder="Mínimo 6 caracteres">
                        </div>
                        <div class="col-md-6">
                            <label class="f-label">Email</label>
                            <input type="email" name="email" class="f-input" placeholder="ejemplo@empresa.com">
                        </div>
                        <div class="col-md-3">
                            <label class="f-label">Turno <span class="req">*</span></label>
                            <select name="idTurno" id="nuevoTurno" class="f-input" required onchange="actualizarAreaYJefes('nuevo')">
                                <option value="">Seleccione...</option>
                                <c:forEach var="t" items="${turnos}">
                                    <option value="${t.idTurno}"><c:out value="${t.nombreTurno}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="f-label">Área <span class="req">*</span></label>
                            <select name="idArea" id="nuevoArea" class="f-input" required onchange="actualizarAreaYJefes('nuevo')">
                                <option value="">Seleccione...</option>
                                <c:forEach var="a" items="${areas}">
                                    <option value="${a.idArea}" data-esjefatura="${a.esJefatura}">
                                        <c:out value="${a.nombreArea}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12" id="nuevoTipoInfo" style="display:none;">
                            <div class="info-box info-green" id="nuevoTipoBox">
                                <i class="bi bi-info-circle" style="flex-shrink:0;margin-top:.1rem;"></i>
                                <span id="nuevoTipoTexto"></span>
                            </div>
                        </div>
                        <div class="col-12" id="nuevoJefeContainer" style="display:none;">
                            <label class="f-label">
                                Jefe Asignado
                                <span id="nuevoJefeSpinner" style="display:none;" class="spinner-sm"></span>
                            </label>
                            <select name="idJefe" id="nuevoJefe" class="f-input">
                                <option value="0">Seleccione turno y área primero...</option>
                            </select>
                            <div class="warn-box mt-2" id="nuevoSinJefeWarn" style="display:none;">
                                <i class="bi bi-exclamation-triangle" style="flex-shrink:0;margin-top:.1rem;"></i>
                                <span>No hay jefes disponibles. Las solicitudes irán directamente a RRHH.</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-outline" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn-modal-primary">
                        <i class="bi bi-person-check"></i>Crear Usuario
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR -->
<div class="modal fade" id="modalEditar" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">
                    <i class="bi bi-pencil me-2"></i>Editar: <span id="editNombre"></span>
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="usuarios" method="post">
                <input type="hidden" name="action" value="actualizar">
                <input type="hidden" name="idUsuario" id="editId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="f-label">Nombre Completo</label>
                            <input type="text" name="nombreCompleto" id="editNombreInput" class="f-input" required>
                        </div>
                        <div class="col-md-6">
                            <label class="f-label">DPI</label>
                            <input type="text" name="dpi" id="editDpi" class="f-input" maxlength="13" required>
                        </div>
                        <div class="col-md-6">
                            <label class="f-label">Email</label>
                            <input type="email" name="email" id="editEmail" class="f-input">
                        </div>
                        <div class="col-md-3">
                            <label class="f-label">Turno</label>
                            <select name="idTurno" id="editTurno" class="f-input" required onchange="actualizarAreaYJefes('editar')">
                                <c:forEach var="t" items="${turnos}">
                                    <option value="${t.idTurno}"><c:out value="${t.nombreTurno}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="f-label">Área</label>
                            <select name="idArea" id="editArea" class="f-input" required onchange="actualizarAreaYJefes('editar')">
                                <c:forEach var="a" items="${areas}">
                                    <option value="${a.idArea}" data-esjefatura="${a.esJefatura}">
                                        <c:out value="${a.nombreArea}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12" id="editTipoInfo" style="display:none;">
                            <div class="info-box info-green" id="editTipoBox">
                                <i class="bi bi-info-circle" style="flex-shrink:0;margin-top:.1rem;"></i>
                                <span id="editTipoTexto"></span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label class="f-label">Estado</label>
                            <select name="estado" id="editEstado" class="f-input">
                                <option value="Activo">Activo</option>
                                <option value="Inactivo">Inactivo</option>
                            </select>
                        </div>
                        <div class="col-md-8">
                            <label class="f-label">Motivo Inactivación</label>
                            <select name="motivoInactivacion" class="f-input">
                                <option value="">Ninguno</option>
                                <option>Permiso Personal</option>
                                <option>Vacaciones</option>
                                <option>Citas al IGSS</option>
                                <option>Licencia de cumpleaños</option>
                                <option>Suspensión Laboral</option>
                                <option>Otros</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-outline" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn-modal-primary">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL CAMBIAR JEFE -->
<div class="modal fade" id="modalCambiarJefe" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">
                    <i class="bi bi-people me-2"></i>Reasignar Jefe: <span id="cjNombre"></span>
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="usuarios" method="post">
                <input type="hidden" name="action" value="cambiarJefe">
                <input type="hidden" name="idEmpleado" id="cjIdEmpleado">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <div class="info-box info-blue">
                                <i class="bi bi-info-circle" style="flex-shrink:0;margin-top:.1rem;"></i>
                                <span>Turno actual: <strong id="cjTurnoActual"></strong>. Puedes cambiar el turno para ver jefes disponibles en otro horario.</span>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="f-label">Turno del Jefe</label>
                            <select id="cjTurno" class="f-input" onchange="cargarJefesParaCambio()">
                                <c:forEach var="t" items="${turnos}">
                                    <option value="${t.idTurno}"><c:out value="${t.nombreTurno}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="f-label">
                                Nuevo Jefe
                                <span id="cjSpinner" style="display:none;" class="spinner-sm"></span>
                            </label>
                            <select name="idJefe" id="cjJefe" class="f-input" required>
                                <option value="">Cargando...</option>
                            </select>
                            <div class="warn-box mt-2" id="cjSinJefeWarn" style="display:none;">
                                <i class="bi bi-exclamation-triangle" style="flex-shrink:0;margin-top:.1rem;"></i>
                                <span>No hay jefes disponibles en este turno.</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-outline" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn-modal-primary">
                        <i class="bi bi-people"></i>Asignar Jefe
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL ROLES -->
<div class="modal fade" id="modalRoles" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title">
                    <i class="bi bi-shield me-2"></i>Roles: <span id="rolesNombre"></span>
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="f-label mb-2" style="color:var(--green);">Conceder Rol</p>
                <form action="usuarios" method="post" style="display:flex;gap:.6rem;margin-bottom:1.25rem;">
                    <input type="hidden" name="action" value="asignarRol">
                    <input type="hidden" name="idUsuario" id="rolesIdAsignar">
                    <select name="idRol" class="f-input" style="flex:1;">
                        <option value="1">AdminRRHH</option>
                        <option value="2">AdminArea</option>
                        <option value="3">Empleado</option>
                        <option value="4">JefeArea</option>
                    </select>
                    <button type="submit" class="btn-modal-green" style="white-space:nowrap;">
                        <i class="bi bi-plus-lg"></i>Asignar
                    </button>
                </form>
                <hr style="border-color:var(--gray-lt);margin:1rem 0;">
                <p class="f-label mb-2" style="color:var(--red);">Revocar Rol</p>
                <form action="usuarios" method="post" style="display:flex;gap:.6rem;">
                    <input type="hidden" name="action" value="eliminarRol">
                    <input type="hidden" name="idUsuario" id="rolesIdEliminar">
                    <select name="idRol" class="f-input" style="flex:1;">
                        <option value="1">AdminRRHH</option>
                        <option value="2">AdminArea</option>
                        <option value="3">Empleado</option>
                        <option value="4">JefeArea</option>
                    </select>
                    <button type="submit" class="btn-modal-red" style="white-space:nowrap;">
                        <i class="bi bi-trash"></i>Revocar
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filtrar() {
    const q = document.getElementById('busqueda').value.toLowerCase();
    document.querySelectorAll('#tablaUsuarios tbody tr').forEach(tr => {
        if (tr.querySelector('td'))
            tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}

function cargarJefes(prefijo, idArea, idTurno, idJefeActual) {
    const selJefe = document.getElementById(prefijo + 'Jefe');
    const spinner = document.getElementById(prefijo + 'JefeSpinner');
    const warnBox = document.getElementById(prefijo + 'SinJefeWarn');
    if (!selJefe) return;
    if (!idArea || !idTurno) {
        selJefe.innerHTML = '<option value="0">Seleccione turno y área primero...</option>';
        if (warnBox) warnBox.style.display = 'none'; return;
    }
    if (spinner) spinner.style.display = 'inline-block';
    selJefe.innerHTML = '<option value="0">Cargando...</option>';
    if (warnBox) warnBox.style.display = 'none';
    fetch('usuarios?action=getJefes&idArea=' + idArea + '&idTurno=' + idTurno)
        .then(r => r.json())
        .then(jefes => {
            if (spinner) spinner.style.display = 'none';
            selJefe.innerHTML = '';
            if (jefes.length === 0) {
                selJefe.innerHTML = '<option value="0">Sin jefes disponibles</option>';
                if (warnBox) warnBox.style.display = 'flex';
            } else {
                if (warnBox) warnBox.style.display = 'none';
                if (!idJefeActual || idJefeActual == 0)
                    selJefe.innerHTML = '<option value="0">Sin jefe (irá a RRHH)</option>';
                jefes.forEach(j => {
                    const opt = document.createElement('option');
                    opt.value = j.id; opt.textContent = j.nombre;
                    if (idJefeActual && j.id == idJefeActual) opt.selected = true;
                    selJefe.appendChild(opt);
                });
            }
        })
        .catch(() => {
            if (spinner) spinner.style.display = 'none';
            selJefe.innerHTML = '<option value="0">Error al cargar jefes</option>';
        });
}

function actualizarAreaYJefes(prefijo) {
    const selArea  = document.getElementById(prefijo + 'Area');
    const selTurno = document.getElementById(prefijo + 'Turno');
    const tipoInfo = document.getElementById(prefijo + 'TipoInfo');
    const tipoBox  = document.getElementById(prefijo + 'TipoBox');
    const tipoTexto= document.getElementById(prefijo + 'TipoTexto');
    const jefeCont = document.getElementById(prefijo + 'JefeContainer');
    if (!selArea || !selTurno) return;
    const idArea  = selArea.value;
    const idTurno = selTurno.value;
    const selOpt  = selArea.options[selArea.selectedIndex];
    const esJefatura = selOpt && selOpt.dataset.esjefatura === 'true';

    if (idArea && tipoInfo) {
        tipoInfo.style.display = 'block';
        if (esJefatura) {
            tipoBox.className = 'info-box info-yellow';
            tipoTexto.innerHTML = '<i class="bi bi-person-badge me-1"></i>Área de <strong>Jefatura</strong>. El usuario será creado como <strong>Jefe de Área</strong> con rol <em>JefeArea</em>.';
        } else {
            tipoBox.className = 'info-box info-green';
            tipoTexto.innerHTML = '<i class="bi bi-person me-1"></i>Área de <strong>Empleados</strong>. El usuario será creado con rol <em>Empleado</em>.';
        }
    } else if (tipoInfo) tipoInfo.style.display = 'none';

    if (jefeCont) {
        if (!esJefatura && idArea) {
            jefeCont.style.display = 'block';
            if (idTurno) cargarJefes(prefijo, idArea, idTurno, 0);
        } else jefeCont.style.display = 'none';
    }
}

function abrirEditar(id, dpi, nombre, email, idArea, idTurno, estado, esJefe) {
    document.getElementById('editId').value           = id;
    document.getElementById('editNombre').textContent = nombre;
    document.getElementById('editNombreInput').value  = nombre;
    document.getElementById('editDpi').value          = dpi;
    document.getElementById('editEmail').value        = email;
    document.getElementById('editEstado').value       = estado;
    const sa = document.getElementById('editArea');
    for (let o of sa.options) o.selected = (o.value == idArea);
    const st = document.getElementById('editTurno');
    for (let o of st.options) o.selected = (o.value == idTurno);
    actualizarAreaYJefes('editar');
    new bootstrap.Modal(document.getElementById('modalEditar')).show();
}

let _cjIdArea = 0;
function abrirCambiarJefe(idEmpleado, nombre, idArea, idTurno, idJefeActual) {
    _cjIdArea = parseInt(idArea);
    document.getElementById('cjIdEmpleado').value   = idEmpleado;
    document.getElementById('cjNombre').textContent = nombre;
    const st = document.getElementById('cjTurno');
    for (let o of st.options) o.selected = (o.value == idTurno);
    document.getElementById('cjTurnoActual').textContent =
        st.options[st.selectedIndex] ? st.options[st.selectedIndex].textContent : 'N/A';
    cargarJefesParaCambio(idJefeActual);
    new bootstrap.Modal(document.getElementById('modalCambiarJefe')).show();
}

function cargarJefesParaCambio(idJefeActual) {
    const selTurno = document.getElementById('cjTurno');
    const selJefe  = document.getElementById('cjJefe');
    const spinner  = document.getElementById('cjSpinner');
    const warnBox  = document.getElementById('cjSinJefeWarn');
    const idTurno  = selTurno.value;
    if (!idTurno || !_cjIdArea) return;
    if (spinner) spinner.style.display = 'inline-block';
    selJefe.innerHTML = '<option value="">Consultando...</option>';
    if (warnBox) warnBox.style.display = 'none';
    fetch('usuarios?action=getJefes&idArea=' + _cjIdArea + '&idTurno=' + idTurno)
        .then(r => r.json())
        .then(jefes => {
            if (spinner) spinner.style.display = 'none';
            selJefe.innerHTML = '';
            if (jefes.length === 0) {
                selJefe.innerHTML = '<option value="">Sin jefes en este turno</option>';
                if (warnBox) warnBox.style.display = 'flex';
            } else {
                if (warnBox) warnBox.style.display = 'none';
                jefes.forEach(j => {
                    const opt = document.createElement('option');
                    opt.value = j.id; opt.textContent = j.nombre;
                    if (idJefeActual && j.id == idJefeActual) opt.selected = true;
                    selJefe.appendChild(opt);
                });
            }
        })
        .catch(() => {
            if (spinner) spinner.style.display = 'none';
            selJefe.innerHTML = '<option value="">Error al cargar</option>';
        });
}

function abrirRoles(id, nombre) {
    document.getElementById('rolesNombre').textContent = nombre;
    document.getElementById('rolesIdAsignar').value    = id;
    document.getElementById('rolesIdEliminar').value   = id;
    new bootstrap.Modal(document.getElementById('modalRoles')).show();
}
</script>
</body>
</html>
