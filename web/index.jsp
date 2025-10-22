<%-- 
    Document   : index
    Created on : 15 set. 2025, 11:07:20 p. m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sistema PETI - Inicio de Sesión</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-blue: #2563eb;
                --primary-blue-dark: #1e40af;
                --secondary-blue: #0ea5e9;
                --blue-50: #eff6ff;
                --blue-100: #dbeafe;
                --blue-200: #bfdbfe;
                --blue-900: #1e3a8a;
                --text-primary: #1e293b;
                --text-secondary: #64748b;
                --text-light: #94a3b8;
                --white: #ffffff;
                --gray-50: #f8fafc;
                --gray-200: #e2e8f0;
                --shadow-sm: 0 2px 8px rgba(37, 99, 235, 0.08);
                --shadow-md: 0 8px 24px rgba(37, 99, 235, 0.12);
                --shadow-lg: 0 16px 48px rgba(37, 99, 235, 0.18);
                --shadow-xl: 0 20px 60px rgba(37, 99, 235, 0.25);
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }
            
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Inter', 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #2563eb 0%, #1e40af 50%, #0ea5e9 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                position: relative;
                overflow-x: hidden;
            }
            
            /* Fondo animado */
            body::before {
                content: '';
                position: absolute;
                width: 800px;
                height: 800px;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
                top: -400px;
                right: -200px;
                border-radius: 50%;
                animation: float 25s infinite ease-in-out;
            }
            
            body::after {
                content: '';
                position: absolute;
                width: 600px;
                height: 600px;
                background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
                bottom: -300px;
                left: -150px;
                border-radius: 50%;
                animation: float 20s infinite ease-in-out reverse;
            }
            
            @keyframes float {
                0%, 100% { transform: translate(0, 0) scale(1); }
                50% { transform: translate(50px, -30px) scale(1.1); }
            }
            
            .container-wrapper {
                position: relative;
                z-index: 1;
                width: 100%;
                max-width: 480px;
            }
            
            /* Logo y título */
            .brand-header {
                text-align: center;
                margin-bottom: 2.5rem;
                animation: fadeInDown 0.6s ease-out;
            }
            
            @keyframes fadeInDown {
                from { opacity: 0; transform: translateY(-40px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .brand-logo {
                width: 90px;
                height: 90px;
                background: var(--white);
                border-radius: 24px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1.25rem;
                box-shadow: var(--shadow-xl);
                animation: pulse 3s infinite;
                position: relative;
            }
            
            .brand-logo::before {
                content: '';
                position: absolute;
                inset: -4px;
                background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
                border-radius: 26px;
                z-index: -1;
                opacity: 0.3;
                animation: rotate 8s linear infinite;
            }
            
            @keyframes pulse {
                0%, 100% { transform: scale(1); box-shadow: var(--shadow-xl); }
                50% { transform: scale(1.05); box-shadow: 0 20px 70px rgba(37, 99, 235, 0.35); }
            }
            
            @keyframes rotate {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
            
            .brand-logo i {
                font-size: 3rem;
                color: var(--primary-blue);
            }
            
            .brand-title {
                color: var(--white);
                font-size: 2.75rem;
                font-weight: 800;
                margin-bottom: 0.5rem;
                text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
                letter-spacing: -1px;
            }
            
            .brand-subtitle {
                color: rgba(255, 255, 255, 0.95);
                font-size: 1.15rem;
                font-weight: 500;
                text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            }
            
            /* Pestañas */
            .tabs {
                display: flex;
                gap: 8px;
                margin-bottom: 0;
                padding: 6px;
                background: rgba(255, 255, 255, 0.15);
                backdrop-filter: blur(20px);
                border-radius: 16px;
                box-shadow: var(--shadow-md);
                animation: fadeInUp 0.6s ease-out 0.2s both;
            }
            
            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .tab-button {
                flex: 1;
                padding: 0.875rem 1.5rem;
                border: none;
                background: transparent;
                color: rgba(255, 255, 255, 0.8);
                cursor: pointer;
                font-size: 1rem;
                font-weight: 600;
                transition: var(--transition);
                border-radius: 12px;
                position: relative;
            }
            
            .tab-button::before {
                content: '';
                position: absolute;
                inset: 0;
                background: var(--white);
                opacity: 0;
                transition: opacity 0.3s;
                border-radius: 12px;
            }
            
            .tab-button.active::before {
                opacity: 1;
            }
            
            .tab-button.active {
                color: var(--primary-blue);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            
            .tab-button:hover:not(.active) {
                background: rgba(255, 255, 255, 0.1);
                color: var(--white);
            }
            
            .tab-button i {
                margin-right: 8px;
                font-size: 1.1rem;
                position: relative;
                z-index: 1;
            }
            
            .tab-button span {
                position: relative;
                z-index: 1;
            }
            
            /* Contenedor del formulario */
            .login-container {
                background: var(--white);
                padding: 2.5rem;
                border-radius: 0 0 24px 24px;
                box-shadow: var(--shadow-xl);
                animation: fadeInUp 0.6s ease-out 0.3s both;
                position: relative;
                overflow: hidden;
            }
            
            .login-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(90deg, var(--primary-blue), var(--secondary-blue), var(--primary-blue));
                background-size: 200% 100%;
                animation: shimmer 3s infinite;
            }
            
            @keyframes shimmer {
                0% { background-position: -200% 0; }
                100% { background-position: 200% 0; }
            }
            
            .login-header {
                text-align: center;
                margin-bottom: 2rem;
            }
            
            .login-header h1 {
                color: var(--text-primary);
                font-size: 1.875rem;
                margin-bottom: 0.5rem;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
            }
            
            .login-header h1 i {
                font-size: 1.75rem;
                color: var(--primary-blue);
            }
            
            .login-header p {
                color: var(--text-secondary);
                font-size: 1rem;
            }
            
            /* Formulario */
            .form-group {
                margin-bottom: 1.5rem;
            }
            
            .form-group label {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 0.65rem;
                color: var(--text-primary);
                font-weight: 600;
                font-size: 0.9rem;
            }
            
            .form-group label i {
                color: var(--primary-blue);
                font-size: 1.1rem;
                width: 20px;
                text-align: center;
            }
            
            .form-group input {
                width: 100%;
                padding: 1rem 1.125rem;
                border: 2px solid var(--gray-200);
                border-radius: 14px;
                font-size: 1rem;
                transition: var(--transition);
                background: var(--gray-50);
                font-family: inherit;
                color: var(--text-primary);
            }
            
            .form-group input:hover {
                border-color: var(--blue-200);
                background: var(--white);
            }
            
            .form-group input:focus {
                outline: none;
                border-color: var(--primary-blue);
                background: var(--white);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
                transform: translateY(-2px);
            }
            
            .form-group input::placeholder {
                color: var(--text-light);
            }
            
            .optional-label {
                font-size: 0.8rem;
                color: var(--text-light);
                font-style: italic;
                font-weight: 400;
            }
            
            /* Botón */
            .btn-login {
                width: 100%;
                padding: 1.125rem;
                background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
                color: var(--white);
                border: none;
                border-radius: 14px;
                font-size: 1.05rem;
                font-weight: 700;
                cursor: pointer;
                transition: var(--transition);
                box-shadow: 0 8px 20px rgba(37, 99, 235, 0.35);
                position: relative;
                overflow: hidden;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .btn-login::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.3);
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
            }
            
            .btn-login:hover::before {
                width: 400px;
                height: 400px;
            }
            
            .btn-login:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 28px rgba(37, 99, 235, 0.45);
            }
            
            .btn-login:active {
                transform: translateY(-1px);
            }
            
            .btn-login i,
            .btn-login span {
                position: relative;
                z-index: 1;
            }
            
            .btn-login i {
                margin-right: 8px;
            }
            
            /* Divisor */
            .divider {
                text-align: center;
                margin: 2rem 0;
                position: relative;
            }
            
            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 2px;
                background: linear-gradient(90deg, transparent, var(--blue-200), transparent);
            }
            
            .divider span {
                background: var(--white);
                padding: 0 1.5rem;
                color: var(--primary-blue);
                font-size: 0.85rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                position: relative;
                z-index: 1;
            }
            
            /* Info box */
            .info-box {
                background: linear-gradient(135deg, var(--blue-50) 0%, var(--blue-100) 100%);
                border-left: 5px solid var(--primary-blue);
                padding: 1.5rem;
                margin-top: 1.75rem;
                border-radius: 0 16px 16px 0;
                box-shadow: var(--shadow-sm);
            }
            
            .info-box h4 {
                color: var(--blue-900);
                margin-bottom: 0.875rem;
                font-size: 1rem;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .info-box h4 i {
                color: var(--primary-blue);
                font-size: 1.2rem;
            }
            
            .info-box p {
                color: var(--text-secondary);
                font-size: 0.9rem;
                line-height: 1.7;
                margin-bottom: 0.6rem;
            }
            
            .info-box p:last-child {
                margin-bottom: 0;
            }
            
            .info-box strong {
                color: var(--primary-blue);
                font-weight: 700;
            }
            
            /* Alertas */
            .alert {
                padding: 1.125rem 1.375rem;
                border-radius: 14px;
                margin-bottom: 1.75rem;
                font-size: 0.95rem;
                display: flex;
                align-items: flex-start;
                gap: 14px;
                border-left: 5px solid;
                animation: slideInDown 0.5s ease-out;
            }
            
            @keyframes slideInDown {
                from { opacity: 0; transform: translateY(-25px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .alert i {
                font-size: 1.375rem;
                margin-top: 2px;
                flex-shrink: 0;
            }
            
            .alert-error {
                background: #fef2f2;
                border-color: #ef4444;
                color: #991b1b;
            }
            
            .alert-error i {
                color: #ef4444;
            }
            
            .alert-success {
                background: var(--blue-50);
                border-color: var(--primary-blue);
                color: var(--blue-900);
            }
            
            .alert-success i {
                color: var(--primary-blue);
            }
            
            /* Pestañas de contenido */
            .tab-content {
                display: none;
            }
            
            .tab-content.active {
                display: block;
            }
            
            /* Responsive - Tablet */
            @media (max-width: 768px) {
                .container-wrapper {
                    max-width: 420px;
                }
                
                .brand-logo {
                    width: 75px;
                    height: 75px;
                }
                
                .brand-logo i {
                    font-size: 2.5rem;
                }
                
                .brand-title {
                    font-size: 2.25rem;
                }
                
                .brand-subtitle {
                    font-size: 1rem;
                }
                
                .login-container {
                    padding: 2.25rem 2rem;
                }
                
                .tab-button {
                    font-size: 0.95rem;
                    padding: 0.875rem 1.25rem;
                }
                
                .login-header h1 {
                    font-size: 1.625rem;
                }
            }
            
            /* Responsive - Mobile */
            @media (max-width: 480px) {
                body {
                    padding: 15px 10px;
                }
                
                .brand-header {
                    margin-bottom: 2rem;
                }
                
                .brand-logo {
                    width: 70px;
                    height: 70px;
                }
                
                .brand-logo i {
                    font-size: 2.25rem;
                }
                
                .brand-title {
                    font-size: 1.875rem;
                }
                
                .brand-subtitle {
                    font-size: 0.925rem;
                }
                
                .tabs {
                    padding: 5px;
                }
                
                .tab-button {
                    font-size: 0.875rem;
                    padding: 0.75rem 0.875rem;
                }
                
                .tab-button i {
                    margin-right: 6px;
                    font-size: 1rem;
                }
                
                .login-container {
                    padding: 2rem 1.5rem;
                    border-radius: 0 0 20px 20px;
                }
                
                .login-header h1 {
                    font-size: 1.5rem;
                }
                
                .login-header h1 i {
                    font-size: 1.5rem;
                }
                
                .login-header p {
                    font-size: 0.9rem;
                }
                
                .form-group input {
                    padding: 0.875rem 1rem;
                    font-size: 0.95rem;
                }
                
                .btn-login {
                    padding: 1rem;
                    font-size: 0.975rem;
                }
                
                .info-box {
                    padding: 1.25rem;
                }
                
                .info-box h4 {
                    font-size: 0.925rem;
                }
                
                .info-box p {
                    font-size: 0.85rem;
                }
            }
            
            /* Extra pequeño */
            @media (max-width: 360px) {
                .brand-title {
                    font-size: 1.625rem;
                }
                
                .login-container {
                    padding: 1.75rem 1.25rem;
                }
                
                .tab-button {
                    font-size: 0.8rem;
                    padding: 0.675rem 0.75rem;
                }
                
                .form-group input {
                    padding: 0.75rem 0.875rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="container-wrapper">
            <!-- Logo y título -->
            <div class="brand-header">
                <div class="brand-logo">
                    <i class="fas fa-laptop-code"></i>
                </div>
                <h1 class="brand-title">Sistema PETI</h1>
                <p class="brand-subtitle">Planeación Estratégica de Tecnologías de Información</p>
            </div>
            
            <!-- Pestañas -->
            <div class="tabs">
                <button class="tab-button active" onclick="showTab('login')">
                    <i class="fas fa-sign-in-alt"></i><span>Iniciar Sesión</span>
                </button>
                <button class="tab-button" onclick="showTab('register')">
                    <i class="fas fa-user-plus"></i><span>Registrarse</span>
                </button>
            </div>
            
            <!-- Formulario de Login -->
            <div id="loginTab" class="login-container tab-content active">
                <div class="login-header">
                    <h1><i class="fas fa-lock"></i>Bienvenido</h1>
                    <p>Inicia sesión para acceder al sistema</p>
                </div>
                
                <%
                    String error = request.getParameter("error");
                    String success = request.getParameter("success");
                    
                    if (error != null) {
                        String mensajeError = "";
                        switch (error) {
                            case "campos_vacios":
                                mensajeError = "Por favor, completa todos los campos obligatorios.";
                                break;
                            case "credenciales_invalidas":
                                mensajeError = "Usuario o contraseña incorrectos.";
                                break;
                            case "codigo_invalido":
                                mensajeError = "El código de grupo ingresado no es válido.";
                                break;
                            case "grupo_lleno":
                                mensajeError = "El grupo ha alcanzado su límite máximo de usuarios.";
                                break;
                            case "campos_vacios_registro":
                                mensajeError = "Todos los campos obligatorios deben estar completos.";
                                break;
                            case "passwords_no_coinciden":
                                mensajeError = "Las contraseñas no coinciden.";
                                break;
                            case "password_muy_corta":
                                mensajeError = "La contraseña debe tener al menos 3 caracteres.";
                                break;
                            case "username_invalido":
                                mensajeError = "El nombre de usuario debe tener entre 3 y 50 caracteres.";
                                break;
                            case "email_invalido":
                                mensajeError = "El formato del email no es válido.";
                                break;
                            case "usuario_ya_existe":
                                mensajeError = "Este nombre de usuario ya está registrado.";
                                break;
                            case "email_ya_existe":
                                mensajeError = "Este email ya está registrado.";
                                break;
                            case "datos_duplicados":
                                mensajeError = "Los datos ingresados ya están en uso.";
                                break;
                            case "error_base_datos":
                                mensajeError = "Error de conexión con la base de datos.";
                                break;
                            case "error_interno":
                                mensajeError = "Error interno del servidor. Inténtalo más tarde.";
                                break;
                            case "error_registro":
                                mensajeError = "No se pudo completar el registro. Inténtalo de nuevo.";
                                break;
                            default:
                                mensajeError = "Ha ocurrido un error. Inténtalo de nuevo.";
                        }
                %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span><%= mensajeError %></span>
                        </div>
                <%
                    }
                    
                    if (success != null) {
                        String mensajeExito = "";
                        switch (success) {
                            case "logout":
                                mensajeExito = "Has cerrado sesión correctamente.";
                                break;
                            case "registro_exitoso":
                                String usernameParam = request.getParameter("username");
                                mensajeExito = "¡Cuenta creada exitosamente" + 
                                             (usernameParam != null ? " para " + usernameParam : "") + 
                                             "! Ya puedes iniciar sesión.";
                                break;
                            default:
                                mensajeExito = "Operación realizada con éxito.";
                        }
                %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span><%= mensajeExito %></span>
                        </div>
                <%
                    }
                %>
                
                <form action="validarLogin.jsp" method="post">
                    <div class="form-group">
                        <label for="usuario">
                            <i class="fas fa-user"></i> Usuario
                        </label>
                        <input type="text" id="usuario" name="usuario" required 
                               placeholder="Ingresa tu nombre de usuario">
                    </div>
                    
                    <div class="form-group">
                        <label for="password">
                            <i class="fas fa-lock"></i> Contraseña
                        </label>
                        <input type="password" id="password" name="password" required
                               placeholder="Ingresa tu contraseña">
                    </div>
                    
                    <div class="divider">
                        <span>Opcional</span>
                    </div>
                    
                    <div class="form-group">
                        <label for="codigoGrupo">
                            <i class="fas fa-users"></i> Código de Grupo 
                            <span class="optional-label">(opcional)</span>
                        </label>
                        <input type="text" id="codigoGrupo" name="codigoGrupo" 
                               placeholder="Ingresa el código si deseas unirte a un grupo">
                    </div>
                    
                    <button type="submit" class="btn-login">
                        <i class="fas fa-sign-in-alt"></i><span>Iniciar Sesión</span>
                    </button>
                </form>
                
                <div class="info-box">
                    <h4><i class="fas fa-info-circle"></i> ¿Cómo funciona?</h4>
                    <p><strong>Sin código:</strong> Accederás al menú principal donde podrás crear tu propio grupo de trabajo.</p>
                    <p><strong>Con código:</strong> Te unirás directamente a un grupo existente creado por otro usuario.</p>
                </div>
            </div>
            
            <!-- Formulario de Registro -->
            <div id="registerTab" class="login-container tab-content">
                <div class="login-header">
                    <h1><i class="fas fa-user-plus"></i>Crear Cuenta</h1>
                    <p>Regístrate para comenzar a crear o unirte a grupos</p>
                </div>
                
                <form action="registrarUsuario.jsp" method="post">
                    <div class="form-group">
                        <label for="regUsername">
                            <i class="fas fa-user-circle"></i> Nombre de Usuario
                        </label>
                        <input type="text" id="regUsername" name="username" required 
                               placeholder="Elige un nombre de usuario" maxlength="50">
                    </div>
                    
                    <div class="form-group">
                        <label for="regPassword">
                            <i class="fas fa-key"></i> Contraseña
                        </label>
                        <input type="password" id="regPassword" name="password" required 
                               placeholder="Crea una contraseña segura" minlength="3">
                    </div>
                    
                    <div class="form-group">
                        <label for="regConfirmPassword">
                            <i class="fas fa-check-double"></i> Confirmar Contraseña
                        </label>
                        <input type="password" id="regConfirmPassword" name="confirmPassword" required 
                               placeholder="Repite la contraseña" minlength="3">
                    </div>
                    
                    <div class="form-group">
                        <label for="regEmail">
                            <i class="fas fa-envelope"></i> Email 
                            <span class="optional-label">(opcional)</span>
                        </label>
                        <input type="email" id="regEmail" name="email" 
                               placeholder="tu@email.com" maxlength="100">
                    </div>
                    
                    <button type="submit" class="btn-login">
                        <i class="fas fa-rocket"></i><span>Crear Cuenta</span>
                    </button>
                </form>
                
                <div class="info-box">
                    <h4><i class="fas fa-lightbulb"></i> Beneficios de registrarte</h4>
                    <p><strong>✓</strong> Crea y gestiona tus propios grupos de trabajo colaborativos.</p>
                    <p><strong>✓</strong> Únete a grupos existentes usando códigos de invitación.</p>
                    <p><strong>✓</strong> Guarda y comparte tu progreso en el plan PETI.</p>
                </div>
            </div>
        </div>
        
        <script>
            function showTab(tabName) {
                // Ocultar todos los contenidos
                const tabContents = document.querySelectorAll('.tab-content');
                tabContents.forEach(tab => tab.classList.remove('active'));
                
                // Remover clase active de todos los botones
                const tabButtons = document.querySelectorAll('.tab-button');
                tabButtons.forEach(button => button.classList.remove('active'));
                
                // Mostrar la pestaña seleccionada
                if (tabName === 'login') {
                    document.getElementById('loginTab').classList.add('active');
                    document.querySelector('[onclick="showTab(\'login\')"]').classList.add('active');
                } else if (tabName === 'register') {
                    document.getElementById('registerTab').classList.add('active');
                    document.querySelector('[onclick="showTab(\'register\')"]').classList.add('active');
                }
            }
        </script>
    </body>
</html>
