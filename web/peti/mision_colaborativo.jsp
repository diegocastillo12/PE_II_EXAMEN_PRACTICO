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
    
    // Variables para los datos
    String misionActual = "";
    String visionActual = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String accion = request.getParameter("accion");
        String nuevaMision = request.getParameter("mision");
        String nuevaVision = request.getParameter("vision");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = false;
        
        try {
            if ("guardar_mision".equals(accion) && nuevaMision != null && !nuevaMision.trim().isEmpty()) {
                ClsEPeti datoMision = new ClsEPeti(grupoId, "mision", "declaracion", nuevaMision.trim(), usuarioId);
                exito = negocioPeti.guardarDato(datoMision);
                if (exito) {
                    mensaje = "Misión guardada exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar la misión";
                    tipoMensaje = "error";
                }
            } else if ("guardar_vision".equals(accion) && nuevaVision != null && !nuevaVision.trim().isEmpty()) {
                ClsEPeti datoVision = new ClsEPeti(grupoId, "vision", "declaracion", nuevaVision.trim(), usuarioId);
                exito = negocioPeti.guardarDato(datoVision);
                if (exito) {
                    mensaje = "Visión guardada exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar la visión";
                    tipoMensaje = "error";
                }
            } else if ("guardar_ambas".equals(accion)) {
                boolean exitoMision = true;
                boolean exitoVision = true;
                
                if (nuevaMision != null && !nuevaMision.trim().isEmpty()) {
                    ClsEPeti datoMision = new ClsEPeti(grupoId, "mision", "declaracion", nuevaMision.trim(), usuarioId);
                    exitoMision = negocioPeti.guardarDato(datoMision);
                }
                if (nuevaVision != null && !nuevaVision.trim().isEmpty()) {
                    ClsEPeti datoVision = new ClsEPeti(grupoId, "vision", "declaracion", nuevaVision.trim(), usuarioId);
                    exitoVision = negocioPeti.guardarDato(datoVision);
                }
                
                if (exitoMision && exitoVision) {
                    mensaje = "Misión y Visión guardadas exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar algunos datos";
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
            Map<String, String> datosMision = negocioPeti.obtenerDatosSeccion(grupoId, "mision");
            Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
            
            if (datosMision.containsKey("declaracion")) {
                misionActual = datosMision.get("declaracion");
            }
            if (datosVision.containsKey("declaracion")) {
                visionActual = datosVision.get("declaracion");
            }
        } catch (Exception e) {
            //System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
    
    // Obtener iniciales del usuario para el avatar
    String userInitials = "";
    if (usuario != null && usuario.length() > 0) {
        String[] parts = usuario.split(" ");
        if (parts.length >= 2) {
            userInitials = parts[0].substring(0, 1).toUpperCase() + parts[1].substring(0, 1).toUpperCase();
        } else {
            userInitials = usuario.substring(0, Math.min(2, usuario.length())).toUpperCase();
        }
    }
    
    String userEmail = usuario + "@empresa.com"; // Email simulado
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Misión y Visión - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --primary-dark: #2d3748;
            --secondary-color: #2d3748;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --error-color: #e53e3e;
            --text-primary: #2d3748;
            --text-secondary: #4a5568;
            --background-light: #f7fafc;
            --background-white: #ffffff;
            --border-color: #e2e8f0;
            --shadow-light: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-medium: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-heavy: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--background-light);
            min-height: 100vh;
            color: var(--text-primary);
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background: var(--background-light);
        }

        .dashboard-sidebar {
            width: 280px;
            background: var(--primary-color);
            color: white;
            box-shadow: var(--shadow-heavy);
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
        }

        .company-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .company-logo i {
            font-size: 28px;
            color: var(--accent-color);
        }

        .company-logo h2 {
            font-size: 20px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.025em;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            margin-top: 8px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: var(--accent-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 16px;
            color: white;
            flex-shrink: 0;
        }

        .user-info h3 {
            font-size: 14px;
            font-weight: 600;
            margin: 0;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.7;
            margin: 0;
        }

        .dashboard-nav {
            flex: 1;
            padding: 20px 0;
            overflow-y: auto;
        }

        .nav-section {
            margin-bottom: 24px;
        }

        .nav-section-title {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.6);
            padding: 0 20px 8px;
            letter-spacing: 0.5px;
        }

        .nav-section ul {
            list-style: none;
        }

        .nav-section li {
            margin: 2px 0;
        }

        .nav-section a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 14px;
            border-left: 3px solid transparent;
        }

        .nav-section a:hover {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: var(--accent-color);
            color: white;
        }

        .nav-section li.active a {
            background: rgba(49, 130, 206, 0.2);
            border-left-color: var(--accent-color);
            color: white;
            font-weight: 500;
        }

        .nav-section a i {
            width: 16px;
            text-align: center;
            font-size: 14px;
        }

        .dashboard-content {
            flex: 1;
            margin-left: 280px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .dashboard-header {
            background: var(--background-white);
            padding: 20px 32px;
            box-shadow: var(--shadow-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
        }

        .dashboard-header h1 {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .status-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: var(--success-color);
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .admin-badge {
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            background: rgba(255,255,255,0.2);
            border-radius: 12px;
            font-size: 12px;
            margin-left: 8px;
        }

        .dashboard-main {
            flex: 1;
            padding: 32px;
            background: var(--background-light);
        }

        .dashboard-section {
            background: var(--background-white);
            border-radius: 16px;
            box-shadow: var(--shadow-light);
            margin-bottom: 24px;
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .section-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            background: var(--background-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-header h2 {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .section-content {
            padding: 24px;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-secondary {
            background: var(--text-secondary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-secondary:hover {
            background: var(--text-primary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
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
            background: #f0fff4;
            border: 1px solid #9ae6b4;
            color: #22543d;
        }

        .alert-error {
            background: #fed7d7;
            border: 1px solid #feb2b2;
            color: #742a2a;
        }

        .alert-warning {
            background: #fefcbf;
            border: 1px solid #f6e05e;
            color: #744210;
        }

        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background: var(--background-white);
        }

        .form-section h3 {
            color: var(--text-primary);
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: var(--text-primary);
            font-weight: 500;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .preview {
            background: var(--background-light);
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            border-left: 4px solid var(--accent-color);
        }

        .preview h4 {
            color: var(--text-primary);
            margin-bottom: 10px;
        }

        .preview p {
            color: var(--text-secondary);
            line-height: 1.6;
            font-style: italic;
        }

        .guidelines {
            background: #ebf8ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .guidelines h4 {
            color: var(--accent-color);
            margin-bottom: 10px;
        }

        .guidelines ul {
            color: var(--text-secondary);
            padding-left: 20px;
        }

        .guidelines li {
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
                height: auto;
                min-height: 100vh;
            }
            
            .dashboard-sidebar {
                width: 100%;
                position: relative;
                height: auto;
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
                        <span><%= userInitials %></span>
                    </div>
                    <div class="user-info">
                        <h3><%= usuario %></h3>
                        <p><%= userEmail %></p>
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
                        <li class="active"><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
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
            <header class="dashboard-header">
                <h1>
                    <i class="fas fa-bullseye"></i> Misión y Visión
                    <% if (modoColaborativo) { %>
                        - <%= grupoActual %>
                    <% } else { %>
                        - Modo Individual
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <div class="status-badge">
                            <i class="fas fa-users"></i> Modo Colaborativo
                            <% if ("admin".equals(rolUsuario)) { %>
                                <span class="admin-badge">
                                    <i class="fas fa-crown"></i> Administrador
                                </span>
                            <% } %>
                        </div>
                    <% } %>
                    <a href="../menuprincipal.jsp" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Menú Principal
                    </a>
                </div>
            </header>
            <main class="dashboard-main">
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
                        <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Únete a un grupo</a> 
                        para trabajar colaborativamente.
                    </div>
                <% } %>

                <form method="post" action="">
                    <!-- Sección Misión -->
                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2><i class="fas fa-bullseye"></i> Definición de la Misión</h2>
                        </div>
                        <div class="section-content">
                            <div class="guidelines">
                                <h4>Guía para redactar la misión:</h4>
                                <ul>
                                    <li>¿Qué hace la empresa? (productos/servicios)</li>
                                    <li>¿Para quién lo hace? (clientes/mercado)</li>
                                    <li>¿Cómo lo hace? (ventaja competitiva)</li>
                                    <li>¿Por qué lo hace? (propósito/valores)</li>
                                </ul>
                            </div>

                            <div class="form-group">
                                <label for="mision">
                                    Declaración de la Misión:
                                    <% if (modoColaborativo && !misionActual.isEmpty()) { %>
                                        <span style="color: #28a745; font-size: 12px;">
                                            <i class="fas fa-check-circle"></i> Datos guardados del grupo
                                        </span>
                                    <% } %>
                                </label>
                                <textarea 
                                    id="mision" 
                                    name="mision"
                                    placeholder="Redacte la misión de su empresa de manera clara y concisa..."
                                    <%= modoColaborativo ? "" : "readonly" %>
                                    onkeyup="actualizarPreview()"
                                ><%= misionActual %></textarea>
                            </div>

                            <div class="preview">
                                <h4>Vista Previa de la Misión:</h4>
                                <p id="misionPreview"><%= !misionActual.isEmpty() ? misionActual : "La misión aparecerá aquí mientras la escribes..." %></p>
                            </div>

                            <% if (modoColaborativo) { %>
                                <button type="submit" name="accion" value="guardar_mision" class="btn-primary" style="margin-top: 15px;">
                                    <i class="fas fa-save"></i> Guardar Misión
                                </button>
                            <% } %>
                        </div>
                    </div>

                    <!-- Sección Visión -->
                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2><i class="fas fa-eye"></i> Definición de la Visión</h2>
                        </div>
                        <div class="section-content">
                            <div class="guidelines">
                                <h4>Guía para redactar la visión:</h4>
                                <ul>
                                    <li>¿Cómo se ve la empresa en el futuro?</li>
                                    <li>¿Qué posición quiere alcanzar?</li>
                                    <li>¿Cuáles son sus aspiraciones a largo plazo?</li>
                                    <li>¿Qué impacto quiere tener en su mercado?</li>
                                </ul>
                            </div>

                            <div class="form-group">
                                <label for="vision">
                                    Declaración de la Visión:
                                    <% if (modoColaborativo && !visionActual.isEmpty()) { %>
                                        <span style="color: #28a745; font-size: 12px;">
                                            <i class="fas fa-check-circle"></i> Datos guardados del grupo
                                        </span>
                                    <% } %>
                                </label>
                                <textarea 
                                    id="vision" 
                                    name="vision"
                                    placeholder="Redacte la visión de su empresa hacia el futuro..."
                                    <%= modoColaborativo ? "" : "readonly" %>
                                    onkeyup="actualizarPreviewVision()"
                                ><%= visionActual %></textarea>
                            </div>

                            <div class="preview">
                                <h4>Vista Previa de la Visión:</h4>
                                <p id="visionPreview"><%= !visionActual.isEmpty() ? visionActual : "La visión aparecerá aquí mientras la escribes..." %></p>
                            </div>

                            <% if (modoColaborativo) { %>
                                <div style="margin-top: 15px; display: flex; gap: 15px;">
                                    <button type="submit" name="accion" value="guardar_vision" class="btn-primary">
                                        <i class="fas fa-save"></i> Guardar Visión
                                    </button>
                                    <button type="submit" name="accion" value="guardar_ambas" class="btn-primary" style="background: #28a745;">
                                        <i class="fas fa-save"></i> Guardar Ambas
                                    </button>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </form>

                <% if (modoColaborativo) { %>
                    <div class="dashboard-section">
                        <div class="section-content">
                            <div style="background: #e8f5e8; padding: 15px; border-radius: 8px;">
                                <p style="color: #2d5a3d; margin: 0;">
                                    <i class="fas fa-info-circle"></i> 
                                    <strong>Modo Colaborativo Activo:</strong> Los cambios se guardan automáticamente y son visibles 
                                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                                </p>
                            </div>
                        </div>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    <script>
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }

        function actualizarPreview() {
            const mision = document.getElementById('mision').value;
            const preview = document.getElementById('misionPreview');
            
            if (mision.trim()) {
                preview.textContent = mision;
                preview.style.fontStyle = 'normal';
                preview.style.color = '#333';
            } else {
                preview.textContent = 'La misión aparecerá aquí mientras la escribes...';
                preview.style.fontStyle = 'italic';
                preview.style.color = '#666';
            }
        }
        
        function actualizarPreviewVision() {
            const vision = document.getElementById('vision').value;
            const preview = document.getElementById('visionPreview');
            
            if (vision.trim()) {
                preview.textContent = vision;
                preview.style.fontStyle = 'normal';
                preview.style.color = '#333';
            } else {
                preview.textContent = 'La visión aparecerá aquí mientras la escribes...';
                preview.style.fontStyle = 'italic';
                preview.style.color = '#666';
            }
        }

        // Actualizar enlaces de navegación
        document.addEventListener('DOMContentLoaded', function() {
            const navLinks = document.querySelectorAll('.dashboard-nav a[href$=".jsp"]');
            navLinks.forEach(link => {
                const originalHref = link.getAttribute('href');
                <% if (modoColaborativo) { %>
                    if (!originalHref.includes('?')) {
                        link.setAttribute('href', originalHref + '?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>');
                    }
                <% } else { %>
                    if (!originalHref.includes('?')) {
                        link.setAttribute('href', originalHref + '?modo=individual');
                    }
                <% } %>
            });
        });
    </script>
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh cada 10 segundos para ver cambios de otros usuarios
        setInterval(function() {
            // Solo recargar si no hay cambios sin guardar
            const misionInput = document.getElementById('mision');
            const visionInput = document.getElementById('vision');
            
            if (!misionInput.dataset.changed && !visionInput.dataset.changed) {
                location.reload();
            }
        }, 10000);

        // Marcar como cambiado cuando el usuario escribe
        document.getElementById('mision').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
        
        document.getElementById('vision').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
    </script>
    <% } %>
</body>
</html>