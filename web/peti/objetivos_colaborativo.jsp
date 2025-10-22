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
    String objetivoGeneral = "";
    String objetivo1 = "";
    String objetivo2 = "";
    String objetivo3 = "";
    String objetivo4 = "";
    String indicadores = "";
    String metas = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevoObjetivoGeneral = request.getParameter("objetivo_general");
        String nuevosIndicadores = request.getParameter("indicadores");
        String nuevasMetas = request.getParameter("metas");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            // PASO 1: Eliminar TODOS los objetivos específicos existentes (objetivo1, objetivo2, etc.)
            // Esto asegura que los objetivos eliminados en el front se eliminen también del servidor
            Map<String, String> datosExistentes = negocioPeti.obtenerDatosSeccion(grupoId, "objetivos");
            for (String campo : datosExistentes.keySet()) {
                if (campo.startsWith("objetivo") && !campo.equals("objetivo_general")) {
                    negocioPeti.eliminarDato(grupoId, "objetivos", campo, usuarioId);
                }
            }
            
            // PASO 2: Guardar objetivo general
            if (nuevoObjetivoGeneral != null && !nuevoObjetivoGeneral.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", "objetivo_general", nuevoObjetivoGeneral.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            // PASO 3: Guardar objetivos específicos que vienen del formulario
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("objetivo") && !paramName.equals("objetivo_general")) {
                    String valor = request.getParameter(paramName);
                    if (valor != null && !valor.trim().isEmpty()) {
                        ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", paramName, valor.trim(), usuarioId);
                        exito = exito && negocioPeti.guardarDato(dato);
                    }
                }
            }
            
            // PASO 4: Guardar indicadores y metas
            if (nuevosIndicadores != null && !nuevosIndicadores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", "indicadores", nuevosIndicadores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasMetas != null && !nuevasMetas.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "objetivos", "metas", nuevasMetas.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Objetivos estratégicos guardados exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar algunos datos";
                tipoMensaje = "error";
            }
        } catch (Exception e) {
            mensaje = "Error interno: " + e.getMessage();
            tipoMensaje = "error";
        }
    }
    
    // Cargar datos existentes
    Map<String, String> todosLosObjetivos = new java.util.HashMap<>();
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosObjetivos = negocioPeti.obtenerDatosSeccion(grupoId, "objetivos");
            
            objetivoGeneral = datosObjetivos.getOrDefault("objetivo_general", "");
            objetivo1 = datosObjetivos.getOrDefault("objetivo1", "");
            objetivo2 = datosObjetivos.getOrDefault("objetivo2", "");
            objetivo3 = datosObjetivos.getOrDefault("objetivo3", "");
            objetivo4 = datosObjetivos.getOrDefault("objetivo4", "");
            indicadores = datosObjetivos.getOrDefault("indicadores", "");
            metas = datosObjetivos.getOrDefault("metas", "");
            
            // Obtener todos los objetivos específicos adicionales
            todosLosObjetivos.putAll(datosObjetivos);
        } catch (Exception e) {
            //System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
    
    // Generar iniciales del usuario
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    // Obtener información del usuario para mostrar en el dashboard
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Objetivos Estratégicos - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --secondary-color: #2d3748;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --text-primary: #2d3748;
            --text-secondary: #4a5568;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
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
            height: 100vh;
            overflow: hidden;
            color: var(--text-primary);
        }

        .dashboard-container {
            width: 100vw;
            height: 100vh;
            display: flex;
            overflow: hidden;
        }

        .dashboard-sidebar {
            width: 280px;
            min-width: 280px;
            background: var(--primary-color);
            color: white;
            padding: 0;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-lg);
            border-right: 1px solid var(--border-color);
            height: 100vh;
            overflow: hidden;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
        }

        .company-logo {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }

        .company-logo i {
            font-size: 28px;
            margin-right: 12px;
            color: var(--accent-color);
        }

        .company-logo h2 {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -0.025em;
        }

        .user-profile {
            display: flex;
            align-items: center;
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
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: 600;
            margin-right: 12px;
            flex-shrink: 0;
        }

        .user-info h3 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.7;
        }

        .dashboard-nav {
            flex: 1;
            padding: 20px 0;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .nav-section {
            margin-bottom: 24px;
        }

        .nav-section-title {
            padding: 0 20px 8px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: rgba(255, 255, 255, 0.6);
        }

        .dashboard-nav ul {
            list-style: none;
            padding: 0;
        }

        .dashboard-nav li {
            margin-bottom: 2px;
        }

        .dashboard-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
            font-size: 14px;
            font-weight: 500;
            position: relative;
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 18px;
            text-align: center;
            font-size: 16px;
        }

        .dashboard-nav a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .dashboard-nav li.active a {
            background: var(--accent-color);
            color: white;
        }

        .dashboard-nav li.active a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: white;
        }

        .dashboard-content {
            flex: 1;
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
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(56, 161, 105, 0.2);
        }

        .alert-error {
            background: rgba(229, 62, 62, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(229, 62, 62, 0.2);
        }

        .alert-warning {
            background: rgba(214, 158, 46, 0.1);
            color: var(--warning-color);
            border: 1px solid rgba(214, 158, 46, 0.2);
        }

        .guide-section {
            background: rgba(49, 130, 206, 0.05);
            border: 1px solid rgba(49, 130, 206, 0.1);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .guide-section h3 {
            color: var(--accent-color);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
        }

        .guide-section ul {
            list-style: none;
            padding: 0;
        }

        .guide-section li {
            color: var(--text-primary);
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }

        .guide-section li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: var(--success-color);
            font-weight: bold;
        }

        .guide-tip {
            background: rgba(49, 130, 206, 0.1);
            border-left: 4px solid var(--accent-color);
            padding: 12px 16px;
            margin-top: 16px;
            border-radius: 0 6px 6px 0;
        }

        .guide-tip i {
            color: var(--accent-color);
            margin-right: 8px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .form-section {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.2s ease;
            background: var(--card-bg);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .saved-indicator {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--success-color);
            font-size: 12px;
            margin-top: 4px;
        }

        .preview-card {
            background: rgba(26, 54, 93, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-card h4 {
            color: var(--text-primary);
            margin-bottom: 12px;
            font-size: 16px;
        }

        .preview-element {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 16px;
            margin-bottom: 12px;
            border-left: 4px solid var(--accent-color);
        }

        .preview-element h5 {
            color: var(--text-primary);
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        .preview-element p {
            color: var(--text-secondary);
            line-height: 1.5;
            margin: 0;
        }

        .mode-info {
            background: rgba(214, 158, 46, 0.1);
            border: 1px solid rgba(214, 158, 46, 0.2);
            color: var(--warning-color);
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .save-button-container {
            display: flex;
            justify-content: center;
            margin-top: 24px;
        }

        .btn-save {
            background: var(--success-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-save:hover {
            background: #2f855a;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .objetivos-especificos {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .objetivo-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            transition: all 0.2s ease;
            position: relative;
        }

        .objetivo-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .objetivo-card h3 {
            color: var(--text-primary);
            margin-bottom: 16px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-icon {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            background: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .btn-remove {
            background: var(--danger-color);
            color: white;
            border: none;
            border-radius: 4px;
            padding: 4px 8px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-remove:hover {
            background: #c53030;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
                height: auto;
                min-height: 100vh;
            }
            
            .dashboard-sidebar {
                width: 100%;
                order: 2;
            }
            
            .dashboard-content {
                order: 1;
                margin-left: 0;
                height: auto;
            }
            
            .dashboard-main {
                padding: 20px;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .objetivos-especificos {
                grid-template-columns: 1fr;
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
                        <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
                        <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                        <li class="active"><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
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
                <h1>Objetivos Estratégicos</h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i>
                            Modo Colaborativo
                        </span>
                        <% if ("Administrador".equals(rolUsuario)) { %>
                            <span class="status-badge admin-badge">
                                <i class="fas fa-crown"></i>
                                Administrador
                            </span>
                        <% } %>
                    <% } %>
                    <a href="../menuprincipal.jsp" class="btn-primary">
                        <i class="fas fa-home"></i>
                        Menú Principal
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
                    <div class="mode-info">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> Debes estar en un grupo para acceder a esta funcionalidad colaborativa.
                        <a href="../menuprincipal.jsp" style="color: var(--warning-color); text-decoration: underline;">Ir al menú principal</a>
                    </div>
                <% } else { %>

                <div class="dashboard-section">
                    <div class="section-header">
                        <h2><i class="fas fa-lightbulb"></i> Guía para Objetivos Estratégicos</h2>
                    </div>
                    <div class="section-content">
                        <div class="guide-section">
                            <h3><i class="fas fa-info-circle"></i> Características de objetivos SMART</h3>
                            <ul>
                                <li><strong>Específicos:</strong> Claros y bien definidos para su empresa</li>
                                <li><strong>Medibles:</strong> Con indicadores cuantificables y métricas específicas</li>
                                <li><strong>Alcanzables:</strong> Realistas según los recursos y capacidades de su organización</li>
                                <li><strong>Relevantes:</strong> Alineados con la misión, visión y valores de su empresa</li>
                                <li><strong>Temporales:</strong> Con plazos definidos y cronogramas claros</li>
                            </ul>
                            <div class="guide-tip">
                                <i class="fas fa-lightbulb"></i>
                                <strong>Consejo:</strong> Los objetivos estratégicos deben reflejar las aspiraciones de crecimiento y desarrollo específicas de su sector de negocio.
                            </div>
                        </div>
                    </div>
                </div>

                <form method="post" action="" onsubmit="return sincronizarTodosLosCampos()">
                    <!-- Campos hidden para preservar objetivos dinámicos -->
                    <div id="hiddenFields">
                        <!-- Los campos hidden se crearán dinámicamente con JavaScript -->
                    </div>

                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2><i class="fas fa-target"></i> Objetivo General</h2>
                        </div>
                        <div class="section-content">
                            <div class="form-group">
                                <label for="objetivo_general">Objetivo General de su Empresa</label>
                                <textarea name="objetivo_general" id="objetivo_general" 
                                         placeholder="Ejemplo: Posicionar a nuestra empresa como líder en [su sector] mediante la innovación, calidad de servicio y expansión estratégica, alcanzando un crecimiento sostenible del 20% anual en los próximos 3 años..."
                                         onkeyup="actualizarVistaPrevia()"><%= objetivoGeneral %></textarea>
                                <% if (!objetivoGeneral.isEmpty()) { %>
                                    <div class="saved-indicator">
                                        <i class="fas fa-check-circle"></i>
                                        Guardado automáticamente
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2><i class="fas fa-list"></i> Objetivos Específicos</h2>
                            <button type="button" class="btn-primary" onclick="agregarObjetivo()">
                                <i class="fas fa-plus"></i>
                                Agregar Objetivo
                            </button>
                        </div>
                        <div class="section-content">
                            <div class="objetivos-especificos" id="objetivosContainer">
                                <!-- Objetivos específicos predefinidos -->
                                <div class="objetivo-card">
                                    <h3><span class="card-icon">1</span> Objetivo Específico 1</h3>
                                    <div class="form-group">
                                        <textarea name="objetivo1" id="objetivo1" 
                                                 placeholder="Ejemplo: Incrementar las ventas en un 25% durante el próximo año fiscal mediante la implementación de nuevas estrategias de marketing digital y expansión a mercados regionales..."
                                                 onkeyup="actualizarVistaPrevia()"><%= objetivo1 %></textarea>
                                        <% if (!objetivo1.isEmpty()) { %>
                                            <div class="saved-indicator">
                                                <i class="fas fa-check-circle"></i>
                                                Guardado
                                            </div>
                                        <% } %>
                                    </div>
                                </div>

                                <div class="objetivo-card">
                                    <h3><span class="card-icon">2</span> Objetivo Específico 2</h3>
                                    <div class="form-group">
                                        <textarea name="objetivo2" id="objetivo2" 
                                                 placeholder="Ejemplo: Mejorar la satisfacción del cliente alcanzando un índice de satisfacción del 95% mediante la optimización de procesos de atención y capacitación del personal..."
                                                 onkeyup="actualizarVistaPrevia()"><%= objetivo2 %></textarea>
                                        <% if (!objetivo2.isEmpty()) { %>
                                            <div class="saved-indicator">
                                                <i class="fas fa-check-circle"></i>
                                                Guardado
                                            </div>
                                        <% } %>
                                    </div>
                                </div>

                                <div class="objetivo-card">
                                    <h3><span class="card-icon">3</span> Objetivo Específico 3</h3>
                                    <div class="form-group">
                                        <textarea name="objetivo3" id="objetivo3" 
                                                 placeholder="Ejemplo: Reducir los costos operativos en un 15% mediante la automatización de procesos clave y la optimización de la cadena de suministro..."
                                                 onkeyup="actualizarVistaPrevia()"><%= objetivo3 %></textarea>
                                        <% if (!objetivo3.isEmpty()) { %>
                                            <div class="saved-indicator">
                                                <i class="fas fa-check-circle"></i>
                                                Guardado
                                            </div>
                                        <% } %>
                                    </div>
                                </div>

                                <div class="objetivo-card">
                                    <h3><span class="card-icon">4</span> Objetivo Específico 4</h3>
                                    <div class="form-group">
                                        <textarea name="objetivo4" id="objetivo4" 
                                                 placeholder="Ejemplo: Desarrollar e implementar 3 nuevos productos/servicios innovadores que respondan a las necesidades emergentes del mercado en los próximos 18 meses..."
                                                 onkeyup="actualizarVistaPrevia()"><%= objetivo4 %></textarea>
                                        <% if (!objetivo4.isEmpty()) { %>
                                            <div class="saved-indicator">
                                                <i class="fas fa-check-circle"></i>
                                                Guardado
                                            </div>
                                        <% } %>
                                    </div>
                                </div>

                                <!-- Objetivos adicionales dinámicos -->
                                <% 
                                int contadorObjetivos = 5;
                                for (Map.Entry<String, String> entry : todosLosObjetivos.entrySet()) {
                                    String key = entry.getKey();
                                    String value = entry.getValue();
                                    if (key.startsWith("objetivo") && !key.equals("objetivo_general") && 
                                        !key.equals("objetivo1") && !key.equals("objetivo2") && 
                                        !key.equals("objetivo3") && !key.equals("objetivo4")) {
                                %>
                                    <div class="objetivo-card" id="card_<%= key %>">
                                        <h3>
                                            <span class="card-icon"><%= contadorObjetivos %></span> 
                                            Objetivo Específico <%= contadorObjetivos %>
                                            <button type="button" class="btn-remove" onclick="eliminarObjetivo('<%= key %>')">
                                                <i class="fas fa-trash"></i>
                                                Eliminar
                                            </button>
                                        </h3>
                                        <div class="form-group">
                                            <textarea name="<%= key %>" id="<%= key %>" 
                                                     placeholder="Defina un objetivo específico adicional que contribuya al crecimiento y desarrollo de su empresa..."
                                                     onkeyup="actualizarVistaPrevia()"><%= value %></textarea>
                                            <% if (!value.isEmpty()) { %>
                                                <div class="saved-indicator">
                                                    <i class="fas fa-check-circle"></i>
                                                    Guardado
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>
                                <% 
                                        contadorObjetivos++;
                                    }
                                }
                                %>
                            </div>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="dashboard-section">
                            <div class="section-header">
                                <h2><i class="fas fa-chart-line"></i> Indicadores de Gestión</h2>
                            </div>
                            <div class="section-content">
                                <div class="form-group">
                                    <label for="indicadores">Indicadores de Medición y KPIs</label>
                                    <textarea name="indicadores" id="indicadores" 
                                             placeholder="Ejemplo: 
• Crecimiento de ventas: % de incremento mensual/anual
• Satisfacción del cliente: Índice NPS (Net Promoter Score)
• Eficiencia operativa: Reducción de tiempos de proceso
• Rentabilidad: ROI (Retorno sobre la inversión)
• Participación de mercado: % de cuota de mercado
• Productividad del personal: Ventas por empleado..."
                                             onkeyup="actualizarVistaPrevia()"><%= indicadores %></textarea>
                                    <% if (!indicadores.isEmpty()) { %>
                                        <div class="saved-indicator">
                                            <i class="fas fa-check-circle"></i>
                                            Guardado automáticamente
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <div class="dashboard-section">
                            <div class="section-header">
                                <h2><i class="fas fa-bullseye"></i> Metas y Cronograma</h2>
                            </div>
                            <div class="section-content">
                                <div class="form-group">
                                    <label for="metas">Metas Específicas y Plazos de Ejecución</label>
                                    <textarea name="metas" id="metas" 
                                             placeholder="Ejemplo:
• Corto plazo (3-6 meses): Implementar sistema CRM y capacitar al equipo de ventas
• Mediano plazo (6-12 meses): Lanzar campaña de marketing digital y abrir 2 nuevos puntos de venta
• Largo plazo (1-3 años): Expandir operaciones a 3 ciudades adicionales y diversificar línea de productos
• Revisiones trimestrales: Evaluación de KPIs y ajuste de estrategias según resultados..."
                                             onkeyup="actualizarVistaPrevia()"><%= metas %></textarea>
                                    <% if (!metas.isEmpty()) { %>
                                        <div class="saved-indicator">
                                            <i class="fas fa-check-circle"></i>
                                            Guardado automáticamente
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2><i class="fas fa-eye"></i> Vista Previa de Objetivos</h2>
                        </div>
                        <div class="section-content">
                            <div class="preview-card" id="vistaPrevia">
                                <h4>Objetivos Estratégicos de su Empresa</h4>
                                <div id="previewContent">
                                    <!-- El contenido se actualizará dinámicamente -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="save-button-container">
                        <button type="submit" class="btn-save">
                            <i class="fas fa-save"></i>
                            Guardar Objetivos Estratégicos
                        </button>
                    </div>
                </form>

                <% } %>
            </div>
        </div>
    </div>

    <script>
        <%
            int contador = 5;
            for (String key : todosLosObjetivos.keySet()) {
                if (key.startsWith("objetivo") && !key.equals("objetivo_general") && 
                    !key.equals("objetivo1") && !key.equals("objetivo2") && 
                    !key.equals("objetivo3") && !key.equals("objetivo4")) {
                    contador++;
                }
            }
        %>
        let contadorObjetivos = <%= contador %>;

        function agregarObjetivo() {
            const container = document.getElementById('objetivosContainer');
            const nuevoObjetivo = document.createElement('div');
            nuevoObjetivo.className = 'objetivo-card adding';
            nuevoObjetivo.id = 'card_objetivo' + contadorObjetivos;
            
            nuevoObjetivo.innerHTML = `
                <h3>
                    <span class="card-icon">${contadorObjetivos}</span> 
                    Objetivo Específico ${contadorObjetivos}
                    <button type="button" class="btn-remove" onclick="eliminarObjetivo('objetivo${contadorObjetivos}')">
                        <i class="fas fa-trash"></i>
                        Eliminar
                    </button>
                </h3>
                <div class="form-group">
                    <textarea name="objetivo${contadorObjetivos}" id="objetivo${contadorObjetivos}" 
                             placeholder="Defina un nuevo objetivo específico que contribuya al crecimiento de su empresa..."
                             onkeyup="actualizarVistaPrevia(); sincronizarCampo('objetivo${contadorObjetivos}')"></textarea>
                </div>
            `;
            
            container.appendChild(nuevoObjetivo);
            
            contadorObjetivos++;
            actualizarVistaPrevia();
        }

        function eliminarObjetivo(objetivoId) {
            const card = document.getElementById('card_' + objetivoId);
            const hiddenField = document.getElementById('hidden_' + objetivoId);
            
            if (card) {
                card.classList.add('removing');
                setTimeout(() => {
                    card.remove();
                    if (hiddenField) {
                        hiddenField.remove();
                    }
                    actualizarVistaPrevia();
                }, 300);
            }
        }

        function sincronizarTodosLosCampos() {
            console.log('=== SINCRONIZANDO CAMPOS ===');
            
            // Limpiar campos hidden existentes
            const hiddenFieldsDiv = document.getElementById('hiddenFields');
            hiddenFieldsDiv.innerHTML = '';
            
            // Crear campos hidden para TODOS los objetivos específicos que existen en el DOM
            const textareas = document.querySelectorAll('textarea[name^="objetivo"]');
            console.log('Total textareas encontrados:', textareas.length);
            
            textareas.forEach(textarea => {
                const nombre = textarea.name;
                const valor = textarea.value;
                
                console.log(`Campo: ${nombre}, Valor: "${valor.substring(0, 30)}..."`);
                
                // Crear hidden para todos los objetivos específicos (no el general) aunque estén vacíos
                if (nombre !== 'objetivo_general') {
                    const hiddenField = document.createElement('input');
                    hiddenField.type = 'hidden';
                    hiddenField.name = nombre;
                    hiddenField.value = valor;
                    hiddenField.id = 'hidden_' + nombre;
                    hiddenFieldsDiv.appendChild(hiddenField);
                    console.log(`✓ Hidden creado para: ${nombre}`);
                }
            });
            
            console.log('=== FIN SINCRONIZACIÓN ===');
            return true; // Permitir envío del formulario
        }

        function actualizarVistaPrevia() {
            const previewContent = document.getElementById('previewContent');
            let html = '';
            
            // Objetivo General
            const objetivoGeneral = document.getElementById('objetivo_general').value;
            if (objetivoGeneral.trim()) {
                html += `
                    <div class="preview-element">
                        <h5><i class="fas fa-target"></i> Objetivo General</h5>
                        <p>${objetivoGeneral}</p>
                    </div>
                `;
            }
            
            // Objetivos Específicos
            const objetivos = [];
            for (let i = 1; i <= 4; i++) {
                const objetivo = document.getElementById('objetivo' + i);
                if (objetivo && objetivo.value.trim()) {
                    objetivos.push({
                        numero: i,
                        texto: objetivo.value
                    });
                }
            }
            
            // Objetivos adicionales
            const textareas = document.querySelectorAll('textarea[name^="objetivo"]');
            textareas.forEach(textarea => {
                if (textarea.name.startsWith('objetivo') && 
                    textarea.name !== 'objetivo_general' &&
                    !textarea.name.match(/^objetivo[1-4]$/)) {
                    if (textarea.value.trim()) {
                        const numero = textarea.name.replace('objetivo', '');
                        objetivos.push({
                            numero: numero,
                            texto: textarea.value
                        });
                    }
                }
            });
            
            if (objetivos.length > 0) {
                html += `
                    <div class="preview-element">
                        <h5><i class="fas fa-list"></i> Objetivos Específicos</h5>
                `;
                objetivos.forEach((obj, index) => {
                    html += `<p><strong>${index + 1}.</strong> ${obj.texto}</p>`;
                });
                html += `</div>`;
            }
            
            // Indicadores
            const indicadores = document.getElementById('indicadores').value;
            if (indicadores.trim()) {
                html += `
                    <div class="preview-element">
                        <h5><i class="fas fa-chart-line"></i> Indicadores de Gestión</h5>
                        <p>${indicadores}</p>
                    </div>
                `;
            }
            
            // Metas
            const metas = document.getElementById('metas').value;
            if (metas.trim()) {
                html += `
                    <div class="preview-element">
                        <h5><i class="fas fa-bullseye"></i> Metas y Plazos</h5>
                        <p>${metas}</p>
                    </div>
                `;
            }
            
            if (html === '') {
                html = '<p style="text-align: center; color: var(--text-secondary); font-style: italic;">Complete los campos para ver la vista previa de los objetivos estratégicos de su empresa...</p>';
            }
            
            previewContent.innerHTML = html;
        }

        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }

        // Actualizar vista previa al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            actualizarVistaPrevia();
            
            // Auto-refresh en modo colaborativo cada 30 segundos
            <% if (modoColaborativo) { %>
                setInterval(function() {
                    // Solo refrescar si no hay cambios sin guardar
                    const forms = document.querySelectorAll('input, textarea');
                    let hasUnsavedChanges = false;
                    
                    forms.forEach(form => {
                        if (form.defaultValue !== form.value) {
                            hasUnsavedChanges = true;
                        }
                    });
                    
                    if (!hasUnsavedChanges) {
                        location.reload();
                    }
                }, 30000);
            <% } %>
        });
    </script>
</body>
</html>