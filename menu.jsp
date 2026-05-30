<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    com.turnos.modelo.Usuario menuUsuario =
        (com.turnos.modelo.Usuario) session.getAttribute("usuario");

    // Exponer roles como booleanos para que JSTL los pueda evaluar
    boolean esAdminRRHH  = menuUsuario.tieneRol("AdminRRHH");
    boolean esJefeArea   = menuUsuario.tieneRol("JefeArea") || menuUsuario.isEsJefeArea();
    boolean esAdminArea  = menuUsuario.tieneRol("AdminArea");
    boolean esAdmin      = esAdminRRHH || esJefeArea || esAdminArea;

    request.setAttribute("menuUsuario",  menuUsuario);
    request.setAttribute("esAdminRRHH",  esAdminRRHH);
    request.setAttribute("esJefeArea",   esJefeArea);
    request.setAttribute("esAdminArea",  esAdminArea);
    request.setAttribute("esAdmin",      esAdmin);
%>

<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800;900&family=Barlow:wght@300;400;500;600&display=swap" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>

/* ?? TOKENS ??????????????????????????????????????? */

:root {

    --yellow:      #F5C518;

    --yellow-d:    #D4A800;

    --black:       #111111;

    --gray-dk:     #2a2a2a;

    --gray-md:     #555555;

    --gray-lt:     #e4e4e4;

    --white:       #FAFAFA;

    --red:         #E53935;

    --sidebar-w:   260px;

    --topbar-h:    64px;

}

*, *::before, *::after { box-sizing: border-box; }

body {

    background: var(--white) !important;

    color: var(--black) !important;

    font-family: 'Barlow', sans-serif;

    margin: 0;

}

/* ?? SIDEBAR ??????????????????????????????????????? */

#sidebar {

    position: fixed;

    top: 0; left: 0; bottom: 0;

    width: var(--sidebar-w);

    background: var(--black);

    display: flex;

    flex-direction: column;

    z-index: 1000;

    transition: transform .3s ease;

    overflow: hidden;

}

/* Patrón de puntos decorativo */

#sidebar::before {

    content: '';

    position: absolute;

    top: 0; left: 0; right: 0; bottom: 0;

    background-image: radial-gradient(circle, rgba(255,255,255,.05) 1px, transparent 1px);

    background-size: 24px 24px;

    pointer-events: none;

    z-index: 0;

}

/* Blob amarillo decorativo en esquina */

#sidebar::after {

    content: '';

    position: absolute;

    bottom: -80px; right: -80px;

    width: 220px; height: 220px;

    background: var(--yellow);

    border-radius: 50%;

    opacity: .07;

    pointer-events: none;

    z-index: 0;

}

/* ?? BRAND ????????????????????????????????????????? */

.brand-section {

    position: relative;

    z-index: 1;

    padding: 1.4rem 1.25rem;

    border-bottom: 1px solid rgba(255,255,255,.07);

    display: flex;

    align-items: center;

    gap: .75rem;

    flex-shrink: 0;

}

.brand-logo {

    width: 36px; height: 36px;

    background: var(--yellow);

    border-radius: 4px;

    display: flex;

    align-items: center;

    justify-content: center;

    color: var(--black);

    font-size: 1.1rem;

    flex-shrink: 0;

}

.brand-name {

    font-family: 'Barlow Condensed', sans-serif;

    font-size: 1.05rem;

    font-weight: 800;

    color: var(--white);

    text-transform: uppercase;

    letter-spacing: .5px;

    line-height: 1.1;

}

.brand-name span {

    display: block;

    font-size: .65rem;

    font-weight: 600;

    color: rgba(255,255,255,.35);

    text-transform: uppercase;

    letter-spacing: 1.5px;

}

/* ?? NAV ??????????????????????????????????????????? */

.menu-container {

    flex: 1;

    padding: 1.25rem .85rem;

    overflow-y: auto;

    position: relative;

    z-index: 1;

}

.menu-container::-webkit-scrollbar { width: 3px; }

.menu-container::-webkit-scrollbar-track { background: transparent; }

.menu-container::-webkit-scrollbar-thumb { background: rgba(255,255,255,.1); border-radius: 2px; }

.menu-label {

    font-family: 'Barlow Condensed', sans-serif;

    font-size: .65rem;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 2px;

    color: rgba(255,255,255,.25);

    padding-left: .65rem;

    margin-bottom: .6rem;

    display: block;

}

.nav-list {

    list-style: none;

    display: flex;

    flex-direction: column;

    gap: .2rem;

    margin-bottom: 1.5rem;

    padding: 0;

}

.nav-item-link {

    display: flex;

    align-items: center;

    gap: .75rem;

    padding: .65rem .85rem;

    color: rgba(255,255,255,.45);

    text-decoration: none;

    font-size: .88rem;

    font-weight: 500;

    border-radius: 3px;

    transition: all .15s;

    position: relative;

}

.nav-item-link i {

    font-size: 1rem;

    flex-shrink: 0;

    width: 18px;

    text-align: center;

}

.nav-item-link:hover {

    background: rgba(255,255,255,.06);

    color: var(--white);

}

.nav-item-link.active {

    background: var(--yellow);

    color: var(--black);

    font-weight: 700;

}

.nav-item-link.active i {

    color: var(--black);

}

/* ?? USER BOX ?????????????????????????????????????? */

.user-profile-box {

    position: relative;

    z-index: 1;

    padding: 1rem 1.1rem;

    border-top: 1px solid rgba(255,255,255,.07);

    display: flex;

    align-items: center;

    gap: .7rem;

    flex-shrink: 0;

    background: rgba(0,0,0,.3);

}

.user-avatar {

    width: 36px; height: 36px;

    background: var(--yellow);

    border-radius: 3px;

    display: flex;

    align-items: center;

    justify-content: center;

    color: var(--black);

    font-family: 'Barlow Condensed', sans-serif;

    font-weight: 900;

    font-size: 1rem;

    flex-shrink: 0;

}

.user-info { flex: 1; overflow: hidden; }

.user-name {

    font-size: .83rem;

    font-weight: 600;

    color: var(--white);

    white-space: nowrap;

    overflow: hidden;

    text-overflow: ellipsis;

}

.user-role {

    font-size: .68rem;

    color: rgba(255,255,255,.35);

    margin-top: .1rem;

}

.btn-logout {

    color: rgba(255,255,255,.35);

    background: transparent;

    border: none;

    padding: .3rem;

    border-radius: 3px;

    cursor: pointer;

    font-size: 1.05rem;

    transition: color .15s, background .15s;

    flex-shrink: 0;

    display: flex;

    align-items: center;

}

.btn-logout:hover {

    color: var(--red);

    background: rgba(229,57,53,.1);

}

/* ?? TOPBAR ???????????????????????????????????????? */

.topbar {

    position: fixed;

    top: 0;

    right: 0;

    left: var(--sidebar-w);

    height: var(--topbar-h);

    background: var(--white);

    border-bottom: 2px solid var(--black);

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding: 0 2rem;

    z-index: 999;

}

.topbar-left {

    display: flex;

    align-items: center;

    gap: 1rem;

}

.btn-toggle-menu {

    display: none;

    background: var(--black);

    border: none;

    color: var(--yellow);

    padding: .35rem .65rem;

    border-radius: 3px;

    cursor: pointer;

    font-size: 1.1rem;

}

.topbar-page-title {

    font-family: 'Barlow Condensed', sans-serif;

    font-size: 1.05rem;

    font-weight: 800;

    text-transform: uppercase;

    letter-spacing: 1px;

    color: var(--black);

    margin: 0;

}

/* Barra amarilla izquierda del título */

.topbar-page-title::before {

    content: '';

    display: inline-block;

    width: 4px;

    height: .9em;

    background: var(--yellow);

    border-radius: 2px;

    margin-right: .6rem;

    vertical-align: middle;

}

.topbar-right {

    display: flex;

    align-items: center;

    gap: 1.5rem;

}

.clock-widget { text-align: right; }

#topClock {

    font-family: 'Barlow Condensed', sans-serif;

    font-size: 1.1rem;

    font-weight: 800;

    color: var(--black);

    display: block;

    line-height: 1;

}

#topDate {

    font-size: .7rem;

    font-weight: 600;

    text-transform: uppercase;

    letter-spacing: 1px;

    color: var(--gray-md);

}

/* ?? MAIN CONTENT ?????????????????????????????????? */

.main-content {

    margin-left: var(--sidebar-w);

    padding-top: calc(var(--topbar-h) + 2rem);

    padding-left: 2rem;

    padding-right: 2rem;

    padding-bottom: 2.5rem;

    min-height: 100vh;

    background: var(--white) !important;

    color: var(--black) !important;

}

/* ?? SHARED UTILITIES ?????????????????????????????? */

/* Botones globales */

.btn-grad, .btn-primary-st {

    background: var(--black);

    color: var(--yellow);

    border: 2px solid var(--black);

    border-radius: 3px;

    padding: .55rem 1.3rem;

    font-family: 'Barlow Condensed', sans-serif;

    font-size: .88rem;

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

.btn-grad:hover, .btn-primary-st:hover {

    background: var(--yellow);

    color: var(--black);

}

.btn-outline-glass, .btn-outline-st {

    background: transparent;

    color: var(--black);

    border: 2px solid var(--black);

    border-radius: 3px;

    padding: .5rem 1.1rem;

    font-family: 'Barlow Condensed', sans-serif;

    font-size: .85rem;

    font-weight: 700;

    text-transform: uppercase;

    cursor: pointer;

    transition: all .15s;

}

.btn-outline-glass:hover, .btn-outline-st:hover {

    background: var(--black);

    color: var(--white);

}

/* Cards */

.card-glass {

    background: var(--white);

    border: 2px solid var(--black);

    border-radius: 3px;

}

/* Tabla base */

.table {

    color: var(--black) !important;

}

.table thead th {

    background: var(--black) !important;

    color: var(--white) !important;

    font-family: 'Barlow Condensed', sans-serif !important;

    font-size: .75rem !important;

    font-weight: 700 !important;

    text-transform: uppercase !important;

    letter-spacing: 1.5px !important;

    border: none !important;

    padding: .7rem 1rem !important;

}

.table thead th:first-child { color: var(--yellow) !important; }

.table tbody tr { border-bottom: 1px solid var(--gray-lt) !important; }

.table tbody tr:hover { background: #fffbe6 !important; }

.table tbody td {

    color: var(--black) !important;

    padding: .8rem 1rem !important;

    vertical-align: middle !important;

    border: none !important;

}

.table-hover > tbody > tr:hover > * {

    background-color: #fffbe6 !important;

    color: var(--black) !important;

}

/* Badges globales */

.badge-pill, .badge-st {

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

.badge-success { background:#e8f5e9 !important; color:#2E7D32 !important; border:1px solid #a5d6a7 !important; }

.badge-danger  { background:#ffebee !important; color:#E53935 !important; border:1px solid #ef9a9a !important; }

.badge-warning { background:#fff8e1 !important; color:#bf8600 !important; border:1px solid var(--yellow) !important; }

.badge-info    { background:#e3f2fd !important; color:#1565C0 !important; border:1px solid #90caf9 !important; }

.badge-purple  { background:#ede7f6 !important; color:#4527a0 !important; border:1px solid #b39ddb !important; }

.badge-blue    { background:#e3f2fd !important; color:#1565C0 !important; border:1px solid #90caf9 !important; }

/* ?? RESPONSIVE ???????????????????????????????????? */

@media (max-width: 992px) {

    #sidebar { transform: translateX(calc(-1 * var(--sidebar-w))); }

    #sidebar.open { transform: translateX(0); }

    .topbar { left: 0; padding: 0 1rem; }

    .main-content { margin-left: 0; }

    .btn-toggle-menu { display: flex !important; }

}

</style>

<!-- ?? SIDEBAR ?????????????????????????????????????? -->

<nav id="sidebar">

    <div class="brand-section">

        <div class="brand-logo">

            <i class="bi bi-clock-history"></i>

        </div>

        <div class="brand-name">

            Sistema Turnos

            <span>Control de Personal</span>

        </div>

    </div>

    <div class="menu-container">

        <span class="menu-label">Menú Principal</span>

        <ul class="nav-list">

            <li>

                <a href="dashboard" class="nav-item-link">

                    <i class="bi bi-grid-1x2-fill"></i>Dashboard

                </a>

            </li>

            <li>

                <a href="marcaje" class="nav-item-link">

                    <i class="bi bi-fingerprint"></i>Control Marcaje

                </a>

            </li>

            <li>

                <a href="solicitudes" class="nav-item-link">

                    <i class="bi bi-file-earmark-text"></i>Mis Solicitudes

                </a>

            </li>

        </ul>

        <c:if test="${esAdmin}">

            <span class="menu-label">Administración</span>

            <ul class="nav-list">

                <c:if test="${esAdminRRHH || esJefeArea}">

                <li>

                    <a href="aprobaciones" class="nav-item-link">

                        <i class="bi bi-check2-square"></i>Aprobaciones

                    </a>

                </li>

                </c:if>

                <c:if test="${esJefeArea}">

                <li>

                    <a href="usuarios?action=misEmpleados" class="nav-item-link">

                        <i class="bi bi-people"></i>Mis Empleados

                    </a>

                </li>

                </c:if>

                <c:if test="${esAdminRRHH || esAdminArea}">

                <li>

                    <a href="usuarios" class="nav-item-link">

                        <i class="bi bi-person-gear"></i>Gestión Usuarios

                    </a>

                </li>

                </c:if>

                <c:if test="${esAdminRRHH}">

                <li>

                    <a href="asignacion-turno" class="nav-item-link">

                        <i class="bi bi-calendar-range"></i>Asignar Turnos

                    </a>

                </li>

                <li>

                    <a href="historial" class="nav-item-link">

                        <i class="bi bi-clock-history"></i>Historial y Auditoría

                    </a>

                </li>

                </c:if>

            </ul>

        </c:if>

    </div>

    <div class="user-profile-box">

        <div class="user-avatar">

            ${menuUsuario.nombreCompleto.substring(0,1).toUpperCase()}

        </div>

        <div class="user-info">

            <div class="user-name">${menuUsuario.nombreCompleto}</div>

            <div class="user-role">Sesión Activa</div>

        </div>

        <a href="logout" class="btn-logout" title="Cerrar Sesión">

            <i class="bi bi-box-arrow-right"></i>

        </a>

    </div>

</nav>

<!-- ?? TOPBAR ??????????????????????????????????????? -->

<header class="topbar">

    <div class="topbar-left">

        <button class="btn-toggle-menu" onclick="toggleSidebar()">

            <i class="bi bi-list"></i>

        </button>

        <h5 class="topbar-page-title" id="dynamicPageTitle">Panel de Control</h5>

    </div>

    <div class="topbar-right">

        <div class="clock-widget">

            <span id="topClock">00:00:00</span>

            <span id="topDate">Cargando...</span>

        </div>

    </div>

</header>

<script>

(function () {

    const dias  = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];

    const meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];

    function tick() {

        const now = new Date();

        const ce = document.getElementById('topClock');

        const de = document.getElementById('topDate');

        if (ce) ce.textContent = now.toLocaleTimeString('es-GT');

        if (de) de.textContent = dias[now.getDay()] + ' ' + now.getDate() + ' ' + meses[now.getMonth()];

    }

    tick();

    setInterval(tick, 1000);

    function toggleSidebar() {

        document.getElementById('sidebar').classList.toggle('open');

    }

    window.toggleSidebar = toggleSidebar;

    // Marcar enlace activo

    const uri = window.location.href;

    document.querySelectorAll('.nav-item-link').forEach(function (a) {

        const href = a.getAttribute('href') || '';

        const page = href.split('?')[0];

        if (page && uri.includes(page) && page !== '#') {

            a.classList.add('active');

        }

    });

    // Título dinámico

    const titleEl = document.getElementById('dynamicPageTitle');

    if (titleEl) {

        if      (uri.includes('dashboard'))       titleEl.textContent = 'Dashboard General';

        else if (uri.includes('marcaje'))         titleEl.textContent = 'Control de Asistencia';

        else if (uri.includes('solicitudes'))     titleEl.textContent = 'Mis Solicitudes de Permiso';

        else if (uri.includes('aprobaciones'))    titleEl.textContent = 'Panel de Aprobaciones';

        else if (uri.includes('misEmpleados'))    titleEl.textContent = 'Mi Equipo de Trabajo';

        else if (uri.includes('usuarios'))        titleEl.textContent = 'Gestión de Usuarios';

        else if (uri.includes('asignacion'))      titleEl.textContent = 'Asignación de Turnos';

        else if (uri.includes('historial'))       titleEl.textContent = 'Historial y Auditoría';

    }

})();

</script>
