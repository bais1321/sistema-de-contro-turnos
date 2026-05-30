<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema Control de Turnos — Acceso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800;900&family=Barlow:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --yellow:   #F5C518;
            --yellow-d: #D4A800;
            --black:    #111111;
            --gray-dk:  #2a2a2a;
            --gray-md:  #666666;
            --gray-lt:  #e4e4e4;
            --white:    #FAFAFA;
            --red:      #E53935;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            display: flex;
            font-family: 'Barlow', sans-serif;
            background: var(--white);
        }

        /* ── PANEL IZQUIERDO (decorativo) ── */
        .left-panel {
            width: 45%;
            background: var(--black);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 3rem 3.5rem;
            position: relative;
            overflow: hidden;
        }
        /* Patrón de puntos decorativo */
        .left-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background-image: radial-gradient(circle, rgba(255,255,255,.08) 1px, transparent 1px);
            background-size: 28px 28px;
            pointer-events: none;
        }
        /* Bloque amarillo decorativo */
        .left-panel::after {
            content: '';
            position: absolute;
            bottom: -60px; right: -60px;
            width: 280px; height: 280px;
            background: var(--yellow);
            border-radius: 50%;
            opacity: .12;
        }

        .brand-block {
            position: relative;
            z-index: 2;
        }
        .brand-icon {
            width: 52px; height: 52px;
            background: var(--yellow);
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--black);
            margin-bottom: 1.5rem;
        }
        .brand-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 2.8rem;
            font-weight: 900;
            line-height: 1.05;
            color: var(--white);
            text-transform: uppercase;
            margin-bottom: .6rem;
        }
        .brand-title span { color: var(--yellow); }
        .brand-sub {
            font-size: .88rem;
            color: rgba(255,255,255,.45);
            line-height: 1.6;
            max-width: 300px;
        }

        /* Stats decorativos */
        .stats-deco {
            position: relative;
            z-index: 2;
            display: flex;
            gap: 1.5rem;
        }
        .stat-deco {
            border-left: 3px solid var(--yellow);
            padding-left: .85rem;
        }
        .stat-deco-num {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1.8rem;
            font-weight: 900;
            color: var(--white);
            line-height: 1;
        }
        .stat-deco-label {
            font-size: .7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255,255,255,.4);
            margin-top: .15rem;
        }

        /* ── PANEL DERECHO (formulario) ── */
        .right-panel {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem;
            background: var(--white);
        }

        .login-box {
            width: 100%;
            max-width: 380px;
        }

        .login-eyebrow {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: var(--gray-md);
            margin-bottom: .5rem;
        }
        .login-heading {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 2.2rem;
            font-weight: 900;
            text-transform: uppercase;
            color: var(--black);
            line-height: 1;
            margin-bottom: 2rem;
        }
        .login-heading span { color: var(--yellow); }

        /* Alerts */
        .alert-st {
            display: flex;
            align-items: center;
            gap: .65rem;
            padding: .75rem 1rem;
            border-radius: 3px;
            font-size: .85rem;
            font-weight: 500;
            margin-bottom: 1.25rem;
        }
        .alert-error {
            background: #ffebee;
            border: 1.5px solid #ef9a9a;
            color: var(--red);
        }
        .alert-info {
            background: #e8f5e9;
            border: 1.5px solid #a5d6a7;
            color: #2E7D32;
        }

        /* Form */
        .f-group { margin-bottom: 1.15rem; }
        .f-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: .72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: var(--gray-md);
            display: block;
            margin-bottom: .4rem;
        }
        .input-wrap { position: relative; }
        .input-icon {
            position: absolute;
            left: .9rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-md);
            font-size: .95rem;
            pointer-events: none;
        }
        .f-input {
            width: 100%;
            border: 2px solid var(--gray-lt);
            border-radius: 3px;
            background: var(--white);
            color: var(--black);
            padding: .7rem 1rem .7rem 2.5rem;
            font-family: 'Barlow', sans-serif;
            font-size: .9rem;
            transition: border-color .15s, box-shadow .15s;
        }
        .f-input::placeholder { color: #bbb; }
        .f-input:focus {
            outline: none;
            border-color: var(--yellow);
            box-shadow: 3px 3px 0 var(--yellow);
        }
        .btn-eye {
            position: absolute;
            right: .85rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--gray-md);
            cursor: pointer;
            font-size: .95rem;
            padding: 0;
        }
        .btn-eye:hover { color: var(--black); }

        /* Submit */
        .btn-login {
            width: 100%;
            padding: .85rem;
            background: var(--black);
            color: var(--yellow);
            border: 2px solid var(--black);
            border-radius: 3px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 1rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            cursor: pointer;
            transition: all .15s;
            margin-top: .5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .5rem;
        }
        .btn-login:hover {
            background: var(--yellow);
            color: var(--black);
            border-color: var(--yellow);
        }

        .login-footer {
            text-align: center;
            margin-top: 2rem;
            font-size: .72rem;
            color: var(--gray-md);
            border-top: 1px solid var(--gray-lt);
            padding-top: 1.25rem;
        }
        .login-footer strong {
            color: var(--black);
            font-weight: 700;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 768px) {
            body { flex-direction: column; }
            .left-panel {
                width: 100%;
                padding: 2rem;
                min-height: 220px;
            }
            .stats-deco { display: none; }
            .brand-title { font-size: 2rem; }
            .right-panel { padding: 2rem 1.5rem; }
        }
    </style>
</head>
<body>

    <!-- PANEL IZQUIERDO -->
    <div class="left-panel">
        <div class="brand-block">
            <div class="brand-icon">
                <i class="bi bi-clock-history"></i>
            </div>
            <h1 class="brand-title">
                Control<br>de <span>Turnos</span>
            </h1>
            <p class="brand-sub">
                Plataforma integral para la gestión de horarios, marcajes,
                solicitudes de permiso y control del personal.
            </p>
        </div>
        <div class="stats-deco">
            <div class="stat-deco">
                <div class="stat-deco-num">3</div>
                <div class="stat-deco-label">Turnos</div>
            </div>
            <div class="stat-deco">
                <div class="stat-deco-num">24/7</div>
                <div class="stat-deco-label">Control</div>
            </div>
            <div class="stat-deco">
                <div class="stat-deco-num">v1.0</div>
                <div class="stat-deco-label">Sistema</div>
            </div>
        </div>
    </div>

    <!-- PANEL DERECHO -->
    <div class="right-panel">
        <div class="login-box">

            <p class="login-eyebrow">Acceso al Sistema</p>
            <h2 class="login-heading">
                Inicia <span>Sesión</span>
            </h2>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert-st alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <% if (request.getParameter("logout") != null) { %>
            <div class="alert-st alert-info">
                <i class="bi bi-check-circle-fill"></i>
                Sesión cerrada correctamente.
            </div>
            <% } %>

            <form action="login" method="post" autocomplete="off">

                <div class="f-group">
                    <label class="f-label">Usuario</label>
                    <div class="input-wrap">
                        <i class="bi bi-person input-icon"></i>
                        <input type="text" name="username"
                               class="f-input"
                               placeholder="nombre.usuario"
                               required autofocus>
                    </div>
                </div>

                <div class="f-group">
                    <label class="f-label">Contraseña</label>
                    <div class="input-wrap">
                        <i class="bi bi-lock input-icon"></i>
                        <input type="password" name="password"
                               id="passInput" class="f-input"
                               placeholder="••••••••" required>
                        <button type="button" class="btn-eye"
                                onclick="togglePass()">
                            <i class="bi bi-eye" id="eyeIcon"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn-login">
                    <i class="bi bi-box-arrow-in-right"></i>
                    Iniciar Sesión
                </button>

            </form>

            <div class="login-footer">
                <strong>Sistema v1.0</strong> &mdash; Solo personal autorizado<br>
                © 2025 Control de Turnos. Todos los derechos reservados.
            </div>

        </div>
    </div>

<script>
function togglePass() {
    const input = document.getElementById('passInput');
    const icon  = document.getElementById('eyeIcon');
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'bi bi-eye';
    }
}
</script>
</body>
</html>
