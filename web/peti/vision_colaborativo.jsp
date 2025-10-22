<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.*"%>

<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener información del grupo desde la sesión
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    // Verificar modo colaborativo
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    // Obtener información del usuario para el perfil
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) userEmail = "usuario@sistema.local";
    
    // Generar iniciales del usuario
    String userInitials = "";
    if (usuario != null && usuario.length() > 0) {
        String[] nombres = usuario.split(" ");
        userInitials = nombres[0].substring(0, 1).toUpperCase();
        if (nombres.length > 1) {
            userInitials += nombres[nombres.length - 1].substring(0, 1).toUpperCase();
        }
    }
    
    // Variables para los datos
    String visionActual = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaVision = request.getParameter("vision");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        
        try {
            if (nuevaVision != null && !nuevaVision.trim().isEmpty()) {
                ClsEPeti datoVision = new ClsEPeti(grupoId, "vision", "declaracion", nuevaVision.trim(), usuarioId);
                boolean exito = negocioPeti.guardarDato(datoVision);
                
                if (exito) {
                    mensaje = "Visión guardada exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar la visión";
                    tipoMensaje = "error";
                }
            }
        } catch (Exception e) {
            mensaje = "Error interno: " + e.getMessage();
            tipoMensaje = "error";
            e.printStackTrace();
        }
    }
    
    // Cargar datos existentes
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
            
            if (datosVision.containsKey("declaracion")) {
                visionActual = datosVision.get("declaracion");
            }
        } catch (Exception e) {
            //System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visión Corporativa - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1a365d;
            --primary-dark: #2d3748;
            --secondary-color: #2d3748;
            --accent-color: #3182ce;
            --accent-light: #63b3ed;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --text-primary: #2d3748;
            --text-secondary: #4a5568;
            --text-light: #718096;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        body {
            background: var(--light-bg);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background: var(--light-bg);
        }

        .dashboard-sidebar {
            width: 280px;
            background: var(--primary-color);
            color: white;
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            left: 0;
            top: 0;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .company-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
        }

        .company-logo i {
            font-size: 28px;
            color: var(--accent-light);
        }

        .company-logo h2 {
            font-size: 20px;
            font-weight: 700;
            color: white;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: var(--accent-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
            color: white;
        }

        .user-info h3 {
            font-size: 14px;
            font-weight: 600;
            color: white;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
        }

        .dashboard-nav {
            flex: 1;
            padding: 20px 0;
        }

        .nav-section {
            margin-bottom: 32px;
        }

        .nav-section-title {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 12px;
            padding: 0 20px;
        }

        .nav-section ul {
            list-style: none;
        }

        .nav-section li {
            margin-bottom: 4px;
        }

        .nav-section a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
            border-left: 3px solid transparent;
            position: relative;
        }

        .nav-section a:hover {
            background: rgba(255, 255, 255, 0.05);
            color: white;
            border-left-color: var(--accent-color);
        }

        .nav-section li.active a {
            background: var(--accent-color);
            color: white;
        }

        .nav-section li.active a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: white;
        }

        .nav-section a i {
            width: 18px;
            text-align: center;
            font-size: 16px;
        }

        .dashboard-content {
            flex: 1;
            margin-left: 280px;
            background: var(--light-bg);
            overflow-y: auto;
            height: 100vh;
        }

        .dashboard-header {
            background: var(--card-bg);
            padding: 20px 32px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow-sm);
        }

        .dashboard-header h1 {
            color: var(--text-primary);
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.025em;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            background: rgba(49, 130, 206, 0.1);
            color: var(--accent-color);
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
        }

        .status-badge i {
            margin-right: 6px;
        }

        .admin-badge {
            background: rgba(214, 158, 46, 0.1);
            color: var(--warning-color);
            margin-left: 8px;
        }

        .dashboard-main {
            padding: 32px;
        }

        .btn-primary {
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none;
        }

        .btn-primary:hover {
            background: #2c5282;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-primary i {
            margin-right: 8px;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .dashboard-section {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
            overflow: hidden;
        }

        .section-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            background: rgba(26, 54, 93, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-header h2 {
            margin: 0;
            color: var(--text-primary);
            font-size: 18px;
            font-weight: 600;
        }

        .section-content {
            padding: 24px;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: rgba(56, 161, 105, 0.1);
            border: 1px solid rgba(56, 161, 105, 0.2);
            color: var(--success-color);
        }

        .alert-error {
            background: rgba(229, 62, 62, 0.1);
            border: 1px solid rgba(229, 62, 62, 0.2);
            color: var(--danger-color);
        }

        .alert-warning {
            background: rgba(214, 158, 46, 0.1);
            border: 1px solid rgba(214, 158, 46, 0.2);
            color: var(--warning-color);
        }

        .guide-section {
            background: rgba(56, 161, 105, 0.05);
            border: 1px solid rgba(56, 161, 105, 0.2);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .guide-section h3 {
            color: var(--success-color);
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .guide-section ul {
            list-style: none;
            padding-left: 0;
        }

        .guide-section li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
            color: var(--text-secondary);
            font-size: 14px;
        }

        .guide-section li::before {
            content: '•';
            position: absolute;
            left: 0;
            color: var(--success-color);
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-weight: 500;
            font-size: 14px;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.2s ease;
            background: var(--card-bg);
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .form-group textarea[readonly] {
            background: #f8f9fa;
            color: var(--text-secondary);
            cursor: not-allowed;
        }

        .preview-card {
            background: rgba(26, 54, 93, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            margin-top: 24px;
        }

        .preview-card h3 {
            color: var(--text-primary);
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .preview-content {
            color: var(--text-primary);
            line-height: 1.6;
            font-size: 14px;
            padding: 16px;
            background: var(--card-bg);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            min-height: 80px;
        }

        .preview-content.empty {
            color: var(--text-light);
            font-style: italic;
        }

        .saved-indicator {
            color: var(--success-color);
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-left: 8px;
        }

        .mode-info {
            background: rgba(49, 130, 206, 0.05);
            border: 1px solid rgba(49, 130, 206, 0.2);
            border-radius: 8px;
            padding: 16px;
            margin-top: 24px;
            color: var(--accent-color);
            text-align: center;
        }

        .save-button-container {
            margin-top: 32px;
            text-align: center;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }
            
            .dashboard-sidebar {
                width: 100%;
                position: relative;
                height: auto;
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .dashboard-content {
                margin-left: 0;
            }
            
            .dashboard-main {
                padding: 20px;
            }
            
            .dashboard-header {
                padding: 16px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="company-logo">
                    <i class="fas fa-building"></i>
                    <h2>PETI System</h2>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        <span id="userInitials"><%= userInitials %></span>
                    </div>
                    <div class="user-info">
                        <h3 id="userName"><%= usuario %></h3>
                        <p id="userEmail"><%= userEmail %></p>
                    </div>
                </div>
            </div>
            <nav class="dashboard-nav">
                <div class="nav-section">
                    <div class="nav-section-title">Principal</div>
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Planificación Estratégica</div>
                    <ul>
                        <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Información Empresarial</a></li>
                        <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li class="active"><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
                        <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                        <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis Estratégico</div>
                    <ul>
                        <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
                        <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
                 
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Herramientas de Gestión</div>
                    <ul>
       
                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                        <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
                         <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
                        <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Sistema</div>
                    <ul>
                        <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                    </ul>
                </div>
            </nav>
        </div>

        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>
                    <i class="fas fa-eye"></i> Misión & Visión - <%= grupoActual != null ? grupoActual : "Modo Individual" %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i>
                            Modo Colaborativo
                        </span>
                        <% if ("admin".equals(rolUsuario)) { %>
                            <span class="status-badge admin-badge">
                                <i class="fas fa-crown"></i>
                                Administrador
                            </span>
                        <% } %>
                    <% } else { %>
                        <span class="status-badge">
                            <i class="fas fa-user"></i>
                            Modo Individual
                        </span>
                    <% } %>
                    <a href="../menuprincipal.jsp" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Menú Principal
                    </a>
                </div>
            </div>

            <div class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %>">
                        <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-triangle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> No puedes guardar cambios. 
                        <a href="../menuprincipal.jsp" style="color: var(--warning-color); text-decoration: underline;">Únete a un grupo</a> 
                        para trabajar colaborativamente.
                    </div>
                <% } %>

                <div class="dashboard-section">
                    <div class="section-header">
                        <h2><i class="fas fa-eye"></i> Definición de la Visión</h2>
                    </div>
                    <div class="section-content">
                        <div class="guide-section">
                            <h3><i class="fas fa-lightbulb"></i> Guía para redactar la visión:</h3>
                            <ul>
                                <li>¿Cómo se ve la empresa en el futuro?</li>
                                <li>¿Qué posición quiere alcanzar?</li>
                                <li>¿Cuáles son las aspiraciones a largo plazo?</li>
                                <li>¿Por qué el futuro competitivo deseado?</li>
                            </ul>
                        </div>

                        <form method="post" action="vision_colaborativo.jsp">
                            <div class="form-group">
                                <label for="vision">
                                    Declaración de la Visión:
                                    <% if (modoColaborativo && !visionActual.isEmpty()) { %>
                                        <span class="saved-indicator">
                                            <i class="fas fa-check-circle"></i> Guardado
                                        </span>
                                    <% } %>
                                </label>
                                <textarea 
                                    id="vision" 
                                    name="vision" 
                                    placeholder="Describe la visión a largo plazo de la organización..."
                                    oninput="updatePreview()"
                                    <%= modoColaborativo ? "" : "readonly" %>
                                    required><%= visionActual %></textarea>
                            </div>

                            <div class="preview-card">
                                <h3><i class="fas fa-eye"></i> Vista Previa de la Visión</h3>
                                <div id="visionPreview" class="preview-content <%= visionActual.isEmpty() ? "empty" : "" %>">
                                    <%= visionActual.isEmpty() ? "La vista previa aparecerá aquí mientras escribes..." : visionActual %>
                                </div>
                            </div>

                            <% if (modoColaborativo) { %>
                                <div class="save-button-container">
                                    <button type="submit" class="btn-primary">
                                        <i class="fas fa-save"></i> Guardar Visión
                                    </button>
                                </div>
                            <% } else { %>
                                <div class="mode-info">
                                    <i class="fas fa-info-circle"></i>
                                    Para guardar cambios, únete a un grupo colaborativo desde el menú principal.
                                </div>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function updatePreview() {
            const visionText = document.getElementById('vision').value;
            const preview = document.getElementById('visionPreview');
            
            if (visionText.trim()) {
                preview.textContent = visionText;
                preview.classList.remove('empty');
            } else {
                preview.textContent = 'La vista previa aparecerá aquí mientras escribes...';
                preview.classList.add('empty');
            }
        }

        function logout() {
            if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
                window.location.href = '../logout.jsp';
            }
        }

        // Auto-refresh para modo colaborativo
        <% if (modoColaborativo) { %>
            let lastUpdateTime = new Date().getTime();
            
            function checkForUpdates() {
                // Implementar lógica de actualización automática si es necesario
            }
            
            // Verificar actualizaciones cada 30 segundos
            setInterval(checkForUpdates, 30000);
        <% } %>

        // Inicializar vista previa
        document.addEventListener('DOMContentLoaded', function() {
            updatePreview();
        });
    </script>
</body>
</html>