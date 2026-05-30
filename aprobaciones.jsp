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
    <title>Aprobaciones | Sistema de Turnos</title>
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
            flex-wrap: wrap; gap: 1rem;
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

        /* ── ALERT ── */
        .alert-st {
            display: flex; align-items: center; gap: .65rem;
            padding: .8rem 1rem; border-radius: 3px;
            font-size: .88rem; font-weight: 500; margin-bottom: 1.5rem;
        }
        .alert-success { background:#e8f5e9; border:1.5px solid #a5d6a7; color:var(--green); }

        /* ── SECTION BLOCK ── */
        .section-block { margin-bottom: 2rem; }
        .section-header {
            display: flex; align-items: center; gap: .85rem;
            margin-bottom: 1.25rem; padding-bottom: .85rem;
            border-bottom: 2px solid var(--gray-lt);
        }
        .section-icon {
            width: 40px; height: 40px; border-radius: 3px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem; flex-shrink: 0;
        }
        .section-icon.yellow { background: var(--yellow); color: var(--black); }
        .section-icon.black  { background: var(--black);  color: var(--yellow); }
        .section-heading {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.1rem; font-weight: 900;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--black); margin: 0; line-height: 1.1;
        }
        .section-sub {
            font-size: .75rem; color: var(--gray-md);
            margin-top: .15rem;
        }

        /* ── SOL CARD ── */
        .sol-card {
            border: 2px solid var(--gray-lt);
            border-radius: 4px;
            padding: 1.25rem;
            margin-bottom: .75rem;
            background: var(--white);
            transition: border-color .15s, box-shadow .15s;
        }
        .sol-card:last-child { margin-bottom: 0; }
        .sol-card:hover {
            border-color: var(--black);
            box-shadow: 3px 3px 0 var(--yellow);
        }

        .sol-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .sol-info { flex: 1; min-width: 220px; }
        .sol-name {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.1rem; font-weight: 900;
            text-transform: uppercase; color: var(--black);
            margin-bottom: .35rem;
        }
        .sol-meta {
            font-size: .82rem; color: var(--gray-md);
            display: flex; flex-wrap: wrap; gap: .6rem;
            align-items: center; margin-bottom: .35rem;
        }
        .sol-motivo {
            font-size: .85rem; color: var(--gray-dk);
            margin-top: .25rem;
        }
        .sol-extra {
            font-size: .78rem; color: var(--gray-md);
            margin-top: .2rem;
        }

        /* ── TAGS ── */
        .tag {
            display: inline-flex; align-items: center; gap: .25rem;
            padding: .2rem .65rem; border-radius: 2px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: .6px;
        }
        .tag-tipo   { background: var(--yellow);   color: var(--black);  border: 1px solid var(--yellow-d); }
        .tag-dias   { background: var(--black);     color: var(--yellow); }
        .tag-visto  { background: #e8f5e9; color: var(--green); border: 1px solid #a5d6a7; }

        /* ── ACTION BUTTONS ── */
        .btn-approve {
            background: #e8f5e9; color: var(--green);
            border: 2px solid #a5d6a7; border-radius: 3px;
            padding: .45rem 1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .82rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: .8px;
            cursor: pointer; transition: all .15s;
            display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-approve:hover { background: #c8e6c9; border-color: #81c784; }

        .btn-reject {
            background: #ffebee; color: var(--red);
            border: 2px solid #ef9a9a; border-radius: 3px;
            padding: .45rem 1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .82rem; font-weight: 800;
            text-transform: uppercase; letter-spacing: .8px;
            cursor: pointer; transition: all .15s;
            display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-reject:hover { background: #ffcdd2; border-color: #e57373; }

        /* ── EMPTY ── */
        .empty-state {
            text-align: center; padding: 2.5rem 1rem;
            border: 2px dashed var(--gray-lt); border-radius: 4px;
        }
        .empty-state i {
            font-size: 2rem; opacity: .25;
            display: block; margin-bottom: .6rem;
        }
        .empty-state p {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .95rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--gray-md); margin: 0;
        }

        /* ── MODALES ── */
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
        }
        .modal-title.approve { color: #6ee7b7 !important; }
        .modal-title.reject  { color: #fca5a5 !important; }
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
        .f-textarea {
            width: 100%; border: 2px solid var(--gray-lt); border-radius: 3px;
            background: var(--white); color: var(--black);
            padding: .65rem .85rem; font-family: 'Barlow', sans-serif;
            font-size: .88rem; resize: vertical; min-height: 80px;
            transition: border-color .15s;
        }
        .f-textarea:focus { outline: none; border-color: var(--yellow); box-shadow: 2px 2px 0 var(--yellow); }
        .f-textarea::placeholder { color: #bbb; }

        .btn-modal-outline {
            background: transparent; color: var(--black);
            border: 2px solid var(--gray-lt); border-radius: 3px;
            padding: .5rem 1.1rem;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .83rem; font-weight: 700;
            text-transform: uppercase; cursor: pointer; transition: all .15s;
        }
        .btn-modal-outline:hover { border-color: var(--black); }
    </style>
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="main-content">

    <!-- HEADER -->
    <div class="page-header">
        <div>
            <p class="page-eyebrow">Gestión de Permisos</p>
            <h1 class="page-title">Panel de <span>Aprobaciones</span></h1>
        </div>
    </div>

    <!-- ALERT -->
    <% String msg = request.getParameter("msg");
       if (msg != null) { %>
    <div class="alert-st alert-success">
        <i class="bi bi-check-circle-fill"></i>
        Acción realizada. El empleado fue notificado
        <% if (!"sin_correo".equals(msg)) { %> por sistema y correo electrónico. <% } else { %> en el sistema. <% } %>
    </div>
    <% } %>

    <!-- SECCIÓN JEFE DE ÁREA -->
    <% if (u.isRolJefeArea()) { %>
    <div class="section-block">
        <div class="section-header">
            <div class="section-icon yellow">
                <i class="bi bi-people-fill"></i>
            </div>
            <div>
                <h5 class="section-heading">Solicitudes de Mi Área</h5>
                <p class="section-sub">Al aprobar, pasa automáticamente a RRHH para autorización final.</p>
            </div>
        </div>

        <c:forEach var="s" items="${pendientesJefe}">
        <div class="sol-card">
            <div class="sol-top">
                <div class="sol-info">
                    <div class="sol-name"><c:out value="${s.nombreSolicitante}"/></div>
                    <div class="sol-meta">
                        <span class="tag tag-tipo">
                            <c:out value="${s.nombreTipoSolicitud}"/>
                        </span>
                        <span class="tag tag-dias">
                            <c:out value="${s.diasSolicitados}"/> días
                        </span>
                        <span style="font-size:.78rem;">
                            <i class="bi bi-calendar3 me-1"></i>
                            <c:out value="${s.fechaInicio}"/> → <c:out value="${s.fechaFin}"/>
                        </span>
                    </div>
                    <div class="sol-motivo">
                        <c:out value="${s.motivo}"/>
                    </div>
                </div>
                <div style="display:flex;gap:.6rem;flex-shrink:0;align-items:flex-start;">
                    <button class="btn-approve"
                            onclick="prepararAccion('${s.idSolicitud}','${s.nombreSolicitante}','procesarJefe','Aprobar')">
                        <i class="bi bi-check2"></i>Aprobar
                    </button>
                    <button class="btn-reject"
                            onclick="prepararAccion('${s.idSolicitud}','${s.nombreSolicitante}','procesarJefe','Rechazar')">
                        <i class="bi bi-x"></i>Rechazar
                    </button>
                </div>
            </div>
        </div>
        </c:forEach>

        <c:if test="${empty pendientesJefe}">
        <div class="empty-state">
            <i class="bi bi-check2-all"></i>
            <p>No hay solicitudes pendientes en tu área</p>
        </div>
        </c:if>
    </div>
    <% } %>

    <!-- SECCIÓN RRHH -->
    <% if (u.isRolAdminRRHH()) { %>
    <div class="section-block">
        <div class="section-header">
            <div class="section-icon black">
                <i class="bi bi-shield-check"></i>
            </div>
            <div>
                <h5 class="section-heading">Autorizaciones Finales — RRHH</h5>
                <p class="section-sub">Solicitudes con visto bueno de jefatura, listas para autorización final.</p>
            </div>
        </div>

        <c:forEach var="s" items="${pendientesRRHH}">
        <div class="sol-card">
            <div class="sol-top">
                <div class="sol-info">
                    <div class="sol-name">
                        <c:out value="${s.nombreSolicitante}"/>
                    </div>
                    <div class="sol-meta">
                        <span class="tag tag-tipo">
                            <c:out value="${s.nombreTipoSolicitud}"/>
                        </span>
                        <span class="tag tag-dias">
                            <c:out value="${s.diasSolicitados}"/> días
                        </span>
                        <span class="tag tag-visto">
                            <i class="bi bi-check-circle-fill me-1"></i>V°B° Jefatura
                        </span>
                        <span style="font-size:.78rem;">
                            <i class="bi bi-calendar3 me-1"></i>
                            <c:out value="${s.fechaInicio}"/> → <c:out value="${s.fechaFin}"/>
                        </span>
                    </div>
                    <div class="sol-motivo">
                        <strong>Motivo:</strong> <c:out value="${s.motivo}"/>
                    </div>
                    <div class="sol-extra">
                        <strong>Área:</strong> <c:out value="${s.nombreArea}"/> &nbsp;—&nbsp;
                        <strong>Jefe:</strong> <c:out value="${s.nombreJefe}"/>
                    </div>
                </div>
                <div style="display:flex;gap:.6rem;flex-shrink:0;align-items:flex-start;">
                    <button class="btn-approve"
                            onclick="prepararAccion('${s.idSolicitud}','${s.nombreSolicitante}','procesarRRHH','Aprobar')">
                        <i class="bi bi-shield-check"></i>Autorizar
                    </button>
                    <button class="btn-reject"
                            onclick="prepararAccion('${s.idSolicitud}','${s.nombreSolicitante}','procesarRRHH','Rechazar')">
                        <i class="bi bi-shield-x"></i>Denegar
                    </button>
                </div>
            </div>
        </div>
        </c:forEach>

        <c:if test="${empty pendientesRRHH}">
        <div class="empty-state">
            <i class="bi bi-inbox"></i>
            <p>No hay solicitudes listas para autorización final</p>
        </div>
        </c:if>
    </div>
    <% } %>

</div><!-- /main-content -->

<!-- ================================================================
     MODAL: APROBAR
     ================================================================ -->
<div class="modal fade" id="modalDinamicoAprobar" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
        <div class="modal-content">
            <form id="formAprobar" method="POST" action="">
                <input type="hidden" id="ap_idSolicitud" name="idSolicitud" value="">
                <input type="hidden" name="opcion" value="Aprobar">
                <div class="modal-header">
                    <h6 class="modal-title approve" id="ap_titulo">
                        <i class="bi bi-check-circle me-2"></i>Aprobar Solicitud
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p style="font-size:.88rem;color:var(--gray-md);margin:0;">
                        Aprobar la solicitud de
                        <strong style="color:var(--black);" id="ap_nombreEmpleado"></strong>.
                        Pasará a la siguiente etapa de revisión.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-outline" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn-approve" style="padding:.55rem 1.25rem;">
                        <i class="bi bi-check2"></i>Confirmar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ================================================================
     MODAL: RECHAZAR
     ================================================================ -->
<div class="modal fade" id="modalDinamicoRechazar" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
        <div class="modal-content">
            <form id="formRechazar" method="POST" action="">
                <input type="hidden" id="re_idSolicitud" name="idSolicitud" value="">
                <input type="hidden" name="opcion" value="Rechazar">
                <div class="modal-header">
                    <h6 class="modal-title reject">
                        <i class="bi bi-x-circle me-2"></i>Rechazar Solicitud
                    </h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p style="font-size:.88rem;color:var(--gray-md);margin-bottom:1rem;">
                        Rechazar la solicitud de
                        <strong style="color:var(--black);" id="re_nombreEmpleado"></strong>.
                        El empleado será notificado.
                    </p>
                    <label class="f-label">Motivo del Rechazo <span class="req">*</span></label>
                    <textarea name="comentario" class="f-textarea"
                              placeholder="Indique el motivo..." required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-outline" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn-reject" style="padding:.55rem 1.25rem;">
                        <i class="bi bi-x"></i>Confirmar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function prepararAccion(idSolicitud, nombreEmpleado, targetAction, opcion) {
    if (opcion === 'Aprobar') {
        document.getElementById('formAprobar').action = 'aprobaciones?action=' + targetAction;
        document.getElementById('ap_idSolicitud').value     = idSolicitud;
        document.getElementById('ap_nombreEmpleado').textContent = nombreEmpleado;
        const titulo = document.getElementById('ap_titulo');
        if (targetAction === 'procesarRRHH') {
            titulo.innerHTML = '<i class="bi bi-shield-check me-2"></i>Autorización Final (RRHH)';
        } else {
            titulo.innerHTML = '<i class="bi bi-check-circle me-2"></i>Aprobar Solicitud (Jefatura)';
        }
        new bootstrap.Modal(document.getElementById('modalDinamicoAprobar')).show();
    } else {
        document.getElementById('formRechazar').action = 'aprobaciones?action=' + targetAction;
        document.getElementById('re_idSolicitud').value     = idSolicitud;
        document.getElementById('re_nombreEmpleado').textContent = nombreEmpleado;
        new bootstrap.Modal(document.getElementById('modalDinamicoRechazar')).show();
    }
}
</script>
</body>
</html>
